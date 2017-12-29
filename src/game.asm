SECTION "game_vars", WRAM0

; One byte counter that gets decremented in a timer.
; Controls the draw rate by overflowing when a frame
; is to be animated.
INTERRUPT_COUNTER: ds 1
DEFAULT_INTERRUPT_COUNTER EQU $01

; Dynamic ship x position
SHIP_X: ds 1
SHIP_Y: ds 1

SECTION "game", ROMX

INCLUDE "constants.inc"
INCLUDE "bg_space_map.inc"
INCLUDE "ship_map.inc"

handle_game_timer_interrupt::
  push af
  ld a, [INTERRUPT_COUNTER]
  dec a
  jp nz, .finish

  ; If zero, move the window and reset the counter
  call wait_vblank
  call motion_update
  ld a, DEFAULT_INTERRUPT_COUNTER

.finish:
  ld [INTERRUPT_COUNTER], a
  pop af
  reti

motion_update::
  push af
  ld a, [LCD_SCROLL_Y]
  sbc a, 10
  ld [LCD_SCROLL_Y], a

  ; Decrement the ship's x position
  ; ld a, [SHIP_X]
  ; sbc a, 2
  ; ld [SHIP_X], a

  pop af
  ret

load_game_data::
  ; Configure LCD
  ld HL, LCD_CTRL
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

  ; Initialize the ship's position
  ld a, $50
  ld [SHIP_X], a

  ld a, $80
  ld [SHIP_Y], a

  ; Set palettes
  ld hl, LCD_BG_PAL
  LD [hl], %11101010
  ld hl, OBJ0_PAL
  ld [hl], %00000000
  ld hl, OBJ1_PAL
  ld [hl], %00000000

  ; Clear OAM
  call clear_oam

  ; de - block size
  ; bc - source address
  ; hl - destination address

  ; Load sprite tiles
  ld de, ship_tile_data_size ;len
  ld bc, ship_tile_data ;src
  ld hl, VRAM_TILES_SPRITE ;dest
  call memcpy

  ; load top tile map to vram (background)
  ld DE, bg_space_tile_data_size
  ld BC, bg_space_tile_data
  ld HL, VRAM_TILES_BACKGROUND
  call memcpy

  call .load_all_tiles

  call draw_ship

  ret

.load_all_tiles:
  ld de, bg_space_tile_map_size ;len
  ld bc, bg_space_map_data ;src
  ld hl, $9C00 ;dest
  call memcpy
  ret

draw_ship::
  ; Load the ship's position into registers
  ld hl, SHIP_Y
  ld b, [hl]
  ld hl, SHIP_X
  ld c, [hl]

  ; Draw the ship, clockwise from top left.
  ; (TODO DMA; adds sprites to OAM directly, for now)
  ; (TODO use variables instead of addresses)
  ld hl, $fe00
  ld [hl], b
  inc l
  ld [hl], c
  inc l
  ld [hl], $00; tile number

  ld hl, $fe04
  ld e, c
  ld a, c
  adc a, 8
  ld c, a
  ld [hl], b
  inc l
  ld [hl], c
  inc l
  ld [hl], $01; tile number

  ld hl, $fe0c
  ld a, b
  adc a, 8
  ld b, a
  ld [hl], b
  inc l
  ld [hl], e
  inc l
  ld [hl], $02; tile number

  ld hl, $fe08
  ld [hl], b
  inc l
  ld [hl], c
  inc l
  ld [hl], $03; tile number
  ret
