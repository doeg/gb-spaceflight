_RESET_: MACRO
  ld SP, $fffe

  call wait_vblank
  call lcd_off
  call clear_bg_map
  call lcd_on

  ld HL, LCD_SCROLL_Y
  ld [HL], $00
  ld HL, LCD_SCROLL_X
  ld [HL], $00
  ENDM
