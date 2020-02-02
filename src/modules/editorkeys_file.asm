* FILE......: editorkeys_fíle.asm
* Purpose...: File related actions (load file, save file, ...)


*---------------------------------------------------------------
* Load DV/80 text file into editor
*---------------------------------------------------------------
* b     @edkey.action.loadfile 
*--------------------------------------------------------------- 
* INPUT
* tmp0  = Pointer to length-prefixed string containing device
*         and filename
* parm1 = >FFFF for RLE compression on load, otherwise >0000
*---------------------------------------------------------------
edkey.action.loadfile:
        mov   @parm1,@parm2         ; RLE compression on/off        
        mov   tmp0,@parm1           ; Setup file to load

        bl    @edb.init             ; Initialize editor buffer
        bl    @idx.init             ; Initialize index
        bl    @fb.init              ; Initialize framebuffer
        mov   @parm2,@edb.rle       ; Save RLE compression        
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
        bl    @filv
              data sprsat,>0000,4   ; Turn off sprites (cursor)

        mov   @fb.screenrows,tmp1
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!

        clr   tmp0                  ; VDP target address
        li    tmp1,32               ; Character to fill

        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Bytes to copy                                    
        ;-------------------------------------------------------
        ; Read DV80 file and display
        ;-------------------------------------------------------
        bl    @tfh.file.read        ; Read specified file
                                    ; \ i  parm1 = Pointer to length prefixed file descriptor
                                    ; / i  parm2 = RLE compression on (>FFFF) or off (>0000)

        clr   @edb.dirty            ; Editor buffer completely replaced, no longer dirty
        b     @edkey.action.top     ; Goto 1st line in editor buffer 



edkey.action.buffer0:
        li   tmp0,fdname0
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 
edkey.action.buffer1:
        li   tmp0,fdname1
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer2:
        li   tmp0,fdname2
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer3:
        li   tmp0,fdname3
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer4:
        li   tmp0,fdname4
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer5:
        li   tmp0,fdname5
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer6:
        li   tmp0,fdname6
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer7:
        li   tmp0,fdname7
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer8:
        li   tmp0,fdname8
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 

edkey.action.buffer9:
        li   tmp0,fdname9
        jmp  edkey.action.loadfile
                                    ; Load DIS/VAR 80 file into editor buffer 
