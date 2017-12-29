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



SECTION "timer_vars", WRAM0[$C800]

; Whatever, just a counter
COUNTER:: ds 1

; Maintains game state (splash, game, game over)
GAME_STATE:: ds 1
GAME_STATE_SPLASH EQU $00
GAME_STATE_GAME EQU $01

SECTION "main", ROMX

main::
  nop
  jp start_splash

start_splash::
  ; Disable interrupts while we manipulate VRAM
  di

  ; Clear the screen
  ld B, $16
  _RESET_
  call clear_joypad

  ; Initialize splash data
  call wait_vblank
  call lcd_off
  call load_splash_data
  call lcd_on

  di
  ; Enable timer, vblank, and joypad interrupts
  ld a, IEF_TIMER | IEF_VBLANK | IEF_HILO
  ld [rIE], a

  ; Initialize the interrupt counter to 0
  ld a, 0
  ld [COUNTER], a

  ; Initialize timer code
  call init_timer

  ; Set the game state
  ld a, GAME_STATE_SPLASH
  ld [GAME_STATE], a

  ; Enable interrupts
  ei

.splash_loop:
  call wait_vblank
  call update_splash
  jr .splash_loop

start_game::
  di
  ld B, $00 ; clear tile id
  _RESET_
  call clear_joypad
  call wait_vblank
  call lcd_off

  ; Set the X/Y scroll registers to the upper left of the tile map
  ld a, 50
  ld [LCD_SCROLL_X], a
  ld [LCD_SCROLL_Y], a
  ; Change the game state
  ld a, GAME_STATE_GAME
  ld [GAME_STATE], a

  call load_game_data
  call lcd_on
  ei
  jp run_game

; See http://gameboy.mongenel.com/dmg/timer.txt
init_timer::
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

  ; $FF07 (TAC) selects the clock frequency. You set it to 4 for a frequency of 4.096Khz
  ld [rTAC], a
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
