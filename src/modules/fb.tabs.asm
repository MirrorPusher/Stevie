* FILE......: fb.tabs.asm
* Purpose...: Tabbing functionality in frame buffer

***************************************************************
* _fb.null2char
* Replace all null characters with character
***************************************************************
*  bl   @_fb.null2char
*--------------------------------------------------------------
* INPUT
* tmp1 = Replacement character
* tmp2 = Length of row
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
*--------------------------------------------------------------
* Remarks
* Internal method. Only to be called from fb.tab.asm
********|*****|*********************|**************************
_fb.null2char:
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
        ;-------------------------------------------------------
        ; Sanity checks
        ;-------------------------------------------------------
        mov   tmp2,tmp2             ; Minimum 1 character
        jeq   _fb.null2char.crash  
        ci    tmp2,80               ; Maximum 80 characters
        jle   _fb.null2char.init
        ;------------------------------------------------------
        ; Asserts failed
        ;------------------------------------------------------
_fb.null2char.crash:        
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
_fb.null2char.init:
        mov   tmp1,tmp3             ; Get character to write
        sla   tmp3,8                ; LSB to MSB

        clr   @fb.column
        bl    @fb.calc_pointer      ; Beginning of row
        mov   @fb.current,tmp0      ; Get position
        ;-------------------------------------------------------
        ; Loop over characters in line
        ;-------------------------------------------------------
_fb.null2char.loop:
        clr   tmp1
        movb  *tmp0,tmp1            ; Get character
        jne   !                     ; Not a null character, skip it
        li    tmp1,>2a00            ; ASCII 32 in MSB
        movb  tmp3,*tmp0            ; Replace null character
        ;-------------------------------------------------------
        ; Prepare for next iteration
        ;-------------------------------------------------------
!       inc   tmp0                  ; Move to next character
        dec   tmp2
        jgt   _fb.null2char.loop   ; Repeat until done
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
_fb.null2char.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0          
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



***************************************************************
* fb.tab.next
* Move cursor to next tab position
***************************************************************
*  bl   @fb.tab.next
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* For simplicity reasons we're assuming base 1 during copy
* (first line starts at 1 instead of 0). 
* Makes it easier when comparing values.
********|*****|*********************|**************************
fb.tab.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
        li    tmp0,tv.tabs.table    ; Get pointer to tabs table
        li    tmp2,20               ; Up to 20 tabs supported
        ;-------------------------------------------------------
        ; Find next tab position
        ;-------------------------------------------------------
fb.tab.next.loop:        
        movb  *tmp0+,tmp1           ; \ Get tab position
        srl   tmp1,8                ; / Right align

        ci    tmp1,>00ff            ; End-of-list reached?
        jeq   fb.tab.next.eol       ; Yes, home cursor and exit
        ;-------------------------------------------------------
        ; Compare position
        ;-------------------------------------------------------
        c     @fb.column,tmp1       ; Cursor > tab position?
        jhe   !                     ; Yes, next loop iteration
        ;-------------------------------------------------------
        ; Set cursor
        ;-------------------------------------------------------
        mov   tmp1,tmp2             ; Set length of row
        li    tmp1,32               ; Replacement character = ASCII 32
        bl    @_fb.null2char        ; \ Replace any null characters with space
                                    ; | i  tmp1 = Replacement character
                                    ; / i  tmp2 = Length of row

        mov   tmp2,tmp1             ; Restore tmp1
        mov   tmp1,@fb.column       ; Set cursor on tab position

        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   tmp1,tmp0             ; \ Set VDP cursor column position
        bl    @xsetx                ; / i  tmp0 = new X value

        mov   *stack+,tmp0          ; Pop tmp0

        bl    @fb.calc_pointer      ; Calculate position in frame buffer

        seto  @fb.row.dirty         ; Current row dirty in frame buffer
        seto  @fb.status.dirty      ; Refresh status line        
        seto  @edb.dirty            ; Editor buffer dirty (text changed)
        ;-------------------------------------------------------
        ; Set row length
        ;------------------------------------------------------- 
        mov   @fb.column,tmp0
        inc   tmp0                  ; Base 1
        c     @fb.column,@fb.row.length
        jlt   fb.tab.next.exit      ; No need to set row length, exit
        mov   tmp0,@fb.row.length   : Set new length
        jmp   fb.tab.next.exit      ; Exit
        ;-------------------------------------------------------
        ; End-of-list reached, special treatment
        ;------------------------------------------------------- 
fb.tab.next.eol:        
        clr   @fb.column            ; Home cursor         
        clr   tmp0                  ; Home cursor

        bl    @xsetx                ; \ Set VDP cursor column position
                                    ; / i  tmp0 = new X value

        seto  @fb.status.dirty      ; Refresh status line
        jmp   fb.tab.next.exit      ; Exit
        ;-------------------------------------------------------
        ; Prepare for next iteration
        ;-------------------------------------------------------
!       dec   tmp2
        jgt   fb.tab.next.loop
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.tab.next.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11 
        b     *r11                  ; Return to caller