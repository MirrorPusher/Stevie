* FILE......: idx_delete.asm
* Purpose...: Delete index entry

***************************************************************
* _idx.entry.delete.reorg
* Reorganize index slot entries
***************************************************************
* bl @_idx.entry.delete.reorg
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_delete
********|*****|*********************|**************************
_idx.entry.delete.reorg:
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
        ai    tmp0,idx.top          ; Add index base to offset        
        mov   tmp0,tmp1             ; a = current slot
        inct  tmp1                  ; b = current slot + 2
        ;------------------------------------------------------
        ; Loop forward until end of index
        ;------------------------------------------------------
_idx.entry.delete.reorg.loop:        
        mov   *tmp1+,*tmp0+         ; Copy b -> a       
        dec   tmp2                  ; tmp2--
        jne   _idx.entry.delete.reorg.loop
                                    ; Loop unless completed
        b     *r11                  ; Return to caller



***************************************************************
* idx.entry.delete
* Delete index entry - Close gap created by delete
***************************************************************
* bl @idx.entry.delete
*--------------------------------------------------------------
* INPUT
* @parm1    = Line number in editor buffer to delete
* @parm2    = Line number of last line to check for reorg
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
********|*****|*********************|**************************
idx.entry.delete:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;------------------------------------------------------
        ; Get index slot
        ;------------------------------------------------------      
        mov   @parm1,tmp0           ; Line number in editor buffer

        bl    @_idx.samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page
        
        mov   @outparm1,tmp0        ; Index offset
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        jeq   idx.entry.delete.lastline
                                    ; Exit early if last line = 0

        s     @parm1,tmp2           ; Calculate loop         
        jgt   idx.entry.delete.reorg
                                    ; Reorganize if loop counter > 0
        ;------------------------------------------------------
        ; Special treatment for last line
        ;------------------------------------------------------
idx.entry.delete.lastline:        
        ai    tmp0,idx.top          ; Add index base to offset        
        clr   *tmp0                 ; Clear index entry        
        jmp   idx.entry.delete.exit ; Exit early
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.delete.reorg:
        mov   @parm2,tmp3           ; Get last line to reorganize
        ci    tmp3,2048
        jle   idx.entry.delete.reorg.simple
                                    ; Do simple reorg only if single
                                    ; SAMS index page, otherwise complex reorg.
        ;------------------------------------------------------
        ; Complex index reorganization (multiple SAMS pages)
        ;------------------------------------------------------
idx.entry.delete.reorg.complex:        
        bl    @_idx.sams.mapcolumn.on
                                    ; Index in continuous memory region                

        ;-------------------------------------------------------
        ; Recalculate index offset in continuous memory region
        ;-------------------------------------------------------        
        mov   @parm1,tmp0           ; Restore line number
        sla   tmp0,1                ; Calculate offset

        bl    @_idx.entry.delete.reorg
                                    ; Reorganize index
                                    ; \ i  tmp0 = Index offset
                                    ; / i  tmp2 = Loop count

        bl    @_idx.sams.mapcolumn.off 
                                    ; Restore memory window layout

        jmp   !
        ;------------------------------------------------------
        ; Simple index reorganization
        ;------------------------------------------------------
idx.entry.delete.reorg.simple:
        bl    @_idx.entry.delete.reorg
        ;------------------------------------------------------
        ; Clear index entry (base + offset already set)
        ;------------------------------------------------------              
!       clr   *tmp0                 ; Clear index entry
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.delete.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
