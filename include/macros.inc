_RESET_: MACRO
  ; Set the stack pointer
  ld SP, pSTACK

  ; Need to wait for vblank so that we can manipulate VRAM
  call wait_vblank
  call lcd_off

  ; Clear out HMEM. -1 so we don't trample the stack pointer
  ; on the call to mem_set, and -1 again since subtracting the
  ; start and end of HMEM gives an inclusive range and mem_set
  ; takes an exclusive range.
  xor a ; value
  ld hl, pHRAM; hl - pMem
  ld bc, pHRAM_END - pHRAM - 2 ; bytecount
  call mem_set

  ld hl, pOAM
  ld bc, pOAM_END - pOAM - 1
  call mem_set

  call wait_vblank
  call lcd_off
  call clear_bg_map
  call lcd_on

  ld HL, LCD_SCROLL_Y
  ld [HL], $00
  ld HL, LCD_SCROLL_X
  ld [HL], $00
  ENDM
