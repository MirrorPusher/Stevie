* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Strings for status line pane
;--------------------------------------------------------------
txt.delim          #string ','
txt.marker         #string '*EOF*'
txt.bottom         #string '  BOT'
txt.ovrwrite       #string 'OVR'
txt.insert         #string 'INS'
txt.star           #string '*'
txt.loading        #string 'Loading...'
txt.kb             #string 'kb'
txt.rle            #string 'RLE'
txt.lines          #string 'Lines'
txt.bufnum         #string '#1 '
txt.newfile        #string '[New file]'
txt.filetype.dv80  #string 'DV80'
txt.filetype.none  #string '    '



;--------------------------------------------------------------
; Dialog strings
;--------------------------------------------------------------
txt.keys.loaddv80  #string 'F9=Back    F3=Clear    ^A=Home    ^F=End    ^,=Previous    ^.=Next'





;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr          #string 'I/O error. Failed loading file: '
txt.io.nofile      #string 'I/O error. No filename specified.'


;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.title     #string 'Command buffer'
txt.cmdb.prompt    #string '>'
txt.cmdb.loaddv80  #string 'Load DV80 file'

txt.cmdb.hintdv80  #string 'HINT: Specify filename and press ENTER.'

txt.cmdb.hbar      byte    66
                   byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                   byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                   byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                   byte    1,1,1,1,1,1
                   even



txt.stevie         byte    12
                   byte    10
                   text    'stevie v1.00'
                   byte    11
                   even

txt.colorscheme    #string 'COLOR SCHEME: '


;--------------------------------------------------------------
; Strings for filenames
;--------------------------------------------------------------
fdname1            #string 'PI.CLOCK'
fdname2            #string 'TIPI.TIVI.NR80'
fdname3            #string 'DSK1.XBEADOC'
fdname4            #string 'TIPI.TIVI.C99MAN1'
fdname5            #string 'TIPI.TIVI.C99MAN2'
fdname6            #string 'TIPI.TIVI.C99MAN3'
fdname7            #string 'TIPI.TIVI.C99SPECS'
fdname8            #string 'TIPI.TIVI.RANDOM#C'
fdname9            #string 'DSK1.INVADERS'
fdname0            #string 'DSK1.NR80'
fdname.clock       #string 'PI.CLOCK'