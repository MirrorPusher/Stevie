* FILE......: fm.load.asm
* Purpose...: File Manager - Load file into editor buffer

***************************************************************
* fm.loadfile
* Load file into editor buffer
***************************************************************
* bl  @fm.loadfile
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
*--------------------------------------------------------------- 
* OUTPUT
* outparm1 = >FFFF if editor bufer dirty (does not load file)
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.loadfile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Exit early if editor buffer is dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp1       ; Get dirty flag
        jeq   !                     ; Load file if not dirty

        seto  @outparm1             ; \ 
        jmp   fm.loadfile.exit      ; / Editor buffer dirty, exit early 
        ;-------------------------------------------------------
        ; Reset editor
        ;-------------------------------------------------------
!       bl    @tv.reset             ; Reset editor
        ;-------------------------------------------------------
        ; Change filename
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; Source address
        li    tmp1,edb.filename     ; Target address
        li    tmp2,80               ; Number of bytes to copy
        mov   tmp1,@edb.filename.ptr
                                    ; Set filename

        bl    @xpym2m               ; tmp0 = Memory source address
                                    ; tmp1 = Memory target address
                                    ; tmp2 = Number of bytes to copy
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
        bl    @filv
              data sprsat,>0000,4   ; Turn off sprites (cursor)

        mov   @fb.scrrows.max,tmp1
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!
 
        bl    @scroff               ; Turn off screen
        
        li    tmp0,>0050            ; VDP target address (2nd row on screen!)
        li    tmp1,32               ; Character to fill

        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Bytes to copy

        bl    @pane.action.colorscheme.load
                                    ; Load color scheme and turn on screen
        ;-------------------------------------------------------
        ; Read DV80 file and display
        ;-------------------------------------------------------
        li    tmp0,fm.loadsave.cb.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadsave.cb.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadsave.cb.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadsave.cb.fioerr
        mov   tmp0,@parm5           ; Register callback 4

        bl    @fh.file.read.edb     ; Read file into editor buffer
                                    ; \ i  parm1 = Pointer to length prefixed 
                                    ; |            file descriptor
                                    ; | i  parm2 = Pointer to callback
                                    ; |            "Before Open file"
                                    ; | i  parm3 = Pointer to callback
                                    ; |            "Read line from file"
                                    ; | i  parm4 = Pointer to callback
                                    ; |            "Close file"
                                    ; | i  parm5 = Pointer to callback 
                                    ; /            "File I/O error"

        clr   @edb.dirty            ; Editor buffer content replaced, not
                                    ; longer dirty.
                                    
        li    tmp0,txt.filetype.DV80                                     
        mov   tmp0,@edb.filetype.ptr
                                    ; Set filetype display string

        clr   @outparm1             ; Reset                                    
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.loadfile.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller