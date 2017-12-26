SECTION "memory", ROMX

INCLUDE "constants.inc"

; memcpy implementation for Z80
memcpy::
    ; DE = block size
    ; BC = source address
    ; HL = destination address
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

;***************************************************************************
;*
;* mem_Copy - "Copy" a monochrome font from ROM to RAM
;*
;* input:
;*   hl - pSource
;*   de - pDest
;*   bc - bytecount of Source
;*
;***************************************************************************
mem_copy_mono::
	inc	b
	inc	c
	jr	.skip
.loop
  ld	a,[hl+]
	ld	[de],a
	inc	de
  ld      [de],a
  inc     de
.skip
  dec	c
	jr	nz,.loop
	dec	b
	jr	nz,.loop
	ret


;***************************************************************************
;*
;* mem_Set - "Set" a memory region
;*
;* input:
;*    a - value
;*   hl - pMem
;*   bc - bytecount
;*
;***************************************************************************
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

; Copies the dma code to HRAM
setup_dma::
  ld de, dma_copy_end - dma_copy ;len
  ld bc, dma_copy ;src
  ld hl, $FF80 ; dest, start of HRAM
  call memcpy
	ret				; go back to what we were doing

; Copies the dma code to HRAM
dma_copy::
	push af				; store the old a and status reg (f) on the stack so we can use them for our own purposes
	ld a, $C0			; OamData variable
	ldh [OAM_DMA_TRANS], a			; once we put this address into the DMA register, the transfer will begin ($A0 bytes from $C000)

	; now we want to delay for 160us while the data gets copied
	; this uses a basic countdown-jump back loop
	ld a, $28			; this is our countdown value ($28 to 0)
dma_copy_wait:
	dec a
	jr nz, dma_copy_wait		; if a is not 0, jump back to the wait loop

	; once we are here, the dma is all done
	pop af				; restore af to its old value
	reti				; and go back to what we were doing
dma_copy_end:
