SECTION "game_vars", WRAM0

; one byte counter that gets decremented in a timer
INTERRUPT_COUNTER: ds 1
DEFAULT_INTERRUPT_COUNTER EQU $01

SHIP_Y EQU $80

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
  dec a
  dec a
  dec a
  dec a
  dec a
  ld [LCD_SCROLL_Y], a
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
  ld a, DEFAULT_INTERRUPT_COUNTER
  ld [INTERRUPT_COUNTER], a

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

  ; Add sprites to OAM (directly, for now)
  ld hl, $FE00
  ld [hl], SHIP_Y ;y
  inc l
  ld [hl], $50 ;x
  inc l
  ld [hl], $00; tile number

  ld hl, $FE04
  ld [hl], SHIP_Y ;y
  inc l
  ld [hl], $58 ;x
  inc l
  ld [hl], $01; tile number

  ld hl, $FE08
  ld [hl], SHIP_Y + $08 ;y
  inc l
  ld [hl], $50 ;x
  inc l
  ld [hl], $02; tile number

  ld hl, $FE0C
  ld [hl], SHIP_Y + $08 ;y
  inc l
  ld [hl], $58 ;x
  inc l
  ld [hl], $03; tile number

  ; load top tile map to vram (background)
  ld DE, bg_space_tile_data_size
  ld BC, bg_space_tile_data
  ld HL, VRAM_TILES_BACKGROUND
  call memcpy

  call .load_all_tiles
  ret

.load_all_tiles:
  ld de, bg_space_tile_map_size ;len
  ld bc, bg_space_map_data ;src
  ld hl, $9C00 ;dest
  call memcpy
  ret
