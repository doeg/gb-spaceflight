SECTION "ship_vars", WRAM0

MOVE_COUNTDOWN: ds 1
DEFAULT_MOVE_COUNTDOWN EQU $1 ; cycles/px

; Dynamic ship x position
SHIP_X:: ds 1
SHIP_Y:: ds 1
; 0: left, 1: right
SHIP_DIRECTION:: ds 1

SHIP_VELOCITY EQU 1

SECTION "ship", ROMX

INCLUDE "constants.inc"

init_ship::
  ; Initialize the ship's position
  ld a, $50
  ld [SHIP_X], a

  ld a, $80
  ld [SHIP_Y], a

  ld a, DEFAULT_MOVE_COUNTDOWN
  ld [MOVE_COUNTDOWN], a
  ret

; Called on every cycle of the 4096 Mhz timer.
update_ship::
  push af
  ld a, [MOVE_COUNTDOWN]
  dec a
  jr nz, .update_done
.update_position:
  ; ld a, [SHIP_X]
  ; sbc a, SHIP_VELOCITY
  ; ld [SHIP_X], a
  ld a, DEFAULT_MOVE_COUNTDOWN
.update_done:
  ld [MOVE_COUNTDOWN], a
  pop af
  call draw_ship
  ret

draw_ship::
  push af
  push bc
  push de
  push hl

  ; Load the ship's position into registers
  ld hl, SHIP_Y
  ld b, [hl]
  ld hl, SHIP_X
  ld c, [hl]

  ; Draw the ship, clockwise from top left.
  ; (TODO DMA; adds sprites to OAM directly, for now)
  ; (TODO use variables instead of addresses)
  ld hl, pSHADOW_OAM
  ld [hl], b
  inc l
  ld [hl], c
  inc l
  ld [hl], $00; tile number

  ld hl, pSHADOW_OAM + $04
  ld e, c
  ld a, c
  adc a, 8
  ld c, a
  ld [hl], b
  inc l
  ld [hl], c
  inc l
  ld [hl], $01; tile number

  ld hl, pSHADOW_OAM + $0c
  ld a, b
  adc a, 8
  ld b, a
  ld [hl], b
  inc l
  ld [hl], e
  inc l
  ld [hl], $02; tile number

  ld hl, pSHADOW_OAM + $08
  ld [hl], b
  inc l
  ld [hl], c
  inc l
  ld [hl], $03; tile number

  pop hl
  pop de
  pop bc
  pop af
  ret
