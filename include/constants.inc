; Constants prefixed with "p" are pointers (addresses)
; to a memory location; e.g., pHRAM.
;
; When a range of addresses is given by two constants,
; that range is inclusive. (e.g., pOAM, pOAM_END).
;
; Addresses are organized from lowest ($0000)
; to highest ($0000).
;
; Hex uses lowercase letters because it's easier
; to read :B
;
; Resources:
;   - http://gameboy.mongenel.com/dmg/asmmemmap.html
;   - http://gameboy.mongenel.com/dmg/gbspec.txt

; Used for sprites, the background, and the window display.
; Tiles are numbered from 0 to 255.
pVRAM_TILES_SPRITE       EQU $8000
; Used for the background and the window display. It is organized as 32 rows of 32 bytes each.
; Each byte contains a number of a tile to be displayed. The Tile Data Table address for the
; background can be selected by setting the LCDC register.
; Tiles in pVRAM_TILES_MIX are numbered with unsigned numbers from 0 to 255.
pVRAM_TILES_MIX          EQU $8800
; Tiles in pVRAM_TILES_BACKGROUND are numbered with signed numbers from -128 to 127.
pVRAM_TILES_BACKGROUND   EQU $9000

; There are two different Background Tile Maps. One is
; located from $9800-9Bff. The other from $9C00-9FFF.
; Only one of these can be viewed at any one time. The
; currently displayed background can be selected by
; setting the LCDC register.
pVRAM_MAP_CHR            EQU $9800
pVRAM_MAP_BG             EQU $9c00

; OAM (object attribute memory, a.k.a. the sprite
; attribute table). This is mirrored by the range
; beginning at pSHADOW_OAM.
pOAM                     EQU $fe00
pOAM_END                 EQU $fe9f
; Register for reading joypad information & determining system type.
pUSER_IO                 EQU $ff00
; TMA - Timer modulo (R/W)
pTMA                     EQU $ff06
; TAC - Timer control (R/W)
pTAC                     EQU $ff07
; IF - Interrupt Flag (R/W)
pINTERRUPT_FLAG          EQU $ff0f
; LCD control flags.
pLCD_CTRL                EQU $ff40
; LCDC Status, shows the current status of the LCD controller.
pLCD_STAT                EQU $ff41
; 8 Bit value $00-$FF to scroll BG Y screen
pLCD_SCROLL_Y            EQU $ff42
; 8 Bit value $00-$FF to scroll BG X screen position
pLCD_SCROLL_X            EQU $ff43
; The LY indicates the vertical line to which
; the present data is transferred to the LCD
; Driver. The LY can take on any value between
; 0 through 153. The values between 144 and 153
; indicate the V-Blank period. Writing will
; reset the counter.
pLCD_LINE_Y              EQU $ff44
; The LYC compares itself with the LY. If the
; values are the same it causes the STAT to set
; the coincident flag.
pLCD_LINE_Y_CP           EQU $ff45
; The DMA Transfer (40*28 bit) from internal ROM or RAM
; ($0000-$F19F) to the OAM (address $FE00-$FE9F) can be
; performed. It takes 160 microseconds for the transfer.
pOAM_DMA_TRANS           EQU $ff46
; This selects the shade of grays to use for
; the background (BG) & window pixels. Since
; each pixel uses 2 bits, the corresponding
; shade will be selected from here.
pLCD_BG_PAL              EQU $ff47
; This selects the colors for sprite palette 0.
; It works exactly as BGP ($FF47) except each
; each value of 0 is transparent.
pOBJ0_PAL                EQU $ff48
; This Selects the colors for sprite palette 1.
; It works exactly as OBP0 ($FF48).
pOBJ1_PAL                EQU $ff49

; Window Y position. 0 <= WY <= 143.
pWIN_Y                   EQU $ff4a
; Window X position. 0 <= WX <= 166
; WX is offset from absolute screen coordinates
; by 7. Setting the window to WX=7, WY=0 will
; put the upper left corner of the window at
; absolute screen coordinates 0,0.
pWIN_X                   EQU $ff4b

; High RAM, (a.k.a. high memory, HMEM)
pHRAM                    EQU $ff80
pHRAM_END                EQU $fffe
pSTACK                   EQU pHRAM_END

; IE - Interrupt Enable (R/W)
pINTERRUPT_ENABLE        EQU $ffff

; TODO: comment this
VRAM_MAP_BLOCK0_SIZE    EQU    $0800

; Joypad constants
NO_INPUT_P14            EQU    $EF      ; LEFT, RIGHT, UP, DOWN
NO_INPUT_P15            EQU    $DF      ; A, B, SELECT, START
BUTTON_RIGHT            EQU    $0
BUTTON_LEFT             EQU    $1
BUTTON_UP               EQU    $2
BUTTON_DOWN             EQU    $3
BUTTON_A                EQU    $0
BUTTON_B                EQU    $1
BUTTON_SELECT           EQU    $2
BUTTON_START            EQU    $3

; LCD constants
LCD_WIDTH               EQU    160
LCD_HEIGHT              EQU    144

; Timer constants
IEF_HILO    EQU  %00010000 ; Transition from High to Low of Pin number P10-P13
IEF_SERIAL  EQU  %00001000 ; Serial I/O transfer end
IEF_TIMER   EQU  %00000100 ; Timer Overflow
IEF_LCDC    EQU  %00000010 ; LCDC (see STAT)
IEF_VBLANK  EQU  %00000001 ; V-Blank

TACF_START   EQU %00000100
TACF_STOP    EQU %00000000
TACF_4KHZ    EQU %00000000
TACF_16KHZ   EQU %00000011
TACF_65KHZ   EQU %00000010
TACF_262KHZ  EQU %00000001
