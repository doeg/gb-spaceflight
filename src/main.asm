INCLUDE "constants.inc"
INCLUDE "macros.inc"

SECTION  "Vblank", ROM0[$0040]
  jp pVBLANK_HANDLER
SECTION  "LCDC", ROM0[$0048]
  reti
SECTION  "Timer_Overflow", ROM0[$0050]
  reti
SECTION  "Serial", ROM0[$0058]
  reti
SECTION  "p1thru4", ROM0[$0060]
  reti

; Point-of-entry
SECTION  "start", ROM0[$0100]
  nop
  jp main

INCLUDE "header.inc"

SECTION "main", ROMX

main::
  nop
  _RESET_

.loop:
  nop
  nop
  jr .loop

; Copies the DMA handler code to HRAM
init_dma::
  ld de, vblank_handler_end - vblank_handler + 1 ;block size
  ld bc, vblank_handler ;source
  ld hl, pVBLANK_HANDLER; dest
  call memcpy
  ret

vblank_handler::
  push af
  push hl
  nop
  nop
  nop
  pop hl
  pop af
  reti
vblank_handler_end:
