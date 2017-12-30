SECTION "game_vars", WRAM0

; One byte counter that gets decremented in a timer.
; Controls the draw rate by overflowing when a frame
; is to be animated.
INTERRUPT_COUNTER: ds 1
DEFAULT_INTERRUPT_COUNTER EQU $01

SECTION "game", ROMX

INCLUDE "constants.inc"
INCLUDE "bg_space_map.inc"
INCLUDE "macros.inc"
INCLUDE "ship_map.inc"

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
  call draw_ship
  jr .game_loop

handle_game_timer_interrupt::
  push af
  ld a, [INTERRUPT_COUNTER]
  dec a
  jp nz, .finish

  ; If zero, move the window and reset the counter
  call motion_update
  ld a, DEFAULT_INTERRUPT_COUNTER

.finish:
  ld [INTERRUPT_COUNTER], a
  pop af
  reti

; Scrolls the starfield background
motion_update::
  push af
  ld a, [pLCD_SCROLL_Y]
  sbc a, 1
  ld [pLCD_SCROLL_Y], a
  pop af
  ret

load_game_data::
  ; Configure LCD
  ld HL, pLCD_CTRL
  ; Reset OBJ (Sprite) Display (0: off)
  set 1, [HL]
  ; Set BG Tile Map Display Select (1: $9C00-$9FFF)
  set 3, [HL]
  ; Reset BG & Window tile data select (0: $8800-$97FF)
  res 4, [HL]

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
  call draw_ship
  ret

load_all_tiles:
  ld de, bg_space_tile_map_size ;len
  ld bc, bg_space_map_data ;src
  ld hl, $9C00 ;dest
  call memcpy
  ret
