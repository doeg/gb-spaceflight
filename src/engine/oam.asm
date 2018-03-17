; Shadow OAM needs to be 16-byte aligned since
; the last two hex digits of the address are
; assumed to be 00 during DMA transfer.
SECTION "shadow_oam", WRAM0, ALIGN[2]

; The shadow OAM is essentially a double buffer for the "real" OAM.
; The real OAM can only be accessed during Vblank; it is locked
; during Vdraw. The shadow OAM can be written to at any time,
; and copied over to the real OAM during Vblank (using DMA).
;
; The shadow OAM is the same size as the regular OAM:
; 40 x 4-byte indices, each storing sprite metadata.
;
; Each 4-byte index (or "block") has the following format
; (see http://gameboy.mongenel.com/dmg/gbspec.txt)
;
; Byte0  Y position on the screen
; Byte1  X position on the screen
; Byte2  Pattern number 0-255 (Unlike some tile
;        numbers, sprite pattern numbers are unsigned.
;        LSB is ignored (treated as 0) in 8x16 mode.)
; Byte3  Flags:
;
;        Bit7  Priority
;              If this bit is set to 0, sprite is displayed
;              on top of background & window. If this bit
;              is set to 1, then sprite will be hidden behind
;              colors 1, 2, and 3 of the background & window.
;              (Sprite only prevails over color 0 of BG & win.)
;        Bit6  Y flip
;              Sprite pattern is flipped vertically if
;              this bit is set to 1.
;        Bit5  X flip
;              Sprite pattern is flipped horizontally if
;              this bit is set to 1.
;        Bit4  Palette number
;              Sprite colors are taken from OBJ1PAL if
;              this bit is set to 1 and from OBJ0PAL
;              otherwise.
SHADOW_OAM:: ds 40 * 4
