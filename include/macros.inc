_RESET_: MACRO
  ld SP, pSTACK

  call wait_vblank
  call lcd_off
  call clear_bg_map

  ; Clear OAM
  ld a, 0 ; value
  ld hl, $FE00 ; start of OAM
  ld bc, $A0 ; the full size of the OAM area: 40 bytes, 4 bytes per sprite
  call mem_set

  call lcd_on

  ld HL, pLCD_SCROLL_Y
  ld [HL], $00
  ld HL, pLCD_SCROLL_X
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
