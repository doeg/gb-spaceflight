SECTION "game_vars", WRAM0

; One byte counter that gets decremented in a timer.
; Controls the draw rate by overflowing when a frame
; is to be animated.
INTERRUPT_COUNTER: ds 1
DEFAULT_INTERRUPT_COUNTER EQU $1

SECTION "game", ROMX

INCLUDE "constants.inc"
INCLUDE "bg_space_map.inc"
INCLUDE "macros.inc"
INCLUDE "ship_map.inc"
INCLUDE "ibmpc1.inc"

; The address of the first map location for the first digit
; in the four-digit score.
; TODO this should really use an offset from the window's
; tile map display ($9800).
pSCORE_MAP EQU $9981
pSCORE_MAP_END EQU $9984
; The tile number of the first tile in tiles for numbers 0-9.
; The tile for the digit "1" would be `ASCII_NUM_0 + $1`,
; the tile for digit "2" would be `ASCII_NUM_0 + $2`, etc.
ASCII_NUM_0 EQU $47

start_game::
  di
  call wait_vblank
  call lcd_off
  call clear_oam
  call clear_bg_map
  ; Reset the viewport to the top-left corner.
  ; TODO refactor into function
  ld HL, pLCD_SCROLL_Y
  ld [HL], $00
  ld HL, pLCD_SCROLL_X
  ld [HL], $00
  call clear_joypad

  ; Update game state
  ld a, $01
  ld [GAME_STATE], a

  call load_game_data

  call lcd_on
  ei

.game_loop:
  jr .game_loop

handle_game_timer_interrupt::
  call update_background
  call update_ship
  reti

update_background::
  push af
  ld a, [INTERRUPT_COUNTER]
  dec a
  jp nz, .finish
  ; If zero, move the viewport and reset the counter
  ld a, [pLCD_SCROLL_Y]
  sbc a, 2
  ld [pLCD_SCROLL_Y], a
  ld a, DEFAULT_INTERRUPT_COUNTER

.finish:
  ld [INTERRUPT_COUNTER], a
  pop af
  ret

load_game_data::
  ; Configure LCD
  ld HL, pLCD_CTRL
  ; Reset OBJ (Sprite) Display (0: off)
  set 1, [HL]
  ; Set BG Tile Map Display Select (1: $9C00-$9FFF)
  set 3, [HL]

  ; Set BG & Window tile data select '
  ; 0: $8800-$97FF (res)
  ; 1: $8000-$8FFF (set) <- Same area as OBJ
  res 4, [HL]

  ; Set the Window Tile Map display
  ; 0 - $9800 - $9bff (res)
  ; 1 - $9c00 - $9fff (set)
  res 6, [hl]

  ; Set the window to x=111, y=0 (48px wide)
  ld b, $76
  ld c, $00
  call set_window_xy

zero_score::
  ; Zeroes out the score
  ld hl, GAME_SCORE
  ld a, $00
  ld [hl], a
  inc hl
  ld [hl], a

; Draws the current value of the game score to the display.
draw_score::
  ; Load the value of the current game score into b
  ld hl, GAME_SCORE
  ld b, [hl]

  ; [hl] is the address of the tile data for the score on the screen.
  ; So in other words, we're changing the pointers to which tiles
  ; (ascii digits) are shown by changing the stored addresses.
  ld hl, pSCORE_MAP_END

  ; Start at the lowest digit and move left through memory
  ; to the highest digit.
  ;
  ; FIXME the offset added to ASCII_NUM_0 should come from GAME_SCORE[3]
  ; Maybe use: `ADD HL, r16` (add the value in r16 to HL) -- but
  ; ASCII_NUM_0 is not a pointer, it's just a 1-byte tile number
  ; (e.g., 47) so probably fine to use easier math here...
  ld a, ASCII_NUM_0 + $0
  ; Decrement to get the second digit (from the lowest)
  ld [hl-], a

  ; The offset we add to the "0" tile's position is simply
  ; that ascii digit. ASCII_NUM_0 + $1 -> tile "1", etc.
  ld a, ASCII_NUM_0
  ; FIXME the offset added to ASCII_NUM_0 should come from GAME_SCORE[2]
  add a, $1
  ld [hl-], a

  ; Third digit, always 0 for now
  ld a, ASCII_NUM_0
  ; FIXME the offset added to ASCII_NUM_0 should come from GAME_SCORE[1]
  add a, $2
  ld [hl-], a

  ; Fourth digit, always 0 for now
  ld a, ASCII_NUM_0
  ; FIXME the offset added to ASCII_NUM_0 should come from GAME_SCORE[0]
  add a, $3
  ld [hl], a

.draw_score_end:
  nop

  ; Turn on the window
  call set_window_on

  ; Load the ASCII tileset into the bg tiles
  ld hl, ascii
  ld de, $9370
  ld bc, 31 * 8 ; byte count - 31 letters x 8 bytes
  call mem_copy_mono

  ; Initialize the interrupt counter
  ; TODO just zero the whole variables blockw
  ld a, DEFAULT_INTERRUPT_COUNTER
  ld [INTERRUPT_COUNTER], a

  ; Set palettes
  ld hl, pLCD_BG_PAL
  LD [hl], %11101010
  ld hl, pOBJ0_PAL
  ld [hl], %00000000
  ld hl, pOBJ1_PAL
  ld [hl], %00000000

  ; de - block size
  ; bc - source address
  ; hl - destination address

  ; Load sprite tiles
  ld de, ship_tile_data_size ;len
  ld bc, ship_tile_data ;src
  ld hl, pVRAM_TILES_SPRITE ;dest
  call memcpy

  ; load top tile map to vram (background)
  ld DE, bg_space_tile_data_size
  ld BC, bg_space_tile_data
  ld HL, pVRAM_TILES_BACKGROUND
  call memcpy

  call load_all_tiles
  call init_ship
  ret

load_all_tiles:
  ld de, bg_space_tile_map_size ;len
  ld bc, bg_space_map_data ;src
  ld hl, pVRAM_MAP_BG ;dest
  call memcpy
  ret

ascii:
  chr_IBMPC1 2, 2
