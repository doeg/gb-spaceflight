SECTION "window", ROM0

INCLUDE "constants.inc"

; Turns on the window overlay.
window_on::
  push hl
  ld hl, pLCD_CTRL
  set 5, [hl]
  pop hl
  ret

; Turns off the window overlay.
window_off::
  push hl
  ld hl, pLCD_CTRL
  res 5, [hl]
  pop hl
  ret

; Sets the coordinates (WX, XY) of the window,
; where 0 <= WINX <= 166 and 0 <= WINY <= 143.
;
; Arguments
;   BC - WINX, WINY,
;
; Example:
;   BC = 0x4657
;
;   The window would be positioned as so:
;
;      0                  80               159
;      ______________________________________
;   0 |                                      |
;     |                   |                  |
;     |                                      |
;     |         Background Display           |
;     |               Here                   |
;     |                                      |
;     |                                      |
;  70 |         -         +------------------|
;     |                   | 80,70            |
;     |                   |                  |
;     |                   |  Window Display  |
;     |                   |       Here       |
;     |                   |                  |
;     |                   |                  |
; 143 |___________________|__________________|
;
window_set_pos::
  push hl
  ld hl, pWIN_X
  ld [hl], b
  ld hl, pWIN_Y
  ld [hl], c
  pop hl
  ret
