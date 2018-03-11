; Functions in this file are by bitnenfer
; https://github.com/bitnenfer/flappy-boy-asm
SECTION "lcd", ROMX

INCLUDE "constants.inc"

lcd_off::
  ld HL, pLCD_CTRL
  res 7, [HL]
  ret

lcd_on::
  ld HL, pLCD_CTRL
  set 7, [HL]
  ret

; Loops until Vblank and then returns. 
;
; When & why to use this:
; The vblank interrupt happens every 16.6ms (~60 times/second)
; and lasts ~1.1ms (10 scanlines). During this period
; VRAM/OAM may be freely accessed, as the PPU is not using it.
wait_vblank::
  push af
.vblank_loop:
  ld A, [pLCD_LINE_Y]
  cp 144
  jr nz, .vblank_loop
  pop af
  ret

; FIXME this doesn't push/pop hl & af
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
