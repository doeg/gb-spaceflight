SECTION "memory", ROMX

INCLUDE "constants.inc"

; Memcpy implementation for Z80.
; From https://github.com/bitnenfer/flappy-boy-asm
;
; de - block size
; bc - source address
; hl - destination address
;
memcpy::
  dec DE
.memcpy_loop:
  ld A, [BC]
  ld [HL], A
  inc BC
  inc HL
  dec DE
.memcpy_check_limit:
  ld A, E
  cp $00
  jr nz, .memcpy_loop
  ld A, D
  cp $00
  jr nz, .memcpy_loop
  ret

; Copy a monochrome font from ROM to RAM.
; From GBHW.INC - Gameboy Hardware definitions for GALP.
;
; hl - pSource
; de - pDest
; bc - bytecount of Source
;
mem_copy_mono::
  inc	b
  inc	c
  jr .skip
.loop
  ld a, [hl+]
  ld [de], a
  inc de
  ld [de], a
  inc de
.skip
  dec c
  jr nz,.loop
  dec b
  jr nz,.loop
  ret

; Set a memory region to a value.
; From GBHW.INC - Gameboy Hardware definitions for GALP.
;
; a - value
; hl - pMem
; bc - bytecount
;
mem_set::
	inc	b
	inc	c
	jr	.skip
.loop	ld	[hl+],a
.skip	dec	c
	jr	nz,.loop
	dec	b
	jr	nz,.loop
	ret
