SECTION "splash_variables", WRAM0

variables_start:
; we need this so that it pushes all of the other variables away from our OAM ram bank (40 sprites, 4 bytes each)
OAM_DATA: DS 40 * 4
; DS allocates a number of bytes. The content is undefined.
; This is the preferred method of allocating space in a RAM section.
; See https://rednex.github.io/rgbds/rgbasm.5.html#Declaring_variables_in_a_RAM_section
ADDR: DS 2

SECTION "splash", ROMX

INCLUDE "splash_map.inc"
INCLUDE "constants.inc"
INCLUDE "ibmpc1.inc"

load_splash_data::
  ; Configure LCD
  ld HL, LCD_CTRL
  ; Reset OBJ (Sprite) Display (0: off)
  set 1, [HL]
  ; Set BG Tile Map Display Select (1: $9C00-$9FFF)
  set 3, [HL]
  ; Reset BG & Window tile data select (0: $8800-$97FF)
  res 4, [HL]

  ; Invert background & OBJ0 palette
  ; (so that the background is white text, black bc)
  ld hl, LCD_BG_PAL
  LD [hl], %00011011
  ld hl, OBJ0_PAL
  ld [hl], %00011011
  ld hl, OBJ1_PAL
  ld [hl], %00011011

  ; load top tile map to vram (background)
  ld DE, splash_tile_data_size
  ld BC, splash_tile_data
  ld HL, VRAM_TILES_BACKGROUND
  call memcpy

  ; Load tile data
  call .load_splash_tiles

  ; Prompt text.
  ; Load the ASCII tileset into sprite memory
  ld hl, ascii
  ld de, VRAM_TILES_SPRITE
  ld bc, 31 * 8 ;
  call mem_CopyMono

  ret

.load_splash_tiles:
  ; We just load every line by hand.
  ld DE, $15
  ld BC, splash_map_data + ($14 * $0)
  ld HL, $9C00
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $1)
  ld HL, $9C20
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $2)
  ld HL, $9C40
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $3)
  ld HL, $9C60
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $4)
  ld HL, $9C80
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $5)
  ld HL, $9CA0
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $6)
  ld HL, $9CC0
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $7)
  ld HL, $9CE0
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $8)
  ld HL, $9D00
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $9)
  ld HL, $9D20
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $A)
  ld HL, $9D40
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $B)
  ld HL, $9D60
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $C)
  ld HL, $9D80
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $D)
  ld HL, $9DA0
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $E)
  ld HL, $9DC0
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $F)
  ld HL, $9DE0
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $10)
  ld HL, $9E00
  call memcpy

  ld DE, $15
  ld BC, splash_map_data + ($14 * $11)
  ld HL, $9E20
  call memcpy

  ret

; and initialise the ascii tileset
ascii:
	chr_IBMPC1 3, 3
splash_text:
  db "Press A"
splash_text_end:
  nop
