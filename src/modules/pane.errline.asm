* FILE......: pane.errline.asm
* Purpose...: Stevie Editor - Error line pane

***************************************************************
* pane.errline.show
* Show command buffer pane
***************************************************************
* bl @pane.errline.show
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
pane.errline.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1

        li    tmp1,>00f6            ; White on dark red
        mov   tmp1,@parm1

        li    tmp1,pane.botrow-1    ; 
        mov   tmp1,@parm2           ; Error line on screen

        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
                                    
        ;------------------------------------------------------
        ; Pad error message to 80 characters
        ;------------------------------------------------------
        li    tmp0,tv.error.msg
        mov   tmp0,@parm1           ; Get pointer to string
                                    
        li    tmp0,80
        mov   tmp0,@parm2           ; Set requested length
        
        li    tmp0,32
        mov   tmp0,@parm3           ; Set character to fill
        
        li    tmp0,rambuf
        mov   tmp0,@parm4           ; Set pointer to buffer for output string

        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill characgter
                                    ; | i  @parm4 = Pointer to buffer with
                                    ; /             output string        
        ;------------------------------------------------------
        ; Show error message
        ;------------------------------------------------------
        bl    @at
              byte pane.botrow-1,0  ; Set cursor

        mov   @outparm1,tmp1        ; \ Display error message
        bl    @xutst0               ; /
        
        mov   @fb.scrrows.max,tmp0
        dec   tmp0
        mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer

        seto  @tv.error.visible     ; Error line is visible
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.errline.show.exit:        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* pane.errline.hide
* Hide error line
***************************************************************
* bl @pane.errline.hide
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Hiding the error line passes pane focus to frame buffer.
********|*****|*********************|**************************
pane.errline.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Hide command buffer pane
        ;------------------------------------------------------
        bl    @errline.init         ; Clear error line

        mov   @tv.color,tmp0        ; Get colors
        srl   tmp0,8                ; Right aligns
        mov   tmp0,@parm1           ; set foreground/background color        


        li    tmp1,pane.botrow-1    ; 
        mov   tmp1,@parm2           ; Error line on screen

        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen

        clr   @tv.error.visible     ; Error line no longer visible
        mov   @fb.scrrows.max,@fb.scrrows
                                    ; Set frame buffer to full size again
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.errline.hide.exit:        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
