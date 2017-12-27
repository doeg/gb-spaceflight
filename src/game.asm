SECTION "game_vars", WRAM0

; one byte counter that gets decremented in a timer
INTERRUPT_COUNTER: ds 1
DEFAULT_INTERRUPT_COUNTER EQU $01

SECTION "game", ROMX

INCLUDE "constants.inc"
INCLUDE "bg_space_map.inc"

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

motion_update::
  push af
  ld a, [LCD_SCROLL_Y]
  inc a
  inc a
  inc a
  inc a
  ld [LCD_SCROLL_Y], a
  pop af
  ret

load_game_data::
  ; Configure LCD
  ld HL, LCD_CTRL
  ; Reset OBJ (Sprite) Display (0: off)
  res 1, [HL]
  ; Set BG Tile Map Display Select (1: $9C00-$9FFF)
  set 3, [HL]
  ; Reset BG & Window tile data select (0: $8800-$97FF)
  res 4, [HL]

  ; Initialize the interrupt counter
  ld a, DEFAULT_INTERRUPT_COUNTER
  ld [INTERRUPT_COUNTER], a

  ld hl, LCD_BG_PAL
  LD [hl], %11100100

  ; load top tile map to vram (background)
  ld DE, bg_space_tile_data_size
  ld BC, bg_space_tile_data
  ld HL, VRAM_TILES_BACKGROUND
  call memcpy
  ; Load tile data
  call .load_menu_tiles_0
  call .load_menu_tiles_1
  ret
.load_menu_tiles_0:
  ; We just load every line by hand.
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $0)
  ld HL, $9C00
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $1)
  ld HL, $9C20
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $2)
  ld HL, $9C40
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $3)
  ld HL, $9C60
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $4)
  ld HL, $9C80
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $5)
  ld HL, $9CA0
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $6)
  ld HL, $9CC0
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $7)
  ld HL, $9CE0
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $8)
  ld HL, $9D00
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $9)
  ld HL, $9D20
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $A)
  ld HL, $9D40
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $B)
  ld HL, $9D60
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $C)
  ld HL, $9D80
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $D)
  ld HL, $9DA0
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $E)
  ld HL, $9DC0
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $F)
  ld HL, $9DE0
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $10)
  ld HL, $9E00
  call memcpy
  ld DE, $14
  ld BC, bg_space_map_data + ($14 * $11)
  ld HL, $9E20
  call memcpy
  ret
.load_menu_tiles_1:
  ; We just load every line by hand.
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $0)
  ld HL, $9C13
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $1)
  ld HL, $9C33
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $2)
  ld HL, $9C53
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $3)
  ld HL, $9C73
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $4)
  ld HL, $9C93
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $5)
  ld HL, $9CB3
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $6)
  ld HL, $9CD3
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $7)
  ld HL, $9CF3
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $8)
  ld HL, $9D13
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $9)
  ld HL, $9D33
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $A)
  ld HL, $9D53
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $B)
  ld HL, $9D73
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $C)
  ld HL, $9D93
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $D)
  ld HL, $9DB3
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $E)
  ld HL, $9DD3
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $F)
  ld HL, $9DF3
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $10)
  ld HL, $9E13
  call memcpy
  ld DE, $0E
  ld BC, bg_space_map_data + ($14 * $11)
  ld HL, $9E33
  call memcpy
  ret
