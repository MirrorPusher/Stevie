***************************************************************
*                          Stevie Editor
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2020 // Filip van Vooren
***************************************************************
* File: equates.equ                 ; Version %%build_date%%
*--------------------------------------------------------------
* Stevie memory map
*
*
* LOW MEMORY EXPANSION (2000-2fff)
* 
* Mem range   Bytes    SAMS   Purpose
* =========   =====    ====   ==================================
* 2000-2eff    3840           SP2 library
* 2f00-2fff     256           SP2 work memory
*
* LOW MEMORY EXPANSION (3000-3fff)
*
* Mem range   Bytes    SAMS   Purpose
* =========   =====    ====   ==================================
* 3000-3fff    4096           Resident Stevie Modules
*
*
* CARTRIDGE SPACE (6000-7fff)
*
* Mem range   Bytes    BANK   Purpose
* =========   =====    ====   ==================================
* 6000-7fff    8192       0   SP2 ROM CODE, copy to RAM code, resident modules
* 6000-7fff    8192       1   Stevie program code
*
*
* HIGH MEMORY EXPANSION (a000-ffff)
*
* Mem range   Bytes    SAMS   Purpose
* =========   =====    ====   ==================================
* a000-a0ff     256           Stevie Editor shared structure
* a100-a1ff     256           Framebuffer structure
* a200-a2ff     256           Editor buffer structure
* a300-a3ff     256           Command buffer structure   
* a400-a4ff     256           File handle structure
* a500-a5ff     256           Index structure
* a600-af5f    2400           Frame buffer
* af60-afff     ???           *FREE*
*
* b000-bfff    4096           Index buffer page
* c000-cfff    4096           Editor buffer page
* d000-dfff    4096           Command history buffer
* e000-efff    4096           Heap
* f000-ffff    4096           *FREE*
*
*
* VDP RAM
*
* Mem range   Bytes    Hex    Purpose
* =========   =====   =====   =================================
* 0000-095f    2400   >0960   PNT - Pattern Name Table
* 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
* 0fc0                        PCT - Pattern Color Table
* 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
* 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
* 2180                        SAT - Sprite Attribute List
* 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
skip_vdp_boxes            equ  1       ; Skip filbox, putbox
skip_vdp_bitmap           equ  1       ; Skip bitmap functions
skip_vdp_viewport         equ  1       ; Skip viewport functions
skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
skip_sound_player         equ  1       ; Skip inclusion of sound player code
skip_speech_detection     equ  1       ; Skip speech synthesizer detection
skip_speech_player        equ  1       ; Skip inclusion of speech player code
skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
skip_random_generator     equ  1       ; Skip random functions
skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
skip_mem_paging           equ  1       ; Skip support for memory paging 
*--------------------------------------------------------------
* Stevie specific equates
*--------------------------------------------------------------
fh.fopmode.none           equ  0       ; No file operation in progress
fh.fopmode.readfile       equ  1       ; Read file from disk to memory
fh.fopmode.writefile      equ  2       ; Save file from memory to disk
*--------------------------------------------------------------
* Stevie Dialog / Pane specific equates
*--------------------------------------------------------------
pane.botrow               equ  29      ; Bottom row on screen
pane.focus.fb             equ  0       ; Editor pane has focus
pane.focus.cmdb           equ  1       ; Command buffer pane has focus
id.dialog.load            equ  10      ; ID dialog "Load DV 80 file"
id.dialog.save            equ  11      ; ID dialog "Save DV 80 file"
;-----------------------------------------------------------------
;   Dialog ID's > 100 indicate that command prompt should be 
;   hidden and no characters added to buffer
;-----------------------------------------------------------------
id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
id.dialog.about           equ  102     ; ID dialog "About"
*--------------------------------------------------------------
* SPECTRA2 / Stevie startup options
*--------------------------------------------------------------
debug                     equ  1       ; Turn on spectra2 debugging
startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
*--------------------------------------------------------------
* Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
*--------------------------------------------------------------
parm1             equ  >2f20           ; Function parameter 1
parm2             equ  >2f22           ; Function parameter 2
parm3             equ  >2f24           ; Function parameter 3
parm4             equ  >2f26           ; Function parameter 4
parm5             equ  >2f28           ; Function parameter 5
parm6             equ  >2f2a           ; Function parameter 6
parm7             equ  >2f2c           ; Function parameter 7
parm8             equ  >2f2e           ; Function parameter 8
outparm1          equ  >2f30           ; Function output parameter 1
outparm2          equ  >2f32           ; Function output parameter 2
outparm3          equ  >2f34           ; Function output parameter 3
outparm4          equ  >2f36           ; Function output parameter 4
outparm5          equ  >2f38           ; Function output parameter 5
outparm6          equ  >2f3a           ; Function output parameter 6
outparm7          equ  >2f3c           ; Function output parameter 7
outparm8          equ  >2f3e           ; Function output parameter 8
keycode1          equ  >2f40           ; Current key scanned
keycode2          equ  >2f42           ; Previous key scanned
timers            equ  >2f44           ; Timer table
ramsat            equ  >2f54           ; Sprite Attribute Table in RAM
rambuf            equ  >2f64           ; RAM workbuffer 1
*--------------------------------------------------------------
* Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
*--------------------------------------------------------------
tv.top            equ  >a000           ; Structure begin
tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
tv.error.visible  equ  tv.top + 30     ; Error pane visible
tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
tv.free           equ  tv.top + 192    ; End of structure
*--------------------------------------------------------------
* Frame buffer structure              @>a100-a1ff   (256 bytes)
*--------------------------------------------------------------
fb.struct         equ  >a100           ; Structure begin
fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
                                       ; line X in editor buffer).
