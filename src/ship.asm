SECTION "ship_vars", WRAM0

; Dynamic ship x position
SHIP_X:: ds 1
SHIP_Y:: ds 1

; The velocity of the ship along the x axis.
SHIP_Vx:: ds 1
; 0: left, 1: right
SHIP_DIRECTION:: ds 1

SECTION "ship", ROMX

INCLUDE "constants.inc"

init_ship::
  ; Initialize the ship's position
  ld a, $50
  ld [SHIP_X], a

  ld a, $80
  ld [SHIP_Y], a

  ; Initialize the x velocity to 0
  ld a, 1
  ld [SHIP_Vx], a
  ret

; Called on every cycle of the 4096 Mhz timer.
update_ship::
  push af
  push bc
  ; Pressing the left or right button will apply
  ; acceleration to the ship's current velocity
  call read_joypad
  ld hl, IO_P14
  bit BUTTON_LEFT, [hl]
  jr z, .update_position
  bit BUTTON_RIGHT, [hl]
  jr z, .update_position
  jr .update_done
.update_position::
  ; Calculate next x position (x1)
  ; x1 = x0 + vx(dt), where dt = 1
  ld a, [SHIP_Vx]
  ld b, a
  ld a, [SHIP_X]
  ld hl, IO_P14
  bit BUTTON_RIGHT, [hl]
  jr nz, .move_right
.move_left:
  add a, b
  jr .update_continue
.move_right:
  sub a, b
.update_continue:
  ld [SHIP_X], a

.update_done::
  pop bc
  pop af
  call draw_ship
  ret

; Update the shadow OAM. Actual render does not happen
; until the vblank interrupt.
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
