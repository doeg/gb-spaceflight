; Functions in this file are by bitnenfer
; https://github.com/bitnenfer/flappy-boy-asm
SECTION "lcd", ROMX

INCLUDE "constants.inc"

lcd_off::
  ld HL, LCD_CTRL
  res 7, [HL]
  ret

lcd_on::
  ld HL, LCD_CTRL
  set 7, [HL]
  ret

wait_vblank::
  push af
.vblank_loop:
  ld A, [LCD_LINE_Y]
  cp 144
  jr nz, .vblank_loop
  pop af
  ret

clear_bg_map::
  ld HL, $9C00

.clear_loop:
  ld [HL], B
  inc HL
  ld A, H
  cp $9F
  jr nz, .clear_loop
  ld A, L
  cp $FF
  jr nz, .clear_loop
  ret
