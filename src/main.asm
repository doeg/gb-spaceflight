INCLUDE "constants.inc"
INCLUDE "macros.inc"

SECTION	"Vblank", ROM0[$0040]
	reti
SECTION	"LCDC", ROM0[$0048]
	reti
SECTION	"Timer_Overflow", ROM0[$0050]
	reti
SECTION	"Serial", ROM0[$0058]
	reti
SECTION	"p1thru4", ROM0[$0060]
	reti

SECTION	"start", ROM0[$0100]
  nop
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
