INCLUDE "constants.inc"
INCLUDE "macros.inc"

SECTION  "Vblank", ROM0[$0040]
  reti
SECTION  "LCDC", ROM0[$0048]
  reti
SECTION  "Timer_Overflow", ROM0[$0050]
  jp timer_interrupt
SECTION  "Serial", ROM0[$0058]
  reti
SECTION  "p1thru4", ROM0[$0060]
  reti

SECTION  "start", ROM0[$0100]
  nop
  jp main

INCLUDE "header.inc"

main::
  nop
  jp start_splash

start_splash::
  ; Disable interrupts while we manipulate VRAM
  di

  ; Clear the screen
  ld B, $16
  _RESET_

  ; Initialize splash data
  call wait_vblank
  call lcd_off
  call load_splash_data
  call lcd_on

  di
  ; Set accumulator with VBlank and Timer enabled bitmask
  ;  IEF_VBLANK -> Bit 0 high -> VBlank Interrupt Enabled
  ;  IEF_TIMER -> Bit 2 high -> Timer Interrupt Enabled
  ld a, IEF_TIMER | IEF_VBLANK
  ; Write the accumulator bitmask to the Interrupt Enable register
  ld [rIE], a

  ; Initialize the interrupt counter to 0
  ld a, 0
  ld [COUNTER], a

  ; Enable interrupts
  ei

.main_loop:
  ; Set up a timer and wait
  call timer_wait
  ; Loop forever
  jr .main_loop

timer_wait::
  ; Set up a timer modulo
  ld a, 10
  ; Write the timer modulo to the TMA register
  ; when the timer overflows it will be reset to this value
  ld [rTMA], a
  ; Set up a timer control bitmask.
  ;   TACF_START -> bit 2 high -> start the timer
  ; We want the timer to run at 4KHz
  ;   TACF_4KHZ -> bit 1 and bit 0 low -> 4096 hz timer
  ld a, TACF_START|TACF_4KHZ
  ; Write the timer control bitmask value to the timer control register
  ld [rTAC], a
  ; Stop the CPU waiting for interrupts to happen
  halt
  ; Always NOP after a halt - hardware bug
  nop
  ret

timer_interrupt::
  push af
  push hl

  ld a, [COUNTER]
  cp $0
  jr z, .hide_prompt

.show_prompt:
  ld hl, OBJ0_PAL
  ld [hl], %11100100
  ld a, 0
  ld [COUNTER], a
  jr .done

.hide_prompt:
  ld hl, OBJ0_PAL
  ld [hl], %00011011
  ld a, 1
  ld [COUNTER], a
  jr .done

.done:
  pop hl
  pop af
  reti


SECTION "game_vars", WRAM0[$C800]

; Whatever, just a counter
COUNTER: ds 1
