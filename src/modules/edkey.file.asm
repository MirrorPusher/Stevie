* FILE......: edkey.fíle.asm
* Purpose...: File related actions (load file, save file, ...)


edkey.action.buffer0:
        li   tmp0,fdname0
        jmp  edkey.action.rest
edkey.action.buffer1:
        li   tmp0,fdname1
        jmp  edkey.action.rest
edkey.action.buffer2:
        li   tmp0,fdname2
        jmp  edkey.action.rest
edkey.action.buffer3:
        li   tmp0,fdname3
        jmp  edkey.action.rest
edkey.action.buffer4:
        li   tmp0,fdname4
        jmp  edkey.action.rest
edkey.action.buffer5:
        li   tmp0,fdname5
        jmp  edkey.action.rest
edkey.action.buffer6:
        li   tmp0,fdname6
        jmp  edkey.action.rest
edkey.action.buffer7:
        li   tmp0,fdname7
        jmp  edkey.action.rest
edkey.action.buffer8:
        li   tmp0,fdname8
        jmp  edkey.action.rest
edkey.action.buffer9:
        li   tmp0,fdname9
        jmp  edkey.action.rest
edkey.action.rest:
        bl   @fm.loadfile           ; Load DIS/VAR 80 file into editor buffer 
        b    @edkey.action.top      ; Goto 1st line in editor buffer 