fb.row            equ  fb.struct + 6   ; Current row in frame buffer
                                       ; (offset 0 .. @fb.scrrows)
fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
fb.column         equ  fb.struct + 12  ; Current column in frame buffer
fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
fb.free1          equ  fb.struct + 16  ; **** free ****
fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
fb.free           equ  fb.struct + 28  ; End of structure
*--------------------------------------------------------------
* Editor buffer structure             @>a200-a2ff   (256 bytes)
*--------------------------------------------------------------
edb.struct        equ  >a200           ; Begin structure
edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
edb.rle           equ  edb.struct + 12 ; RLE compression activated
edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
                                       ; with current filename.
edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
                                       ; with current file type.                                    
edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
edb.sams.hipage   equ  edb.struct + 20 ; Highest SAMS page in use
edb.free          equ  edb.struct + 22 ; End of structure
*--------------------------------------------------------------
* Command buffer structure            @>a300-a3ff   (256 bytes)
*--------------------------------------------------------------
cmdb.struct       equ  >a300           ; Command Buffer structure
cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB 
cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
cmdb.action.ptr   equ  cmdb.struct + 34; Pointer to function to execute
cmdb.cmdlen       equ  cmdb.struct + 36; Length of current command (MSB byte!)
cmdb.cmd          equ  cmdb.struct + 37; Current command (80 bytes max.)
cmdb.free         equ  cmdb.struct +117; End of structure
*--------------------------------------------------------------
* File handle structure               @>a400-a4ff   (256 bytes)
*--------------------------------------------------------------
fh.struct         equ  >a400           ; stevie file handling structures
;***********************************************************************
; ATTENTION
; The dsrlnk variables must form a continuous memory block and keep 
; their order!
;***********************************************************************
dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte) 
fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
fh.records        equ  fh.struct + 60  ; File records counter
fh.reclen         equ  fh.struct + 62  ; Current record length
fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
fh.free           equ  fh.struct +170  ; End of structure
fh.vrecbuf        equ  >0960           ; VDP address record buffer
fh.vpab           equ  >0a60           ; VDP address PAB
*--------------------------------------------------------------
* Index structure                     @>a500-a5ff   (256 bytes)
*--------------------------------------------------------------
idx.struct        equ  >a500           ; stevie index structure
idx.sams.page     equ  idx.struct      ; Current SAMS page
idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
*--------------------------------------------------------------
* Frame buffer                        @>a600-afff  (2560 bytes)
*--------------------------------------------------------------
fb.top            equ  >a600           ; Frame buffer (80x30)
fb.size           equ  80*30           ; Frame buffer size                                     
*--------------------------------------------------------------
* Index                               @>b000-bfff  (4096 bytes)
*--------------------------------------------------------------
idx.top           equ  >b000           ; Top of index
idx.size          equ  4096            ; Index size
*--------------------------------------------------------------
* Editor buffer                       @>c000-cfff  (4096 bytes)
*--------------------------------------------------------------
edb.top           equ  >c000           ; Editor buffer high memory
edb.size          equ  4096            ; Editor buffer size
*--------------------------------------------------------------
* Command history buffer              @>d000-dfff  (4096 bytes)
*--------------------------------------------------------------
cmdb.top          equ  >d000           ; Top of command history buffer
cmdb.size         equ  4096            ; Command buffer size
*--------------------------------------------------------------
* Heap                                @>e000-efff  (4096 bytes)
*--------------------------------------------------------------
heap.top          equ  >e000           ; Top of heap