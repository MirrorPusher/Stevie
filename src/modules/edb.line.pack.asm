* FILE......: edb.line.pack.asm
* Purpose...: Stevie Editor - Editor Buffer pack line

*//////////////////////////////////////////////////////////////
*          Stevie Editor - Editor Buffer pack line
*//////////////////////////////////////////////////////////////



***************************************************************
* edb.line.pack
* Pack current line in framebuffer
***************************************************************
*  bl   @edb.line.pack
*--------------------------------------------------------------
* INPUT
* @fb.top       = Address of top row in frame buffer
* @fb.row       = Current row in frame buffer
* @fb.column    = Current column in frame buffer
* @fb.colsline  = Columns per line in frame buffer
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Memory usage
* rambuf   = Saved @fb.column
* rambuf+2 = Saved beginning of row
* rambuf+4 = Saved length of row
********|*****|*********************|**************************
edb.line.pack:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Get values
        ;------------------------------------------------------
        mov   @fb.column,@rambuf    ; Save @fb.column
        clr   @fb.column
        bl    @fb.calc_pointer      ; Beginning of row
        ;------------------------------------------------------
        ; Prepare scan
        ;------------------------------------------------------
        clr   tmp0                  ; Counter 
        mov   @fb.current,tmp1      ; Get position
        mov   tmp1,@rambuf+2        ; Save beginning of row
        ;------------------------------------------------------
        ; Scan line for >00 byte termination
        ;------------------------------------------------------
edb.line.pack.scan:
        movb  *tmp1+,tmp2           ; Get char
        srl   tmp2,8                ; Right justify
        jeq   edb.line.pack.check_setpage 
                                    ; Stop scan if >00 found
        inc   tmp0                  ; Increase string length
        ;------------------------------------------------------
        ; Not more than 80 characters
        ;------------------------------------------------------
        ci    tmp0,colrow
        jeq   edb.line.pack.check_setpage
                                    ; Stop scan if 80 characters processed
        jmp   edb.line.pack.scan    ; Next character
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------  
edb.line.pack.crash:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; 1a: Check if SAMS page needs to be increased
        ;------------------------------------------------------ 
edb.line.pack.check_setpage:
        mov   @edb.sams.hipage,@edb.sams.page
                                    ; \ Copy on write!
                                    ; / Start with highest SAMS page in use.

        mov   @edb.next_free.ptr,tmp0
                                    ;--------------------------
                                    ; Sanity check
                                    ;-------------------------- 
        ci    tmp0,edb.top + edb.size
                                    ; Insane address ?
        jgt   edb.line.pack.crash   ; Yes, crash!
                                    ;--------------------------
                                    ; Check for page overflow
                                    ;-------------------------- 
        andi  tmp0,>0fff            ; Get rid of highest nibble        
        ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
        ci    tmp0,>1000 - 16       ; 4K boundary reached?
        jlt   edb.line.pack.setpage ; Not yet, don't increase SAMS page
        ;------------------------------------------------------
        ; 1b: Increase SAMS page
        ;------------------------------------------------------ 
        inc   @edb.sams.page        ; Next SAMS page
        mov   @edb.sams.page,@edb.sams.hipage
                                    ; Set highest SAMS page
        mov   @edb.top.ptr,@edb.next_free.ptr
                                    ; Start at top of SAMS page again
        ;------------------------------------------------------
        ; 1c: Switch to SAMS page
        ;------------------------------------------------------ 
edb.line.pack.setpage:        
        mov   @edb.sams.page,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Step 2: Prepare for storing line
        ;------------------------------------------------------
edb.line.pack.prepare:
        mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
        a     @fb.row,@parm1        ; /

        mov   tmp0,@rambuf+4        ; Save length of line
        ;------------------------------------------------------
        ; 2a Update index
        ;------------------------------------------------------
edb.line.pack.update_index:
        mov   @edb.next_free.ptr,@parm2
                                    ; Pointer to new line
        mov   @edb.sams.page,@parm3 ; Setup parm3

        bl    @idx.entry.update     ; Update index
                                    ; \ i  parm1 = Line number in editor buffer
                                    ; | i  parm2 = pointer to line in 
                                    ; |            editor buffer
                                    ; / i  parm3 = SAMS page
        ;------------------------------------------------------
        ; 3. Set line prefix in editor buffer
        ;------------------------------------------------------
!       mov   @rambuf+2,tmp0        ; Source for memory copy
        mov   @edb.next_free.ptr,tmp1 
                                    ; Address of line in editor buffer

        inct  @edb.next_free.ptr    ; Adjust pointer

        mov   @rambuf+4,tmp2        ; Get line length
        inc   tmp1                  ; Skip MSB for now (compressed length)
        swpb  tmp2
        movb  tmp2,*tmp1+           ; Set line length as line prefix
        swpb  tmp2
        jeq   edb.line.pack.exit    ; Nothing to copy if empty line
        ;------------------------------------------------------
        ; 4. Copy line from framebuffer to editor buffer
        ;------------------------------------------------------
edb.line.pack.copyline:        
        ci    tmp2,2
        jne   edb.line.pack.copyline.checkbyte
        movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
        movb  *tmp0+,*tmp1+         ; / uneven address
        jmp   !

edb.line.pack.copyline.checkbyte:
        ci    tmp2,1
        jne   edb.line.pack.copyline.block
        movb  *tmp0,*tmp1           ; Copy single byte
        jmp   !

edb.line.pack.copyline.block:
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;------------------------------------------------------
        ; 5: Align pointer to multiple of 16 memory address
        ;------------------------------------------------------ 
!       a     @rambuf+4,@edb.next_free.ptr
                                       ; Add length of line

        mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
        neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
        andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
        a     tmp0,@edb.next_free.ptr  ; / Chapter 2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.pack.exit:
        mov   @rambuf,@fb.column    ; Retrieve @fb.column
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
