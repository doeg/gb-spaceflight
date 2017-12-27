; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: ship.png
; Pixel Width: 16px
; Pixel Height: 16px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

ship_tile_map_size EQU $04
ship_tile_map_width EQU $02
ship_tile_map_height EQU $02

ship_tile_data_size EQU $40
ship_tile_count EQU $04

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

ship_map_data:
DB $00,$01,$02,$03

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

ship_tile_data:
DB $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00
DB $00,$11,$00,$00,$00,$0B,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$10,$00,$00,$00,$A0,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00