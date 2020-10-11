* FILE......: edkey.fb.del.asm
* Purpose...: Delete related actions in frame buffer pane.


*---------------------------------------------------------------
* Delete character
*---------------------------------------------------------------
edkey.action.del_char:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        ;-------------------------------------------------------
        ; Sanity check 1 - Empty line
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.del_char.exit
                                    ; Exit if empty line
        ;-------------------------------------------------------
        ; Sanity check 2 - Already at EOL
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   edkey.action.del_char.exit
                                    ; Exit if at EOL
        ;-------------------------------------------------------
        ; Prepare for delete operation
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   tmp0,tmp1             ; \ tmp0 = Current character
        inc   tmp1                  ; / tmp1 = Next character
        ;-------------------------------------------------------
        ; Loop until end of line
        ;-------------------------------------------------------
edkey.action.del_char_loop:
        movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
        dec   tmp2
        jne   edkey.action.del_char_loop
        ;-------------------------------------------------------
        ; Special treatment if line 80 characters long
        ;-------------------------------------------------------
        li    tmp2,colrow
        c     @fb.row.length,tmp2
        jne   !
        dec   tmp0                  ; One time adjustment
        clr   tmp1
        movb  tmp1,*tmp0            ; Write >00 character
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
!       seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        dec   @fb.row.length        ; @fb.row.length--
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Delete until end of line
*---------------------------------------------------------------
edkey.action.del_eol:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.del_eol.exit
                                    ; Exit if empty line
        ;-------------------------------------------------------
        ; Prepare for erase operation
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.colsline,tmp2
        s     @fb.column,tmp2
        clr   tmp1
        ;-------------------------------------------------------
        ; Loop until last column in frame buffer
        ;-------------------------------------------------------
edkey.action.del_eol_loop:
        movb  tmp1,*tmp0+           ; Overwrite current char with >00
        dec   tmp2
        jne   edkey.action.del_eol_loop
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh

        mov   @fb.column,@fb.row.length
                                    ; Set new row length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_eol.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Delete current line
*---------------------------------------------------------------
edkey.action.del_line:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Special treatment if only 1 line in file
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        jne   !
        clr   @fb.column            ; Column 0
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @edkey.action.del_eol ; Delete until end of line
        ;-------------------------------------------------------
        ; Delete entry in index
        ;-------------------------------------------------------
!       bl    @fb.calc_pointer      ; Calculate position in frame buffer
        clr   @fb.row.dirty         ; Discard current line        
        mov   @fb.topline,@parm1    
        a     @fb.row,@parm1        ; Line number to remove
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        bl    @idx.entry.delete     ; Reorganize index
        dec   @edb.lines            ; One line less in editor buffer
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Special treatment if current line was last line
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     tmp0,@edb.lines       ; Was last line?
        jle   edkey.action.del_line.exit
        b     @edkey.action.up      ; One line up
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_line.exit:
        b     @edkey.action.home    ; Move cursor to home and return
