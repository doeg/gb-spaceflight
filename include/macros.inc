_RESET_: MACRO
  ld SP, pSTACK

  call wait_vblank
  call lcd_off
  call clear_bg_map
  call lcd_on

  ld HL, LCD_SCROLL_Y
  ld [HL], $00
  ld HL, LCD_SCROLL_X
  ld [HL], $00

  ; Clear HRAM. -2 to save room for the stack,
  ; and because the range is inclusive.
  xor a
  ld hl, pHRAM
  ld bc, pHRAM_END - pHRAM - 2
  call mem_set

  ; TODO clear OAM
  ; TODO clear shadow OAM

  call clear_joypad

  ENDM
