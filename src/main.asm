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

; Shadow OAM needs to be 16-byte aligned since
; the last two hex digits of the address are
; assumed to be 00 during DMA transfer.
SECTION "variables", WRAM0, ALIGN[2]
variables_start:
SHADOW_OAM:: ds 40 * 4
variables_end:

SECTION "main", ROMX

main::
  nop
  _RESET_
  jp start_splash

; Copies the DMA handler code to HRAM
init_dma::
  ; FIXME the final reti gets clipped unless a +1 is added.
  ; I think this memcpy implementation has an off-by-one error...
  ; at least, for how I want to use it.
  ld de, vblank_handler_end - vblank_handler + 1
  ld bc, vblank_handler
  ld hl, pVBLANK_HANDLER
  call memcpy
  ret

vblank_handler::
  push af
  ld a, pSHADOW_OAM / $100
  ; Invoke DMA
  ldh [pOAM_DMA_TRANS], a
  ; Delay for 28 (5 x 50) cycles (~200ms)
  ld a, $28
.dma_wait:
  dec a
  jr nz, .dma_wait
  pop af
  reti
vblank_handler_end:

clear_oam::
  push af
  push hl
  push bc

  xor a
  ld hl, $FE00 ; start of OAM
  ld bc, $A0 ; the full size of the OAM area: 40 bytes, 4 bytes per sprite
  call mem_set

  xor a
  ld hl, pSHADOW_OAM
  ld bc, pSHADOW_OAM_END - pSHADOW_OAM
  call mem_set

  pop bc
  pop hl
  pop af
  ret
