SECTION "memory", ROMX
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
