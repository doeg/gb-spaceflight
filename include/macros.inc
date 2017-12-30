_RESET_: MACRO
  di
  ld SP, pSTACK

  ; Clear HRAM. -2 to save room for the stack,
  ; and because the range is inclusive.
  xor a
  ld hl, pHRAM
  ld bc, pHRAM_END - pHRAM - 2
  call mem_set

  call wait_vblank
  call lcd_off

  call clear_oam
  call init_dma

  call clear_bg_map
  call lcd_on

  ; Reset the viewport to the top-left corner.
  ; TODO refactor into function
  ld HL, pLCD_SCROLL_Y
  ld [HL], $00
  ld HL, pLCD_SCROLL_X
  ld [HL], $00

  call clear_joypad

  ; Enable timer, vblank, and joypad interrupts
  ld a, IEF_TIMER | IEF_VBLANK | IEF_HILO
  ld [pINTERRUPT_ENABLE], a

  ei
  ENDM
