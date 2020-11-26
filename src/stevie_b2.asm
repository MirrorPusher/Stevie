***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: stevie_b1.asm               ; Version %%build_date%%
*
* Bank 2 "Jacky"
*
***************************************************************
        copy  "bank.noninverted.asm"    
                                    ; Bank order "non-inverted"

        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >3000             ; Top of SP2 stack starts at 2ffe-2fff 
                                    ; and grows downwards

***************************************************************
* BANK 2
********|*****|*********************|**************************
        aorg  >6000
        save  >6000,>7fff           ; Save bank 2
*--------------------------------------------------------------
* Cartridge header
********|*****|*********************|**************************
        byte  >aa,1,1,0,0,0
        data  $+10
        byte  0,0,0,0,0,0,0,0
        data  0                     ; No more items following
        data  kickstart.code1

        .ifdef debug
              #string 'STEVIE V0.1F'
        .else
              #string 'STEVIE V0.1F'
        .endif

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6030
        clr   @bank0                ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Satisfy assembler, must know SP2 in low MEMEXP
********|*****|*********************|**************************
        aorg  >2000                 
        copy  "%%spectra2%%/runlib.asm"
                                    ; Relocated spectra2 in low MEMEXP, was
                                    ; copied to >2000 from ROM in bank 0
        ;------------------------------------------------------
        ; End of File marker
        ;------------------------------------------------------
        data >dead,>beef,>dead,>beef     
        .print "***** PC relocated SP2 library @ >2000 - ", $, "(dec)"                                    
***************************************************************
* Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
********|*****|*********************|**************************
        aorg  >3000
        ;------------------------------------------------------
        ; Activate bank 1 and branch to >6036
        ;------------------------------------------------------
        clr   @bank1                ; Activate bank 1 "James"
        b     @kickstart.code2      ; Jump to entry routine
        ;------------------------------------------------------
        ; Resident Stevie modules >3000 - >3fff
        ;------------------------------------------------------
        copy  "fb.asm"              ; Framebuffer      
        copy  "idx.asm"             ; Index management           
        copy  "edb.asm"             ; Editor Buffer        
        copy  "cmdb.asm"            ; Command buffer            
        copy  "errline.asm"         ; Error line
        copy  "tv.asm"              ; Main editor configuration        
        copy  "data.constants.asm"  ; Data Constants
        copy  "data.strings.asm"    ; Data segment - Strings
        copy  "data.keymap.asm"     ; Data segment - Keyboard mapping        
        ;------------------------------------------------------
        ; End of File marker
        ;------------------------------------------------------        
        data  >dead,>beef,>dead,>beef
        .print "***** PC resident stevie modules @ >3000 - ", $, "(dec)"
***************************************************************
* Step 4: Include modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6036
        jmp   $
        ;-----------------------------------------------------------------------
        ; Dialogs
        ;-----------------------------------------------------------------------           
        copy  "dialog.about.asm"    ; Dialog "About"

        ;-----------------------------------------------------------------------
        ; Bank specific vector table
        ;----------------------------------------------------------------------- 
        .ifgt $, >7fce
              .error 'Aborted. Bank 1 cartridge program too large!'
        .else
              data $                ; Bank 1 ROM size OK.
        .endif

        aorg  >7fe0
        
vector.0   data  $
vector.1   data  edkey.action.about 
vector.2   data  $
vector.3   data  $
vector.4   data  $
vector.5   data  $
vector.6   data  $
vector.7   data  $
vector.8   data  $
vector.9   data  $
vector.a   data  $
vector.b   data  $
vector.c   data  $
vector.d   data  $
vector.e   data  $
vector.f   data  $


*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table
