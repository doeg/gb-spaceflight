SECTION "game_vars", WRAM0

SECTION "game", ROMX

INCLUDE "constants.inc"
INCLUDE "bg_space_map.inc"

load_game_data::
  ; Configure LCD
  ld HL, LCD_CTRL
  ; Reset OBJ (Sprite) Display (0: off)
  res 1, [HL]
  ; Set BG Tile Map Display Select (1: $9C00-$9FFF)
  set 3, [HL]
  ; Reset BG & Window tile data select (0: $8800-$97FF)
  res 4, [HL]

  ld hl, LCD_BG_PAL
  LD [hl], %11100100

  ; load top tile map to vram (background)
  ld DE, bg_space_tile_data_size
  ld BC, bg_space_tile_data
  ld HL, VRAM_TILES_BACKGROUND
  call memcpy

  call .load_game_background

  ret

.load_game_background:
  ; We just load every line by hand.
  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $0)
  ld HL, $9C00
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $1)
  ld HL, $9C20
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $2)
  ld HL, $9C40
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $3)
  ld HL, $9C60
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $4)
  ld HL, $9C80
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $5)
  ld HL, $9CA0
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $6)
  ld HL, $9CC0
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $7)
  ld HL, $9CE0
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $8)
  ld HL, $9D00
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $9)
  ld HL, $9D20
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $A)
  ld HL, $9D40
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $B)
  ld HL, $9D60
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $C)
  ld HL, $9D80
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $D)
  ld HL, $9DA0
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $E)
  ld HL, $9DC0
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $F)
  ld HL, $9DE0
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $10)
  ld HL, $9E00
  call memcpy

  ld DE, $15
  ld BC, bg_space_map_data + ($14 * $11)
  ld HL, $9E20
  call memcpy

  ret
