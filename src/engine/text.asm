SECTION "text_utils", ROM0

INCLUDE "constants.inc"

; Arguments:
;   hl - pointer to string, must be terminated by "@"
;   de - destination
;
; Strings must be terminated by "@" to mark the end of the
; string (since byte count is determinted dynamically.)
text_print::
  push hl

  ; bc - counter for string length in bytes
  ld bc, $0000

.loop:
  ld a, [hl+]
  cp "@"
  jr z, .loop_end
  inc bc
  jr .loop

.loop_end:
  pop hl
  ret
