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

; Point-of-entry
SECTION  "start", ROM0[$0100]
  nop
  jp main

INCLUDE "header.inc"

SECTION "timer_vars", WRAM0[$C800]

; Whatever, just a counter
COUNTER:: ds 1

; Maintains game state (splash, game, game over)
GAME_STATE:: ds 1
GAME_STATE_SPLASH EQU $00
GAME_STATE_GAME EQU $01

SECTION "main", ROMX

; Program start!
main::
  nop
  jp start_splash

; See http://gameboy.mongenel.com/dmg/timer.txt
init_timer::
  ; Set up a timer modulo
  ld a, 10
  ; Write the timer modulo to the TMA register
  ; when the timer overflows it will be reset to this value
  ld [pTMA], a

  ; Set up a timer control bitmask.
  ;   TACF_START -> bit 2 high -> start the timer
  ; We want the timer to run at 4KHz
  ;   TACF_4KHZ -> bit 1 and bit 0 low -> 4096 hz timer

  ld a, TACF_START|TACF_4KHZ

  ; $FF07 (TAC) selects the clock frequency. You set it to 4 for a frequency of 4.096Khz
  ld [pTAC], a
  ret

timer_interrupt::
  ; Push AF onto the stack so that we can use a
  push af
  ; Load the current game state onto a
  ld a, [GAME_STATE]

  ; If game state is 0, we're interrupting the splash
  cp $0
  jr z, .interrupt_splash

  ; Otherwise, we're interrupting the game
.interrupt_game:
  pop af
  call handle_game_timer_interrupt
  jr .timer_done

  ; Restore the original values of AF since we're done with them
.interrupt_splash:
  pop af
  call handle_splash_timer_interrupt
  jr .timer_done

.timer_done:
  call init_timer
  reti
