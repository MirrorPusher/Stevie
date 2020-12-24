* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Strings for welcome pane
;--------------------------------------------------------------
txt.about.program  #string 'Stevie V0.1I'
txt.about.purpose  #string 'Programming Editor for the TI-99/4a'
txt.about.author   #string '2018-2020 by Filip Van Vooren'
txt.about.website  #string 'https://stevie.oratronik.de'
txt.about.build    #string 'Build: %%build_date%%'

txt.about.msg1     #string 'fctn-7 (F7)   Help, shortcuts, about'
txt.about.msg2     #string 'fctn-9 (F9)   Toggle edit/cmd mode'
txt.about.msg3     #string 'fctn-+        Quit Stevie'
txt.about.msg4     #string 'CTRL-O (^O)   Open DV80 file'
txt.about.msg5     #string 'CTRL-S (^S)   Save DV80 file'
txt.about.msg6     #string 'CTRL-Z (^Z)   Cycle colors'

txt.about.msg7     byte    56,15
                   text    ' ALPHA LOCK up     '
                   byte    14
                   text    ' ALPHA LOCK down   '
                   text    '  * Text changed'


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
txt.saving         #string 'Saving....'
txt.deleting       #string 'Deleting block....'
txt.fastmode       #string 'Fastmode'
txt.kb             #string 'kb'
txt.lines          #string 'Lines'
txt.bufnum         #string '#1 '
txt.newfile        #string '[New file]'
txt.filetype.dv80  #string 'DV80'
txt.m1             #string 'M1='
txt.m2             #string 'M2='

txt.keys.block     byte    47
                   text    '^D=Del  ^V=Paste  ^G=Goto M1  ^R=Reset  ^S=Save'                   

txt.alpha.up       data >010f
txt.alpha.down     data >010e
txt.vertline       data >0110

txt.clear          #string '    '
txt.filetype.none  equ txt.clear


;--------------------------------------------------------------
; Dialog Load DV 80 file
;--------------------------------------------------------------
txt.head.load      #string 'Open DV80 file '
txt.hint.load      #string 'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
txt.keys.load      #string 'F9=Back    F3=Clear    F5=Fastmode    F-H=Home    F-L=End'
txt.keys.load2     #string 'F9=Back    F3=Clear   *F5=Fastmode    F-H=Home    F-L=End'

;--------------------------------------------------------------
; Dialog Save DV 80 file
;--------------------------------------------------------------
txt.head.save      #string 'Save DV80 file '
txt.head.save2     #string 'Save code block to DV80 file '
txt.hint.save      #string 'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
txt.keys.save      #string 'F9=Back    F3=Clear    F-H=Home    F-L=End'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   #string 'Unsaved changes '
txt.info.unsaved   #string 'You are about to lose changes to the current file!'
txt.hint.unsaved   #string 'HINT: Press F6 to proceed without saving or ENTER to save file.'
txt.keys.unsaved   #string 'F9=Back    F6=Proceed    ENTER=Save file'

;--------------------------------------------------------------
; Dialog "About"
;--------------------------------------------------------------
txt.head.about     #string 'About Stevie '
txt.hint.about     #string 'HINT: Press F9 or ENTER to return to editor.'
txt.keys.about     #string 'F9=Back    ENTER=Back'

;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr.load     #string 'I/O error. Failed loading file: '
txt.ioerr.save     #string 'I/O error. Failed saving file: '
txt.io.nofile      #string 'I/O error. No filename specified.'


;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.title     #string 'Command buffer'
txt.cmdb.prompt    #string '>'

txt.stevie         byte    12
                   byte    10
                   text    'stevie V0.1I'
                   byte    11
                   even

txt.colorscheme    #string 'Colorscheme:'