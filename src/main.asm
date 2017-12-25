SECTION "rom", ROM0

INCLUDE "interrupts.inc"
INCLUDE "constants.inc"
INCLUDE "macros.inc"

jp main

INCLUDE "header.inc"

main::
  jp start_splash

start_splash::
  ld B, $16 ; clear tile ID
  _RESET_
  call wait_vblank
  call lcd_off
  call load_splash_data
  call lcd_on 

.splash_loop:
  call wait_vblank
  jr .splash_loop
