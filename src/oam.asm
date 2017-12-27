SECTION "oam_utils", ROMX

clear_oam::
  ; Clear out the object attribute memory (OAM)
  ld a, 0 ; value
  ld hl, $FE00 ; start of OAM
  ld bc, $A0 ; the full size of the OAM area: 40 bytes, 4 bytes per sprite
  call mem_set
