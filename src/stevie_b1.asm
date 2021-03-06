***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2021 // Filip van Vooren
***************************************************************
* File: stevie_b1.asm               ; Version %%build_date%%
*
* Bank 1 "James"
*
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options        
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration

***************************************************************
* Spectra2 core configuration
********|*****|*********************|**************************
sp2.stktop    equ >3000             ; SP2 stack starts at 2ffe-2fff and
                                    ; grows downwards to >2000
***************************************************************
* BANK 1
********|*****|*********************|**************************
bankid  equ   bank1.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>7fff           ; Save bank
        ;-------------------------------------------------------
        ; Vector table bank 1: >6000 - >603f
        ;-------------------------------------------------------
        copy  "rom.vectors.bank1.asm"        

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
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
        ; Activate bank 1 and branch to  >6036
        ;------------------------------------------------------
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine
        ;------------------------------------------------------
        ; Resident Stevie modules: >3000 - >3fff
        ;------------------------------------------------------
        copy  "ram.resident.3000.asm"            
***************************************************************
* Step 4: Include main editor modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6046
        b     @main.stevie          ; Start editor 
        ;-----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------
        copy  "main.asm"            ; Main file (entrypoint)
        ;-----------------------------------------------------------------------
        ; Keyboard actions
        ;-----------------------------------------------------------------------
        copy  "edkey.key.process.asm"    ; Process keyboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Framebuffer (1)             
        ;-----------------------------------------------------------------------
        copy  "edkey.fb.mov.leftright.asm" 
                                         ; Move left / right / home / end
        copy  "edkey.fb.mov.word.asm"    ; Move previous / next word
        copy  "edkey.fb.mov.updown.asm"  ; Move line up / down        
        copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
        copy  "edkey.fb.mov.topbot.asm"  ; Move file top / bottom
        copy  "edkey.fb.mov.goto.asm"    ; Goto line in editor buffer
        copy  "edkey.fb.del.asm"         ; Delete characters or lines
        copy  "edkey.fb.ins.asm"         ; Insert characters or lines
        copy  "edkey.fb.mod.asm"         ; Actions for modifier keys                
        copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
        copy  "edkey.fb.file.asm"        ; File related actions
        copy  "edkey.fb.block.asm"       ; Actions for block move/copy/delete...
        copy  "edkey.fb.tabs.asm"        ; tab-key related actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Command Buffer    
        ;-----------------------------------------------------------------------
        copy  "edkey.cmdb.mov.asm"       ; Actions for movement keys 
        copy  "edkey.cmdb.mod.asm"       ; Actions for modifier keys
        copy  "edkey.cmdb.misc.asm"      ; Miscelanneous actions
        copy  "edkey.cmdb.file.new.asm"  ; New DV80 file
        copy  "edkey.cmdb.file.load.asm" ; Read DV80 file
        copy  "edkey.cmdb.file.save.asm" ; Save DV80 file
        copy  "edkey.cmdb.dialog.asm"    ; Dialog specific actions
        ;-----------------------------------------------------------------------
        ; Logic for Framebuffer (1)
        ;-----------------------------------------------------------------------        
        copy  "fb.utils.asm"        ; Framebuffer utilities
        copy  "fb.get.firstnonblank.asm"
                                    ; Get column of first non-blank character
        copy  "fb.refresh.asm"      ; Refresh framebuffer
        copy  "fb.restore.asm"      ; Restore frame buffer to normal operation
        ;-----------------------------------------------------------------------
        ; Logic for Index management
        ;-----------------------------------------------------------------------
        copy  "idx.update.asm"      ; Index management - Update entry
        copy  "idx.pointer.asm"     ; Index management - Get pointer to line
        copy  "idx.delete.asm"      ; Index management - delete slot
        copy  "idx.insert.asm"      ; Index management - insert slot
        ;-----------------------------------------------------------------------
        ; Logic for Editor Buffer
        ;-----------------------------------------------------------------------
        copy  "edb.utils.asm"          ; Editor buffer utilities
        copy  "edb.line.mappage.asm"   ; Activate SAMS page for line
        copy  "edb.line.pack.fb.asm"   ; Pack line into editor buffer
        copy  "edb.line.unpack.fb.asm" ; Unpack line from editor buffer
        copy  "edb.line.getlen.asm"    ; Get line length
        copy  "edb.line.copy.asm"      ; Copy line
        copy  "edb.line.del.asm"       ; Delete line        
        copy  "edb.block.mark.asm"     ; Mark code block
        copy  "edb.block.reset.asm"    ; Reset markers
        copy  "edb.block.copy.asm"     ; Copy code block
        copy  "edb.block.del.asm"      ; Delete code block
        ;-----------------------------------------------------------------------
        ; Command buffer handling
        ;-----------------------------------------------------------------------
        copy  "cmdb.refresh.asm"    ; Refresh command buffer contents
        copy  "cmdb.cmd.asm"        ; Command line handling
        ;-----------------------------------------------------------------------
        ; User hook, background tasks
        ;-----------------------------------------------------------------------
        copy  "hook.keyscan.asm"           ; spectra2 user hook: keyboard scan
        copy  "task.vdp.panes.asm"         ; Draw editor panes in VDP

    .ifeq device.f18a,1

        copy  "task.vdp.cursor.sat.asm"    ; Copy cursor SAT to VDP
        copy  "task.vdp.cursor.f18a.asm"   ; Set cursor shape in VDP (blink)

    .else 

        copy  "task.vdp.cursor.9938.asm"   ; Set cursor shape in VDP (blink)    
  
    .endif

        copy  "task.oneshot.asm"           ; Run "one shot" task
        ;-----------------------------------------------------------------------
        ; Screen pane utilities
        ;-----------------------------------------------------------------------
        copy  "pane.utils.asm"             ; Pane utility functions
        copy  "pane.utils.hint.asm"        ; Show hint in pane
        copy  "pane.utils.colorscheme.asm" ; Colorscheme handling in panes 
        copy  "pane.cursor.asm"            ; Cursor utility functions        
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------   
        copy  "colors.line.set.asm"        ; Set color combination for line
        copy  "pane.cmdb.asm"              ; Command buffer 
        copy  "pane.cmdb.show.asm"         ; Show command buffer pane
        copy  "pane.cmdb.hide.asm"         ; Hide command buffer pane
        copy  "pane.cmdb.draw.asm"         ; Draw command buffer pane contents

        copy  "pane.topline.asm"           ; Top line
        copy  "pane.errline.asm"           ; Error line
        copy  "pane.botline.asm"           ; Bottom line
        ;-----------------------------------------------------------------------
        ; Stubs using trampoline
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank1.asm"        ; Stubs for functions in other banks
        ;-----------------------------------------------------------------------
        ; Program data
        ;----------------------------------------------------------------------- 
        copy  "data.keymap.actions.asm"    ; Data segment - Keyboard actions
        ;-----------------------------------------------------------------------
        ; Bank specific vector table
        ;----------------------------------------------------------------------- 
        .ifgt $, >7fff
              .error 'Aborted. Bank 1 cartridge program too large!'
        .else
              data $                ; Bank 1 ROM size OK.
        .endif

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
