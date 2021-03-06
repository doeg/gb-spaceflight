INCLUDE "constants.inc"
INCLUDE "macros.inc"

SECTION  "Vblank", ROM0[$0040]
  jp pVBLANK_HANDLER
SECTION  "LCDC", ROM0[$0048]
  reti
SECTION  "Timer_Overflow", ROM0[$0050]
  jp timer_handler
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
GAME_STATE:: ds 1

SECTION "main", ROMX

main::
  _RESET_

  ; Clear the game state
  xor a
  ld [GAME_STATE], a

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

timer_handler::
  push af
  ld a, [GAME_STATE]
  cp $0
  call z, handle_splash_timer_interrupt
  cp $1
  call z, handle_game_timer_interrupt
  pop af
  reti

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

; Calls the timer interrupt 64 times a second
; Uses the 4096 MHz timer with a modulo of 5.
; See http://gameboy.mongenel.com/dmg/timer.txt
init_timer::
  ld a, -32
  ld [pTMA], a
  ld a, 4
  ld [pTAC], a
  ret
