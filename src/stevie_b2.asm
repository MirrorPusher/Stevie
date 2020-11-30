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
        copy  "rb.order.asm"        ; ROM bank order "non-inverted"
        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >3000             ; Top of SP2 stack starts at 2ffe-2fff 
                                    ; and grows downwards

***************************************************************
* BANK 2
********|*****|*********************|**************************
bankid  equ   bank2                 ; Set bank identifier to current bank
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
              #string 'STEVIE V0.1G'
        .else
              #string 'STEVIE V0.1G'
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
        ; Resident Stevie modules: >3000 - >3fff
        ;------------------------------------------------------
        copy  "mem.resident.3000.asm"        
***************************************************************
* Step 4: Include modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6036
        bl    @cpu.crash            ; Should never get here
        ;-----------------------------------------------------------------------
        ; Include files - Utility functions
        ;-----------------------------------------------------------------------         
        copy  "mem.asm"             ; SAMS Memory Management
        ;-----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------         
        copy  "fh.read.edb.asm"     ; Read file to editor buffer
        copy  "fh.write.edb.asm"    ; Write editor buffer to file
        copy  "fm.load.asm"         ; Load DV80 file into editor buffer
        copy  "fm.save.asm"         ; Save DV80 file from editor buffer
        copy  "fm.callbacks.asm"    ; Callbacks for file operations
        ;-----------------------------------------------------------------------
        ; Stubs using trampoline
        ;-----------------------------------------------------------------------        
        copy  "stubs.bank2.asm"     ; Stubs for functions in other banks        
        ;-----------------------------------------------------------------------
        ; Bank specific vector table
        ;----------------------------------------------------------------------- 
        .ifgt $, >7f9b
              .error 'Aborted. Bank 1 cartridge program too large!'
        .else
              data $                ; Bank 1 ROM size OK.
        .endif
        ;-------------------------------------------------------
        ; Vector table bank 2: >7f9c - >7fff
        ;-------------------------------------------------------
        copy  "rb.vectors.bank2.asm"

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