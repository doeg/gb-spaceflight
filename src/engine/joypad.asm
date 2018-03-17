; Referenced heavily from Flappy Boy
; See http://voidptr.io/blog/2017/01/21/GameBoy.html
SECTION "joypad_vars", WRAM0

IO_P14:: DS 1
IO_P14_OLD:: DS 1

IO_P15:: DS 1
IO_P15_OLD:: DS 1

; pUSER_IO                 EQU    $FF00
; NO_INPUT_P14            EQU    $EF      ; LEFT, RIGHT, UP, DOWN
; NO_INPUT_P15            EQU    $DF      ; A, B, SELECT, START

SECTION "joypad", ROMX

INCLUDE "constants.inc"

clear_joypad::
  ld hl, IO_P14
  ld [hl], NO_INPUT_P14
  ld hl, IO_P14_OLD
  ld [hl], NO_INPUT_P14

  ld hl, IO_P15
  ld [hl], NO_INPUT_P15
  ld hl, IO_P15_OLD
  ld [hl], NO_INPUT_P15
  ret

; What I do here is read the register that are used to map
; the current button input and store the values on memory.
; First I save the previous value into IO_PXX_OLD and then
; store the fresh input value into IO_PXX. This allows me
; to not only check when a button is pressed down but
; also when it’s hit. The last one is useful when you want
; to do an action only when the button was initially pressed.
read_joypad::
  ; Read P14
  ld HL, pUSER_IO
  ld A, $20
  ld [HL], A
  ld A, [HL]
  ld HL, IO_P14
  ld B, [HL]
  ld [HL], A
  ld HL, IO_P14_OLD
  ld [HL], B

  ; Read P15
  ld HL, pUSER_IO
  ld A, $10
  ld [HL], A
  ld A, [HL]
  ld HL, IO_P15
  ld B, [HL]
  ld [HL], A
  ld HL, IO_P15_OLD
  ld [HL], B

  ; Reset
  ld HL, pUSER_IO
  ld A, $FF
  ld [HL], A
  ret
