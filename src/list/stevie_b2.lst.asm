XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b2.asm.488847
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2021 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 201220-488847
0010               *
0011               * Bank 2 "Jacky"
0012               *
0013               ***************************************************************
0014                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
**** **** ****     > rom.order.asm
0001               * FILE......: rom.order.asm
0002               * Purpose...: Equates with CPU write addresses for switching banks
0003               
0004               *--------------------------------------------------------------
0005               * Bank order (non-inverted)
0006               *--------------------------------------------------------------
0007      6000     bank0                     equ  >6000   ; Jill
0008      6002     bank1                     equ  >6002   ; James
0009      6004     bank2                     equ  >6004   ; Jacky
0010      6006     bank3                     equ  >6006   ; John
**** **** ****     > stevie_b2.asm.488847
0015                       copy  "equates.asm"         ; Equates Stevie configuration
**** **** ****     > equates.asm
0001               * FILE......: equates.asm
0002               * Purpose...: The main equates file for Stevie editor
0003               
0004               
0005               *===============================================================================
0006               * Memory map
0007               * ==========
0008               *
0009               * LOW MEMORY EXPANSION (2000-2fff)
0010               *
0011               *     Mem range   Bytes    SAMS   Purpose
0012               *     =========   =====    ====   ==================================
0013               *     2000-2eff    3840           SP2 library
0014               *     2f00-2f1f      32           **RESERVED**
0015               *     2f20-2f3f      32           Function input/output parameters
0016               *     2f40-2f43       4           Keyboard
0017               *     2f44-2f63      32           Timer tasks table
0018               *     2f64-2f9f      60           RAM buffer
0019               *     2fa0-2fff      96           Value/Return stack
0020               *
0021               *
0022               * LOW MEMORY EXPANSION (3000-3fff)
0023               *
0024               *     Mem range   Bytes    SAMS   Purpose
0025               *     =========   =====    ====   ==================================
0026               *     3000-3fff    4096           Resident Stevie Modules
0027               *
0028               *
0029               * HIGH MEMORY EXPANSION (a000-ffff)
0030               *
0031               *     Mem range   Bytes    SAMS   Purpose
0032               *     =========   =====    ====   ==================================
0033               *     a000-a0ff     256           Stevie Editor shared structure
0034               *     a100-a1ff     256           Framebuffer structure
0035               *     a200-a2ff     256           Editor buffer structure
0036               *     a300-a3ff     256           Command buffer structure
0037               *     a400-a4ff     256           File handle structure
0038               *     a500-a5ff     256           Index structure
0039               *     a600-af5f    2400           Frame buffer
0040               *     af60-afff     ???           *FREE*
0041               *
0042               *     b000-bfff    4096           Index buffer page
0043               *     c000-cfff    4096           Editor buffer page
0044               *     d000-dfff    4096           Command history buffer
0045               *     e000-ebff    3072           Heap
0046               *     ec00-efff    1024           Farjump return stack (trampolines)
0047               *     f000-ffff    4096           *FREE*
0048               *
0049               *
0050               * CARTRIDGE SPACE (6000-7fff)
0051               *
0052               *     Mem range   Bytes    BANK   Purpose
0053               *     =========   =====    ====   ==================================
0054               *     6000-7f9b    8128       0   SP2 library, code to RAM, resident modules
0055               *     7f9c-7fff      64       0   Vector table (32 vectors)
0056               *     ..............................................................
0057               *     6000-7f9b    8128       1   Stevie program code
0058               *     7f9c-7fff      64       1   Vector table (32 vectors)
0059               *     ..............................................................
0060               *     6000-7f9b    8128       2   Stevie program code
0061               *     7f9c-7fff      64       2   Vector table (32 vectors)
0062               *     ..............................................................
0063               *     6000-7f9b    8128       3   Stevie program code
0064               *     7f9c-7fff      64       3   Vector table (32 vectors)
0065               *
0066               *
0067               * VDP RAM
0068               *
0069               *     Mem range   Bytes    Hex    Purpose
0070               *     =========   =====   =====   =================================
0071               *     0000-095f    2400   >0960   PNT - Pattern Name Table
0072               *     0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0073               *     0fc0                        PCT - Pattern Color Table
0074               *     1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0075               *     1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0076               *     2180                        SAT - Sprite Attribute List
0077               *     2800                        SPT - Sprite Pattern Table. On 2K boundary
0078               *
0079               *===============================================================================
0080               
0081               *--------------------------------------------------------------
0082               * Skip unused spectra2 code modules for reduced code size
0083               *--------------------------------------------------------------
0084      0001     skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
0085      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0086      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0087      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0088      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0089      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0090      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0091      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0092      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0093      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0094      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0095      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0096      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0097      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0098      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0099      0001     skip_random_generator     equ  1       ; Skip random functions
0100      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0101      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0102               *--------------------------------------------------------------
0103               * Stevie specific equates
0104               *--------------------------------------------------------------
0105      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0106      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0107      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0108      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0109      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0110      1FD0     vdp.cmdb.toprow.tat       equ  >1fd0   ; VDP TAT address of 1st CMDB row
0111      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0112      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0113               *--------------------------------------------------------------
0114               * Stevie Dialog / Pane specific equates
0115               *--------------------------------------------------------------
0116      001D     pane.botrow               equ  29      ; Bottom row on screen
0117      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0118      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0119               ;-----------------------------------------------------------------
0120               ;   Dialog ID's >= 100 indicate that command prompt should be
0121               ;   hidden and no characters added to CMDB keyboard buffer
0122               ;-----------------------------------------------------------------
0123      000A     id.dialog.load            equ  10      ; ID dialog "Load DV 80 file"
0124      000B     id.dialog.save            equ  11      ; ID dialog "Save DV 80 file"
0125      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0126      0066     id.dialog.block           equ  102     ; ID dialog "Block move/copy/delete"
0127      0067     id.dialog.about           equ  103     ; ID dialog "About"
0128               *--------------------------------------------------------------
0129               * SPECTRA2 / Stevie startup options
0130               *--------------------------------------------------------------
0131      0001     debug                     equ  1       ; Turn on spectra2 debugging
0132      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0133      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0134      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0135               *--------------------------------------------------------------
0136               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0137               *--------------------------------------------------------------
0138      2F20     parm1             equ  >2f20           ; Function parameter 1
0139      2F22     parm2             equ  >2f22           ; Function parameter 2
0140      2F24     parm3             equ  >2f24           ; Function parameter 3
0141      2F26     parm4             equ  >2f26           ; Function parameter 4
0142      2F28     parm5             equ  >2f28           ; Function parameter 5
0143      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0144      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0145      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0146      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0147      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0148      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0149      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0150      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0151      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0152      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0153      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0154      2F40     keycode1          equ  >2f40           ; Current key scanned
0155      2F42     keycode2          equ  >2f42           ; Previous key scanned
0156      2F44     unpacked.string   equ  >2f44           ; 6 char string with unpacked uin16
0157      2F4A     timers            equ  >2f4a           ; Timer table
0158      2F5A     ramsat            equ  >2f5a           ; Sprite Attribute Table in RAM
0159      2F6A     rambuf            equ  >2f6a           ; RAM workbuffer 1
0160               *--------------------------------------------------------------
0161               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0162               *--------------------------------------------------------------
0163      A000     tv.top            equ  >a000           ; Structure begin
0164      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0165      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0166      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0167      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0168      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0169      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0170      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0171      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0172      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0173      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0174      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0175      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0176      A018     tv.color          equ  tv.top + 24     ; FG/BG-color framebufffer + bottom line
0177      A01A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0178      A01C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0179      A01E     tv.pane.focus     equ  tv.top + 30     ; Identify pane that has focus
0180      A020     tv.task.oneshot   equ  tv.top + 32     ; Pointer to one-shot routine
0181      A022     tv.fj.stackpnt    equ  tv.top + 34     ; Pointer to farjump return stack
0182      A024     tv.error.visible  equ  tv.top + 36     ; Error pane visible
0183      A026     tv.error.msg      equ  tv.top + 38     ; Error message (max. 160 characters)
0184      A0C6     tv.free           equ  tv.top + 198    ; End of structure
0185               *--------------------------------------------------------------
0186               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0187               *--------------------------------------------------------------
0188      A100     fb.struct         equ  >a100           ; Structure begin
0189      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0190      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0191      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0192                                                      ; line X in editor buffer).
0193      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0194                                                      ; (offset 0 .. @fb.scrrows)
0195      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0196      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0197      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0198      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0199      A110     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0200      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0201      A114     fb.free0          equ  fb.struct + 20  ; **free**
0202      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0203      A118     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0204      A11A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0205      A11C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0206      A11E     fb.free           equ  fb.struct + 30  ; End of structure
0207               *--------------------------------------------------------------
0208               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0209               *--------------------------------------------------------------
0210      A200     edb.struct        equ  >a200           ; Begin structure
0211      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0212      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0213      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0214      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0215      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0216      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0217      A20C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker
0218      A20E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker
0219      A210     edb.block.m3      equ  edb.struct + 16 ; Block operation target line
0220      A212     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0221                                                      ; with current filename.
0222      A214     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0223                                                      ; with current file type.
0224      A216     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0225      A218     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0226      A21A     edb.free          equ  edb.struct + 26 ; End of structure
0227               *--------------------------------------------------------------
0228               * Command buffer structure            @>a300-a3ff   (256 bytes)
0229               *--------------------------------------------------------------
0230      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0231      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0232      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0233      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0234      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0235      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0236      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0237      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0238      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0239      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0240      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0241      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0242      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0243      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0244      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0245      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string pane header
0246      A31E     cmdb.paninfo      equ  cmdb.struct + 30; Pointer to string pane info (1st line)
0247      A320     cmdb.panhint      equ  cmdb.struct + 32; Pointer to string pane hint (2nd line)
0248      A322     cmdb.pankeys      equ  cmdb.struct + 34; Pointer to string pane keys (stat line)
0249      A324     cmdb.action.ptr   equ  cmdb.struct + 36; Pointer to function to execute
0250      A326     cmdb.cmdlen       equ  cmdb.struct + 38; Length of current command (MSB byte!)
0251      A327     cmdb.cmd          equ  cmdb.struct + 39; Current command (80 bytes max.)
0252      A378     cmdb.free         equ  cmdb.struct +120; End of structure
0253               *--------------------------------------------------------------
0254               * File handle structure               @>a400-a4ff   (256 bytes)
0255               *--------------------------------------------------------------
0256      A400     fh.struct         equ  >a400           ; stevie file handling structures
0257               ;***********************************************************************
0258               ; ATTENTION
0259               ; The dsrlnk variables must form a continuous memory block and keep
0260               ; their order!
0261               ;***********************************************************************
0262      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0263      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0264      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0265      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0266      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0267      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0268      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0269      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0270      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0271      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0272      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0273      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0274      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0275      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0276      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0277      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0278      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0279      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0280      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0281      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0282      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0283      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0284      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0285      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0286      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0287      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0288      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0289      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0290      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0291      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0292      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0293               *--------------------------------------------------------------
0294               * Index structure                     @>a500-a5ff   (256 bytes)
0295               *--------------------------------------------------------------
0296      A500     idx.struct        equ  >a500           ; stevie index structure
0297      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0298      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0299      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0300               *--------------------------------------------------------------
0301               * Frame buffer                        @>a600-afff  (2560 bytes)
0302               *--------------------------------------------------------------
0303      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0304      0960     fb.size           equ  80*30           ; Frame buffer size
0305               *--------------------------------------------------------------
0306               * Index                               @>b000-bfff  (4096 bytes)
0307               *--------------------------------------------------------------
0308      B000     idx.top           equ  >b000           ; Top of index
0309      1000     idx.size          equ  4096            ; Index size
0310               *--------------------------------------------------------------
0311               * Editor buffer                       @>c000-cfff  (4096 bytes)
0312               *--------------------------------------------------------------
0313      C000     edb.top           equ  >c000           ; Editor buffer high memory
0314      1000     edb.size          equ  4096            ; Editor buffer size
0315               *--------------------------------------------------------------
0316               * Command history buffer              @>d000-dfff  (4096 bytes)
0317               *--------------------------------------------------------------
0318      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0319      1000     cmdb.size         equ  4096            ; Command buffer size
0320               *--------------------------------------------------------------
0321               * Heap                                @>e000-ebff  (3072 bytes)
0322               *--------------------------------------------------------------
0323      E000     heap.top          equ  >e000           ; Top of heap
0324               *--------------------------------------------------------------
0325               * Farjump return stack                @>ec00-efff  (1024 bytes)
0326               *--------------------------------------------------------------
0327      F000     fj.bottom         equ  >f000           ; Stack grows downwards
**** **** ****     > stevie_b2.asm.488847
0016               
0017               ***************************************************************
0018               * Spectra2 core configuration
0019               ********|*****|*********************|**************************
0020      3000     sp2.stktop    equ >3000             ; Top of SP2 stack starts at 2ffe-2fff
0021                                                   ; and grows downwards
0022               
0023               ***************************************************************
0024               * BANK 2
0025               ********|*****|*********************|**************************
0026      6004     bankid  equ   bank2                 ; Set bank identifier to current bank
0027                       aorg  >6000
0028                       save  >6000,>7fff           ; Save bank 2
0029               *--------------------------------------------------------------
0030               * Cartridge header
0031               ********|*****|*********************|**************************
0032 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0033 6006 6010             data  $+10
0034 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0035 6010 0000             data  0                     ; No more items following
0036 6012 6030             data  kickstart.code1
0037               
0039               
0040 6014 0C53             byte  12
0041 6015 ....             text  'STEVIE V0.1H'
0042                       even
0043               
0051               
0052               ***************************************************************
0053               * Step 1: Switch to bank 0 (uniform code accross all banks)
0054               ********|*****|*********************|**************************
0055                       aorg  kickstart.code1       ; >6030
0056 6030 04E0  34         clr   @bank0                ; Switch to bank 0 "Jill"
     6032 6000 
0057               ***************************************************************
0058               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0059               ********|*****|*********************|**************************
0060                       aorg  >2000
0061                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *
0007               *                TMS9900 Monitor with Arcade Game support
0008               *                                  for
0009               *              the Texas Instruments TI-99/4A Home Computer
0010               *
0011               *                      2010-2020 by Filip Van Vooren
0012               *
0013               *              https://github.com/FilipVanVooren/spectra2.git
0014               *******************************************************************************
0015               * This file: runlib.a99
0016               *******************************************************************************
0017               * Use following equates to skip/exclude support modules and to control startup
0018               * behaviour.
0019               *
0020               * == Memory
0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0028               *
0029               * == VDP
0030               * skip_textmode             equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a             equ  1  ; Skip f18a support
0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0043               *
0044               * == Sound & speech
0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0048               *
0049               * ==  Keyboard
0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0052               *
0053               * == Utilities
0054               * skip_random_generator     equ  1  ; Skip random generator functions
0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0061               * skip_cpu_strings          equ  1  ; Skip string support utilities
0062               
0063               * == Kernel/Multitasking
0064               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0065               * skip_mem_paging           equ  1  ; Skip support for memory paging
0066               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0067               *
0068               * == Startup behaviour
0069               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0070               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0071               *******************************************************************************
0072               
0073               *//////////////////////////////////////////////////////////////
0074               *                       RUNLIB SETUP
0075               *//////////////////////////////////////////////////////////////
0076               
0077                       copy  "memsetup.equ"             ; Equates runlib scratchpad mem setup
**** **** ****     > memsetup.equ
0001               * FILE......: memsetup.equ
0002               * Purpose...: Equates for spectra2 memory layout
0003               
0004               ***************************************************************
0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0006               ********|*****|*********************|**************************
0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0022               ***************************************************************
0023      832A     by      equ   wyx                   ;      Cursor Y position
0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0026               ***************************************************************
**** **** ****     > runlib.asm
0078                       copy  "registers.equ"            ; Equates runlib registers
**** **** ****     > registers.equ
0001               * FILE......: registers.equ
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4      Temporary register/variable tmp0
0011               * R5      Temporary register/variable tmp1
0012               * R6      Temporary register/variable tmp2
0013               * R7      Temporary register/variable tmp3
0014               * R8      Temporary register/variable tmp4
0015               * R9      Stack pointer
0016               * R10     Highest slot in use + Timer counter
0017               * R11     Subroutine return address
0018               * R12     CRU
0019               * R13     Copy of VDP status byte and counter for sound player
0020               * R14     Copy of VDP register #0 and VDP register #1 bytes
0021               * R15     VDP read/write address
0022               *--------------------------------------------------------------
0023               * Special purpose registers
0024               * R0      shift count
0025               * R12     CRU
0026               * R13     WS     - when using LWPI, BLWP, RTWP
0027               * R14     PC     - when using LWPI, BLWP, RTWP
0028               * R15     STATUS - when using LWPI, BLWP, RTWP
0029               ***************************************************************
0030               * Define registers
0031               ********|*****|*********************|**************************
0032      0000     r0      equ   0
0033      0001     r1      equ   1
0034      0002     r2      equ   2
0035      0003     r3      equ   3
0036      0004     r4      equ   4
0037      0005     r5      equ   5
0038      0006     r6      equ   6
0039      0007     r7      equ   7
0040      0008     r8      equ   8
0041      0009     r9      equ   9
0042      000A     r10     equ   10
0043      000B     r11     equ   11
0044      000C     r12     equ   12
0045      000D     r13     equ   13
0046      000E     r14     equ   14
0047      000F     r15     equ   15
0048               ***************************************************************
0049               * Define register equates
0050               ********|*****|*********************|**************************
0051      0002     config  equ   r2                    ; Config register
0052      0003     xconfig equ   r3                    ; Extended config register
0053      0004     tmp0    equ   r4                    ; Temp register 0
0054      0005     tmp1    equ   r5                    ; Temp register 1
0055      0006     tmp2    equ   r6                    ; Temp register 2
0056      0007     tmp3    equ   r7                    ; Temp register 3
0057      0008     tmp4    equ   r8                    ; Temp register 4
0058      0009     stack   equ   r9                    ; Stack pointer
0059      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0060      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0061               ***************************************************************
0062               * Define MSB/LSB equates for registers
0063               ********|*****|*********************|**************************
0064      8300     r0hb    equ   ws1                   ; HI byte R0
0065      8301     r0lb    equ   ws1+1                 ; LO byte R0
0066      8302     r1hb    equ   ws1+2                 ; HI byte R1
0067      8303     r1lb    equ   ws1+3                 ; LO byte R1
0068      8304     r2hb    equ   ws1+4                 ; HI byte R2
0069      8305     r2lb    equ   ws1+5                 ; LO byte R2
0070      8306     r3hb    equ   ws1+6                 ; HI byte R3
0071      8307     r3lb    equ   ws1+7                 ; LO byte R3
0072      8308     r4hb    equ   ws1+8                 ; HI byte R4
0073      8309     r4lb    equ   ws1+9                 ; LO byte R4
0074      830A     r5hb    equ   ws1+10                ; HI byte R5
0075      830B     r5lb    equ   ws1+11                ; LO byte R5
0076      830C     r6hb    equ   ws1+12                ; HI byte R6
0077      830D     r6lb    equ   ws1+13                ; LO byte R6
0078      830E     r7hb    equ   ws1+14                ; HI byte R7
0079      830F     r7lb    equ   ws1+15                ; LO byte R7
0080      8310     r8hb    equ   ws1+16                ; HI byte R8
0081      8311     r8lb    equ   ws1+17                ; LO byte R8
0082      8312     r9hb    equ   ws1+18                ; HI byte R9
0083      8313     r9lb    equ   ws1+19                ; LO byte R9
0084      8314     r10hb   equ   ws1+20                ; HI byte R10
0085      8315     r10lb   equ   ws1+21                ; LO byte R10
0086      8316     r11hb   equ   ws1+22                ; HI byte R11
0087      8317     r11lb   equ   ws1+23                ; LO byte R11
0088      8318     r12hb   equ   ws1+24                ; HI byte R12
0089      8319     r12lb   equ   ws1+25                ; LO byte R12
0090      831A     r13hb   equ   ws1+26                ; HI byte R13
0091      831B     r13lb   equ   ws1+27                ; LO byte R13
0092      831C     r14hb   equ   ws1+28                ; HI byte R14
0093      831D     r14lb   equ   ws1+29                ; LO byte R14
0094      831E     r15hb   equ   ws1+30                ; HI byte R15
0095      831F     r15lb   equ   ws1+31                ; LO byte R15
0096               ********|*****|*********************|**************************
0097      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0098      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0099      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0100      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0101      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0102      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0103      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0104      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0105      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0106      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0107               ********|*****|*********************|**************************
0108      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0109      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0110      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0111      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0112               ***************************************************************
**** **** ****     > runlib.asm
0079                       copy  "portaddr.equ"             ; Equates runlib hw port addresses
**** **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
0002               * Purpose...: Equates for hardware port addresses
0003               
0004               ***************************************************************
0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0006               ********|*****|*********************|**************************
0007      8400     sound   equ   >8400                 ; Sound generator address
0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0010      8802     vdps    equ   >8802                 ; VDP status register
0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0013      9802     grmra   equ   >9802                 ; GROM set read address
0014      9800     grmrd   equ   >9800                 ; GROM read byte
0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
**** **** ****     > runlib.asm
0080                       copy  "param.equ"                ; Equates runlib parameters
**** **** ****     > param.equ
0001               * FILE......: param.equ
0002               * Purpose...: Equates used for subroutine parameters
0003               
0004               ***************************************************************
0005               * Subroutine parameter equates
0006               ***************************************************************
0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0024               *--------------------------------------------------------------
0025               *   Speech player
0026               *--------------------------------------------------------------
0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
**** **** ****     > runlib.asm
0081               
0085               
0086                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
**** **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               ---------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 2000 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 2002 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 2004 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2006 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2008 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 200A 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 200C 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 200E 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 2010 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 2012 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 2014 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2016 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2018 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 201A 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 201C 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 201E 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 2020 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 2022 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 2024 D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      2000     hb$00   equ   w$0000                ; >0000
0035      2012     hb$01   equ   w$0100                ; >0100
0036      2014     hb$02   equ   w$0200                ; >0200
0037      2016     hb$04   equ   w$0400                ; >0400
0038      2018     hb$08   equ   w$0800                ; >0800
0039      201A     hb$10   equ   w$1000                ; >1000
0040      201C     hb$20   equ   w$2000                ; >2000
0041      201E     hb$40   equ   w$4000                ; >4000
0042      2020     hb$80   equ   w$8000                ; >8000
0043      2024     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      2000     lb$00   equ   w$0000                ; >0000
0048      2002     lb$01   equ   w$0001                ; >0001
0049      2004     lb$02   equ   w$0002                ; >0002
0050      2006     lb$04   equ   w$0004                ; >0004
0051      2008     lb$08   equ   w$0008                ; >0008
0052      200A     lb$10   equ   w$0010                ; >0010
0053      200C     lb$20   equ   w$0020                ; >0020
0054      200E     lb$40   equ   w$0040                ; >0040
0055      2010     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      2002     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      2004     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2006     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2008     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      200A     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      200C     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      200E     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      2010     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      2012     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      2014     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2016     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2018     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      201A     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      201C     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      201E     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      2020     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0087                       copy  "config.equ"               ; Equates for bits in config register
**** **** ****     > config.equ
0001               * FILE......: config.equ
0002               * Purpose...: Equates for bits in config register
0003               
0004               ***************************************************************
0005               * The config register equates
0006               *--------------------------------------------------------------
0007               * Configuration flags
0008               * ===================
0009               *
0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0019               * ; 06  Timer: Block user hook          1=yes          0=no
0020               * ; 05  Speech synthesizer present      1=yes          0=no
0021               * ; 04  Speech player: busy             1=yes          0=no
0022               * ; 03  Speech player: enabled          1=yes          0=no
0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0024               * ; 01  F18A present                    1=on           0=off
0025               * ; 00  Subroutine state flag           1=on           0=off
0026               ********|*****|*********************|**************************
0027      201C     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      2012     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      200E     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      200A     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
**** **** ****     > runlib.asm
0088                       copy  "cpu_crash.asm"            ; CPU crash handler
**** **** ****     > cpu_crash.asm
0001               * FILE......: cpu_crash.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               ***************************************************************
0006               * cpu.crash - CPU program crashed handler
0007               ***************************************************************
0008               *  bl   @cpu.crash
0009               *--------------------------------------------------------------
0010               * Crash and halt system. Upon crash entry register contents are
0011               * copied to the memory region >ffe0 - >fffe and displayed after
0012               * resetting the spectra2 runtime library, video modes, etc.
0013               *
0014               * Diagnostics
0015               * >ffce  caller address
0016               *
0017               * Register contents
0018               * >ffdc  wp
0019               * >ffde  st
0020               * >ffe0  r0
0021               * >ffe2  r1
0022               * >ffe4  r2  (config)
0023               * >ffe6  r3
0024               * >ffe8  r4  (tmp0)
0025               * >ffea  r5  (tmp1)
0026               * >ffec  r6  (tmp2)
0027               * >ffee  r7  (tmp3)
0028               * >fff0  r8  (tmp4)
0029               * >fff2  r9  (stack)
0030               * >fff4  r10
0031               * >fff6  r11
0032               * >fff8  r12
0033               * >fffa  r13
0034               * >fffc  r14
0035               * >fffe  r15
0036               ********|*****|*********************|**************************
0037               cpu.crash:
0038 2026 022B  22         ai    r11,-4                ; Remove opcode offset
     2028 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 202A C800  38         mov   r0,@>ffe0
     202C FFE0 
0043 202E C801  38         mov   r1,@>ffe2
     2030 FFE2 
0044 2032 C802  38         mov   r2,@>ffe4
     2034 FFE4 
0045 2036 C803  38         mov   r3,@>ffe6
     2038 FFE6 
0046 203A C804  38         mov   r4,@>ffe8
     203C FFE8 
0047 203E C805  38         mov   r5,@>ffea
     2040 FFEA 
0048 2042 C806  38         mov   r6,@>ffec
     2044 FFEC 
0049 2046 C807  38         mov   r7,@>ffee
     2048 FFEE 
0050 204A C808  38         mov   r8,@>fff0
     204C FFF0 
0051 204E C809  38         mov   r9,@>fff2
     2050 FFF2 
0052 2052 C80A  38         mov   r10,@>fff4
     2054 FFF4 
0053 2056 C80B  38         mov   r11,@>fff6
     2058 FFF6 
0054 205A C80C  38         mov   r12,@>fff8
     205C FFF8 
0055 205E C80D  38         mov   r13,@>fffa
     2060 FFFA 
0056 2062 C80E  38         mov   r14,@>fffc
     2064 FFFC 
0057 2066 C80F  38         mov   r15,@>ffff
     2068 FFFF 
0058 206A 02A0  12         stwp  r0
0059 206C C800  38         mov   r0,@>ffdc
     206E FFDC 
0060 2070 02C0  12         stst  r0
0061 2072 C800  38         mov   r0,@>ffde
     2074 FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2076 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2078 8300 
0067 207A 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     207C 8302 
0068 207E 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     2080 4A4A 
0069 2082 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     2084 2E0C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 22FA 
0078 208A 21EA                   data graph1           ; Equate selected video mode table
0079               
0080 208C 06A0  32         bl    @ldfnt
     208E 2362 
0081 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C 
0082               
0083 2094 06A0  32         bl    @filv
     2096 2290 
0084 2098 0380                   data >0380,>f0,32*24  ; Load color table
     209A 00F0 
     209C 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 209E 06A0  32         bl    @putat                ; Show crash message
     20A0 2444 
0089 20A2 0000                   data >0000,cpu.crash.msg.crashed
     20A4 2178 
0090               
0091 20A6 06A0  32         bl    @puthex               ; Put hex value on screen
     20A8 2990 
0092 20AA 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20AC FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20AE 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20B0 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20B2 06A0  32         bl    @putat                ; Show caller message
     20B4 2444 
0101 20B6 0100                   data >0100,cpu.crash.msg.caller
     20B8 218E 
0102               
0103 20BA 06A0  32         bl    @puthex               ; Put hex value on screen
     20BC 2990 
0104 20BE 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20C0 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20C2 2F6A                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20C4 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20C6 06A0  32         bl    @putat
     20C8 2444 
0113 20CA 0300                   byte 3,0
0114 20CC 21AA                   data cpu.crash.msg.wp
0115 20CE 06A0  32         bl    @putat
     20D0 2444 
0116 20D2 0400                   byte 4,0
0117 20D4 21B0                   data cpu.crash.msg.st
0118 20D6 06A0  32         bl    @putat
     20D8 2444 
0119 20DA 1600                   byte 22,0
0120 20DC 21B6                   data cpu.crash.msg.source
0121 20DE 06A0  32         bl    @putat
     20E0 2444 
0122 20E2 1700                   byte 23,0
0123 20E4 21D2                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20E6 06A0  32         bl    @at                   ; Put cursor at YX
     20E8 2694 
0128 20EA 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20EC 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20EE FFDC 
0132 20F0 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 20F2 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 20F4 0649  14         dect  stack
0138 20F6 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 20F8 0649  14         dect  stack
0140 20FA C645  30         mov   tmp1,*stack           ; Push tmp1
0141 20FC 0649  14         dect  stack
0142 20FE C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 2100 C046  18         mov   tmp2,r1               ; Save register number
0148 2102 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     2104 0001 
0149 2106 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2108 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 210A 06A0  32         bl    @mknum
     210C 299A 
0154 210E 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 2110 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 2112 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 2114 06A0  32         bl    @setx                 ; Set cursor X position
     2116 26AA 
0160 2118 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 211A 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     211C 2420 
0164 211E 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 2120 06A0  32         bl    @setx                 ; Set cursor X position
     2122 26AA 
0168 2124 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2126 0281  22         ci    r1,10
     2128 000A 
0172 212A 1102  14         jlt   !
0173 212C 0620  34         dec   @wyx                  ; x=x-1
     212E 832A 
0174               
0175 2130 06A0  32 !       bl    @putstr
     2132 2420 
0176 2134 21A4                   data cpu.crash.msg.r
0177               
0178 2136 06A0  32         bl    @mknum
     2138 299A 
0179 213A 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 213C 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 213E 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 2140 06A0  32         bl    @mkhex                ; Convert hex word to string
     2142 290C 
0188 2144 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2146 2F6A                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2148 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 214A 06A0  32         bl    @setx                 ; Set cursor X position
     214C 26AA 
0194 214E 0004                   data 4                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 2150 06A0  32         bl    @putstr               ; Put '  >'
     2152 2420 
0198 2154 21A6                   data cpu.crash.msg.marker
0199               
0200 2156 06A0  32         bl    @setx                 ; Set cursor X position
     2158 26AA 
0201 215A 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 215C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     215E 2420 
0205 2160 2F6A                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 2162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 2164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2168 06A0  32         bl    @down                 ; y=y+1
     216A 269A 
0213               
0214 216C 0586  14         inc   tmp2
0215 216E 0286  22         ci    tmp2,17
     2170 0011 
0216 2172 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 2174 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2176 2D0A 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2178 1553             byte  21
0225 2179 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 218E 1543             byte  21
0230 218F ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21A4 0152             byte  1
0235 21A5 ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21A6 0320             byte  3
0240 21A7 ....             text  '  >'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21AA 042A             byte  4
0245 21AB ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21B0 042A             byte  4
0250 21B1 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21B6 1B53             byte  27
0255 21B7 ....             text  'Source    stevie_b2.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21D2 1742             byte  23
0260 21D3 ....             text  'Build-ID  201220-488847'
0261                       even
0262               
**** **** ****     > runlib.asm
0089                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 21EA 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21EC 000E 
     21EE 0106 
     21F0 0204 
     21F2 0020 
0008               *
0009               * ; VDP#0 Control bits
0010               * ;      bit 6=0: M3 | Graphics 1 mode
0011               * ;      bit 7=0: Disable external VDP input
0012               * ; VDP#1 Control bits
0013               * ;      bit 0=1: 16K selection
0014               * ;      bit 1=1: Enable display
0015               * ;      bit 2=1: Enable VDP interrupt
0016               * ;      bit 3=0: M1 \ Graphics 1 mode
0017               * ;      bit 4=0: M2 /
0018               * ;      bit 5=0: reserved
0019               * ;      bit 6=1: 16x16 sprites
0020               * ;      bit 7=0: Sprite magnification (1x)
0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
0026               * ; VDP#7 Set screen background color
0027               
0028               
0029               ***************************************************************
0030               * Textmode (40 columns/24 rows)
0031               *--------------------------------------------------------------
0032 21F4 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     21F6 000E 
     21F8 0106 
     21FA 00F4 
     21FC 0028 
0033               *
0034               * ; VDP#0 Control bits
0035               * ;      bit 6=0: M3 | Graphics 1 mode
0036               * ;      bit 7=0: Disable external VDP input
0037               * ; VDP#1 Control bits
0038               * ;      bit 0=1: 16K selection
0039               * ;      bit 1=1: Enable display
0040               * ;      bit 2=1: Enable VDP interrupt
0041               * ;      bit 3=1: M1 \ TEXT MODE
0042               * ;      bit 4=0: M2 /
0043               * ;      bit 5=0: reserved
0044               * ;      bit 6=1: 16x16 sprites
0045               * ;      bit 7=0: Sprite magnification (1x)
0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0051               * ; VDP#7 Set foreground/background color
0052               ***************************************************************
0053               
0054               
0055               ***************************************************************
0056               * Textmode (80 columns, 24 rows) - F18A
0057               *--------------------------------------------------------------
0058 21FE 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2200 003F 
     2202 0240 
     2204 03F4 
     2206 0050 
0059               *
0060               * ; VDP#0 Control bits
0061               * ;      bit 6=0: M3 | Graphics 1 mode
0062               * ;      bit 7=0: Disable external VDP input
0063               * ; VDP#1 Control bits
0064               * ;      bit 0=1: 16K selection
0065               * ;      bit 1=1: Enable display
0066               * ;      bit 2=1: Enable VDP interrupt
0067               * ;      bit 3=1: M1 \ TEXT MODE
0068               * ;      bit 4=0: M2 /
0069               * ;      bit 5=0: reserved
0070               * ;      bit 6=0: 8x8 sprites
0071               * ;      bit 7=0: Sprite magnification (1x)
0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0077               * ; VDP#7 Set foreground/background color
0078               ***************************************************************
0079               
0080               
0081               ***************************************************************
0082               * Textmode (80 columns, 30 rows) - F18A
0083               *--------------------------------------------------------------
0084 2208 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220A 003F 
     220C 0240 
     220E 03F4 
     2210 0050 
0085               *
0086               * ; VDP#0 Control bits
0087               * ;      bit 6=0: M3 | Graphics 1 mode
0088               * ;      bit 7=0: Disable external VDP input
0089               * ; VDP#1 Control bits
0090               * ;      bit 0=1: 16K selection
0091               * ;      bit 1=1: Enable display
0092               * ;      bit 2=1: Enable VDP interrupt
0093               * ;      bit 3=1: M1 \ TEXT MODE
0094               * ;      bit 4=0: M2 /
0095               * ;      bit 5=0: reserved
0096               * ;      bit 6=0: 8x8 sprites
0097               * ;      bit 7=0: Sprite magnification (1x)
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0103               * ; VDP#7 Set foreground/background color
0104               ***************************************************************
**** **** ****     > runlib.asm
0090                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
**** **** ****     > basic_cpu_vdp.asm
0001               * FILE......: basic_cpu_vdp.asm
0002               * Purpose...: Basic CPU & VDP functions used by other modules
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *       Support Machine Code for copy & fill functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ; Machine code for tight loop.
0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
0011               *--------------------------------------------------------------
0012               *       DATA  >????                 ; \ mcloop  mov   ...
0013 2212 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2214 16FD             data  >16fd                 ; |         jne   mcloop
0015 2216 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2218 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 221A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               ***************************************************************
0027               * loadmc - Load machine code into scratchpad  >8322 - >8328
0028               ***************************************************************
0029               *  bl  @loadmc
0030               *--------------------------------------------------------------
0031               *  REMARKS
0032               *  Machine instruction in location @>8320 will be set by
0033               *  SP2 copy/fill routine that is called later on.
0034               ********|*****|*********************|**************************
0035               loadmc:
0036 221C 0201  20         li    r1,mccode             ; Machinecode to patch
     221E 2212 
0037 2220 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2222 8322 
0038 2224 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2226 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2228 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 222A 045B  20         b     *r11                  ; Return to caller
0042               
0043               
0044               *//////////////////////////////////////////////////////////////
0045               *                    STACK SUPPORT FUNCTIONS
0046               *//////////////////////////////////////////////////////////////
0047               
0048               ***************************************************************
0049               * POPR. - Pop registers & return to caller
0050               ***************************************************************
0051               *  B  @POPRG.
0052               *--------------------------------------------------------------
0053               *  REMARKS
0054               *  R11 must be at stack bottom
0055               ********|*****|*********************|**************************
0056 222C C0F9  30 popr3   mov   *stack+,r3
0057 222E C0B9  30 popr2   mov   *stack+,r2
0058 2230 C079  30 popr1   mov   *stack+,r1
0059 2232 C039  30 popr0   mov   *stack+,r0
0060 2234 C2F9  30 poprt   mov   *stack+,r11
0061 2236 045B  20         b     *r11
0062               
0063               
0064               
0065               *//////////////////////////////////////////////////////////////
0066               *                   MEMORY FILL FUNCTIONS
0067               *//////////////////////////////////////////////////////////////
0068               
0069               ***************************************************************
0070               * FILM - Fill CPU memory with byte
0071               ***************************************************************
0072               *  bl   @film
0073               *  data P0,P1,P2
0074               *--------------------------------------------------------------
0075               *  P0 = Memory start address
0076               *  P1 = Byte to fill
0077               *  P2 = Number of bytes to fill
0078               *--------------------------------------------------------------
0079               *  bl   @xfilm
0080               *
0081               *  TMP0 = Memory start address
0082               *  TMP1 = Byte to fill
0083               *  TMP2 = Number of bytes to fill
0084               ********|*****|*********************|**************************
0085 2238 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 223A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 223C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Sanity check
0090               *--------------------------------------------------------------
0091 223E C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2240 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2242 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2244 FFCE 
0095 2246 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2248 2026 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 224A D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     224C 830B 
     224E 830A 
0100               
0101 2250 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2252 0001 
0102 2254 1602  14         jne   filchk2
0103 2256 DD05  32         movb  tmp1,*tmp0+
0104 2258 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 225A 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     225C 0002 
0109 225E 1603  14         jne   filchk3
0110 2260 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2262 DD05  32         movb  tmp1,*tmp0+
0112 2264 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2266 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2268 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     226A 0001 
0118 226C 1605  14         jne   fil16b
0119 226E DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2270 0606  14         dec   tmp2
0121 2272 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2274 0002 
0122 2276 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2278 C1C6  18 fil16b  mov   tmp2,tmp3
0127 227A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227C 0001 
0128 227E 1301  14         jeq   dofill
0129 2280 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2282 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2284 0646  14         dect  tmp2
0132 2286 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2288 C1C7  18         mov   tmp3,tmp3
0137 228A 1301  14         jeq   fil.exit
0138 228C DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 228E 045B  20         b     *r11
0141               
0142               
0143               ***************************************************************
0144               * FILV - Fill VRAM with byte
0145               ***************************************************************
0146               *  BL   @FILV
0147               *  DATA P0,P1,P2
0148               *--------------------------------------------------------------
0149               *  P0 = VDP start address
0150               *  P1 = Byte to fill
0151               *  P2 = Number of bytes to fill
0152               *--------------------------------------------------------------
0153               *  BL   @XFILV
0154               *
0155               *  TMP0 = VDP start address
0156               *  TMP1 = Byte to fill
0157               *  TMP2 = Number of bytes to fill
0158               ********|*****|*********************|**************************
0159 2290 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 2292 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 2294 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 2296 0264  22 xfilv   ori   tmp0,>4000
     2298 4000 
0166 229A 06C4  14         swpb  tmp0
0167 229C D804  38         movb  tmp0,@vdpa
     229E 8C02 
0168 22A0 06C4  14         swpb  tmp0
0169 22A2 D804  38         movb  tmp0,@vdpa
     22A4 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22A6 020F  20         li    r15,vdpw              ; Set VDP write address
     22A8 8C00 
0174 22AA 06C5  14         swpb  tmp1
0175 22AC C820  54         mov   @filzz,@mcloop        ; Setup move command
     22AE 22B6 
     22B0 8320 
0176 22B2 0460  28         b     @mcloop               ; Write data to VDP
     22B4 8320 
0177               *--------------------------------------------------------------
0181 22B6 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0183               
0184               
0185               
0186               *//////////////////////////////////////////////////////////////
0187               *                  VDP LOW LEVEL FUNCTIONS
0188               *//////////////////////////////////////////////////////////////
0189               
0190               ***************************************************************
0191               * VDWA / VDRA - Setup VDP write or read address
0192               ***************************************************************
0193               *  BL   @VDWA
0194               *
0195               *  TMP0 = VDP destination address for write
0196               *--------------------------------------------------------------
0197               *  BL   @VDRA
0198               *
0199               *  TMP0 = VDP source address for read
0200               ********|*****|*********************|**************************
0201 22B8 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22BA 4000 
0202 22BC 06C4  14 vdra    swpb  tmp0
0203 22BE D804  38         movb  tmp0,@vdpa
     22C0 8C02 
0204 22C2 06C4  14         swpb  tmp0
0205 22C4 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22C6 8C02 
0206 22C8 045B  20         b     *r11                  ; Exit
0207               
0208               ***************************************************************
0209               * VPUTB - VDP put single byte
0210               ***************************************************************
0211               *  BL @VPUTB
0212               *  DATA P0,P1
0213               *--------------------------------------------------------------
0214               *  P0 = VDP target address
0215               *  P1 = Byte to write
0216               ********|*****|*********************|**************************
0217 22CA C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22CC C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22CE 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22D0 4000 
0223 22D2 06C4  14         swpb  tmp0                  ; \
0224 22D4 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22D6 8C02 
0225 22D8 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22DA D804  38         movb  tmp0,@vdpa            ; /
     22DC 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22DE 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22E0 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22E2 045B  20         b     *r11                  ; Exit
0233               
0234               
0235               ***************************************************************
0236               * VGETB - VDP get single byte
0237               ***************************************************************
0238               *  bl   @vgetb
0239               *  data p0
0240               *--------------------------------------------------------------
0241               *  P0 = VDP source address
0242               *--------------------------------------------------------------
0243               *  bl   @xvgetb
0244               *
0245               *  tmp0 = VDP source address
0246               *--------------------------------------------------------------
0247               *  Output:
0248               *  tmp0 MSB = >00
0249               *  tmp0 LSB = VDP byte read
0250               ********|*****|*********************|**************************
0251 22E4 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22E6 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22E8 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22EA 8C02 
0257 22EC 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22EE D804  38         movb  tmp0,@vdpa            ; /
     22F0 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22F2 D120  34         movb  @vdpr,tmp0            ; Read byte
     22F4 8800 
0263 22F6 0984  56         srl   tmp0,8                ; Right align
0264 22F8 045B  20         b     *r11                  ; Exit
0265               
0266               
0267               ***************************************************************
0268               * VIDTAB - Dump videomode table
0269               ***************************************************************
0270               *  BL   @VIDTAB
0271               *  DATA P0
0272               *--------------------------------------------------------------
0273               *  P0 = Address of video mode table
0274               *--------------------------------------------------------------
0275               *  BL   @XIDTAB
0276               *
0277               *  TMP0 = Address of video mode table
0278               *--------------------------------------------------------------
0279               *  Remarks
0280               *  TMP1 = MSB is the VDP target register
0281               *         LSB is the value to write
0282               ********|*****|*********************|**************************
0283 22FA C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 22FC C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 22FE C144  18         mov   tmp0,tmp1
0289 2300 05C5  14         inct  tmp1
0290 2302 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2304 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2306 FF00 
0292 2308 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 230A C805  38         mov   tmp1,@wbase           ; Store calculated base
     230C 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 230E 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2310 8000 
0298 2312 0206  20         li    tmp2,8
     2314 0008 
0299 2316 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2318 830B 
0300 231A 06C5  14         swpb  tmp1
0301 231C D805  38         movb  tmp1,@vdpa
     231E 8C02 
0302 2320 06C5  14         swpb  tmp1
0303 2322 D805  38         movb  tmp1,@vdpa
     2324 8C02 
0304 2326 0225  22         ai    tmp1,>0100
     2328 0100 
0305 232A 0606  14         dec   tmp2
0306 232C 16F4  14         jne   vidta1                ; Next register
0307 232E C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2330 833A 
0308 2332 045B  20         b     *r11
0309               
0310               
0311               ***************************************************************
0312               * PUTVR  - Put single VDP register
0313               ***************************************************************
0314               *  BL   @PUTVR
0315               *  DATA P0
0316               *--------------------------------------------------------------
0317               *  P0 = MSB is the VDP target register
0318               *       LSB is the value to write
0319               *--------------------------------------------------------------
0320               *  BL   @PUTVRX
0321               *
0322               *  TMP0 = MSB is the VDP target register
0323               *         LSB is the value to write
0324               ********|*****|*********************|**************************
0325 2334 C13B  30 putvr   mov   *r11+,tmp0
0326 2336 0264  22 putvrx  ori   tmp0,>8000
     2338 8000 
0327 233A 06C4  14         swpb  tmp0
0328 233C D804  38         movb  tmp0,@vdpa
     233E 8C02 
0329 2340 06C4  14         swpb  tmp0
0330 2342 D804  38         movb  tmp0,@vdpa
     2344 8C02 
0331 2346 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2348 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 234A C10E  18         mov   r14,tmp0
0341 234C 0984  56         srl   tmp0,8
0342 234E 06A0  32         bl    @putvrx               ; Write VR#0
     2350 2336 
0343 2352 0204  20         li    tmp0,>0100
     2354 0100 
0344 2356 D820  54         movb  @r14lb,@tmp0lb
     2358 831D 
     235A 8309 
0345 235C 06A0  32         bl    @putvrx               ; Write VR#1
     235E 2336 
0346 2360 0458  20         b     *tmp4                 ; Exit
0347               
0348               
0349               ***************************************************************
0350               * LDFNT - Load TI-99/4A font from GROM into VDP
0351               ***************************************************************
0352               *  BL   @LDFNT
0353               *  DATA P0,P1
0354               *--------------------------------------------------------------
0355               *  P0 = VDP Target address
0356               *  P1 = Font options
0357               *--------------------------------------------------------------
0358               * Uses registers tmp0-tmp4
0359               ********|*****|*********************|**************************
0360 2362 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2364 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2366 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2368 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     236A 7FFF 
0364 236C 2120  38         coc   @wbit0,tmp0
     236E 2020 
0365 2370 1604  14         jne   ldfnt1
0366 2372 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2374 8000 
0367 2376 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2378 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 237A C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     237C 23E4 
0372 237E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2380 9C02 
0373 2382 06C4  14         swpb  tmp0
0374 2384 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2386 9C02 
0375 2388 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     238A 9800 
0376 238C 06C5  14         swpb  tmp1
0377 238E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     2390 9800 
0378 2392 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 2394 D805  38         movb  tmp1,@grmwa
     2396 9C02 
0383 2398 06C5  14         swpb  tmp1
0384 239A D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     239C 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 239E C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23A0 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23A2 22B8 
0390 23A4 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23A6 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23A8 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23AA 7FFF 
0393 23AC C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23AE 23E6 
0394 23B0 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23B2 23E8 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23B4 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23B6 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23B8 D120  34         movb  @grmrd,tmp0
     23BA 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23BC 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23BE 2020 
0405 23C0 1603  14         jne   ldfnt3                ; No, so skip
0406 23C2 D1C4  18         movb  tmp0,tmp3
0407 23C4 0917  56         srl   tmp3,1
0408 23C6 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23C8 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23CA 8C00 
0413 23CC 0606  14         dec   tmp2
0414 23CE 16F2  14         jne   ldfnt2
0415 23D0 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23D2 020F  20         li    r15,vdpw              ; Set VDP write address
     23D4 8C00 
0417 23D6 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23D8 7FFF 
0418 23DA 0458  20         b     *tmp4                 ; Exit
0419 23DC D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23DE 2000 
     23E0 8C00 
0420 23E2 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23E4 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23E6 0200 
     23E8 0000 
0425 23EA 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23EC 01C0 
     23EE 0101 
0426 23F0 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23F2 02A0 
     23F4 0101 
0427 23F6 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     23F8 00E0 
     23FA 0101 
0428               
0429               
0430               
0431               ***************************************************************
0432               * YX2PNT - Get VDP PNT address for current YX cursor position
0433               ***************************************************************
0434               *  BL   @YX2PNT
0435               *--------------------------------------------------------------
0436               *  INPUT
0437               *  @WYX = Cursor YX position
0438               *--------------------------------------------------------------
0439               *  OUTPUT
0440               *  TMP0 = VDP address for entry in Pattern Name Table
0441               *--------------------------------------------------------------
0442               *  Register usage
0443               *  TMP0, R14, R15
0444               ********|*****|*********************|**************************
0445 23FC C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 23FE C3A0  34         mov   @wyx,r14              ; Get YX
     2400 832A 
0447 2402 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2404 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2406 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2408 C3A0  34         mov   @wyx,r14              ; Get YX
     240A 832A 
0454 240C 024E  22         andi  r14,>00ff             ; Remove Y
     240E 00FF 
0455 2410 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2412 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2414 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2416 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2418 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 241A 020F  20         li    r15,vdpw              ; VDP write address
     241C 8C00 
0463 241E 045B  20         b     *r11
0464               
0465               
0466               
0467               ***************************************************************
0468               * Put length-byte prefixed string at current YX
0469               ***************************************************************
0470               *  BL   @PUTSTR
0471               *  DATA P0
0472               *
0473               *  P0 = Pointer to string
0474               *--------------------------------------------------------------
0475               *  REMARKS
0476               *  First byte of string must contain length
0477               ********|*****|*********************|**************************
0478 2420 C17B  30 putstr  mov   *r11+,tmp1
0479 2422 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 2424 C1CB  18 xutstr  mov   r11,tmp3
0481 2426 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2428 23FC 
0482 242A C2C7  18         mov   tmp3,r11
0483 242C 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 242E C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 2430 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 2432 0286  22         ci    tmp2,255              ; Length > 255 ?
     2434 00FF 
0491 2436 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2438 0460  28         b     @xpym2v               ; Display string
     243A 2452 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 243C C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     243E FFCE 
0498 2440 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2442 2026 
0499               
0500               
0501               
0502               ***************************************************************
0503               * Put length-byte prefixed string at YX
0504               ***************************************************************
0505               *  BL   @PUTAT
0506               *  DATA P0,P1
0507               *
0508               *  P0 = YX position
0509               *  P1 = Pointer to string
0510               *--------------------------------------------------------------
0511               *  REMARKS
0512               *  First byte of string must contain length
0513               ********|*****|*********************|**************************
0514 2444 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2446 832A 
0515 2448 0460  28         b     @putstr
     244A 2420 
**** **** ****     > runlib.asm
0091               
0093                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
**** **** ****     > copy_cpu_vram.asm
0001               * FILE......: copy_cpu_vram.asm
0002               * Purpose...: CPU memory to VRAM copy support module
0003               
0004               ***************************************************************
0005               * CPYM2V - Copy CPU memory to VRAM
0006               ***************************************************************
0007               *  BL   @CPYM2V
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP start address
0011               *  P1 = RAM/ROM start address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYM2V
0015               *
0016               *  TMP0 = VDP start address
0017               *  TMP1 = RAM/ROM start address
0018               *  TMP2 = Number of bytes to copy
0019               ********|*****|*********************|**************************
0020 244C C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 244E C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 2450 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Sanity check
0025               *--------------------------------------------------------------
0026 2452 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 2454 1604  14         jne   !                     ; No, continue
0028               
0029 2456 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2458 FFCE 
0030 245A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     245C 2026 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 245E 0264  22 !       ori   tmp0,>4000
     2460 4000 
0035 2462 06C4  14         swpb  tmp0
0036 2464 D804  38         movb  tmp0,@vdpa
     2466 8C02 
0037 2468 06C4  14         swpb  tmp0
0038 246A D804  38         movb  tmp0,@vdpa
     246C 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 246E 020F  20         li    r15,vdpw              ; Set VDP write address
     2470 8C00 
0043 2472 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     2474 247C 
     2476 8320 
0044 2478 0460  28         b     @mcloop               ; Write data to VDP and return
     247A 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 247C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0095               
0097                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
**** **** ****     > copy_vram_cpu.asm
0001               * FILE......: copy_vram_cpu.asm
0002               * Purpose...: VRAM to CPU memory copy support module
0003               
0004               ***************************************************************
0005               * CPYV2M - Copy VRAM to CPU memory
0006               ***************************************************************
0007               *  BL   @CPYV2M
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP source address
0011               *  P1 = RAM target address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYV2M
0015               *
0016               *  TMP0 = VDP source address
0017               *  TMP1 = RAM target address
0018               *  TMP2 = Number of bytes to copy
0019               ********|*****|*********************|**************************
0020 247E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 2480 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 2482 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 2484 06C4  14 xpyv2m  swpb  tmp0
0027 2486 D804  38         movb  tmp0,@vdpa
     2488 8C02 
0028 248A 06C4  14         swpb  tmp0
0029 248C D804  38         movb  tmp0,@vdpa
     248E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 2490 020F  20         li    r15,vdpr              ; Set VDP read address
     2492 8800 
0034 2494 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     2496 249E 
     2498 8320 
0035 249A 0460  28         b     @mcloop               ; Read data from VDP
     249C 8320 
0036 249E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0099               
0101                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
**** **** ****     > copy_cpu_cpu.asm
0001               * FILE......: copy_cpu_cpu.asm
0002               * Purpose...: CPU to CPU memory copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       CPU COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * CPYM2M - Copy CPU memory to CPU memory
0010               ***************************************************************
0011               *  BL   @CPYM2M
0012               *  DATA P0,P1,P2
0013               *--------------------------------------------------------------
0014               *  P0 = Memory source address
0015               *  P1 = Memory target address
0016               *  P2 = Number of bytes to copy
0017               *--------------------------------------------------------------
0018               *  BL @XPYM2M
0019               *
0020               *  TMP0 = Memory source address
0021               *  TMP1 = Memory target address
0022               *  TMP2 = Number of bytes to copy
0023               ********|*****|*********************|**************************
0024 24A0 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24A2 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24A4 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24A6 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24A8 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24AA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24AC FFCE 
0034 24AE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24B0 2026 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24B2 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24B4 0001 
0039 24B6 1603  14         jne   cpym0                 ; No, continue checking
0040 24B8 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24BA 04C6  14         clr   tmp2                  ; Reset counter
0042 24BC 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24BE 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24C0 7FFF 
0047 24C2 C1C4  18         mov   tmp0,tmp3
0048 24C4 0247  22         andi  tmp3,1
     24C6 0001 
0049 24C8 1618  14         jne   cpyodd                ; Odd source address handling
0050 24CA C1C5  18 cpym1   mov   tmp1,tmp3
0051 24CC 0247  22         andi  tmp3,1
     24CE 0001 
0052 24D0 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24D2 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24D4 2020 
0057 24D6 1605  14         jne   cpym3
0058 24D8 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24DA 2500 
     24DC 8320 
0059 24DE 0460  28         b     @mcloop               ; Copy memory and exit
     24E0 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24E2 C1C6  18 cpym3   mov   tmp2,tmp3
0064 24E4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24E6 0001 
0065 24E8 1301  14         jeq   cpym4
0066 24EA 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24EC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24EE 0646  14         dect  tmp2
0069 24F0 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24F2 C1C7  18         mov   tmp3,tmp3
0074 24F4 1301  14         jeq   cpymz
0075 24F6 D554  38         movb  *tmp0,*tmp1
0076 24F8 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 24FA 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     24FC 8000 
0081 24FE 10E9  14         jmp   cpym2
0082 2500 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0103               
0107               
0111               
0113                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
**** **** ****     > cpu_sams_support.asm
0001               * FILE......: cpu_sams_support.asm
0002               * Purpose...: Low level support for SAMS memory expansion card
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                SAMS Memory Expansion support
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ACCESS and MAPPING
0010               * (by the late Bruce Harisson):
0011               *
0012               * To use other than the default setup, you have to do two
0013               * things:
0014               *
0015               * 1. You have to "turn on" the card's memory in the
0016               *    >4000 block and write to the mapping registers there.
0017               *    (bl  @sams.page.set)
0018               *
0019               * 2. You have to "turn on" the mapper function to make what
0020               *    you've written into the >4000 block take effect.
0021               *    (bl  @sams.mapping.on)
0022               *--------------------------------------------------------------
0023               *  SAMS                          Default SAMS page
0024               *  Register     Memory bank      (system startup)
0025               *  =======      ===========      ================
0026               *  >4004        >2000-2fff          >002
0027               *  >4006        >3000-4fff          >003
0028               *  >4014        >a000-afff          >00a
0029               *  >4016        >b000-bfff          >00b
0030               *  >4018        >c000-cfff          >00c
0031               *  >401a        >d000-dfff          >00d
0032               *  >401c        >e000-efff          >00e
0033               *  >401e        >f000-ffff          >00f
0034               *  Others       Inactive
0035               *--------------------------------------------------------------
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * sams.page.get - Get SAMS page number for memory address
0042               ***************************************************************
0043               * bl   @sams.page.get
0044               *      data P0
0045               *--------------------------------------------------------------
0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
0047               *      register >4014 (bank >a000 - >afff)
0048               *--------------------------------------------------------------
0049               * bl   @xsams.page.get
0050               *
0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
0052               *        register >4014 (bank >a000 - >afff)
0053               *--------------------------------------------------------------
0054               * OUTPUT
0055               * waux1 = SAMS page number
0056               * waux2 = Address of affected SAMS register
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * r0, tmp0, r12
0060               ********|*****|*********************|**************************
0061               sams.page.get:
0062 2502 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2504 0649  14         dect  stack
0065 2506 C64B  30         mov   r11,*stack            ; Push return address
0066 2508 0649  14         dect  stack
0067 250A C640  30         mov   r0,*stack             ; Push r0
0068 250C 0649  14         dect  stack
0069 250E C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 2510 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2512 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2514 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2516 4000 
0077 2518 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     251A 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 251C 020C  20         li    r12,>1e00             ; SAMS CRU address
     251E 1E00 
0082 2520 04C0  14         clr   r0
0083 2522 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2524 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2526 D100  18         movb  r0,tmp0
0086 2528 0984  56         srl   tmp0,8                ; Right align
0087 252A C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     252C 833C 
0088 252E 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 2530 C339  30         mov   *stack+,r12           ; Pop r12
0094 2532 C039  30         mov   *stack+,r0            ; Pop r0
0095 2534 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2536 045B  20         b     *r11                  ; Return to caller
0097               
0098               
0099               
0100               
0101               ***************************************************************
0102               * sams.page.set - Set SAMS memory page
0103               ***************************************************************
0104               * bl   sams.page.set
0105               *      data P0,P1
0106               *--------------------------------------------------------------
0107               * P0 = SAMS page number
0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
0109               *      register >4014 (bank >a000 - >afff)
0110               *--------------------------------------------------------------
0111               * bl   @xsams.page.set
0112               *
0113               * tmp0 = SAMS page number
0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
0115               *        register >4014 (bank >a000 - >afff)
0116               *--------------------------------------------------------------
0117               * Register usage
0118               * r0, tmp0, tmp1, r12
0119               *--------------------------------------------------------------
0120               * SAMS page number should be in range 0-255 (>00 to >ff)
0121               *
0122               *  Page         Memory
0123               *  ====         ======
0124               *  >00             32K
0125               *  >1f            128K
0126               *  >3f            256K
0127               *  >7f            512K
0128               *  >ff           1024K
0129               ********|*****|*********************|**************************
0130               sams.page.set:
0131 2538 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 253A C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 253C 0649  14         dect  stack
0135 253E C64B  30         mov   r11,*stack            ; Push return address
0136 2540 0649  14         dect  stack
0137 2542 C640  30         mov   r0,*stack             ; Push r0
0138 2544 0649  14         dect  stack
0139 2546 C64C  30         mov   r12,*stack            ; Push r12
0140 2548 0649  14         dect  stack
0141 254A C644  30         mov   tmp0,*stack           ; Push tmp0
0142 254C 0649  14         dect  stack
0143 254E C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 2550 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 2552 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 2554 0284  22         ci    tmp0,255              ; Crash if page > 255
     2556 00FF 
0153 2558 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 255A 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     255C 001E 
0158 255E 150A  14         jgt   !
0159 2560 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     2562 0004 
0160 2564 1107  14         jlt   !
0161 2566 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2568 0012 
0162 256A 1508  14         jgt   sams.page.set.switch_page
0163 256C 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     256E 0006 
0164 2570 1501  14         jgt   !
0165 2572 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 2574 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2576 FFCE 
0170 2578 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     257A 2026 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 257C 020C  20         li    r12,>1e00             ; SAMS CRU address
     257E 1E00 
0176 2580 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 2582 06C0  14         swpb  r0                    ; LSB to MSB
0178 2584 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2586 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2588 4000 
0180 258A 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 258C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 258E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 2590 C339  30         mov   *stack+,r12           ; Pop r12
0188 2592 C039  30         mov   *stack+,r0            ; Pop r0
0189 2594 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 2596 045B  20         b     *r11                  ; Return to caller
0191               
0192               
0193               
0194               
0195               ***************************************************************
0196               * sams.mapping.on - Enable SAMS mapping mode
0197               ***************************************************************
0198               *  bl   @sams.mapping.on
0199               *--------------------------------------------------------------
0200               *  Register usage
0201               *  r12
0202               ********|*****|*********************|**************************
0203               sams.mapping.on:
0204 2598 020C  20         li    r12,>1e00             ; SAMS CRU address
     259A 1E00 
0205 259C 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 259E 045B  20         b     *r11                  ; Return to caller
0211               
0212               
0213               
0214               
0215               ***************************************************************
0216               * sams.mapping.off - Disable SAMS mapping mode
0217               ***************************************************************
0218               * bl  @sams.mapping.off
0219               *--------------------------------------------------------------
0220               * OUTPUT
0221               * none
0222               *--------------------------------------------------------------
0223               * Register usage
0224               * r12
0225               ********|*****|*********************|**************************
0226               sams.mapping.off:
0227 25A0 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A2 1E00 
0228 25A4 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25A6 045B  20         b     *r11                  ; Return to caller
0234               
0235               
0236               
0237               
0238               
0239               ***************************************************************
0240               * sams.layout
0241               * Setup SAMS memory banks
0242               ***************************************************************
0243               * bl  @sams.layout
0244               *     data P0
0245               *--------------------------------------------------------------
0246               * INPUT
0247               * P0 = Pointer to SAMS page layout table (16 words).
0248               *--------------------------------------------------------------
0249               * bl  @xsams.layout
0250               *
0251               * tmp0 = Pointer to SAMS page layout table (16 words).
0252               *--------------------------------------------------------------
0253               * OUTPUT
0254               * none
0255               *--------------------------------------------------------------
0256               * Register usage
0257               * tmp0, tmp1, tmp2, tmp3
0258               ********|*****|*********************|**************************
0259               sams.layout:
0260 25A8 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25AA 0649  14         dect  stack
0263 25AC C64B  30         mov   r11,*stack            ; Save return address
0264 25AE 0649  14         dect  stack
0265 25B0 C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25B2 0649  14         dect  stack
0267 25B4 C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25B6 0649  14         dect  stack
0269 25B8 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25BA 0649  14         dect  stack
0271 25BC C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25BE 0206  20         li    tmp2,8                ; Set loop counter
     25C0 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25C2 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25C4 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25C6 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25C8 253C 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25CA 0606  14         dec   tmp2                  ; Next iteration
0288 25CC 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25CE 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25D0 2598 
0294                                                   ; / activating changes.
0295               
0296 25D2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25DA C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25DC 045B  20         b     *r11                  ; Return to caller
0302               
0303               
0304               
0305               ***************************************************************
0306               * sams.layout.reset
0307               * Reset SAMS memory banks to standard layout
0308               ***************************************************************
0309               * bl  @sams.layout.reset
0310               *--------------------------------------------------------------
0311               * OUTPUT
0312               * none
0313               *--------------------------------------------------------------
0314               * Register usage
0315               * none
0316               ********|*****|*********************|**************************
0317               sams.layout.reset:
0318 25DE 0649  14         dect  stack
0319 25E0 C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25E2 06A0  32         bl    @sams.layout
     25E4 25A8 
0324 25E6 25EC                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25E8 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25EA 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25EC 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25EE 0002 
0336 25F0 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25F2 0003 
0337 25F4 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     25F6 000A 
0338 25F8 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     25FA 000B 
0339 25FC C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     25FE 000C 
0340 2600 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     2602 000D 
0341 2604 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2606 000E 
0342 2608 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     260A 000F 
0343               
0344               
0345               
0346               ***************************************************************
0347               * sams.layout.copy
0348               * Copy SAMS memory layout
0349               ***************************************************************
0350               * bl  @sams.layout.copy
0351               *     data P0
0352               *--------------------------------------------------------------
0353               * P0 = Pointer to 8 words RAM buffer for results
0354               *--------------------------------------------------------------
0355               * OUTPUT
0356               * RAM buffer will have the SAMS page number for each range
0357               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0358               *--------------------------------------------------------------
0359               * Register usage
0360               * tmp0, tmp1, tmp2, tmp3
0361               ***************************************************************
0362               sams.layout.copy:
0363 260C C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 260E 0649  14         dect  stack
0366 2610 C64B  30         mov   r11,*stack            ; Push return address
0367 2612 0649  14         dect  stack
0368 2614 C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2616 0649  14         dect  stack
0370 2618 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 261A 0649  14         dect  stack
0372 261C C646  30         mov   tmp2,*stack           ; Push tmp2
0373 261E 0649  14         dect  stack
0374 2620 C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 2622 0205  20         li    tmp1,sams.layout.copy.data
     2624 2644 
0379 2626 0206  20         li    tmp2,8                ; Set loop counter
     2628 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 262A C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 262C 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     262E 2504 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 2630 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2632 833C 
0390               
0391 2634 0606  14         dec   tmp2                  ; Next iteration
0392 2636 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2638 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 263A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 263C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 263E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 2640 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 2642 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 2644 2000             data  >2000                 ; >2000-2fff
0408 2646 3000             data  >3000                 ; >3000-3fff
0409 2648 A000             data  >a000                 ; >a000-afff
0410 264A B000             data  >b000                 ; >b000-bfff
0411 264C C000             data  >c000                 ; >c000-cfff
0412 264E D000             data  >d000                 ; >d000-dfff
0413 2650 E000             data  >e000                 ; >e000-efff
0414 2652 F000             data  >f000                 ; >f000-ffff
0415               
**** **** ****     > runlib.asm
0115               
0117                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 2654 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2656 FFBF 
0010 2658 0460  28         b     @putv01
     265A 2348 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 265C 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     265E 0040 
0018 2660 0460  28         b     @putv01
     2662 2348 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 2664 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2666 FFDF 
0026 2668 0460  28         b     @putv01
     266A 2348 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 266C 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     266E 0020 
0034 2670 0460  28         b     @putv01
     2672 2348 
**** **** ****     > runlib.asm
0119               
0121                       copy  "vdp_sprites.asm"          ; VDP sprites
**** **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********|*****|*********************|**************************
0010 2674 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2676 FFFE 
0011 2678 0460  28         b     @putv01
     267A 2348 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 267C 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     267E 0001 
0019 2680 0460  28         b     @putv01
     2682 2348 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 2684 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2686 FFFD 
0027 2688 0460  28         b     @putv01
     268A 2348 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 268C 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     268E 0002 
0035 2690 0460  28         b     @putv01
     2692 2348 
**** **** ****     > runlib.asm
0123               
0125                       copy  "vdp_cursor.asm"           ; VDP cursor handling
**** **** ****     > vdp_cursor.asm
0001               * FILE......: vdp_cursor.asm
0002               * Purpose...: VDP cursor handling
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *               VDP cursor movement functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * AT - Set cursor YX position
0011               ***************************************************************
0012               *  bl   @yx
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  INPUT
0016               *  P0 = New Cursor YX position
0017               ********|*****|*********************|**************************
0018 2694 C83B  50 at      mov   *r11+,@wyx
     2696 832A 
0019 2698 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 269A B820  54 down    ab    @hb$01,@wyx
     269C 2012 
     269E 832A 
0028 26A0 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26A2 7820  54 up      sb    @hb$01,@wyx
     26A4 2012 
     26A6 832A 
0037 26A8 045B  20         b     *r11
0038               
0039               
0040               ***************************************************************
0041               * setx - Set cursor X position
0042               ***************************************************************
0043               *  bl   @setx
0044               *  data p0
0045               *--------------------------------------------------------------
0046               *  Register usage
0047               *  TMP0
0048               ********|*****|*********************|**************************
0049 26AA C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26AC D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26AE 832A 
0051 26B0 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26B2 832A 
0052 26B4 045B  20         b     *r11
**** **** ****     > runlib.asm
0127               
0129                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
**** **** ****     > vdp_yx2px_calc.asm
0001               * FILE......: vdp_yx2px_calc.asm
0002               * Purpose...: Calculate pixel position for YX coordinate
0003               
0004               ***************************************************************
0005               * YX2PX - Get pixel position for cursor YX position
0006               ***************************************************************
0007               *  BL   @YX2PX
0008               *
0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
0010               *--------------------------------------------------------------
0011               *  INPUT
0012               *  @WYX   = Cursor YX position
0013               *--------------------------------------------------------------
0014               *  OUTPUT
0015               *  TMP0HB = Y pixel position
0016               *  TMP0LB = X pixel position
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  This subroutine does not support multicolor mode
0020               ********|*****|*********************|**************************
0021 26B6 C120  34 yx2px   mov   @wyx,tmp0
     26B8 832A 
0022 26BA C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26BC 06C4  14         swpb  tmp0                  ; Y<->X
0024 26BE 04C5  14         clr   tmp1                  ; Clear before copy
0025 26C0 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26C2 20A0  38         coc   @wbit1,config         ; f18a present ?
     26C4 201E 
0030 26C6 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26C8 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26CA 833A 
     26CC 26F6 
0032 26CE 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26D0 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26D2 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26D4 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26D6 0500 
0037 26D8 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26DA D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26DC 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26DE 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26E0 D105  18         movb  tmp1,tmp0
0051 26E2 06C4  14         swpb  tmp0                  ; X<->Y
0052 26E4 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26E6 2020 
0053 26E8 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26EA 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26EC 2012 
0059 26EE 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26F0 2024 
0060 26F2 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26F4 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 26F6 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0131               
0135               
0139               
0141                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
**** **** ****     > vdp_f18a.asm
0001               * FILE......: vdp_f18a.asm
0002               * Purpose...: VDP F18A Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * f18unl - Unlock F18A VDP
0010               ***************************************************************
0011               *  bl   @f18unl
0012               ********|*****|*********************|**************************
0013 26F8 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 26FA 06A0  32         bl    @putvr                ; Write once
     26FC 2334 
0015 26FE 391C             data  >391c                 ; VR1/57, value 00011100
0016 2700 06A0  32         bl    @putvr                ; Write twice
     2702 2334 
0017 2704 391C             data  >391c                 ; VR1/57, value 00011100
0018 2706 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2708 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 270A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     270C 2334 
0028 270E 391C             data  >391c
0029 2710 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********|*****|*********************|**************************
0040 2712 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 2714 06A0  32         bl    @cpym2v
     2716 244C 
0042 2718 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     271A 2756 
     271C 0006 
0043 271E 06A0  32         bl    @putvr
     2720 2334 
0044 2722 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 2724 06A0  32         bl    @putvr
     2726 2334 
0046 2728 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 272A 0204  20         li    tmp0,>3f00
     272C 3F00 
0052 272E 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     2730 22BC 
0053 2732 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2734 8800 
0054 2736 0984  56         srl   tmp0,8
0055 2738 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     273A 8800 
0056 273C C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 273E 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 2740 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     2742 BFFF 
0060 2744 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2746 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2748 4000 
0063               f18chk_exit:
0064 274A 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     274C 2290 
0065 274E 3F00             data  >3f00,>00,6
     2750 0000 
     2752 0006 
0066 2754 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2756 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2758 3F00             data  >3f00                 ; 3f02 / 3f00
0073 275A 0340             data  >0340                 ; 3f04   0340  idle
0074               
0075               
0076               ***************************************************************
0077               * f18rst - Reset f18a into standard settings
0078               ***************************************************************
0079               *  bl   @f18rst
0080               *--------------------------------------------------------------
0081               *  REMARKS
0082               *  This is used to leave the F18A mode and revert all settings
0083               *  that could lead to corruption when doing BLWP @0
0084               *
0085               *  There are some F18a settings that stay on when doing blwp @0
0086               *  and the TI title screen cannot recover from that.
0087               *
0088               *  It is your responsibility to set video mode tables should
0089               *  you want to continue instead of doing blwp @0 after your
0090               *  program cleanup
0091               ********|*****|*********************|**************************
0092 275C C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 275E 06A0  32         bl    @putvr
     2760 2334 
0097 2762 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 2764 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2766 2334 
0100 2768 391C             data  >391c                 ; Lock the F18a
0101 276A 0458  20         b     *tmp4                 ; Exit
0102               
0103               
0104               
0105               ***************************************************************
0106               * f18fwv - Get F18A Firmware Version
0107               ***************************************************************
0108               *  bl   @f18fwv
0109               *--------------------------------------------------------------
0110               *  REMARKS
0111               *  Successfully tested with F18A v1.8, note that this does not
0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
0113               *  firmware to begin with.
0114               *--------------------------------------------------------------
0115               *  TMP0 High nibble = major version
0116               *  TMP0 Low nibble  = minor version
0117               *
0118               *  Example: >0018     F18a Firmware v1.8
0119               ********|*****|*********************|**************************
0120 276C C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 276E 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     2770 201E 
0122 2772 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 2774 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2776 8802 
0127 2778 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     277A 2334 
0128 277C 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 277E 04C4  14         clr   tmp0
0130 2780 D120  34         movb  @vdps,tmp0
     2782 8802 
0131 2784 0984  56         srl   tmp0,8
0132 2786 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0143               
0145                       copy  "vdp_hchar.asm"            ; VDP hchar functions
**** **** ****     > vdp_hchar.asm
0001               * FILE......: vdp_hchar.a99
0002               * Purpose...: VDP hchar module
0003               
0004               ***************************************************************
0005               * Repeat characters horizontally at YX
0006               ***************************************************************
0007               *  BL    @HCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 2788 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     278A 832A 
0018 278C D17B  28         movb  *r11+,tmp1
0019 278E 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 2790 D1BB  28         movb  *r11+,tmp2
0021 2792 0986  56         srl   tmp2,8                ; Repeat count
0022 2794 C1CB  18         mov   r11,tmp3
0023 2796 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     2798 23FC 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 279A 020B  20         li    r11,hchar1
     279C 27A2 
0028 279E 0460  28         b     @xfilv                ; Draw
     27A0 2296 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27A2 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27A4 2022 
0033 27A6 1302  14         jeq   hchar2                ; Yes, exit
0034 27A8 C2C7  18         mov   tmp3,r11
0035 27AA 10EE  14         jmp   hchar                 ; Next one
0036 27AC 05C7  14 hchar2  inct  tmp3
0037 27AE 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0147               
0151               
0155               
0159               
0163               
0167               
0171               
0175               
0177                       copy  "keyb_real.asm"            ; Real Keyboard support
**** **** ****     > keyb_real.asm
0001               * FILE......: keyb_real.asm
0002               * Purpose...: Full (real) keyboard support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     KEYBOARD FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * REALKB - Scan keyboard in real mode
0010               ***************************************************************
0011               *  BL @REALKB
0012               *--------------------------------------------------------------
0013               *  Based on work done by Simon Koppelmann
0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
0015               ********|*****|*********************|**************************
0016 27B0 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27B2 2020 
0017 27B4 020C  20         li    r12,>0024
     27B6 0024 
0018 27B8 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27BA 284C 
0019 27BC 04C6  14         clr   tmp2
0020 27BE 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27C0 04CC  14         clr   r12
0025 27C2 1F08  20         tb    >0008                 ; Shift-key ?
0026 27C4 1302  14         jeq   realk1                ; No
0027 27C6 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27C8 287C 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27CA 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27CC 1302  14         jeq   realk2                ; No
0033 27CE 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27D0 28AC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27D2 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27D4 1302  14         jeq   realk3                ; No
0039 27D6 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27D8 28DC 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27DA 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27DC 200C 
0044 27DE 1E15  20         sbz   >0015                 ; Set P5
0045 27E0 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27E2 1302  14         jeq   realk4                ; No
0047 27E4 E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27E6 200C 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27E8 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27EA 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27EC 0006 
0053 27EE 0606  14 realk5  dec   tmp2
0054 27F0 020C  20         li    r12,>24               ; CRU address for P2-P4
     27F2 0024 
0055 27F4 06C6  14         swpb  tmp2
0056 27F6 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 27F8 06C6  14         swpb  tmp2
0058 27FA 020C  20         li    r12,6                 ; CRU read address
     27FC 0006 
0059 27FE 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 2800 0547  14         inv   tmp3                  ;
0061 2802 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     2804 FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2806 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2808 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 280A 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 280C 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 280E 0285  22         ci    tmp1,8
     2810 0008 
0070 2812 1AFA  14         jl    realk6
0071 2814 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2816 1BEB  14         jh    realk5                ; No, next column
0073 2818 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 281A C206  18 realk8  mov   tmp2,tmp4
0078 281C 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 281E A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 2820 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 2822 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 2824 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2826 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2828 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     282A 200C 
0089 282C 1608  14         jne   realka                ; No, continue saving key
0090 282E 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     2830 2876 
0091 2832 1A05  14         jl    realka
0092 2834 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2836 2874 
0093 2838 1B02  14         jh    realka                ; No, continue
0094 283A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     283C E000 
0095 283E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     2840 833C 
0096 2842 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     2844 200A 
0097 2846 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2848 8C00 
0098                                                   ; / using R15 as temp storage
0099 284A 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 284C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     284E 0000 
     2850 FF0D 
     2852 203D 
0102 2854 ....             text  'xws29ol.'
0103 285C ....             text  'ced38ik,'
0104 2864 ....             text  'vrf47ujm'
0105 286C ....             text  'btg56yhn'
0106 2874 ....             text  'zqa10p;/'
0107 287C FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     287E 0000 
     2880 FF0D 
     2882 202B 
0108 2884 ....             text  'XWS@(OL>'
0109 288C ....             text  'CED#*IK<'
0110 2894 ....             text  'VRF$&UJM'
0111 289C ....             text  'BTG%^YHN'
0112 28A4 ....             text  'ZQA!)P:-'
0113 28AC FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28AE 0000 
     28B0 FF0D 
     28B2 2005 
0114 28B4 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28B6 0804 
     28B8 0F27 
     28BA C2B9 
0115 28BC 600B             data  >600b,>0907,>063f,>c1B8
     28BE 0907 
     28C0 063F 
     28C2 C1B8 
0116 28C4 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28C6 7B02 
     28C8 015F 
     28CA C0C3 
0117 28CC BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28CE 7D0E 
     28D0 0CC6 
     28D2 BFC4 
0118 28D4 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28D6 7C03 
     28D8 BC22 
     28DA BDBA 
0119 28DC FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28DE 0000 
     28E0 FF0D 
     28E2 209D 
0120 28E4 9897             data  >9897,>93b2,>9f8f,>8c9B
     28E6 93B2 
     28E8 9F8F 
     28EA 8C9B 
0121 28EC 8385             data  >8385,>84b3,>9e89,>8b80
     28EE 84B3 
     28F0 9E89 
     28F2 8B80 
0122 28F4 9692             data  >9692,>86b4,>b795,>8a8D
     28F6 86B4 
     28F8 B795 
     28FA 8A8D 
0123 28FC 8294             data  >8294,>87b5,>b698,>888E
     28FE 87B5 
     2900 B698 
     2902 888E 
0124 2904 9A91             data  >9a91,>81b1,>b090,>9cBB
     2906 81B1 
     2908 B090 
     290A 9CBB 
**** **** ****     > runlib.asm
0179               
0181                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
**** **** ****     > cpu_hexsupport.asm
0001               * FILE......: cpu_hexsupport.asm
0002               * Purpose...: CPU create, display hex numbers module
0003               
0004               ***************************************************************
0005               * mkhex - Convert hex word to string
0006               ***************************************************************
0007               *  bl   @mkhex
0008               *       data P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = Pointer to 16 bit word
0011               *  P1 = Pointer to string buffer
0012               *  P2 = Offset for ASCII digit
0013               *       MSB determines offset for chars A-F
0014               *       LSB determines offset for chars 0-9
0015               *  (CONFIG#0 = 1) = Display number at cursor YX
0016               *--------------------------------------------------------------
0017               *  Memory usage:
0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
0019               *  waux1, waux2, waux3
0020               *--------------------------------------------------------------
0021               *  Memory variables waux1-waux3 are used as temporary variables
0022               ********|*****|*********************|**************************
0023 290C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 290E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2910 8340 
0025 2912 04E0  34         clr   @waux1
     2914 833C 
0026 2916 04E0  34         clr   @waux2
     2918 833E 
0027 291A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     291C 833C 
0028 291E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2920 0205  20         li    tmp1,4                ; 4 nibbles
     2922 0004 
0033 2924 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2926 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2928 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 292A 0286  22         ci    tmp2,>000a
     292C 000A 
0039 292E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2930 C21B  26         mov   *r11,tmp4
0045 2932 0988  56         srl   tmp4,8                ; Right justify
0046 2934 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2936 FFF6 
0047 2938 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 293A C21B  26         mov   *r11,tmp4
0054 293C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     293E 00FF 
0055               
0056 2940 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2942 06C6  14         swpb  tmp2
0058 2944 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2946 0944  56         srl   tmp0,4                ; Next nibble
0060 2948 0605  14         dec   tmp1
0061 294A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 294C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     294E BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2950 C160  34         mov   @waux3,tmp1           ; Get pointer
     2952 8340 
0067 2954 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2956 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2958 C120  34         mov   @waux2,tmp0
     295A 833E 
0070 295C 06C4  14         swpb  tmp0
0071 295E DD44  32         movb  tmp0,*tmp1+
0072 2960 06C4  14         swpb  tmp0
0073 2962 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2964 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2966 8340 
0078 2968 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     296A 2016 
0079 296C 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 296E C120  34         mov   @waux1,tmp0
     2970 833C 
0084 2972 06C4  14         swpb  tmp0
0085 2974 DD44  32         movb  tmp0,*tmp1+
0086 2976 06C4  14         swpb  tmp0
0087 2978 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 297A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     297C 2020 
0092 297E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 2980 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 2982 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     2984 7FFF 
0098 2986 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2988 8340 
0099 298A 0460  28         b     @xutst0               ; Display string
     298C 2422 
0100 298E 0610     prefix  data  >0610                 ; Length byte + blank
0101               
0102               
0103               
0104               ***************************************************************
0105               * puthex - Put 16 bit word on screen
0106               ***************************************************************
0107               *  bl   @mkhex
0108               *       data P0,P1,P2,P3
0109               *--------------------------------------------------------------
0110               *  P0 = YX position
0111               *  P1 = Pointer to 16 bit word
0112               *  P2 = Pointer to string buffer
0113               *  P3 = Offset for ASCII digit
0114               *       MSB determines offset for chars A-F
0115               *       LSB determines offset for chars 0-9
0116               *--------------------------------------------------------------
0117               *  Memory usage:
0118               *  tmp0, tmp1, tmp2, tmp3
0119               *  waux1, waux2, waux3
0120               ********|*****|*********************|**************************
0121 2990 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     2992 832A 
0122 2994 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2996 8000 
0123 2998 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0183               
0185                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
**** **** ****     > cpu_numsupport.asm
0001               * FILE......: cpu_numsupport.asm
0002               * Purpose...: CPU create, display numbers module
0003               
0004               ***************************************************************
0005               * MKNUM - Convert unsigned number to string
0006               ***************************************************************
0007               *  BL   @MKNUM
0008               *  DATA P0,P1,P2
0009               *
0010               *  P0   = Pointer to 16 bit unsigned number
0011               *  P1   = Pointer to 5 byte string buffer
0012               *  P2HB = Offset for ASCII digit
0013               *  P2LB = Character for replacing leading 0's
0014               *
0015               *  (CONFIG:0 = 1) = Display number at cursor YX
0016               *-------------------------------------------------------------
0017               *  Destroys registers tmp0-tmp4
0018               ********|*****|*********************|**************************
0019 299A 0207  20 mknum   li    tmp3,5                ; Digit counter
     299C 0005 
0020 299E C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29A0 C155  26         mov   *tmp1,tmp1            ; /
0022 29A2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29A4 0228  22         ai    tmp4,4                ; Get end of buffer
     29A6 0004 
0024 29A8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29AA 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29AC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29AE 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29B0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29B2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29B4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29B6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29B8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29BA 0607  14         dec   tmp3                  ; Decrease counter
0036 29BC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29BE 0207  20         li    tmp3,4                ; Check first 4 digits
     29C0 0004 
0041 29C2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29C4 C11B  26         mov   *r11,tmp0
0043 29C6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29C8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29CA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29CC 05CB  14 mknum3  inct  r11
0047 29CE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29D0 2020 
0048 29D2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29D4 045B  20         b     *r11                  ; Exit
0050 29D6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29D8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29DA 13F8  14         jeq   mknum3                ; Yes, exit
0053 29DC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29DE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29E0 7FFF 
0058 29E2 C10B  18         mov   r11,tmp0
0059 29E4 0224  22         ai    tmp0,-4
     29E6 FFFC 
0060 29E8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29EA 0206  20         li    tmp2,>0500            ; String length = 5
     29EC 0500 
0062 29EE 0460  28         b     @xutstr               ; Display string
     29F0 2424 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1,p2
0072               *--------------------------------------------------------------
0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
0074               *  p1   = Pointer to output variable
0075               *  p2   = Padding character to match against
0076               *--------------------------------------------------------------
0077               *  Copy unsigned number string into a length-padded, left
0078               *  justified string for display with putstr, putat, ...
0079               *
0080               *  The new string starts at index 5 in buffer, overwriting
0081               *  anything that is located there !
0082               *
0083               *               01234|56789A
0084               *  Before...:   XXXXX
0085               *  After....:   XXXXX|zY       where length byte z=1
0086               *               XXXXX|zYY      where length byte z=2
0087               *                 ..
0088               *               XXXXX|zYYYYY   where length byte z=5
0089               *--------------------------------------------------------------
0090               *  Destroys registers tmp0-tmp3
0091               ********|*****|*********************|**************************
0092               trimnum:
0093 29F2 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0094 29F4 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0095 29F6 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0096 29F8 06C6  14         swpb  tmp2                  ; LO <-> HI
0097 29FA 0207  20         li    tmp3,5                ; Set counter
     29FC 0005 
0098                       ;------------------------------------------------------
0099                       ; Scan for padding character from left to right
0100                       ;------------------------------------------------------:
0101               trimnum_scan:
0102 29FE 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0103 2A00 1604  14         jne   trimnum_setlen        ; No, exit loop
0104 2A02 0584  14         inc   tmp0                  ; Next character
0105 2A04 0607  14         dec   tmp3                  ; Last digit reached ?
0106 2A06 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0107 2A08 10FA  14         jmp   trimnum_scan
0108                       ;------------------------------------------------------
0109                       ; Scan completed, set length byte new string
0110                       ;------------------------------------------------------
0111               trimnum_setlen:
0112 2A0A 06C7  14         swpb  tmp3                  ; LO <-> HI
0113 2A0C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0114 2A0E 06C7  14         swpb  tmp3                  ; LO <-> HI
0115                       ;------------------------------------------------------
0116                       ; Start filling new string
0117                       ;------------------------------------------------------
0118               trimnum_fill:
0119 2A10 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0120 2A12 0607  14         dec   tmp3                  ; Last character ?
0121 2A14 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0122 2A16 045B  20         b     *r11                  ; Return
0123               
0124               
0125               
0126               
0127               ***************************************************************
0128               * PUTNUM - Put unsigned number on screen
0129               ***************************************************************
0130               *  BL   @PUTNUM
0131               *  DATA P0,P1,P2,P3
0132               *--------------------------------------------------------------
0133               *  P0   = YX position
0134               *  P1   = Pointer to 16 bit unsigned number
0135               *  P2   = Pointer to 5 byte string buffer
0136               *  P3HB = Offset for ASCII digit
0137               *  P3LB = Character for replacing leading 0's
0138               ********|*****|*********************|**************************
0139 2A18 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A1A 832A 
0140 2A1C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A1E 8000 
0141 2A20 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0187               
0191               
0195               
0199               
0203               
0205                       copy  "cpu_strings.asm"          ; String utilities support
**** **** ****     > cpu_strings.asm
0001               * FILE......: cpu_strings.asm
0002               * Purpose...: CPU string manipulation library
0003               
0004               
0005               ***************************************************************
0006               * string.ltrim - Left justify string
0007               ***************************************************************
0008               *  bl   @string.ltrim
0009               *       data p0,p1,p2
0010               *--------------------------------------------------------------
0011               *  P0 = Pointer to length-prefix string
0012               *  P1 = Pointer to RAM work buffer
0013               *  P2 = Fill character
0014               *--------------------------------------------------------------
0015               *  BL   @xstring.ltrim
0016               *
0017               *  TMP0 = Pointer to length-prefix string
0018               *  TMP1 = Pointer to RAM work buffer
0019               *  TMP2 = Fill character
0020               ********|*****|*********************|**************************
0021               string.ltrim:
0022 2A22 0649  14         dect  stack
0023 2A24 C64B  30         mov   r11,*stack            ; Save return address
0024 2A26 0649  14         dect  stack
0025 2A28 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A2A 0649  14         dect  stack
0027 2A2C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A2E 0649  14         dect  stack
0029 2A30 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A32 0649  14         dect  stack
0031 2A34 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A36 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A38 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A3A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A3C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A3E 0649  14         dect  stack
0044 2A40 C64B  30         mov   r11,*stack            ; Save return address
0045 2A42 0649  14         dect  stack
0046 2A44 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A46 0649  14         dect  stack
0048 2A48 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A4A 0649  14         dect  stack
0050 2A4C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A4E 0649  14         dect  stack
0052 2A50 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A52 C1D4  26 !       mov   *tmp0,tmp3
0057 2A54 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A56 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A58 00FF 
0059 2A5A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A5C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A5E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A60 0584  14         inc   tmp0                  ; Next byte
0067 2A62 0607  14         dec   tmp3                  ; Shorten string length
0068 2A64 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A66 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A68 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A6A C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A6C 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A6E C187  18         mov   tmp3,tmp2
0078 2A70 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A72 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A74 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A76 24A6 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A78 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A7A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A7C FFCE 
0090 2A7E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A80 2026 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A82 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A84 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A86 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A8A C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A8C 045B  20         b     *r11                  ; Return to caller
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * string.getlenc - Get length of C-style string
0107               ***************************************************************
0108               *  bl   @string.getlenc
0109               *       data p0,p1
0110               *--------------------------------------------------------------
0111               *  P0 = Pointer to C-style string
0112               *  P1 = String termination character
0113               *--------------------------------------------------------------
0114               *  bl   @xstring.getlenc
0115               *
0116               *  TMP0 = Pointer to C-style string
0117               *  TMP1 = Termination character
0118               *--------------------------------------------------------------
0119               *  OUTPUT:
0120               *  @waux1 = Length of string
0121               ********|*****|*********************|**************************
0122               string.getlenc:
0123 2A8E 0649  14         dect  stack
0124 2A90 C64B  30         mov   r11,*stack            ; Save return address
0125 2A92 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A94 05D9  26         inct  *stack                ; Skip "data P1"
0127 2A96 0649  14         dect  stack
0128 2A98 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2A9A 0649  14         dect  stack
0130 2A9C C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2A9E 0649  14         dect  stack
0132 2AA0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AA2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AA4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AA6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AA8 0649  14         dect  stack
0144 2AAA C64B  30         mov   r11,*stack            ; Save return address
0145 2AAC 0649  14         dect  stack
0146 2AAE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AB0 0649  14         dect  stack
0148 2AB2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AB4 0649  14         dect  stack
0150 2AB6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AB8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2ABA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2ABC 0586  14         inc   tmp2
0161 2ABE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AC0 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2AC2 0286  22         ci    tmp2,255
     2AC4 00FF 
0167 2AC6 1505  14         jgt   string.getlenc.panic
0168 2AC8 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2ACA 0606  14         dec   tmp2                  ; One time adjustment
0174 2ACC C806  38         mov   tmp2,@waux1           ; Store length
     2ACE 833C 
0175 2AD0 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AD2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AD4 FFCE 
0181 2AD6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AD8 2026 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2ADA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2ADC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2ADE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AE0 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AE2 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0207               
0211               
0216               
0218                       copy  "fio.equ"                  ; File I/O equates
**** **** ****     > fio.equ
0001               * FILE......: fio.equ
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations - Byte 0 in PAB
0006               ************************************@**************************
0007      0000     io.op.open       equ >00            ; OPEN
0008      0001     io.op.close      equ >01            ; CLOSE
0009      0002     io.op.read       equ >02            ; READ
0010      0003     io.op.write      equ >03            ; WRITE
0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
0012      0005     io.op.load       equ >05            ; LOAD
0013      0006     io.op.save       equ >06            ; SAVE
0014      0007     io.op.delfile    equ >07            ; DELETE FILE
0015      0008     io.op.scratch    equ >08            ; SCRATCH
0016      0009     io.op.status     equ >09            ; STATUS
0017               ***************************************************************
0018               * File & data type - Byte 1 in PAB (Bit 0-4)
0019               ***************************************************************
0020               * Bit position: 4  3  21  0
0021               *               |  |  ||   \
0022               *               |  |  ||    File type
0023               *               |  |  ||    0 = INTERNAL
0024               *               |  |  ||    1 = FIXED
0025               *               |  |  \\
0026               *               |  |   File operation
0027               *               |  |   00 - UPDATE
0028               *               |  |   01 - OUTPUT
0029               *               |  |   10 - INPUT
0030               *               |  |   11 - APPEND
0031               *               |  |
0032               *               |  \
0033               *               |   Data type
0034               *               |   0 = DISPLAY
0035               *               |   1 = INTERNAL
0036               *               |
0037               *               \
0038               *                Record type
0039               *                0 = FIXED
0040               *                1 = VARIABLE
0041               ***************************************************************
0042               ; Bit position           43210
0043               ************************************|**************************
0044      0000     io.seq.upd.dis.fix  equ :00000      ; 00
0045      0001     io.rel.upd.dis.fix  equ :00001      ; 01
0046      0003     io.rel.out.dis.fix  equ :00011      ; 02
0047      0002     io.seq.out.dis.fix  equ :00010      ; 03
0048      0004     io.seq.inp.dis.fix  equ :00100      ; 04
0049      0005     io.rel.inp.dis.fix  equ :00101      ; 05
0050      0006     io.seq.app.dis.fix  equ :00110      ; 06
0051      0007     io.rel.app.dis.fix  equ :00111      ; 07
0052      0008     io.seq.upd.int.fix  equ :01000      ; 08
0053      0009     io.rel.upd.int.fix  equ :01001      ; 09
0054      000A     io.seq.out.int.fix  equ :01010      ; 0A
0055      000B     io.rel.out.int.fix  equ :01011      ; 0B
0056      000C     io.seq.inp.int.fix  equ :01100      ; 0C
0057      000D     io.rel.inp.int.fix  equ :01101      ; 0D
0058      000E     io.seq.app.int.fix  equ :01110      ; 0E
0059      000F     io.rel.app.int.fix  equ :01111      ; 0F
0060      0010     io.seq.upd.dis.var  equ :10000      ; 10
0061      0011     io.rel.upd.dis.var  equ :10001      ; 11
0062      0012     io.seq.out.dis.var  equ :10010      ; 12
0063      0013     io.rel.out.dis.var  equ :10011      ; 13
0064      0014     io.seq.inp.dis.var  equ :10100      ; 14
0065      0015     io.rel.inp.dis.var  equ :10101      ; 15
0066      0016     io.seq.app.dis.var  equ :10110      ; 16
0067      0017     io.rel.app.dis.var  equ :10111      ; 17
0068      0018     io.seq.upd.int.var  equ :11000      ; 18
0069      0019     io.rel.upd.int.var  equ :11001      ; 19
0070      001A     io.seq.out.int.var  equ :11010      ; 1A
0071      001B     io.rel.out.int.var  equ :11011      ; 1B
0072      001C     io.seq.inp.int.var  equ :11100      ; 1C
0073      001D     io.rel.inp.int.var  equ :11101      ; 1D
0074      001E     io.seq.app.int.var  equ :11110      ; 1E
0075      001F     io.rel.app.int.var  equ :11111      ; 1F
0076               ***************************************************************
0077               * File error codes - Byte 1 in PAB (Bits 5-7)
0078               ************************************|**************************
0079      0000     io.err.no_error_occured             equ 0
0080                       ; Error code 0 with condition bit reset, indicates that
0081                       ; no error has occured
0082               
0083      0000     io.err.bad_device_name              equ 0
0084                       ; Device indicated not in system
0085                       ; Error code 0 with condition bit set, indicates a
0086                       ; device not present in system
0087               
0088      0001     io.err.device_write_prottected      equ 1
0089                       ; Device is write protected
0090               
0091      0002     io.err.bad_open_attribute           equ 2
0092                       ; One or more of the OPEN attributes are illegal or do
0093                       ; not match the file's actual characteristics.
0094                       ; This could be:
0095                       ;   * File type
0096                       ;   * Record length
0097                       ;   * I/O mode
0098                       ;   * File organization
0099               
0100      0003     io.err.illegal_operation            equ 3
0101                       ; Either an issued I/O command was not supported, or a
0102                       ; conflict with the OPEN mode has occured
0103               
0104      0004     io.err.out_of_table_buffer_space    equ 4
0105                       ; The amount of space left on the device is insufficient
0106                       ; for the requested operation
0107               
0108      0005     io.err.eof                          equ 5
0109                       ; Attempt to read past end of file.
0110                       ; This error may also be given for non-existing records
0111                       ; in a relative record file
0112               
0113      0006     io.err.device_error                 equ 6
0114                       ; Covers all hard device errors, such as parity and
0115                       ; bad medium errors
0116               
0117      0007     io.err.file_error                   equ 7
0118                       ; Covers all file-related error like: program/data
0119                       ; file mismatch, non-existing file opened for input mode, etc.
**** **** ****     > runlib.asm
0219                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
**** **** ****     > fio_dsrlnk.asm
0001               * FILE......: fio_dsrlnk.asm
0002               * Purpose...: Custom DSRLNK implementation
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dsrlnk - DSRLNK for file I/O in DSR space >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  Input:
0016               *  P0     = 8 or 10 (a)
0017               *  @>8356 = Pointer to VDP PAB file descriptor length (PAB+9)
0018               *--------------------------------------------------------------
0019               *  Output:
0020               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0021               *--------------------------------------------------------------
0022               *  Remarks:
0023               *
0024               *  You need to specify following equates in main program
0025               *
0026               *  dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0027               *  dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0028               *
0029               *  Scratchpad memory usage
0030               *  >8322            Parameter (>08) or (>0A) passed to dsrlnk
0031               *  >8356            Pointer to PAB
0032               *  >83D0            CRU address of current device
0033               *  >83D2            DSR entry address
0034               *  >83e0 - >83ff    GPL / DSRLNK workspace
0035               *
0036               *  Credits
0037               *  Originally appeared in Miller Graphics The Smart Programmer.
0038               *  This version based on version of Paolo Bagnaresi.
0039               *
0040               *  The following memory address can be used to directly jump
0041               *  into the DSR in consequtive calls without having to
0042               *  scan the PEB cards again:
0043               *
0044               *  dsrlnk.namsto  -  8-byte RAM buf for holding device name
0045               *  dsrlnk.savcru  -  CRU address of device in prev. DSR call
0046               *  dsrlnk.savent  -  DSR entry addr of prev. DSR call
0047               *  dsrlnk.savpab  -  Pointer to Device or Subprogram in PAB
0048               *  dsrlnk.savver  -  Version used in prev. DSR call
0049               *  dsrlnk.savlen  -  Length of DSR name of prev. DSR call (in MSB)
0050               *  dsrlnk.flgptr  -  Pointer to VDP PAB byte 1 (flag byte)
0051               
0052               *--------------------------------------------------------------
0053      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0054                                                   ; dstype is address of R5 of DSRLNK ws.
0055               ********|*****|*********************|**************************
0056 2AE4 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AE6 2AE8             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AE8 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AEA C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AEC A428 
0064 2AEE 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AF0 201C 
0065 2AF2 C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2AF4 8356 
0066 2AF6 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2AF8 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2AFA FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2AFC C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2AFE A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B00 06C0  14         swpb  r0                    ;
0075 2B02 D800  38         movb  r0,@vdpa              ; Send low byte
     2B04 8C02 
0076 2B06 06C0  14         swpb  r0                    ;
0077 2B08 D800  38         movb  r0,@vdpa              ; Send high byte
     2B0A 8C02 
0078 2B0C D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B0E 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B10 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B12 0704  14         seto  r4                    ; Init counter
0086 2B14 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B16 A420 
0087 2B18 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B1A 0584  14         inc   r4                    ; Increment char counter
0089 2B1C 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B1E 0007 
0090 2B20 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B22 80C4  18         c     r4,r3                 ; End of name?
0093 2B24 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B26 06C0  14         swpb  r0                    ;
0098 2B28 D800  38         movb  r0,@vdpa              ; Send low byte
     2B2A 8C02 
0099 2B2C 06C0  14         swpb  r0                    ;
0100 2B2E D800  38         movb  r0,@vdpa              ; Send high byte
     2B30 8C02 
0101 2B32 D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B34 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B36 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B38 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B3A 2C50 
0109 2B3C 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B3E C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B40 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B42 04E0  34         clr   @>83d0
     2B44 83D0 
0118 2B46 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B48 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B4A C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B4C A432 
0121               
0122 2B4E 0584  14         inc   r4                    ; Adjust for dot
0123 2B50 A804  38         a     r4,@>8356             ; Point to position after name
     2B52 8356 
0124 2B54 C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B56 8356 
     2B58 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B5A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B5C 83E0 
0130 2B5E 04C1  14         clr   r1                    ; Version found of dsr
0131 2B60 020C  20         li    r12,>0f00             ; Init cru address
     2B62 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B64 C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B66 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B68 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B6A 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B6C 0100 
0145 2B6E 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B70 83D0 
0146 2B72 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B74 2000 
0147 2B76 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B78 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B7A 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B7C 1D00  20         sbo   0                     ; Turn on ROM
0154 2B7E 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B80 4000 
0155 2B82 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B84 2C4C 
0156 2B86 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B88 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B8A A40A 
0166 2B8C 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B8E C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B90 83D2 
0172                                                   ; subprogram
0173               
0174 2B92 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2B94 C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2B96 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2B98 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2B9A 83D2 
0183                                                   ; subprogram
0184               
0185 2B9C 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2B9E C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BA0 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BA2 D160  34         movb  @>8355,r5             ; Get length as counter
     2BA4 8355 
0195 2BA6 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BA8 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BAA 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BAC 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BAE 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BB0 A420 
0206 2BB2 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BB4 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BB6 0605  14         dec   r5                    ; Update loop counter
0211 2BB8 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BBA 0581  14         inc   r1                    ; Next version found
0217 2BBC C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BBE A42A 
0218 2BC0 C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BC2 A42C 
0219 2BC4 C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BC6 A430 
0220               
0221 2BC8 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BCA 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BCC 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BCE 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BD0 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BD2 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BD4 A400 
0233 2BD6 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BD8 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BDA A428 
0239                                                   ; (8 or >a)
0240 2BDC 0281  22         ci    r1,8                  ; was it 8?
     2BDE 0008 
0241 2BE0 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BE2 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BE4 8350 
0243                                                   ; Get error byte from @>8350
0244 2BE6 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BE8 06C0  14         swpb  r0                    ;
0252 2BEA D800  38         movb  r0,@vdpa              ; send low byte
     2BEC 8C02 
0253 2BEE 06C0  14         swpb  r0                    ;
0254 2BF0 D800  38         movb  r0,@vdpa              ; send high byte
     2BF2 8C02 
0255 2BF4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2BF6 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2BF8 09D1  56         srl   r1,13                 ; just keep error bits
0263 2BFA 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2BFC 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2BFE 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C00 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C02 A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C04 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C06 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C08 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C0A F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C0C 201C 
0281                                                   ; / to indicate error
0282 2C0E 0380  18         rtwp                        ; Return from DSR workspace to caller
0283                                                   ; workspace
0284               
0285               
0286               ***************************************************************
0287               * dsrln.reuse - Reuse previous DSRLNK call for improved speed
0288               ***************************************************************
0289               *  blwp @dsrlnk.reuse
0290               *--------------------------------------------------------------
0291               *  Input:
0292               *  @>8356         = Pointer to VDP PAB file descriptor length byte (PAB+9)
0293               *  @dsrlnk.savcru = CRU address of device in previous DSR call
0294               *  @dsrlnk.savent = DSR entry address of previous DSR call
0295               *  @dsrlnk.savver = Version used in previous DSR call
0296               *  @dsrlnk.pabptr = Pointer to PAB in VDP memory, set in previous DSR call
0297               *--------------------------------------------------------------
0298               *  Output:
0299               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0300               *--------------------------------------------------------------
0301               *  Remarks:
0302               *   Call the same DSR entry again without having to scan through
0303               *   all devices again.
0304               *
0305               *   Expects dsrlnk.savver, @dsrlnk.savent, @dsrlnk.savcru to be
0306               *   set by previous DSRLNK call.
0307               ********|*****|*********************|**************************
0308               dsrlnk.reuse:
0309 2C10 A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C12 2C14             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C14 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C16 83E0 
0316               
0317 2C18 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C1A 201C 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C1C 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C1E A42A 
0322 2C20 C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C22 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C24 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C26 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C28 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C2A C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C2C 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C2E 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C30 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C32 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C34 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C36 4000 
     2C38 2C4C 
0337 2C3A 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C3C 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C3E 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C40 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C42 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C44 A400 
0355 2C46 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C48 A434 
0356               
0357 2C4A 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C4C AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C4E 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C50 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0367               
0368                       even
**** **** ****     > runlib.asm
0220                       copy  "fio_level3.asm"           ; File I/O level 3 support
**** **** ****     > fio_level3.asm
0001               * FILE......: fio_level3.asm
0002               * Purpose...: File I/O level 3 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0011               ;                                   ;         Bit 13-15 used by DSR for returning
0012               ;                                   ;         file error details to DSRLNK
0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
0015               ;       byte  0                     ;  5    - Character count (bytes read)
0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
0018               ; -------------------------------------------------------------
0019               ;       byte  11                    ;  9    - File descriptor length
0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
0021               ;       even
0022               ***************************************************************
0023               
0024               
0025               ***************************************************************
0026               * file.open - Open File for procesing
0027               ***************************************************************
0028               *  bl   @file.open
0029               *       data P0,P1
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *  P1 = LSB contains File type/mode
0033               *--------------------------------------------------------------
0034               *  bl   @xfile.open
0035               *
0036               *  R0 = Address of PAB in VDP RAM
0037               *  R1 = LSB contains File type/mode
0038               *--------------------------------------------------------------
0039               *  Output:
0040               *  tmp0     = Copy of VDP PAB byte 1 after operation
0041               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0042               *  tmp2 LSB = Copy of status register after operation
0043               ********|*****|*********************|**************************
0044               file.open:
0045 2C52 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C54 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C56 0649  14         dect  stack
0052 2C58 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C5A 0204  20         li    tmp0,dsrlnk.savcru
     2C5C A42A 
0057 2C5E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C60 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C62 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C64 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C66 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C68 37D7 
0065 2C6A C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C6C 8370 
0066                                                   ; / location
0067 2C6E C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C70 A44C 
0068 2C72 04C5  14         clr   tmp1                  ; io.op.open
0069 2C74 101F  14         jmp   _file.record.fop      ; Do file operation
0070               
0071               
0072               
0073               ***************************************************************
0074               * file.close - Close currently open file
0075               ***************************************************************
0076               *  bl   @file.close
0077               *       data P0
0078               *--------------------------------------------------------------
0079               *  P0 = Address of PAB in VDP RAM
0080               *--------------------------------------------------------------
0081               *  bl   @xfile.close
0082               *
0083               *  R0 = Address of PAB in VDP RAM
0084               *--------------------------------------------------------------
0085               *  Output:
0086               *  tmp0 LSB = Copy of VDP PAB byte 1 after operation
0087               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0088               *  tmp2 LSB = Copy of status register after operation
0089               ********|*****|*********************|**************************
0090               file.close:
0091 2C76 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C78 0649  14         dect  stack
0097 2C7A C64B  30         mov   r11,*stack            ; Save return address
0098 2C7C 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C7E 0001 
0099 2C80 1019  14         jmp   _file.record.fop      ; Do file operation
0100               
0101               
0102               ***************************************************************
0103               * file.record.read - Read record from file
0104               ***************************************************************
0105               *  bl   @file.record.read
0106               *       data P0
0107               *--------------------------------------------------------------
0108               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0109               *--------------------------------------------------------------
0110               *  bl   @xfile.record.read
0111               *
0112               *  R0 = Address of PAB in VDP RAM
0113               *--------------------------------------------------------------
0114               *  Output:
0115               *  tmp0     = Copy of VDP PAB byte 1 after operation
0116               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0117               *  tmp2 LSB = Copy of status register after operation
0118               ********|*****|*********************|**************************
0119               file.record.read:
0120 2C82 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C84 0649  14         dect  stack
0125 2C86 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C88 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C8A 0002 
0128 2C8C 1013  14         jmp   _file.record.fop      ; Do file operation
0129               
0130               
0131               
0132               ***************************************************************
0133               * file.record.write - Write record to file
0134               ***************************************************************
0135               *  bl   @file.record.write
0136               *       data P0
0137               *--------------------------------------------------------------
0138               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0139               *--------------------------------------------------------------
0140               *  bl   @xfile.record.write
0141               *
0142               *  R0 = Address of PAB in VDP RAM
0143               *--------------------------------------------------------------
0144               *  Output:
0145               *  tmp0     = Copy of VDP PAB byte 1 after operation
0146               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0147               *  tmp2 LSB = Copy of status register after operation
0148               ********|*****|*********************|**************************
0149               file.record.write:
0150 2C8E C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C90 0649  14         dect  stack
0155 2C92 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2C94 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2C96 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2C98 0005 
0159               
0160 2C9A C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2C9C A43E 
0161               
0162 2C9E 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CA0 22CE 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CA2 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CA4 0003 
0167 2CA6 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CA8 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CAA 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CAC 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CAE 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CB0 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CB2 1000  14         nop
0193               
0194               
0195               
0196               ***************************************************************
0197               * file.record.fop - File operation
0198               ***************************************************************
0199               * Called internally via JMP/B by file operations
0200               *--------------------------------------------------------------
0201               *  Input:
0202               *  r0   = Address of PAB in VDP RAM
0203               *  r1   = File type/mode
0204               *  tmp1 = File operation opcode
0205               *
0206               *  @fh.offsetopcode = >00  Data buffer in VDP RAM
0207               *  @fh.offsetopcode = >40  Data buffer in CPU RAM
0208               *--------------------------------------------------------------
0209               *  Output:
0210               *  tmp0     = Copy of VDP PAB byte 1 after operation
0211               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0212               *  tmp2 LSB = Copy of status register after operation
0213               *--------------------------------------------------------------
0214               *  Register usage:
0215               *  r0, r1, tmp0, tmp1, tmp2
0216               *--------------------------------------------------------------
0217               *  Remarks
0218               *  Private, only to be called from inside fio_level2 module
0219               *  via jump or branch instruction.
0220               *
0221               *  Uses @waux1 for backup/restore of memory word @>8322
0222               ********|*****|*********************|**************************
0223               _file.record.fop:
0224                       ;------------------------------------------------------
0225                       ; Write to PAB required?
0226                       ;------------------------------------------------------
0227 2CB4 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CB6 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CB8 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CBA A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CBC A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CBE 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CC0 22CE 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CC4 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CC6 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CC8 A44C 
0246               
0247 2CCA 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CCC 22CE 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CCE 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CD0 0009 
0254 2CD2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CD4 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CD6 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CD8 8322 
     2CDA 833C 
0259               
0260 2CDC C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CDE A42A 
0261 2CE0 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CE2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CE4 2AE4 
0268 2CE6 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CE8 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CEA 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CEC 2C10 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CEE 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CF0 C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2CF2 833C 
     2CF4 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2CF6 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2CF8 A436 
0292 2CFA 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2CFC 0005 
0293 2CFE 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D00 22E6 
0294 2D02 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D04 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0299                                                   ; as returned by DSRLNK
0300               *--------------------------------------------------------------
0301               * Exit
0302               *--------------------------------------------------------------
0303               ; If an error occured during the IO operation, then the
0304               ; equal bit in the saved status register (=tmp2) is set to 1.
0305               ;
0306               ; Upon return from this IO call you should basically test with:
0307               ;       coc   @wbit2,tmp2           ; Equal bit set?
0308               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0309               ;
0310               ; Then look for further details in the copy of VDP PAB byte 1
0311               ; in register tmp0, bits 13-15
0312               ;
0313               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0314               ;                                   ; calls, skip for type >A subprograms!)
0315               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0316               ;       jeq   my_error_handler
0317               *--------------------------------------------------------------
0318               _file.record.fop.exit:
0319 2D06 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D08 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0222               
0223               *//////////////////////////////////////////////////////////////
0224               *                            TIMERS
0225               *//////////////////////////////////////////////////////////////
0226               
0227                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
**** **** ****     > timers_tmgr.asm
0001               * FILE......: timers_tmgr.asm
0002               * Purpose...: Timers / Thread scheduler
0003               
0004               ***************************************************************
0005               * TMGR - X - Start Timers/Thread scheduler
0006               ***************************************************************
0007               *  B @TMGR
0008               *--------------------------------------------------------------
0009               *  REMARKS
0010               *  Timer/Thread scheduler. Normally called from MAIN.
0011               *  This is basically the kernel keeping everything together.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2D0A 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D0C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D0E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D10 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D12 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D14 201C 
0029 2D16 1602  14         jne   tmgr1a                ; No, so move on
0030 2D18 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D1A 2008 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D1C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D1E 2020 
0035 2D20 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D22 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D24 2010 
0048 2D26 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D28 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D2A 200E 
0050 2D2C 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D2E 0460  28         b     @kthread              ; Run kernel thread
     2D30 2DA8 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D32 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D34 2014 
0056 2D36 13EB  14         jeq   tmgr1
0057 2D38 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D3A 2012 
0058 2D3C 16E8  14         jne   tmgr1
0059 2D3E C120  34         mov   @wtiusr,tmp0
     2D40 832E 
0060 2D42 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D44 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D46 2DA6 
0065 2D48 C10A  18         mov   r10,tmp0
0066 2D4A 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D4C 00FF 
0067 2D4E 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D50 201C 
0068 2D52 1303  14         jeq   tmgr5
0069 2D54 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D56 003C 
0070 2D58 1002  14         jmp   tmgr6
0071 2D5A 0284  22 tmgr5   ci    tmp0,50
     2D5C 0032 
0072 2D5E 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D60 1001  14         jmp   tmgr8
0074 2D62 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D64 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D66 832C 
0079 2D68 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D6A FF00 
0080 2D6C C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D6E 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D70 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D72 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D74 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D76 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D78 830C 
     2D7A 830D 
0089 2D7C 1608  14         jne   tmgr10                ; No, get next slot
0090 2D7E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D80 FF00 
0091 2D82 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D84 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D86 8330 
0096 2D88 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D8A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D8C 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D8E 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D90 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D92 8315 
     2D94 8314 
0103 2D96 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2D98 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2D9A 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2D9C 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2D9E 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DA0 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DA2 FF00 
0109 2DA4 10B4  14         jmp   tmgr1
0110 2DA6 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0228                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
**** **** ****     > timers_kthread.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / The kernel thread
0003               
0004               
0005               ***************************************************************
0006               * KTHREAD - The kernel thread
0007               *--------------------------------------------------------------
0008               *  REMARKS
0009               *  You should not call the kernel thread manually.
0010               *  Instead control it via the CONFIG register.
0011               *
0012               *  The kernel thread is responsible for running the sound
0013               *  player and doing keyboard scan.
0014               ********|*****|*********************|**************************
0015 2DA8 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DAA 2010 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 2DAC 06A0  32         bl    @realkb               ; Scan full keyboard
     2DAE 27B0 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DB0 0460  28         b     @tmgr3                ; Exit
     2DB2 2D32 
**** **** ****     > runlib.asm
0229                       copy  "timers_hooks.asm"         ; Timers / User hooks
**** **** ****     > timers_hooks.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / User hooks
0003               
0004               
0005               ***************************************************************
0006               * MKHOOK - Allocate user hook
0007               ***************************************************************
0008               *  BL    @MKHOOK
0009               *  DATA  P0
0010               *--------------------------------------------------------------
0011               *  P0 = Address of user hook
0012               *--------------------------------------------------------------
0013               *  REMARKS
0014               *  The user hook gets executed after the kernel thread.
0015               *  The user hook must always exit with "B @HOOKOK"
0016               ********|*****|*********************|**************************
0017 2DB4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DB6 832E 
0018 2DB8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DBA 2012 
0019 2DBC 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D0E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DBE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DC0 832E 
0029 2DC2 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DC4 FEFF 
0030 2DC6 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0230               
0232                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
**** **** ****     > timers_alloc.asm
0001               * FILE......: timer_alloc.asm
0002               * Purpose...: Timers / Timer allocation
0003               
0004               
0005               ***************************************************************
0006               * MKSLOT - Allocate timer slot(s)
0007               ***************************************************************
0008               *  BL    @MKSLOT
0009               *  BYTE  P0HB,P0LB
0010               *  DATA  P1
0011               *  ....
0012               *  DATA  EOL                        ; End-of-list
0013               *--------------------------------------------------------------
0014               *  P0 = Slot number, target count
0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
0016               ********|*****|*********************|**************************
0017 2DC8 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DCA C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DCC C184  18         mov   tmp0,tmp2
0023 2DCE 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DD0 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DD2 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DD4 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DD6 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DD8 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DDA 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DDC 2022 
0035 2DDE 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DE0 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DE2 05CB  14 mkslo1  inct  r11
0041 2DE4 045B  20         b     *r11                  ; Exit
0042               
0043               
0044               ***************************************************************
0045               * CLSLOT - Clear single timer slot
0046               ***************************************************************
0047               *  BL    @CLSLOT
0048               *  DATA  P0
0049               *--------------------------------------------------------------
0050               *  P0 = Slot number
0051               ********|*****|*********************|**************************
0052 2DE6 C13B  30 clslot  mov   *r11+,tmp0
0053 2DE8 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DEA A120  34         a     @wtitab,tmp0          ; Add table base
     2DEC 832C 
0055 2DEE 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DF0 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DF2 045B  20         b     *r11                  ; Exit
0058               
0059               
0060               ***************************************************************
0061               * RSSLOT - Reset single timer slot loop counter
0062               ***************************************************************
0063               *  BL    @RSSLOT
0064               *  DATA  P0
0065               *--------------------------------------------------------------
0066               *  P0 = Slot number
0067               ********|*****|*********************|**************************
0068 2DF4 C13B  30 rsslot  mov   *r11+,tmp0
0069 2DF6 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2DF8 A120  34         a     @wtitab,tmp0          ; Add table base
     2DFA 832C 
0071 2DFC 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2DFE C154  26         mov   *tmp0,tmp1
0073 2E00 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E02 FF00 
0074 2E04 C505  30         mov   tmp1,*tmp0
0075 2E06 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0234               
0235               
0236               
0237               *//////////////////////////////////////////////////////////////
0238               *                    RUNLIB INITIALISATION
0239               *//////////////////////////////////////////////////////////////
0240               
0241               ***************************************************************
0242               *  RUNLIB - Runtime library initalisation
0243               ***************************************************************
0244               *  B  @RUNLIB
0245               *--------------------------------------------------------------
0246               *  REMARKS
0247               *  if R0 in WS1 equals >4a4a we were called from the system
0248               *  crash handler so we return there after initialisation.
0249               
0250               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0251               *  after clearing scratchpad memory. This has higher priority
0252               *  as crash handler flag R0.
0253               ********|*****|*********************|**************************
0260 2E08 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E0A 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E0C 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E0E 0000 
0266 2E10 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E12 8300 
0267 2E14 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E16 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E18 0202  20 runli2  li    r2,>8308
     2E1A 8308 
0272 2E1C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E1E 0282  22         ci    r2,>8400
     2E20 8400 
0274 2E22 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E24 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E26 FFFF 
0279 2E28 1602  14         jne   runli4                ; No, continue
0280 2E2A 0420  54         blwp  @0                    ; Yes, bye bye
     2E2C 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E2E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E30 833C 
0285 2E32 04C1  14         clr   r1                    ; Reset counter
0286 2E34 0202  20         li    r2,10                 ; We test 10 times
     2E36 000A 
0287 2E38 C0E0  34 runli5  mov   @vdps,r3
     2E3A 8802 
0288 2E3C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E3E 2020 
0289 2E40 1302  14         jeq   runli6
0290 2E42 0581  14         inc   r1                    ; Increase counter
0291 2E44 10F9  14         jmp   runli5
0292 2E46 0602  14 runli6  dec   r2                    ; Next test
0293 2E48 16F7  14         jne   runli5
0294 2E4A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E4C 1250 
0295 2E4E 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E50 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E52 201C 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E54 06A0  32 runli7  bl    @loadmc
     2E56 221C 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E58 04C1  14 runli9  clr   r1
0305 2E5A 04C2  14         clr   r2
0306 2E5C 04C3  14         clr   r3
0307 2E5E 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E60 3000 
0308 2E62 020F  20         li    r15,vdpw              ; Set VDP write address
     2E64 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E66 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E68 4A4A 
0317 2E6A 1605  14         jne   runlia
0318 2E6C 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E6E 2290 
0319 2E70 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E72 0000 
     2E74 3000 
0324 2E76 06A0  32 runlia  bl    @filv
     2E78 2290 
0325 2E7A 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E7C 00F4 
     2E7E 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E80 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E82 26F8 
0333 2E84 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E86 2712 
0334 2E88 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E8A 2708 
0335               
0336 2E8C 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E8E 2334 
0337 2E90 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E92 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E94 22FA 
0351 2E96 32D6             data  spvmod                ; Equate selected video mode table
0352 2E98 0204  20         li    tmp0,spfont           ; Get font option
     2E9A 000C 
0353 2E9C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2E9E 1304  14         jeq   runlid                ; Yes, skip it
0355 2EA0 06A0  32         bl    @ldfnt
     2EA2 2362 
0356 2EA4 1100             data  fntadr,spfont         ; Load specified font
     2EA6 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EA8 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EAA 4A4A 
0361 2EAC 1602  14         jne   runlie                ; No, continue
0362 2EAE 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EB0 2086 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EB2 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EB4 0040 
0367 2EB6 0460  28         b     @main                 ; Give control to main program
     2EB8 6036 
**** **** ****     > stevie_b2.asm.488847
0062                                                   ; Relocated spectra2 in low MEMEXP, was
0063                                                   ; copied to >2000 from ROM in bank 0
0064                       ;------------------------------------------------------
0065                       ; End of File marker
0066                       ;------------------------------------------------------
0067 2EBA DEAD             data >dead,>beef,>dead,>beef
     2EBC BEEF 
     2EBE DEAD 
     2EC0 BEEF 
0069               ***************************************************************
0070               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0071               ********|*****|*********************|**************************
0072                       aorg  >3000
0073                       ;------------------------------------------------------
0074                       ; Activate bank 1 and branch to >6036
0075                       ;------------------------------------------------------
0076 3000 04E0  34         clr   @bank1                ; Activate bank 1 "James"
     3002 6002 
0077 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0078                       ;------------------------------------------------------
0079                       ; Resident Stevie modules: >3000 - >3fff
0080                       ;------------------------------------------------------
0081                       copy  "mem.resident.3000.asm"
**** **** ****     > mem.resident.3000.asm
0001               * FILE......: mem.resident.3000.asm
0002               * Purpose...: Resident Stevie modules. Needs to be include in all banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Resident Stevie modules >3000 - >3fff
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"     ; ROM bankswitch trampoline
**** **** ****     > rom.farjump.asm
0001               * FILE......: rom.farjump.asm
0002               * Purpose...: Trampoline to routine in other ROM bank
0003               
0004               
0005               ***************************************************************
0006               * rom.farjump - Jump to routine in specified bank
0007               ***************************************************************
0008               *  bl   @rom.farjump
0009               *       DATA P0,P1
0010               *--------------------------------------------------------------
0011               *  P0 = Write address of target ROM bank
0012               *  P1 = Vector address with target address to jump to
0013               *  P2 = Write address of source ROM bank
0014               *--------------------------------------------------------------
0015               *  bl @xrom.farjump
0016               *
0017               *  TMP0 = Write address of target ROM bank
0018               *  TMP1 = Vector address with target address to jump to
0019               *  TMP2 = Write address of source ROM bank
0020               ********|*****|*********************|**************************
0021               rom.farjump:
0022 3008 C13B  30         mov   *r11+,tmp0            ; P0
0023 300A C17B  30         mov   *r11+,tmp1            ; P1
0024 300C C1BB  30         mov   *r11+,tmp2            ; P2
0025                       ;------------------------------------------------------
0026                       ; Push registers to value stack (but not r11!)
0027                       ;------------------------------------------------------
0028               xrom.farjump:
0029 300E 0649  14         dect  stack
0030 3010 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 3012 0649  14         dect  stack
0032 3014 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 3016 0649  14         dect  stack
0034 3018 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 301A 0649  14         dect  stack
0036 301C C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Push to farjump return stack
0039                       ;------------------------------------------------------
0040 301E 0284  22         ci    tmp0,>6002            ; Invalid bank write address?
     3020 6002 
0041 3022 110C  14         jlt   rom.farjump.bankswitch.failed1
0042                                                   ; Crash if null value in bank write address
0043               
0044 3024 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     3026 A022 
0045 3028 0647  14         dect  tmp3
0046 302A C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0047 302C 0647  14         dect  tmp3
0048 302E C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0049 3030 C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     3032 A022 
0050                       ;------------------------------------------------------
0051                       ; Bankswitch to target bank
0052                       ;------------------------------------------------------
0053               rom.farjump.bankswitch:
0054 3034 04D4  26         clr   *tmp0                 ; Switch to target ROM bank
0055 3036 C115  26         mov   *tmp1,tmp0            ; Deref value in vector address
0056 3038 1301  14         jeq   rom.farjump.bankswitch.failed1
0057                                                   ; Crash if null-pointer in vector
0058 303A 1004  14         jmp   rom.farjump.bankswitch.call
0059                                                   ; Call function in target bank
0060                       ;------------------------------------------------------
0061                       ; Sanity check 1 failed before bank-switch
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.failed1:
0064 303C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     303E FFCE 
0065 3040 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3042 2026 
0066                       ;------------------------------------------------------
0067                       ; Call function in target bank
0068                       ;------------------------------------------------------
0069               rom.farjump.bankswitch.call:
0070 3044 0694  24         bl    *tmp0                 ; Call function
0071                       ;------------------------------------------------------
0072                       ; Bankswitch back to source bank
0073                       ;------------------------------------------------------
0074               rom.farjump.return:
0075 3046 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     3048 A022 
0076 304A C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0077 304C 130D  14         jeq   rom.farjump.bankswitch.failed2
0078                                                   ; Crash if null-pointer in address
0079               
0080 304E 04F4  30         clr   *tmp0+                ; Remove bank write address from
0081                                                   ; farjump stack
0082               
0083 3050 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0084               
0085 3052 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0086                                                   ; farjump stack
0087               
0088 3054 028B  22         ci    r11,>6000
     3056 6000 
0089 3058 1107  14         jlt   rom.farjump.bankswitch.failed2
0090 305A 028B  22         ci    r11,>7fff
     305C 7FFF 
0091 305E 1504  14         jgt   rom.farjump.bankswitch.failed2
0092               
0093 3060 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     3062 A022 
0094 3064 04D5  26         clr   *tmp1                 ; Switch to bank of caller
0095 3066 1004  14         jmp   rom.farjump.exit
0096                       ;------------------------------------------------------
0097                       ; Sanity check 2 failed after bank-switch
0098                       ;------------------------------------------------------
0099               rom.farjump.bankswitch.failed2:
0100 3068 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     306A FFCE 
0101 306C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     306E 2026 
0102                       ;-------------------------------------------------------
0103                       ; Exit
0104                       ;-------------------------------------------------------
0105               rom.farjump.exit:
0106 3070 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0107 3072 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0108 3074 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0109 3076 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0110 3078 045B  20         b     *r11                  ; Return to caller
**** **** ****     > mem.resident.3000.asm
0008                       copy  "fb.asm"              ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: Stevie Editor - Framebuffer module
0003               
0004               ***************************************************************
0005               * fb.init
0006               * Initialize framebuffer
0007               ***************************************************************
0008               *  bl   @fb.init
0009               *--------------------------------------------------------------
0010               *  INPUT
0011               *  none
0012               *--------------------------------------------------------------
0013               *  OUTPUT
0014               *  none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               fb.init:
0020 307A 0649  14         dect  stack
0021 307C C64B  30         mov   r11,*stack            ; Save return address
0022                       ;------------------------------------------------------
0023                       ; Initialize
0024                       ;------------------------------------------------------
0025 307E 0204  20         li    tmp0,fb.top
     3080 A600 
0026 3082 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3084 A100 
0027 3086 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     3088 A104 
0028 308A 04E0  34         clr   @fb.row               ; Current row=0
     308C A106 
0029 308E 04E0  34         clr   @fb.column            ; Current column=0
     3090 A10C 
0030               
0031 3092 0204  20         li    tmp0,colrow
     3094 0050 
0032 3096 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     3098 A10E 
0033               
0034 309A 0204  20         li    tmp0,28
     309C 001C 
0035 309E C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 28
     30A0 A11A 
0036 30A2 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     30A4 A11C 
0037               
0038 30A6 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     30A8 A01E 
0039 30AA 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     30AC A110 
0040 30AE 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     30B0 A116 
0041 30B2 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     30B4 A118 
0042                       ;------------------------------------------------------
0043                       ; Clear frame buffer
0044                       ;------------------------------------------------------
0045 30B6 06A0  32         bl    @film
     30B8 2238 
0046 30BA A600             data  fb.top,>00,fb.size    ; Clear it all the way
     30BC 0000 
     30BE 0960 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               fb.init.exit:
0051 30C0 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 30C2 045B  20         b     *r11                  ; Return to caller
0053               
**** **** ****     > mem.resident.3000.asm
0009                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Index management
0003               
0004               ***************************************************************
0005               *  Size of index page is 4K and allows indexing of 2048 lines
0006               *  per page.
0007               *
0008               *  Each index slot (word) has the format:
0009               *    +-----+-----+
0010               *    | MSB | LSB |
0011               *    +-----|-----+   LSB = Pointer offset 00-ff.
0012               *
0013               *  MSB = SAMS Page 00-ff
0014               *        Allows addressing of up to 256 4K SAMS pages (1024 KB)
0015               *
0016               *  LSB = Pointer offset in range 00-ff
0017               *
0018               *        To calculate pointer to line in Editor buffer:
0019               *        Pointer address = edb.top + (LSB * 16)
0020               *
0021               *        Note that the editor buffer itself resides in own 4K memory range
0022               *        starting at edb.top
0023               *
0024               *        All support routines must assure that length-prefixed string in
0025               *        Editor buffer always start on a 16 byte boundary for being
0026               *        accessible via index.
0027               ***************************************************************
0028               
0029               
0030               ***************************************************************
0031               * idx.init
0032               * Initialize index
0033               ***************************************************************
0034               * bl @idx.init
0035               *--------------------------------------------------------------
0036               * INPUT
0037               * none
0038               *--------------------------------------------------------------
0039               * OUTPUT
0040               * none
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0
0044               ********|*****|*********************|**************************
0045               idx.init:
0046 30C4 0649  14         dect  stack
0047 30C6 C64B  30         mov   r11,*stack            ; Save return address
0048 30C8 0649  14         dect  stack
0049 30CA C644  30         mov   tmp0,*stack           ; Push tmp0
0050                       ;------------------------------------------------------
0051                       ; Initialize
0052                       ;------------------------------------------------------
0053 30CC 0204  20         li    tmp0,idx.top
     30CE B000 
0054 30D0 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30D2 A202 
0055               
0056 30D4 C120  34         mov   @tv.sams.b000,tmp0
     30D6 A006 
0057 30D8 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     30DA A500 
0058 30DC C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     30DE A502 
0059 30E0 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     30E2 A504 
0060                       ;------------------------------------------------------
0061                       ; Clear index page
0062                       ;------------------------------------------------------
0063 30E4 06A0  32         bl    @film
     30E6 2238 
0064 30E8 B000                   data idx.top,>00,idx.size
     30EA 0000 
     30EC 1000 
0065                                                   ; Clear index
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               idx.init.exit:
0070 30EE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0071 30F0 C2F9  30         mov   *stack+,r11           ; Pop r11
0072 30F2 045B  20         b     *r11                  ; Return to caller
0073               
0074               
0075               
0076               ***************************************************************
0077               * _idx.sams.mapcolumn.on
0078               * Flatten SAMS index pages into continuous memory region.
0079               * Gives 20 KB of index space (2048 * 5 = 10240 lines for each
0080               * editor buffer).
0081               *
0082               * >b000  1st index page
0083               * >c000  2nd index page
0084               * >d000  3rd index page
0085               * >e000  4th index page
0086               * >f000  5th index page
0087               ***************************************************************
0088               * bl @_idx.sams.mapcolumn.on
0089               *--------------------------------------------------------------
0090               * Register usage
0091               * tmp0, tmp1, tmp2
0092               *--------------------------------------------------------------
0093               *  Remarks
0094               *  Private, only to be called from inside idx module
0095               ********|*****|*********************|**************************
0096               _idx.sams.mapcolumn.on:
0097 30F4 0649  14         dect  stack
0098 30F6 C64B  30         mov   r11,*stack            ; Push return address
0099 30F8 0649  14         dect  stack
0100 30FA C644  30         mov   tmp0,*stack           ; Push tmp0
0101 30FC 0649  14         dect  stack
0102 30FE C645  30         mov   tmp1,*stack           ; Push tmp1
0103 3100 0649  14         dect  stack
0104 3102 C646  30         mov   tmp2,*stack           ; Push tmp2
0105               *--------------------------------------------------------------
0106               * Map index pages into memory window  (b000-ffff)
0107               *--------------------------------------------------------------
0108 3104 C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3106 A502 
0109 3108 0205  20         li    tmp1,idx.top
     310A B000 
0110               
0111 310C C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     310E A504 
0112 3110 0586  14         inc   tmp2                  ; +1 loop adjustment
0113 3112 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     3114 A502 
0114                       ;-------------------------------------------------------
0115                       ; Sanity check
0116                       ;-------------------------------------------------------
0117 3116 0286  22         ci    tmp2,5                ; Crash if too many index pages
     3118 0005 
0118 311A 1104  14         jlt   !
0119 311C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     311E FFCE 
0120 3120 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3122 2026 
0121                       ;-------------------------------------------------------
0122                       ; Loop over banks
0123                       ;-------------------------------------------------------
0124 3124 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3126 253C 
0125                                                   ; \ i  tmp0  = SAMS page number
0126                                                   ; / i  tmp1  = Memory address
0127               
0128 3128 0584  14         inc   tmp0                  ; Next SAMS index page
0129 312A 0225  22         ai    tmp1,>1000            ; Next memory region
     312C 1000 
0130 312E 0606  14         dec   tmp2                  ; Update loop counter
0131 3130 15F9  14         jgt   -!                    ; Next iteration
0132               *--------------------------------------------------------------
0133               * Exit
0134               *--------------------------------------------------------------
0135               _idx.sams.mapcolumn.on.exit:
0136 3132 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0137 3134 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0138 3136 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0139 3138 C2F9  30         mov   *stack+,r11           ; Pop return address
0140 313A 045B  20         b     *r11                  ; Return to caller
0141               
0142               
0143               ***************************************************************
0144               * _idx.sams.mapcolumn.off
0145               * Restore normal SAMS layout again (single index page)
0146               ***************************************************************
0147               * bl @_idx.sams.mapcolumn.off
0148               *--------------------------------------------------------------
0149               * Register usage
0150               * tmp0, tmp1, tmp2, tmp3
0151               *--------------------------------------------------------------
0152               *  Remarks
0153               *  Private, only to be called from inside idx module
0154               ********|*****|*********************|**************************
0155               _idx.sams.mapcolumn.off:
0156 313C 0649  14         dect  stack
0157 313E C64B  30         mov   r11,*stack            ; Push return address
0158 3140 0649  14         dect  stack
0159 3142 C644  30         mov   tmp0,*stack           ; Push tmp0
0160 3144 0649  14         dect  stack
0161 3146 C645  30         mov   tmp1,*stack           ; Push tmp1
0162 3148 0649  14         dect  stack
0163 314A C646  30         mov   tmp2,*stack           ; Push tmp2
0164 314C 0649  14         dect  stack
0165 314E C647  30         mov   tmp3,*stack           ; Push tmp3
0166               *--------------------------------------------------------------
0167               * Map index pages into memory window  (b000-?????)
0168               *--------------------------------------------------------------
0169 3150 0205  20         li    tmp1,idx.top
     3152 B000 
0170 3154 0206  20         li    tmp2,5                ; Always 5 pages
     3156 0005 
0171 3158 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     315A A006 
0172                       ;-------------------------------------------------------
0173                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0174                       ;-------------------------------------------------------
0175 315C C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0176               
0177 315E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3160 253C 
0178                                                   ; \ i  tmp0  = SAMS page number
0179                                                   ; / i  tmp1  = Memory address
0180               
0181 3162 0225  22         ai    tmp1,>1000            ; Next memory region
     3164 1000 
0182 3166 0606  14         dec   tmp2                  ; Update loop counter
0183 3168 15F9  14         jgt   -!                    ; Next iteration
0184               *--------------------------------------------------------------
0185               * Exit
0186               *--------------------------------------------------------------
0187               _idx.sams.mapcolumn.off.exit:
0188 316A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0189 316C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0190 316E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0191 3170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0192 3172 C2F9  30         mov   *stack+,r11           ; Pop return address
0193 3174 045B  20         b     *r11                  ; Return to caller
0194               
0195               
0196               
0197               ***************************************************************
0198               * _idx.samspage.get
0199               * Get SAMS page for index
0200               ***************************************************************
0201               * bl @_idx.samspage.get
0202               *--------------------------------------------------------------
0203               * INPUT
0204               * tmp0 = Line number
0205               *--------------------------------------------------------------
0206               * OUTPUT
0207               * @outparm1 = Offset for index entry in index SAMS page
0208               *--------------------------------------------------------------
0209               * Register usage
0210               * tmp0, tmp1, tmp2
0211               *--------------------------------------------------------------
0212               *  Remarks
0213               *  Private, only to be called from inside idx module.
0214               *  Activates SAMS page containing required index slot entry.
0215               ********|*****|*********************|**************************
0216               _idx.samspage.get:
0217 3176 0649  14         dect  stack
0218 3178 C64B  30         mov   r11,*stack            ; Save return address
0219 317A 0649  14         dect  stack
0220 317C C644  30         mov   tmp0,*stack           ; Push tmp0
0221 317E 0649  14         dect  stack
0222 3180 C645  30         mov   tmp1,*stack           ; Push tmp1
0223 3182 0649  14         dect  stack
0224 3184 C646  30         mov   tmp2,*stack           ; Push tmp2
0225                       ;------------------------------------------------------
0226                       ; Determine SAMS index page
0227                       ;------------------------------------------------------
0228 3186 C184  18         mov   tmp0,tmp2             ; Line number
0229 3188 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0230 318A 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     318C 0800 
0231               
0232 318E 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0233                                                   ; | tmp1 = quotient  (SAMS page offset)
0234                                                   ; / tmp2 = remainder
0235               
0236 3190 0A16  56         sla   tmp2,1                ; line number * 2
0237 3192 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3194 2F30 
0238               
0239 3196 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     3198 A502 
0240 319A 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     319C A500 
0241               
0242 319E 130E  14         jeq   _idx.samspage.get.exit
0243                                                   ; Yes, so exit
0244                       ;------------------------------------------------------
0245                       ; Activate SAMS index page
0246                       ;------------------------------------------------------
0247 31A0 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     31A2 A500 
0248 31A4 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     31A6 A006 
0249               
0250 31A8 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0251 31AA 0205  20         li    tmp1,>b000            ; Memory window for index page
     31AC B000 
0252               
0253 31AE 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31B0 253C 
0254                                                   ; \ i  tmp0 = SAMS page
0255                                                   ; / i  tmp1 = Memory address
0256                       ;------------------------------------------------------
0257                       ; Check if new highest SAMS index page
0258                       ;------------------------------------------------------
0259 31B2 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31B4 A504 
0260 31B6 1202  14         jle   _idx.samspage.get.exit
0261                                                   ; No, exit
0262 31B8 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31BA A504 
0263                       ;------------------------------------------------------
0264                       ; Exit
0265                       ;------------------------------------------------------
0266               _idx.samspage.get.exit:
0267 31BC C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0268 31BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0269 31C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0270 31C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0271 31C4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > mem.resident.3000.asm
0010                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: Stevie Editor - Editor Buffer module
0003               
0004               ***************************************************************
0005               * edb.init
0006               * Initialize Editor buffer
0007               ***************************************************************
0008               * bl @edb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               edb.init:
0022 31C6 0649  14         dect  stack
0023 31C8 C64B  30         mov   r11,*stack            ; Save return address
0024 31CA 0649  14         dect  stack
0025 31CC C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31CE 0204  20         li    tmp0,edb.top          ; \
     31D0 C000 
0030 31D2 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31D4 A200 
0031 31D6 C804  38         mov   tmp0,@edb.next_free.ptr
     31D8 A208 
0032                                                   ; Set pointer to next free line
0033               
0034 31DA 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31DC A20A 
0035               
0036 31DE 0204  20         li    tmp0,1
     31E0 0001 
0037 31E2 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31E4 A204 
0038               
0039 31E6 04E0  34         clr   @edb.block.m1         ; Reset block start line
     31E8 A20C 
0040 31EA 04E0  34         clr   @edb.block.m2         ; Reset block end line
     31EC A20E 
0041 31EE 04E0  34         clr   @edb.block.m3         ; Reset block target line
     31F0 A210 
0042               
0043 31F2 0204  20         li    tmp0,txt.newfile      ; "New file"
     31F4 35B8 
0044 31F6 C804  38         mov   tmp0,@edb.filename.ptr
     31F8 A212 
0045               
0046 31FA 0204  20         li    tmp0,txt.filetype.none
     31FC 3604 
0047 31FE C804  38         mov   tmp0,@edb.filetype.ptr
     3200 A214 
0048               
0049               edb.init.exit:
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053 3202 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0054 3204 C2F9  30         mov   *stack+,r11           ; Pop r11
0055 3206 045B  20         b     *r11                  ; Return to caller
0056               
0057               
0058               
0059               
**** **** ****     > mem.resident.3000.asm
0011                       copy  "cmdb.asm"            ; Command buffer
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer module
0003               
0004               ***************************************************************
0005               * cmdb.init
0006               * Initialize Command Buffer
0007               ***************************************************************
0008               * bl @cmdb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.init:
0022 3208 0649  14         dect  stack
0023 320A C64B  30         mov   r11,*stack            ; Save return address
0024 320C 0649  14         dect  stack
0025 320E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3210 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3212 D000 
0030 3214 C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3216 A300 
0031               
0032 3218 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     321A A302 
0033 321C 0204  20         li    tmp0,4
     321E 0004 
0034 3220 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3222 A306 
0035 3224 C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3226 A308 
0036               
0037 3228 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     322A A316 
0038 322C 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     322E A318 
0039 3230 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3232 A324 
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 3234 06A0  32         bl    @film
     3236 2238 
0044 3238 D000             data  cmdb.top,>00,cmdb.size
     323A 0000 
     323C 1000 
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 323E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3240 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3242 045B  20         b     *r11                  ; Return to caller
**** **** ****     > mem.resident.3000.asm
0012                       copy  "errline.asm"         ; Error line
**** **** ****     > errline.asm
0001               * FILE......: errline.asm
0002               * Purpose...: Stevie Editor - Error line utilities
0003               
0004               ***************************************************************
0005               * errline.init
0006               * Initialize error line
0007               ***************************************************************
0008               * bl @errline.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               errline.init:
0022 3244 0649  14         dect  stack
0023 3246 C64B  30         mov   r11,*stack            ; Save return address
0024 3248 0649  14         dect  stack
0025 324A C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 324C 04E0  34         clr   @tv.error.visible     ; Set to hidden
     324E A024 
0030               
0031 3250 06A0  32         bl    @film
     3252 2238 
0032 3254 A026                   data tv.error.msg,0,160
     3256 0000 
     3258 00A0 
0033               
0034 325A 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     325C A000 
0035 325E D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     3260 A026 
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039               errline.exit:
0040 3262 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0041 3264 C2F9  30         mov   *stack+,r11           ; Pop R11
0042 3266 045B  20         b     *r11                  ; Return to caller
0043               
**** **** ****     > mem.resident.3000.asm
0013                       copy  "tv.asm"              ; Main editor configuration
**** **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Stevie Editor - Main editor configuration
0003               
0004               ***************************************************************
0005               * tv.init
0006               * Initialize editor settings
0007               ***************************************************************
0008               * bl @tv.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               tv.init:
0022 3268 0649  14         dect  stack
0023 326A C64B  30         mov   r11,*stack            ; Save return address
0024 326C 0649  14         dect  stack
0025 326E C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3270 0204  20         li    tmp0,1                ; \ Set default color scheme
     3272 0001 
0030 3274 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3276 A012 
0031               
0032 3278 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     327A A020 
0033 327C E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     327E 200C 
0034               
0035 3280 0204  20         li    tmp0,fj.bottom
     3282 F000 
0036 3284 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3286 A022 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 3288 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 328A C2F9  30         mov   *stack+,r11           ; Pop R11
0043 328C 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               
0047               ***************************************************************
0048               * tv.reset
0049               * Reset editor (clear buffer)
0050               ***************************************************************
0051               * bl @tv.reset
0052               *--------------------------------------------------------------
0053               * INPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * OUTPUT
0057               * none
0058               *--------------------------------------------------------------
0059               * Register usage
0060               * r11
0061               *--------------------------------------------------------------
0062               * Notes
0063               ***************************************************************
0064               tv.reset:
0065 328E 0649  14         dect  stack
0066 3290 C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 3292 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     3294 3208 
0071 3296 06A0  32         bl    @edb.init             ; Initialize editor buffer
     3298 31C6 
0072 329A 06A0  32         bl    @idx.init             ; Initialize index
     329C 30C4 
0073 329E 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32A0 307A 
0074 32A2 06A0  32         bl    @errline.init         ; Initialize error line
     32A4 3244 
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               tv.reset.exit:
0079 32A6 C2F9  30         mov   *stack+,r11           ; Pop R11
0080 32A8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > mem.resident.3000.asm
0014                       copy  "tv.utils.asm"        ; General purpose utility functions
**** **** ****     > tv.utils.asm
0001               * FILE......: tv.utils.asm
0002               * Purpose...: General purpose utility functions
0003               
0004               ***************************************************************
0005               * tv.unpack.uint16
0006               * Unpack 16bit unsigned integer to string
0007               ***************************************************************
0008               * bl @tv.unpack.uint16
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = 16bit unsigned integer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @unpacked.string = Length-prefixed string with unpacked uint16
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ***************************************************************
0019               tv.unpack.uint16:
0020 32AA 0649  14         dect  stack
0021 32AC C64B  30         mov   r11,*stack            ; Save return address
0022 32AE 0649  14         dect  stack
0023 32B0 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32B2 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32B4 299A 
0028 32B6 2F20                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32B8 2F6A                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32BA 3020                   byte 48               ; | i p2H = Offset for ASCII digit 0
0031                             byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32BC 0204  20         li    tmp0,unpacked.string
     32BE 2F44 
0034 32C0 04F4  30         clr   *tmp0+                ; Clear string 01
0035 32C2 04F4  30         clr   *tmp0+                ; Clear string 23
0036 32C4 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 32C6 06A0  32         bl    @trimnum              ; Trim unsigned number string
     32C8 29F2 
0039 32CA 2F6A                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 32CC 2F44                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 32CE 0020                   data 32               ; | i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 32D0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 32D2 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 32D4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > mem.resident.3000.asm
0015                       copy  "data.constants.asm"  ; Data Constants
**** **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: Stevie Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               
0008               
0009               ***************************************************************
0010               * Textmode (80 columns, 30 rows) - F18A
0011               *--------------------------------------------------------------
0012               *
0013               * ; VDP#0 Control bits
0014               * ;      bit 6=0: M3 | Graphics 1 mode
0015               * ;      bit 7=0: Disable external VDP input
0016               * ; VDP#1 Control bits
0017               * ;      bit 0=1: 16K selection
0018               * ;      bit 1=1: Enable display
0019               * ;      bit 2=1: Enable VDP interrupt
0020               * ;      bit 3=1: M1 \ TEXT MODE
0021               * ;      bit 4=0: M2 /
0022               * ;      bit 5=0: reserved
0023               * ;      bit 6=0: 8x8 sprites
0024               * ;      bit 7=0: Sprite magnification (1x)
0025               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0026               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0027               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0028               * ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
0029               * ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
0030               * ; VDP#7 Set foreground/background color
0031               ***************************************************************
0032               stevie.tx8030:
0033 32D6 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     32D8 003F 
     32DA 0243 
     32DC 05F4 
     32DE 0050 
0034               
0035               romsat:
0036 32E0 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     32E2 0001 
0037               
0038               cursors:
0039 32E4 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     32E6 0000 
     32E8 0000 
     32EA 001C 
0040 32EC 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     32EE 1010 
     32F0 1010 
     32F2 1000 
0041 32F4 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     32F6 1C1C 
     32F8 1C1C 
     32FA 1C00 
0042               
0043               patterns:
0044 32FC 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     32FE 0000 
     3300 00FF 
     3302 0000 
0045 3304 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     3306 0000 
     3308 FF00 
     330A FF00 
0046               
0047               patterns.box:
0048 330C 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     330E 0000 
     3310 FF00 
     3312 FF00 
0049 3314 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     3316 0000 
     3318 FF80 
     331A BFA0 
0050 331C 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     331E 0000 
     3320 FC04 
     3322 F414 
0051 3324 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     3326 A0A0 
     3328 A0A0 
     332A A0A0 
0052 332C 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     332E 1414 
     3330 1414 
     3332 1414 
0053 3334 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     3336 A0A0 
     3338 BF80 
     333A FF00 
0054 333C 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     333E 1414 
     3340 F404 
     3342 FC00 
0055 3344 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     3346 C0C0 
     3348 C0C0 
     334A 0080 
0056 334C 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     334E 0F0F 
     3350 0F0F 
     3352 0000 
0057               
0058               
0059               patterns.cr:
0060 3354 6C48             data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
     3356 6C48 
     3358 4800 
     335A 7C00 
0061 335C 0024             data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow
     335E 64FC 
     3360 6020 
     3362 0000 
0062               
0063               
0064               alphalock:
0065 3364 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
     3366 00E0 
     3368 E0E0 
     336A E0E0 
0066 336C 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up
     336E E0E0 
     3370 E0E0 
     3372 0000 
0067               
0068               
0069               vertline:
0070 3374 1010             data  >1010,>1010,>1010,>1010 ; 16. Vertical line
     3376 1010 
     3378 1010 
     337A 1010 
0071               
0072               
0073               ***************************************************************
0074               * SAMS page layout table for Stevie (16 words)
0075               *--------------------------------------------------------------
0076               mem.sams.layout.data:
0077 337C 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     337E 0002 
0078 3380 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     3382 0003 
0079 3384 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     3386 000A 
0080               
0081 3388 B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     338A 0010 
0082                                                   ; \ The index can allocate
0083                                                   ; / pages >10 to >2f.
0084               
0085 338C C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     338E 0030 
0086                                                   ; \ Editor buffer can allocate
0087                                                   ; / pages >30 to >ff.
0088               
0089 3390 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     3392 000D 
0090 3394 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     3396 000E 
0091 3398 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     339A 000F 
0092               
0093               
0094               
0095               
0096               
0097               ***************************************************************
0098               * Stevie color schemes table
0099               *--------------------------------------------------------------
0100               * Word 1
0101               * A  MSB  high-nibble    Foreground color text line in frame buffer
0102               * B  MSB  low-nibble     Background color text line in frame buffer
0103               * C  LSB  high-nibble    Foreground color top/bottom line
0104               * D  LSB  low-nibble     Background color top/bottom line
0105               *
0106               * Word 2
0107               * E  MSB  high-nibble    Foreground color cmdb pane
0108               * F  MSB  low-nibble     Background color cmdb pane
0109               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0110               * H  LSB  low-nibble     Cursor foreground color frame buffer
0111               *
0112               * Word 3
0113               * I  MSB  high-nibble    Foreground color busy top/bottom line
0114               * J  MSB  low-nibble     Background color busy top/bottom line
0115               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0116               * L  LSB  low-nibble     Background color marked line in frame buffer
0117               *
0118               * Word 4
0119               * M  MSB  high-nibble    0
0120               * N  MSB  low-nibble     0
0121               * O  LSB  high-nibble    0
0122               * P  LSB  low-nibble     0
0123               *
0124               * Colors
0125               * 0  Transparant
0126               * 1  black
0127               * 2  Green
0128               * 3  Light Green
0129               * 4  Blue
0130               * 5  Light Blue
0131               * 6  Dark Red
0132               * 7  Cyan
0133               * 8  Red
0134               * 9  Light Red
0135               * A  Yellow
0136               * B  Light Yellow
0137               * C  Dark Green
0138               * D  Magenta
0139               * E  Grey
0140               * F  White
0141               *--------------------------------------------------------------
0142      0009     tv.colorscheme.entries   equ 9 ; Entries in table
0143               
0144               tv.colorscheme.table:
0145               ;                              ; #
0146               ;       ABCD  EFGH  IJKL  MNOP ; -
0147 339C F417      data  >f417,>f171,>1b1f,>0000 ; 1  White on blue with inversed cyan border
     339E F171 
     33A0 1B1F 
     33A2 0000 
0148 33A4 F41F      data  >f41f,>f011,>1a17,>0000 ; 2  White on blue with inversed white border
     33A6 F011 
     33A8 1A17 
     33AA 0000 
0149 33AC A11A      data  >a11a,>f0ff,>1f1a,>0000 ; 3  Dark yellow on black with inversed border
     33AE F0FF 
     33B0 1F1A 
     33B2 0000 
0150 33B4 2112      data  >2112,>f0ff,>1b12,>0000 ; 4  Dark green on black with inversed border
     33B6 F0FF 
     33B8 1B12 
     33BA 0000 
0151 33BC E11E      data  >e11e,>f00f,>1b1e,>0000 ; 5  Grey on black with inversed grey border
     33BE F00F 
     33C0 1B1E 
     33C2 0000 
0152 33C4 1771      data  >1771,>1006,>1b71,>0000 ; 6  Black on cyan with inversed black border
     33C6 1006 
     33C8 1B71 
     33CA 0000 
0153 33CC 1FF1      data  >1ff1,>1001,>1bf1,>0000 ; 7  Black on white with inversed black border
     33CE 1001 
     33D0 1BF1 
     33D2 0000 
0154 33D4 A1F0      data  >a1f0,>1a0f,>1b1a,>0000 ; 8  Dark yellow on black with white border
     33D6 1A0F 
     33D8 1B1A 
     33DA 0000 
0155 33DC 21F0      data  >21f0,>f20f,>1b12,>0000 ; 9  Dark green on black with white border
     33DE F20F 
     33E0 1B12 
     33E2 0000 
0156               
**** **** ****     > mem.resident.3000.asm
0016                       copy  "data.strings.asm"    ; Data segment - Strings
**** **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               ;--------------------------------------------------------------
0009               ; Strings for welcome pane
0010               ;--------------------------------------------------------------
0011               txt.about.program
0012 33E4 0C53             byte  12
0013 33E5 ....             text  'Stevie V0.1H'
0014                       even
0015               
0016               txt.about.purpose
0017 33F2 2350             byte  35
0018 33F3 ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.about.author
0022 3416 1D32             byte  29
0023 3417 ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.about.website
0027 3434 1B68             byte  27
0028 3435 ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.about.build
0032 3450 1442             byte  20
0033 3451 ....             text  'Build: 201220-488847'
0034                       even
0035               
0036               
0037               txt.about.msg1
0038 3466 2466             byte  36
0039 3467 ....             text  'fctn-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.about.msg2
0043 348C 2266             byte  34
0044 348D ....             text  'fctn-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.about.msg3
0048 34B0 1966             byte  25
0049 34B1 ....             text  'fctn-+        Quit Stevie'
0050                       even
0051               
0052               txt.about.msg4
0053 34CA 1C43             byte  28
0054 34CB ....             text  'CTRL-O (^O)   Open DV80 file'
0055                       even
0056               
0057               txt.about.msg5
0058 34E8 1C43             byte  28
0059 34E9 ....             text  'CTRL-S (^S)   Save DV80 file'
0060                       even
0061               
0062               txt.about.msg6
0063 3506 1A43             byte  26
0064 3507 ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 3522 380F     txt.about.msg7     byte    56,15
0069 3524 ....                        text    ' ALPHA LOCK up     '
0070                                  byte    14
0071 3538 ....                        text    ' ALPHA LOCK down   '
0072 354B ....                        text    '  * Text changed'
0073               
0074               
0075               ;--------------------------------------------------------------
0076               ; Strings for status line pane
0077               ;--------------------------------------------------------------
0078               txt.delim
0079                       byte  1
0080 355C ....             text  ','
0081                       even
0082               
0083               txt.marker
0084 355E 052A             byte  5
0085 355F ....             text  '*EOF*'
0086                       even
0087               
0088               txt.bottom
0089 3564 0520             byte  5
0090 3565 ....             text  '  BOT'
0091                       even
0092               
0093               txt.ovrwrite
0094 356A 034F             byte  3
0095 356B ....             text  'OVR'
0096                       even
0097               
0098               txt.insert
0099 356E 0349             byte  3
0100 356F ....             text  'INS'
0101                       even
0102               
0103               txt.star
0104 3572 012A             byte  1
0105 3573 ....             text  '*'
0106                       even
0107               
0108               txt.loading
0109 3574 0A4C             byte  10
0110 3575 ....             text  'Loading...'
0111                       even
0112               
0113               txt.saving
0114 3580 0A53             byte  10
0115 3581 ....             text  'Saving....'
0116                       even
0117               
0118               txt.deleting
0119 358C 1244             byte  18
0120 358D ....             text  'Deleting block....'
0121                       even
0122               
0123               txt.fastmode
0124 35A0 0846             byte  8
0125 35A1 ....             text  'Fastmode'
0126                       even
0127               
0128               txt.kb
0129 35AA 026B             byte  2
0130 35AB ....             text  'kb'
0131                       even
0132               
0133               txt.lines
0134 35AE 054C             byte  5
0135 35AF ....             text  'Lines'
0136                       even
0137               
0138               txt.bufnum
0139 35B4 0323             byte  3
0140 35B5 ....             text  '#1 '
0141                       even
0142               
0143               txt.newfile
0144 35B8 0A5B             byte  10
0145 35B9 ....             text  '[New file]'
0146                       even
0147               
0148               txt.filetype.dv80
0149 35C4 0444             byte  4
0150 35C5 ....             text  'DV80'
0151                       even
0152               
0153               txt.m1
0154 35CA 034D             byte  3
0155 35CB ....             text  'M1='
0156                       even
0157               
0158               txt.m2
0159 35CE 034D             byte  3
0160 35CF ....             text  'M2='
0161                       even
0162               
0163               
0164 35D2 2B5E     txt.keys.block     byte    43
0165 35D3 ....                        text    '^C=Copy  ^D=Del  ^M=Move  ^R=Reset  ^S=Save'
0166               
0167 35FE 010F     txt.alpha.up       data >010f
0168 3600 010E     txt.alpha.down     data >010e
0169 3602 0110     txt.vertline       data >0110
0170               
0171               txt.clear
0172 3604 0420             byte  4
0173 3605 ....             text  '    '
0174                       even
0175               
0176      3604     txt.filetype.none  equ txt.clear
0177               
0178               
0179               ;--------------------------------------------------------------
0180               ; Dialog Load DV 80 file
0181               ;--------------------------------------------------------------
0182               txt.head.load
0183 360A 0F4F             byte  15
0184 360B ....             text  'Open DV80 file '
0185                       even
0186               
0187               txt.hint.load
0188 361A 4D48             byte  77
0189 361B ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0190                       even
0191               
0192               txt.keys.load
0193 3668 3F46             byte  63
0194 3669 ....             text  'F9=Back    F3=Clear    F5=Fastmode    fctn-H=Home    fctn-L=End'
0195                       even
0196               
0197               txt.keys.load2
0198 36A8 3F46             byte  63
0199 36A9 ....             text  'F9=Back    F3=Clear   *F5=Fastmode    fctn-H=Home    fctn-L=End'
0200                       even
0201               
0202               
0203               ;--------------------------------------------------------------
0204               ; Dialog Save DV 80 file
0205               ;--------------------------------------------------------------
0206               txt.head.save
0207 36E8 0F53             byte  15
0208 36E9 ....             text  'Save DV80 file '
0209                       even
0210               
0211               txt.hint.save
0212 36F8 3F48             byte  63
0213 36F9 ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
0214                       even
0215               
0216               txt.keys.save
0217 3738 3046             byte  48
0218 3739 ....             text  'F9=Back    F3=Clear    fctn-H=Home    fctn-L=End'
0219                       even
0220               
0221               
0222               ;--------------------------------------------------------------
0223               ; Dialog "Unsaved changes"
0224               ;--------------------------------------------------------------
0225               txt.head.unsaved
0226 376A 1055             byte  16
0227 376B ....             text  'Unsaved changes '
0228                       even
0229               
0230               txt.info.unsaved
0231 377C 3259             byte  50
0232 377D ....             text  'You are about to lose changes to the current file!'
0233                       even
0234               
0235               txt.hint.unsaved
0236 37B0 3F48             byte  63
0237 37B1 ....             text  'HINT: Press F6 to proceed without saving or ENTER to save file.'
0238                       even
0239               
0240               txt.keys.unsaved
0241 37F0 2846             byte  40
0242 37F1 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0243                       even
0244               
0245               
0246               ;--------------------------------------------------------------
0247               ; Dialog "About"
0248               ;--------------------------------------------------------------
0249               txt.head.about
0250 381A 0D41             byte  13
0251 381B ....             text  'About Stevie '
0252                       even
0253               
0254               txt.hint.about
0255 3828 2C48             byte  44
0256 3829 ....             text  'HINT: Press F9 or ENTER to return to editor.'
0257                       even
0258               
0259               txt.keys.about
0260 3856 1546             byte  21
0261 3857 ....             text  'F9=Back    ENTER=Back'
0262                       even
0263               
0264               
0265               ;--------------------------------------------------------------
0266               ; Strings for error line pane
0267               ;--------------------------------------------------------------
0268               txt.ioerr.load
0269 386C 2049             byte  32
0270 386D ....             text  'I/O error. Failed loading file: '
0271                       even
0272               
0273               txt.ioerr.save
0274 388E 1F49             byte  31
0275 388F ....             text  'I/O error. Failed saving file: '
0276                       even
0277               
0278               txt.io.nofile
0279 38AE 2149             byte  33
0280 38AF ....             text  'I/O error. No filename specified.'
0281                       even
0282               
0283               
0284               
0285               ;--------------------------------------------------------------
0286               ; Strings for command buffer
0287               ;--------------------------------------------------------------
0288               txt.cmdb.title
0289 38D0 0E43             byte  14
0290 38D1 ....             text  'Command buffer'
0291                       even
0292               
0293               txt.cmdb.prompt
0294 38E0 013E             byte  1
0295 38E1 ....             text  '>'
0296                       even
0297               
0298               
0299 38E2 0C0A     txt.stevie         byte    12
0300                                  byte    10
0301 38E4 ....                        text    'stevie V0.1H'
0302 38F0 0B00                        byte    11
0303                                  even
0304               
0305               txt.colorscheme
0306 38F2 0C43             byte  12
0307 38F3 ....             text  'Colorscheme:'
0308                       even
0309               
**** **** ****     > mem.resident.3000.asm
0017                       copy  "data.keymap.asm"     ; Data segment - Keyboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard mapping)
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      BC00     key.fctn.0    equ >bc00             ; fctn + 0
0008      0300     key.fctn.1    equ >0300             ; fctn + 1
0009      0400     key.fctn.2    equ >0400             ; fctn + 2
0010      0700     key.fctn.3    equ >0700             ; fctn + 3
0011      0200     key.fctn.4    equ >0200             ; fctn + 4
0012      0E00     key.fctn.5    equ >0e00             ; fctn + 5
0013      0C00     key.fctn.6    equ >0c00             ; fctn + 6
0014      0100     key.fctn.7    equ >0100             ; fctn + 7
0015      0600     key.fctn.8    equ >0600             ; fctn + 8
0016      0F00     key.fctn.9    equ >0f00             ; fctn + 9
0017      0000     key.fctn.a    equ >0000             ; fctn + a
0018      BE00     key.fctn.b    equ >be00             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      BF00     key.fctn.h    equ >bf00             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      C000     key.fctn.j    equ >c000             ; fctn + j
0027      C100     key.fctn.k    equ >c100             ; fctn + k
0028      C200     key.fctn.l    equ >c200             ; fctn + l
0029      C300     key.fctn.m    equ >c300             ; fctn + m
0030      C400     key.fctn.n    equ >c400             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      C500     key.fctn.q    equ >c500             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      7F00     key.fctn.v    equ >7f00             ; fctn + v
0039      7E00     key.fctn.w    equ >7e00             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      C600     key.fctn.y    equ >c600             ; fctn + y
0042      0000     key.fctn.z    equ >0000             ; fctn + z
0043               *---------------------------------------------------------------
0044               * Keyboard scancodes - Function keys extra
0045               *---------------------------------------------------------------
0046      B900     key.fctn.dot    equ >b900           ; fctn + .
0047      B800     key.fctn.comma  equ >b800           ; fctn + ,
0048      0500     key.fctn.plus   equ >0500           ; fctn + +
0049               *---------------------------------------------------------------
0050               * Keyboard scancodes - control keys
0051               *-------------|---------------------|---------------------------
0052      B000     key.ctrl.0    equ >b000             ; ctrl + 0
0053      B100     key.ctrl.1    equ >b100             ; ctrl + 1
0054      B200     key.ctrl.2    equ >b200             ; ctrl + 2
0055      B300     key.ctrl.3    equ >b300             ; ctrl + 3
0056      B400     key.ctrl.4    equ >b400             ; ctrl + 4
0057      B500     key.ctrl.5    equ >b500             ; ctrl + 5
0058      B600     key.ctrl.6    equ >b600             ; ctrl + 6
0059      B700     key.ctrl.7    equ >b700             ; ctrl + 7
0060      9E00     key.ctrl.8    equ >9e00             ; ctrl + 8
0061      9F00     key.ctrl.9    equ >9f00             ; ctrl + 9
0062      8100     key.ctrl.a    equ >8100             ; ctrl + a
0063      8200     key.ctrl.b    equ >8200             ; ctrl + b
0064      8300     key.ctrl.c    equ >8300             ; ctrl + c
0065      8400     key.ctrl.d    equ >8400             ; ctrl + d
0066      8500     key.ctrl.e    equ >8500             ; ctrl + e
0067      8600     key.ctrl.f    equ >8600             ; ctrl + f
0068      8700     key.ctrl.g    equ >8700             ; ctrl + g
0069      8800     key.ctrl.h    equ >8800             ; ctrl + h
0070      8900     key.ctrl.i    equ >8900             ; ctrl + i
0071      8A00     key.ctrl.j    equ >8a00             ; ctrl + j
0072      8B00     key.ctrl.k    equ >8b00             ; ctrl + k
0073      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0074      8D00     key.ctrl.m    equ >8d00             ; ctrl + m
0075      8E00     key.ctrl.n    equ >8e00             ; ctrl + n
0076      8F00     key.ctrl.o    equ >8f00             ; ctrl + o
0077      9000     key.ctrl.p    equ >9000             ; ctrl + p
0078      9100     key.ctrl.q    equ >9100             ; ctrl + q
0079      9200     key.ctrl.r    equ >9200             ; ctrl + r
0080      9300     key.ctrl.s    equ >9300             ; ctrl + s
0081      9400     key.ctrl.t    equ >9400             ; ctrl + t
0082      9500     key.ctrl.u    equ >9500             ; ctrl + u
0083      9600     key.ctrl.v    equ >9600             ; ctrl + v
0084      9700     key.ctrl.w    equ >9700             ; ctrl + w
0085      9800     key.ctrl.x    equ >9800             ; ctrl + x
0086      9900     key.ctrl.y    equ >9900             ; ctrl + y
0087      9A00     key.ctrl.z    equ >9a00             ; ctrl + z
0088               *---------------------------------------------------------------
0089               * Keyboard scancodes - control keys extra
0090               *---------------------------------------------------------------
0091      9B00     key.ctrl.dot    equ >9b00           ; ctrl + .
0092      8000     key.ctrl.comma  equ >8000           ; ctrl + ,
0093      9D00     key.ctrl.plus   equ >9d00           ; ctrl + +
0094               *---------------------------------------------------------------
0095               * Special keys
0096               *---------------------------------------------------------------
0097      0D00     key.enter     equ >0d00             ; enter
0098               
0099               
0100               
0101               *---------------------------------------------------------------
0102               * Keyboard labels - Function keys
0103               *---------------------------------------------------------------
0104               txt.fctn.0
0105 3900 0866             byte  8
0106 3901 ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 390A 0866             byte  8
0111 390B ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 3914 0866             byte  8
0116 3915 ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 391E 0866             byte  8
0121 391F ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 3928 0866             byte  8
0126 3929 ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 3932 0866             byte  8
0131 3933 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 393C 0866             byte  8
0136 393D ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 3946 0866             byte  8
0141 3947 ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 3950 0866             byte  8
0146 3951 ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 395A 0866             byte  8
0151 395B ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 3964 0866             byte  8
0156 3965 ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 396E 0866             byte  8
0161 396F ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 3978 0866             byte  8
0166 3979 ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 3982 0866             byte  8
0171 3983 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 398C 0866             byte  8
0176 398D ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 3996 0866             byte  8
0181 3997 ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 39A0 0866             byte  8
0186 39A1 ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 39AA 0866             byte  8
0191 39AB ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 39B4 0866             byte  8
0196 39B5 ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 39BE 0866             byte  8
0201 39BF ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 39C8 0866             byte  8
0206 39C9 ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 39D2 0866             byte  8
0211 39D3 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 39DC 0866             byte  8
0216 39DD ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 39E6 0866             byte  8
0221 39E7 ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 39F0 0866             byte  8
0226 39F1 ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 39FA 0866             byte  8
0231 39FB ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 3A04 0866             byte  8
0236 3A05 ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 3A0E 0866             byte  8
0241 3A0F ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 3A18 0866             byte  8
0246 3A19 ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 3A22 0866             byte  8
0251 3A23 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 3A2C 0866             byte  8
0256 3A2D ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 3A36 0866             byte  8
0261 3A37 ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 3A40 0866             byte  8
0266 3A41 ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 3A4A 0866             byte  8
0271 3A4B ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 3A54 0866             byte  8
0276 3A55 ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 3A5E 0866             byte  8
0281 3A5F ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 3A68 0866             byte  8
0289 3A69 ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 3A72 0866             byte  8
0294 3A73 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 3A7C 0863             byte  8
0300 3A7D ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 3A86 0863             byte  8
0305 3A87 ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 3A90 0863             byte  8
0313 3A91 ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 3A9A 0863             byte  8
0318 3A9B ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 3AA4 0863             byte  8
0323 3AA5 ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 3AAE 0863             byte  8
0328 3AAF ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 3AB8 0863             byte  8
0333 3AB9 ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 3AC2 0863             byte  8
0338 3AC3 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 3ACC 0863             byte  8
0343 3ACD ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 3AD6 0863             byte  8
0348 3AD7 ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 3AE0 0863             byte  8
0353 3AE1 ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 3AEA 0863             byte  8
0358 3AEB ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 3AF4 0863             byte  8
0363 3AF5 ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 3AFE 0863             byte  8
0368 3AFF ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 3B08 0863             byte  8
0373 3B09 ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 3B12 0863             byte  8
0378 3B13 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 3B1C 0863             byte  8
0383 3B1D ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 3B26 0863             byte  8
0388 3B27 ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 3B30 0863             byte  8
0393 3B31 ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 3B3A 0863             byte  8
0398 3B3B ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 3B44 0863             byte  8
0403 3B45 ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 3B4E 0863             byte  8
0408 3B4F ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 3B58 0863             byte  8
0413 3B59 ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 3B62 0863             byte  8
0418 3B63 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 3B6C 0863             byte  8
0423 3B6D ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 3B76 0863             byte  8
0428 3B77 ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 3B80 0863             byte  8
0433 3B81 ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 3B8A 0863             byte  8
0438 3B8B ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 3B94 0863             byte  8
0443 3B95 ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 3B9E 0863             byte  8
0448 3B9F ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 3BA8 0863             byte  8
0453 3BA9 ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 3BB2 0863             byte  8
0458 3BB3 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 3BBC 0863             byte  8
0463 3BBD ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 3BC6 0863             byte  8
0468 3BC7 ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 3BD0 0863             byte  8
0473 3BD1 ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 3BDA 0863             byte  8
0478 3BDB ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 3BE4 0863             byte  8
0483 3BE5 ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 3BEE 0863             byte  8
0488 3BEF ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 3BF8 0863             byte  8
0496 3BF9 ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 3C02 0565             byte  5
0504 3C03 ....             text  'enter'
0505                       even
0506               
**** **** ****     > mem.resident.3000.asm
0018                       ;------------------------------------------------------
0019                       ; End of File marker
0020                       ;------------------------------------------------------
0021 3C08 DEAD             data  >dead,>beef,>dead,>beef
     3C0A BEEF 
     3C0C DEAD 
     3C0E BEEF 
**** **** ****     > stevie_b2.asm.488847
0082               ***************************************************************
0083               * Step 4: Include modules
0084               ********|*****|*********************|**************************
0085               main:
0086                       aorg  kickstart.code2       ; >6036
0087 6036 06A0  32         bl    @cpu.crash            ; Should never get here
     6038 2026 
0088                       ;-----------------------------------------------------------------------
0089                       ; Include files - Utility functions
0090                       ;-----------------------------------------------------------------------
0091                       copy  "mem.asm"             ; SAMS Memory Management
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: Stevie Editor - Memory management (SAMS)
0003               
0004               ***************************************************************
0005               * mem.sams.layout
0006               * Setup SAMS memory pages for Stevie
0007               ***************************************************************
0008               * bl  @mem.sams.layout
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ***************************************************************
0016               mem.sams.layout:
0017 603A 0649  14         dect  stack
0018 603C C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 603E 06A0  32         bl    @sams.layout
     6040 25A8 
0023 6042 337C                   data mem.sams.layout.data
0024               
0025 6044 06A0  32         bl    @sams.layout.copy
     6046 260C 
0026 6048 A000                   data tv.sams.2000     ; Get SAMS windows
0027               
0028 604A C820  54         mov   @tv.sams.c000,@edb.sams.page
     604C A008 
     604E A216 
0029 6050 C820  54         mov   @edb.sams.page,@edb.sams.hipage
     6052 A216 
     6054 A218 
0030                                                   ; Track editor buffer SAMS page
0031                       ;------------------------------------------------------
0032                       ; Exit
0033                       ;------------------------------------------------------
0034               mem.sams.layout.exit:
0035 6056 C2F9  30         mov   *stack+,r11           ; Pop r11
0036 6058 045B  20         b     *r11                  ; Return to caller
0037               
0038               
0039               
0040               ***************************************************************
0041               * mem.edb.sams.mappage
0042               * Activate editor buffer SAMS page for line
0043               ***************************************************************
0044               * bl  @mem.edb.sams.mappage
0045               *     data p0
0046               *--------------------------------------------------------------
0047               * p0 = Line number in editor buffer
0048               *--------------------------------------------------------------
0049               * bl  @xmem.edb.sams.mappage
0050               *
0051               * tmp0 = Line number in editor buffer
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * outparm1 = Pointer to line in editor buffer
0055               * outparm2 = SAMS page
0056               *--------------------------------------------------------------
0057               * Register usage
0058               * tmp0, tmp1
0059               ***************************************************************
0060               mem.edb.sams.mappage:
0061 605A C13B  30         mov   *r11+,tmp0            ; Get p0
0062               xmem.edb.sams.mappage:
0063 605C 0649  14         dect  stack
0064 605E C64B  30         mov   r11,*stack            ; Push return address
0065 6060 0649  14         dect  stack
0066 6062 C644  30         mov   tmp0,*stack           ; Push tmp0
0067 6064 0649  14         dect  stack
0068 6066 C645  30         mov   tmp1,*stack           ; Push tmp1
0069                       ;------------------------------------------------------
0070                       ; Sanity check
0071                       ;------------------------------------------------------
0072 6068 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     606A A204 
0073 606C 1204  14         jle   mem.edb.sams.mappage.lookup
0074                                                   ; All checks passed, continue
0075                                                   ;--------------------------
0076                                                   ; Sanity check failed
0077                                                   ;--------------------------
0078 606E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6070 FFCE 
0079 6072 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6074 2026 
0080                       ;------------------------------------------------------
0081                       ; Lookup SAMS page for line in parm1
0082                       ;------------------------------------------------------
0083               mem.edb.sams.mappage.lookup:
0084 6076 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6078 66F8 
0085                                                   ; \ i  parm1    = Line number
0086                                                   ; | o  outparm1 = Pointer to line
0087                                                   ; / o  outparm2 = SAMS page
0088               
0089 607A C120  34         mov   @outparm2,tmp0        ; SAMS page
     607C 2F32 
0090 607E C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6080 2F30 
0091 6082 130B  14         jeq   mem.edb.sams.mappage.exit
0092                                                   ; Nothing to page-in if NULL pointer
0093                                                   ; (=empty line)
0094                       ;------------------------------------------------------
0095                       ; Determine if requested SAMS page is already active
0096                       ;------------------------------------------------------
0097 6084 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     6086 A008 
0098 6088 1308  14         jeq   mem.edb.sams.mappage.exit
0099                                                   ; Request page already active. Exit.
0100                       ;------------------------------------------------------
0101                       ; Activate requested SAMS page
0102                       ;-----------------------------------------------------
0103 608A 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     608C 253C 
0104                                                   ; \ i  tmp0 = SAMS page
0105                                                   ; / i  tmp1 = Memory address
0106               
0107 608E C820  54         mov   @outparm2,@tv.sams.c000
     6090 2F32 
     6092 A008 
0108                                                   ; Set page in shadow registers
0109               
0110 6094 C820  54         mov   @outparm2,@edb.sams.page
     6096 2F32 
     6098 A216 
0111                                                   ; Set current SAMS page
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 609A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 609C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 609E C2F9  30         mov   *stack+,r11           ; Pop r11
0119 60A0 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b2.asm.488847
0092                       copy  "colors.line.set.asm" ; Set color combination for line
**** **** ****     > colors.line.set.asm
0001               * FILE......: colors.line.set
0002               * Purpose...: Set color combination for line
0003               
0004               ***************************************************************
0005               * colors.line.set
0006               * Set color combination for line in VDP TAT
0007               ***************************************************************
0008               * bl  @colors.line.set
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Foreground / Background color
0012               * @parm2 = Row on physical screen
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               colors.line.set:
0021 60A2 0649  14         dect  stack
0022 60A4 C64B  30         mov   r11,*stack            ; Save return address
0023 60A6 0649  14         dect  stack
0024 60A8 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 60AA 0649  14         dect  stack
0026 60AC C645  30         mov   tmp1,*stack           ; Push tmp1
0027 60AE 0649  14         dect  stack
0028 60B0 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 60B2 0649  14         dect  stack
0030 60B4 C660  46         mov   @parm1,*stack         ; Push parm1
     60B6 2F20 
0031 60B8 0649  14         dect  stack
0032 60BA C660  46         mov   @parm2,*stack         ; Push parm2
     60BC 2F22 
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 60BE C120  34         mov   @parm2,tmp0           ; Get target line
     60C0 2F22 
0037 60C2 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     60C4 0050 
0038 60C6 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 60C8 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 60CA 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     60CC 1800 
0042 60CE C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     60D0 2F20 
0043 60D2 0206  20         li    tmp2,80               ; Number of bytes to fill
     60D4 0050 
0044               
0045 60D6 06A0  32         bl    @xfilv                ; Fill colors
     60D8 2296 
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 60DA C839  50         mov   *stack+,@parm2        ; Pop @parm2
     60DC 2F22 
0054 60DE C839  50         mov   *stack+,@parm1        ; Pop @parm1
     60E0 2F20 
0055 60E2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 60E4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 60E6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 60E8 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 60EA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.488847
0093                       ;-----------------------------------------------------------------------
0094                       ; Include files
0095                       ;-----------------------------------------------------------------------
0096                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
**** **** ****     > fh.read.edb.asm
0001               * FILE......: fh.read.edb.asm
0002               * Purpose...: File reader module
0003               
0004               ***************************************************************
0005               * fh.file.read.edb
0006               * Read file into editor buffer
0007               ***************************************************************
0008               *  bl   @fh.file.read.edb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1 = Pointer to length-prefixed file descriptor
0012               * parm2 = Pointer to callback function "Before Open file"
0013               * parm3 = Pointer to callback function "Read line from file"
0014               * parm4 = Pointer to callback function "Close file"
0015               * parm5 = Pointer to callback function "File I/O error"
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               *--------------------------------------------------------------
0019               * Register usage
0020               * tmp0, tmp1, tmp2
0021               ********|*****|*********************|**************************
0022               fh.file.read.edb:
0023 60EC 0649  14         dect  stack
0024 60EE C64B  30         mov   r11,*stack            ; Save return address
0025 60F0 0649  14         dect  stack
0026 60F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 60F4 0649  14         dect  stack
0028 60F6 C645  30         mov   tmp1,*stack           ; Push tmp1
0029 60F8 0649  14         dect  stack
0030 60FA C646  30         mov   tmp2,*stack           ; Push tmp2
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 60FC 04E0  34         clr   @fh.records           ; Reset records counter
     60FE A43C 
0035 6100 04E0  34         clr   @fh.counter           ; Clear internal counter
     6102 A442 
0036 6104 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6106 A440 
0037 6108 04E0  34         clr   @fh.kilobytes.prev    ; /
     610A A458 
0038 610C 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     610E A438 
0039 6110 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6112 A43A 
0040               
0041 6114 C120  34         mov   @edb.top.ptr,tmp0
     6116 A200 
0042 6118 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     611A 2504 
0043                                                   ; \ i  tmp0  = Memory address
0044                                                   ; | o  waux1 = SAMS page number
0045                                                   ; / o  waux2 = Address of SAMS register
0046               
0047 611C C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     611E 833C 
     6120 A446 
0048 6122 C820  54         mov   @waux1,@fh.sams.hipage
     6124 833C 
     6126 A448 
0049                                                   ; Set highest SAMS page in use
0050                       ;------------------------------------------------------
0051                       ; Save parameters / callback functions
0052                       ;------------------------------------------------------
0053 6128 0204  20         li    tmp0,fh.fopmode.readfile
     612A 0001 
0054                                                   ; We are going to read a file
0055 612C C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     612E A44A 
0056               
0057 6130 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6132 2F20 
     6134 A444 
0058 6136 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6138 2F22 
     613A A450 
0059 613C C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     613E 2F24 
     6140 A452 
0060 6142 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6144 2F26 
     6146 A454 
0061 6148 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     614A 2F28 
     614C A456 
0062                       ;------------------------------------------------------
0063                       ; Sanity checks
0064                       ;------------------------------------------------------
0065 614E C120  34         mov   @fh.callback1,tmp0
     6150 A450 
0066 6152 0284  22         ci    tmp0,>6000            ; Insane address ?
     6154 6000 
0067 6156 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0068               
0069 6158 0284  22         ci    tmp0,>7fff            ; Insane address ?
     615A 7FFF 
0070 615C 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0071               
0072 615E C120  34         mov   @fh.callback2,tmp0
     6160 A452 
0073 6162 0284  22         ci    tmp0,>6000            ; Insane address ?
     6164 6000 
0074 6166 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0075               
0076 6168 0284  22         ci    tmp0,>7fff            ; Insane address ?
     616A 7FFF 
0077 616C 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0078               
0079 616E C120  34         mov   @fh.callback3,tmp0
     6170 A454 
0080 6172 0284  22         ci    tmp0,>6000            ; Insane address ?
     6174 6000 
0081 6176 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0082               
0083 6178 0284  22         ci    tmp0,>7fff            ; Insane address ?
     617A 7FFF 
0084 617C 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0085               
0086 617E 1004  14         jmp   fh.file.read.edb.load1
0087                                                   ; All checks passed, continue
0088                       ;------------------------------------------------------
0089                       ; Check failed, crash CPU!
0090                       ;------------------------------------------------------
0091               fh.file.read.crash:
0092 6180 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6182 FFCE 
0093 6184 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6186 2026 
0094                       ;------------------------------------------------------
0095                       ; Callback "Before Open file"
0096                       ;------------------------------------------------------
0097               fh.file.read.edb.load1:
0098 6188 C120  34         mov   @fh.callback1,tmp0
     618A A450 
0099 618C 0694  24         bl    *tmp0                 ; Run callback function
0100                       ;------------------------------------------------------
0101                       ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103               fh.file.read.edb.pabheader:
0104 618E 06A0  32         bl    @cpym2v
     6190 244C 
0105 6192 0A60                   data fh.vpab,fh.file.pab.header,9
     6194 6314 
     6196 0009 
0106                                                   ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108                       ; Append file descriptor to PAB header in VDP
0109                       ;------------------------------------------------------
0110 6198 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     619A 0A69 
0111 619C C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     619E A444 
0112 61A0 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0113 61A2 0986  56         srl   tmp2,8                ; Right justify
0114 61A4 0586  14         inc   tmp2                  ; Include length byte as well
0115               
0116 61A6 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     61A8 2452 
0117                                                   ; \ i  tmp0 = VDP destination
0118                                                   ; | i  tmp1 = CPU source
0119                                                   ; / i  tmp2 = Number of bytes to copy
0120                       ;------------------------------------------------------
0121                       ; Open file
0122                       ;------------------------------------------------------
0123 61AA 06A0  32         bl    @file.open            ; Open file
     61AC 2C52 
0124 61AE 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0125 61B0 0014                   data io.seq.inp.dis.var
0126                                                   ; / i  p1 = File type/mode
0127               
0128 61B2 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     61B4 201C 
0129 61B6 1602  14         jne   fh.file.read.edb.check_setpage
0130               
0131 61B8 0460  28         b     @fh.file.read.edb.error
     61BA 62C8 
0132                                                   ; Yes, IO error occured
0133                       ;------------------------------------------------------
0134                       ; 1a: Check if SAMS page needs to be increased
0135                       ;------------------------------------------------------
0136               fh.file.read.edb.check_setpage:
0137 61BC C120  34         mov   @edb.next_free.ptr,tmp0
     61BE A208 
0138                                                   ;--------------------------
0139                                                   ; Sanity check
0140                                                   ;--------------------------
0141 61C0 0284  22         ci    tmp0,edb.top + edb.size
     61C2 D000 
0142                                                   ; Insane address ?
0143 61C4 15DD  14         jgt   fh.file.read.crash    ; Yes, crash!
0144                                                   ;--------------------------
0145                                                   ; Check for page overflow
0146                                                   ;--------------------------
0147 61C6 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     61C8 0FFF 
0148 61CA 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     61CC 0052 
0149 61CE 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     61D0 0FF0 
0150 61D2 110E  14         jlt   fh.file.read.edb.record
0151                                                   ; Not yet so skip SAMS page switch
0152                       ;------------------------------------------------------
0153                       ; 1b: Increase SAMS page
0154                       ;------------------------------------------------------
0155 61D4 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     61D6 A446 
0156 61D8 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     61DA A446 
     61DC A448 
0157                                                   ; Set highest SAMS page
0158 61DE C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     61E0 A200 
     61E2 A208 
0159                                                   ; Start at top of SAMS page again
0160                       ;------------------------------------------------------
0161                       ; 1c: Switch to SAMS page
0162                       ;------------------------------------------------------
0163 61E4 C120  34         mov   @fh.sams.page,tmp0
     61E6 A446 
0164 61E8 C160  34         mov   @edb.top.ptr,tmp1
     61EA A200 
0165 61EC 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     61EE 253C 
0166                                                   ; \ i  tmp0 = SAMS page number
0167                                                   ; / i  tmp1 = Memory address
0168                       ;------------------------------------------------------
0169                       ; 1d: Fill new SAMS page with garbage (debug only)
0170                       ;------------------------------------------------------
0171                       ; bl  @film
0172                       ;     data >c000,>99,4092
0173                       ;------------------------------------------------------
0174                       ; Step 2: Read file record
0175                       ;------------------------------------------------------
0176               fh.file.read.edb.record:
0177 61F0 05A0  34         inc   @fh.records           ; Update counter
     61F2 A43C 
0178 61F4 04E0  34         clr   @fh.reclen            ; Reset record length
     61F6 A43E 
0179               
0180 61F8 0760  38         abs   @fh.offsetopcode
     61FA A44E 
0181 61FC 1310  14         jeq   !                     ; Skip CPU buffer logic if offset = 0
0182                       ;------------------------------------------------------
0183                       ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
0184                       ;------------------------------------------------------
0185 61FE C160  34         mov   @edb.next_free.ptr,tmp1
     6200 A208 
0186 6202 05C5  14         inct  tmp1
0187 6204 0204  20         li    tmp0,fh.vpab + 2
     6206 0A62 
0188               
0189 6208 0264  22         ori   tmp0,>4000            ; Prepare VDP address for write
     620A 4000 
0190 620C 06C4  14         swpb  tmp0                  ; \
0191 620E D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     6210 8C02 
0192 6212 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0193 6214 D804  38         movb  tmp0,@vdpa            ; /
     6216 8C02 
0194               
0195 6218 D7C5  30         movb  tmp1,*r15             ; Write MSB
0196 621A 06C5  14         swpb  tmp1
0197 621C D7C5  30         movb  tmp1,*r15             ; Write LSB
0198                       ;------------------------------------------------------
0199                       ; 2b: Read file record
0200                       ;------------------------------------------------------
0201 621E 06A0  32 !       bl    @file.record.read     ; Read file record
     6220 2C82 
0202 6222 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0203                                                   ; |           (without +9 offset!)
0204                                                   ; | o  tmp0 = Status byte
0205                                                   ; | o  tmp1 = Bytes read
0206                                                   ; | o  tmp2 = Status register contents
0207                                                   ; /           upon DSRLNK return
0208               
0209 6224 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     6226 A438 
0210 6228 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     622A A43E 
0211 622C C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     622E A43A 
0212                       ;------------------------------------------------------
0213                       ; 2c: Calculate kilobytes processed
0214                       ;------------------------------------------------------
0215 6230 A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     6232 A442 
0216 6234 C160  34         mov   @fh.counter,tmp1      ;
     6236 A442 
0217 6238 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     623A 0400 
0218 623C 1106  14         jlt   fh.file.read.edb.check_fioerr
0219                                                   ; Not yet, goto (2d)
0220 623E 05A0  34         inc   @fh.kilobytes
     6240 A440 
0221 6242 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     6244 FC00 
0222 6246 C805  38         mov   tmp1,@fh.counter      ; Update counter
     6248 A442 
0223                       ;------------------------------------------------------
0224                       ; 2d: Check if a file error occured
0225                       ;------------------------------------------------------
0226               fh.file.read.edb.check_fioerr:
0227 624A C1A0  34         mov   @fh.ioresult,tmp2
     624C A43A 
0228 624E 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6250 201C 
0229 6252 1602  14         jne   fh.file.read.edb.process_line
0230                                                   ; No, goto (3)
0231 6254 0460  28         b     @fh.file.read.edb.error
     6256 62C8 
0232                                                   ; Yes, so handle file error
0233                       ;------------------------------------------------------
0234                       ; Step 3: Process line
0235                       ;------------------------------------------------------
0236               fh.file.read.edb.process_line:
0237 6258 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     625A 0960 
0238 625C C160  34         mov   @edb.next_free.ptr,tmp1
     625E A208 
0239                                                   ; RAM target in editor buffer
0240               
0241 6260 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     6262 2F22 
0242               
0243 6264 C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     6266 A43E 
0244 6268 131D  14         jeq   fh.file.read.edb.prepindex.emptyline
0245                                                   ; Handle empty line
0246                       ;------------------------------------------------------
0247                       ; 3a: Set length of line in CPU editor buffer
0248                       ;------------------------------------------------------
0249 626A 04D5  26         clr   *tmp1                 ; Clear word before string
0250 626C 0585  14         inc   tmp1                  ; Adjust position for length byte string
0251 626E DD60  48         movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
     6270 A43F 
0252               
0253 6272 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     6274 A208 
0254 6276 A806  38         a     tmp2,@edb.next_free.ptr
     6278 A208 
0255                                                   ; Add line length
0256               
0257 627A 0760  38         abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
     627C A44E 
0258 627E 1602  14         jne   fh.file.read.edb.preppointer
0259                       ;------------------------------------------------------
0260                       ; 3b: Copy line from VDP to CPU editor buffer
0261                       ;------------------------------------------------------
0262               fh.file.read.edb.vdp2cpu:
0263                       ;
0264                       ; Executed for devices that need their disk buffer in VDP memory
0265                       ; (TI Disk Controller, tipi, nanopeb, ...).
0266                       ;
0267 6280 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     6282 2484 
0268                                                   ; \ i  tmp0 = VDP source address
0269                                                   ; | i  tmp1 = RAM target address
0270                                                   ; / i  tmp2 = Bytes to copy
0271                       ;------------------------------------------------------
0272                       ; 3c: Align pointer for next line
0273                       ;------------------------------------------------------
0274               fh.file.read.edb.preppointer:
0275 6284 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6286 A208 
0276 6288 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0277 628A 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     628C 000F 
0278 628E A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6290 A208 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Update index
0281                       ;------------------------------------------------------
0282               fh.file.read.edb.prepindex:
0283 6292 C820  54         mov   @edb.lines,@parm1     ; \ parm1 = Line number - 1
     6294 A204 
     6296 2F20 
0284 6298 0620  34         dec   @parm1                ; /
     629A 2F20 
0285               
0286                                                   ; parm2 = Must allready be set!
0287 629C C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     629E A446 
     62A0 2F24 
0288               
0289 62A2 1009  14         jmp   fh.file.read.edb.updindex
0290                                                   ; Update index
0291                       ;------------------------------------------------------
0292                       ; 4a: Special handling for empty line
0293                       ;------------------------------------------------------
0294               fh.file.read.edb.prepindex.emptyline:
0295 62A4 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     62A6 A43C 
     62A8 2F20 
0296 62AA 0620  34         dec   @parm1                ;         Adjust for base 0 index
     62AC 2F20 
0297 62AE 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     62B0 2F22 
0298 62B2 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     62B4 2F24 
0299                       ;------------------------------------------------------
0300                       ; 4b: Do actual index update
0301                       ;------------------------------------------------------
0302               fh.file.read.edb.updindex:
0303 62B6 06A0  32         bl    @idx.entry.update     ; Update index
     62B8 66E6 
0304                                                   ; \ i  parm1    = Line num in editor buffer
0305                                                   ; | i  parm2    = Pointer to line in editor
0306                                                   ; |               buffer
0307                                                   ; | i  parm3    = SAMS page
0308                                                   ; | o  outparm1 = Pointer to updated index
0309                                                   ; /               entry
0310               
0311 62BA 05A0  34         inc   @edb.lines            ; lines=lines+1
     62BC A204 
0312                       ;------------------------------------------------------
0313                       ; Step 5: Callback "Read line from file"
0314                       ;------------------------------------------------------
0315               fh.file.read.edb.display:
0316 62BE C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     62C0 A452 
0317 62C2 0694  24         bl    *tmp0                 ; Run callback function
0318                       ;------------------------------------------------------
0319                       ; 5a: Next record
0320                       ;------------------------------------------------------
0321               fh.file.read.edb.next:
0322 62C4 0460  28         b     @fh.file.read.edb.check_setpage
     62C6 61BC 
0323                                                   ; Next record
0324                       ;------------------------------------------------------
0325                       ; Error handler
0326                       ;------------------------------------------------------
0327               fh.file.read.edb.error:
0328 62C8 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     62CA A438 
0329 62CC 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0330 62CE 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     62D0 0005 
0331 62D2 1309  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0332                       ;------------------------------------------------------
0333                       ; File error occured
0334                       ;------------------------------------------------------
0335 62D4 06A0  32         bl    @file.close           ; Close file
     62D6 2C76 
0336 62D8 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0337               
0338 62DA 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     62DC 603A 
0339                       ;------------------------------------------------------
0340                       ; Callback "File I/O error"
0341                       ;------------------------------------------------------
0342 62DE C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     62E0 A456 
0343 62E2 0694  24         bl    *tmp0                 ; Run callback function
0344 62E4 100D  14         jmp   fh.file.read.edb.exit
0345                       ;------------------------------------------------------
0346                       ; End-Of-File reached
0347                       ;------------------------------------------------------
0348               fh.file.read.edb.eof:
0349 62E6 06A0  32         bl    @file.close           ; Close file
     62E8 2C76 
0350 62EA 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0351               
0352 62EC 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     62EE 603A 
0353                       ;------------------------------------------------------
0354                       ; Callback "Close file"
0355                       ;------------------------------------------------------
0356 62F0 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     62F2 A454 
0357 62F4 0694  24         bl    *tmp0                 ; Run callback function
0358               
0359 62F6 C120  34         mov   @edb.lines,tmp0       ; Get number of lines
     62F8 A204 
0360 62FA 1302  14         jeq   fh.file.read.edb.exit ; Exit if lines = 0
0361 62FC 0620  34         dec   @edb.lines            ; One-time adjustment
     62FE A204 
0362               *--------------------------------------------------------------
0363               * Exit
0364               *--------------------------------------------------------------
0365               fh.file.read.edb.exit:
0366 6300 C820  54         mov   @fh.sams.hipage,@edb.sams.hipage
     6302 A448 
     6304 A218 
0367                                                   ; Set highest SAMS page in use
0368 6306 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     6308 A44A 
0369               
0370 630A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0371 630C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0372 630E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0373 6310 C2F9  30         mov   *stack+,r11           ; Pop R11
0374 6312 045B  20         b     *r11                  ; Return to caller
0375               
0376               
0377               ***************************************************************
0378               * PAB for accessing DV/80 file
0379               ********|*****|*********************|**************************
0380               fh.file.pab.header:
0381 6314 0014             byte  io.op.open            ;  0    - OPEN
0382                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0383 6316 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0384 6318 5000             byte  80                    ;  4    - Record length (80 chars max)
0385                       byte  00                    ;  5    - Character count
0386 631A 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0387 631C 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0388                       ;------------------------------------------------------
0389                       ; File descriptor part (variable length)
0390                       ;------------------------------------------------------
0391                       ; byte  12                  ;  9    - File descriptor length
0392                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0393                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b2.asm.488847
0097                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
**** **** ****     > fh.write.edb.asm
0001               * FILE......: fh.write.edb.asm
0002               * Purpose...: File write module
0003               
0004               ***************************************************************
0005               * fh.file.write.edb
0006               * Write editor buffer to file
0007               ***************************************************************
0008               *  bl   @fh.file.write.edb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1 = Pointer to length-prefixed file descriptor
0012               * parm2 = Pointer to callback function "Before Open file"
0013               * parm3 = Pointer to callback function "Write line to file"
0014               * parm4 = Pointer to callback function "Close file"
0015               * parm5 = Pointer to callback function "File I/O error"
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               *--------------------------------------------------------------
0019               * Register usage
0020               * tmp0, tmp1, tmp2
0021               ********|*****|*********************|**************************
0022               fh.file.write.edb:
0023 631E 0649  14         dect  stack
0024 6320 C64B  30         mov   r11,*stack            ; Save return address
0025 6322 0649  14         dect  stack
0026 6324 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 6326 0649  14         dect  stack
0028 6328 C645  30         mov   tmp1,*stack           ; Push tmp1
0029 632A 0649  14         dect  stack
0030 632C C646  30         mov   tmp2,*stack           ; Push tmp2
0031                       ;------------------------------------------------------
0032                       ; Initialisation
0033                       ;------------------------------------------------------
0034 632E 04E0  34         clr   @fh.records           ; Reset records counter
     6330 A43C 
0035 6332 04E0  34         clr   @fh.counter           ; Clear internal counter
     6334 A442 
0036 6336 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6338 A440 
0037 633A 04E0  34         clr   @fh.kilobytes.prev    ; /
     633C A458 
0038 633E 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6340 A438 
0039 6342 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6344 A43A 
0040                       ;------------------------------------------------------
0041                       ; Save parameters / callback functions
0042                       ;------------------------------------------------------
0043 6346 0204  20         li    tmp0,fh.fopmode.writefile
     6348 0002 
0044                                                   ; We are going to write to a file
0045 634A C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     634C A44A 
0046               
0047 634E C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6350 2F20 
     6352 A444 
0048 6354 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6356 2F22 
     6358 A450 
0049 635A C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     635C 2F24 
     635E A452 
0050 6360 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6362 2F26 
     6364 A454 
0051 6366 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6368 2F28 
     636A A456 
0052                       ;------------------------------------------------------
0053                       ; Sanity check
0054                       ;------------------------------------------------------
0055 636C C120  34         mov   @fh.callback1,tmp0
     636E A450 
0056 6370 0284  22         ci    tmp0,>6000            ; Insane address ?
     6372 6000 
0057 6374 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0058               
0059 6376 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6378 7FFF 
0060 637A 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0061               
0062 637C C120  34         mov   @fh.callback2,tmp0
     637E A452 
0063 6380 0284  22         ci    tmp0,>6000            ; Insane address ?
     6382 6000 
0064 6384 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0065               
0066 6386 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6388 7FFF 
0067 638A 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0068               
0069 638C C120  34         mov   @fh.callback3,tmp0
     638E A454 
0070 6390 0284  22         ci    tmp0,>6000            ; Insane address ?
     6392 6000 
0071 6394 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0072               
0073 6396 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6398 7FFF 
0074 639A 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0075               
0076 639C 1004  14         jmp   fh.file.write.edb.save1
0077                                                   ; All checks passed, continue.
0078                       ;------------------------------------------------------
0079                       ; Check failed, crash CPU!
0080                       ;------------------------------------------------------
0081               fh.file.write.crash:
0082 639E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     63A0 FFCE 
0083 63A2 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     63A4 2026 
0084                       ;------------------------------------------------------
0085                       ; Callback "Before Open file"
0086                       ;------------------------------------------------------
0087               fh.file.write.edb.save1:
0088 63A6 C120  34         mov   @fh.callback1,tmp0
     63A8 A450 
0089 63AA 0694  24         bl    *tmp0                 ; Run callback function
0090                       ;------------------------------------------------------
0091                       ; Copy PAB header to VDP
0092                       ;------------------------------------------------------
0093               fh.file.write.edb.pabheader:
0094 63AC 06A0  32         bl    @cpym2v
     63AE 244C 
0095 63B0 0A60                   data fh.vpab,fh.file.pab.header,9
     63B2 6314 
     63B4 0009 
0096                                                   ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098                       ; Append file descriptor to PAB header in VDP
0099                       ;------------------------------------------------------
0100 63B6 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     63B8 0A69 
0101 63BA C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     63BC A444 
0102 63BE D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0103 63C0 0986  56         srl   tmp2,8                ; Right justify
0104 63C2 0586  14         inc   tmp2                  ; Include length byte as well
0105               
0106 63C4 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     63C6 2452 
0107                                                   ; \ i  tmp0 = VDP destination
0108                                                   ; | i  tmp1 = CPU source
0109                                                   ; / i  tmp2 = Number of bytes to copy
0110                       ;------------------------------------------------------
0111                       ; Open file
0112                       ;------------------------------------------------------
0113 63C8 06A0  32         bl    @file.open            ; Open file
     63CA 2C52 
0114 63CC 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0115 63CE 0012                   data io.seq.out.dis.var
0116                                                   ; / i  p1 = File type/mode
0117               
0118 63D0 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     63D2 201C 
0119 63D4 1338  14         jeq   fh.file.write.edb.error
0120                                                   ; Yes, IO error occured
0121                       ;------------------------------------------------------
0122                       ; Step 1: Write file record
0123                       ;------------------------------------------------------
0124               fh.file.write.edb.record:
0125 63D6 8820  54         c     @fh.records,@edb.lines
     63D8 A43C 
     63DA A204 
0126 63DC 133E  14         jeq   fh.file.write.edb.done
0127                                                   ; Exit when all records processed
0128                       ;------------------------------------------------------
0129                       ; 1a: Unpack current line to framebuffer
0130                       ;------------------------------------------------------
0131 63DE C820  54         mov   @fh.records,@parm1    ; Line to unpack
     63E0 A43C 
     63E2 2F20 
0132 63E4 04E0  34         clr   @parm2                ; 1st row in frame buffer
     63E6 2F22 
0133               
0134 63E8 06A0  32         bl    @edb.line.unpack      ; Unpack line
     63EA 670A 
0135                                                   ; \ i  parm1    = Line to unpack
0136                                                   ; | i  parm2    = Target row in frame buffer
0137                                                   ; / o  outparm1 = Length of line
0138                       ;------------------------------------------------------
0139                       ; 1b: Copy unpacked line to VDP memory
0140                       ;------------------------------------------------------
0141 63EC 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     63EE 0960 
0142 63F0 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     63F2 A600 
0143               
0144 63F4 C1A0  34         mov   @outparm1,tmp2        ; Length of line
     63F6 2F30 
0145 63F8 C806  38         mov   tmp2,@fh.reclen       ; Set record length
     63FA A43E 
0146 63FC 1302  14         jeq   !                     ; Skip VDP copy if empty line
0147               
0148 63FE 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     6400 2452 
0149                                                   ; \ i  tmp0 = VDP target address
0150                                                   ; | i  tmp1 = CPU source address
0151                                                   ; / i  tmp2 = Number of bytes to copy
0152                       ;------------------------------------------------------
0153                       ; 1c: Write file record
0154                       ;------------------------------------------------------
0155 6402 06A0  32 !       bl    @file.record.write    ; Write file record
     6404 2C8E 
0156 6406 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0157                                                   ; |           (without +9 offset!)
0158                                                   ; | o  tmp0 = Status byte
0159                                                   ; | o  tmp1 = ?????
0160                                                   ; | o  tmp2 = Status register contents
0161                                                   ; /           upon DSRLNK return
0162               
0163 6408 C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     640A A438 
0164 640C C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     640E A43A 
0165                       ;------------------------------------------------------
0166                       ; 1d: Calculate kilobytes processed
0167                       ;------------------------------------------------------
0168 6410 A820  54         a     @fh.reclen,@fh.counter
     6412 A43E 
     6414 A442 
0169                                                   ; Add record length to counter
0170 6416 C160  34         mov   @fh.counter,tmp1      ;
     6418 A442 
0171 641A 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     641C 0400 
0172 641E 1106  14         jlt   fh.file.write.edb.check_fioerr
0173                                                   ; Not yet, goto (1e)
0174 6420 05A0  34         inc   @fh.kilobytes
     6422 A440 
0175 6424 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     6426 FC00 
0176 6428 C805  38         mov   tmp1,@fh.counter      ; Update counter
     642A A442 
0177                       ;------------------------------------------------------
0178                       ; 1e: Check if a file error occured
0179                       ;------------------------------------------------------
0180               fh.file.write.edb.check_fioerr:
0181 642C C1A0  34         mov   @fh.ioresult,tmp2
     642E A43A 
0182 6430 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     6432 201C 
0183 6434 1602  14         jne   fh.file.write.edb.display
0184                                                   ; No, goto (2)
0185 6436 0460  28         b     @fh.file.write.edb.error
     6438 6446 
0186                                                   ; Yes, so handle file error
0187                       ;------------------------------------------------------
0188                       ; Step 2: Callback "Write line to  file"
0189                       ;------------------------------------------------------
0190               fh.file.write.edb.display:
0191 643A C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     643C A452 
0192 643E 0694  24         bl    *tmp0                 ; Run callback function
0193                       ;------------------------------------------------------
0194                       ; Step 3: Next record
0195                       ;------------------------------------------------------
0196 6440 05A0  34         inc   @fh.records           ; Update counter
     6442 A43C 
0197 6444 10C8  14         jmp   fh.file.write.edb.record
0198                       ;------------------------------------------------------
0199                       ; Error handler
0200                       ;------------------------------------------------------
0201               fh.file.write.edb.error:
0202 6446 C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     6448 A438 
0203 644A 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0204                       ;------------------------------------------------------
0205                       ; File error occured
0206                       ;------------------------------------------------------
0207 644C 06A0  32         bl    @file.close           ; Close file
     644E 2C76 
0208 6450 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0209                       ;------------------------------------------------------
0210                       ; Callback "File I/O error"
0211                       ;------------------------------------------------------
0212 6452 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     6454 A456 
0213 6456 0694  24         bl    *tmp0                 ; Run callback function
0214 6458 1006  14         jmp   fh.file.write.edb.exit
0215                       ;------------------------------------------------------
0216                       ; All records written. Close file
0217                       ;------------------------------------------------------
0218               fh.file.write.edb.done:
0219 645A 06A0  32         bl    @file.close           ; Close file
     645C 2C76 
0220 645E 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0221                       ;------------------------------------------------------
0222                       ; Callback "Close file"
0223                       ;------------------------------------------------------
0224 6460 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     6462 A454 
0225 6464 0694  24         bl    *tmp0                 ; Run callback function
0226               *--------------------------------------------------------------
0227               * Exit
0228               *--------------------------------------------------------------
0229               fh.file.write.edb.exit:
0230 6466 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     6468 A44A 
0231 646A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0232 646C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0233 646E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0234 6470 C2F9  30         mov   *stack+,r11           ; Pop R11
0235 6472 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.488847
0098                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
**** **** ****     > fm.load.asm
0001               * FILE......: fm.load.asm
0002               * Purpose...: File Manager - Load file into editor buffer
0003               
0004               ***************************************************************
0005               * fm.loadfile
0006               * Load file into editor buffer
0007               ***************************************************************
0008               * bl  @fm.loadfile
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1  = Pointer to length-prefixed string containing both
0012               *          device and filename
0013               *---------------------------------------------------------------
0014               * OUTPUT
0015               * outparm1 = >FFFF if editor bufer dirty (does not load file)
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ********|*****|*********************|**************************
0020               fm.loadfile:
0021 6474 0649  14         dect  stack
0022 6476 C64B  30         mov   r11,*stack            ; Save return address
0023 6478 0649  14         dect  stack
0024 647A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 647C 0649  14         dect  stack
0026 647E C645  30         mov   tmp1,*stack           ; Push tmp1
0027 6480 0649  14         dect  stack
0028 6482 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;-------------------------------------------------------
0030                       ; Exit early if editor buffer is dirty
0031                       ;-------------------------------------------------------
0032 6484 C160  34         mov   @edb.dirty,tmp1       ; Get dirty flag
     6486 A206 
0033 6488 1303  14         jeq   !                     ; Load file if not dirty
0034               
0035 648A 0720  34         seto  @outparm1             ; \
     648C 2F30 
0036 648E 1032  14         jmp   fm.loadfile.exit      ; / Editor buffer dirty, exit early
0037                       ;-------------------------------------------------------
0038                       ; Reset editor
0039                       ;-------------------------------------------------------
0040 6490 06A0  32 !       bl    @tv.reset             ; Reset editor
     6492 328E 
0041 6494 C820  54         mov   @parm1,@edb.filename.ptr
     6496 2F20 
     6498 A212 
0042                                                   ; Set filename
0043                       ;-------------------------------------------------------
0044                       ; Clear VDP screen buffer
0045                       ;-------------------------------------------------------
0046 649A 06A0  32         bl    @filv
     649C 2290 
0047 649E 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     64A0 0000 
     64A2 0004 
0048               
0049 64A4 C160  34         mov   @fb.scrrows.max,tmp1
     64A6 A11C 
0050 64A8 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     64AA A10E 
0051                                                   ; 16 bit part is in tmp2!
0052               
0053 64AC 06A0  32         bl    @scroff               ; Turn off screen
     64AE 2654 
0054               
0055 64B0 0204  20         li    tmp0,>0050            ; VDP target address (2nd row on screen!)
     64B2 0050 
0056 64B4 0205  20         li    tmp1,32               ; Character to fill
     64B6 0020 
0057               
0058 64B8 06A0  32         bl    @xfilv                ; Fill VDP memory
     64BA 2296 
0059                                                   ; \ i  tmp0 = VDP target address
0060                                                   ; | i  tmp1 = Byte to fill
0061                                                   ; / i  tmp2 = Bytes to copy
0062               
0063 64BC 06A0  32         bl    @pane.action.colorscheme.load
     64BE 6752 
0064                                                   ; Load color scheme and turn on screen
0065                       ;-------------------------------------------------------
0066                       ; Read DV80 file and display
0067                       ;-------------------------------------------------------
0068 64C0 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     64C2 6552 
0069 64C4 C804  38         mov   tmp0,@parm2           ; Register callback 1
     64C6 2F22 
0070               
0071 64C8 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     64CA 65D4 
0072 64CC C804  38         mov   tmp0,@parm3           ; Register callback 2
     64CE 2F24 
0073               
0074 64D0 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     64D2 6624 
0075 64D4 C804  38         mov   tmp0,@parm4           ; Register callback 3
     64D6 2F26 
0076               
0077 64D8 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     64DA 666A 
0078 64DC C804  38         mov   tmp0,@parm5           ; Register callback 4
     64DE 2F28 
0079               
0080 64E0 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     64E2 60EC 
0081                                                   ; \ i  parm1 = Pointer to length prefixed
0082                                                   ; |            file descriptor
0083                                                   ; | i  parm2 = Pointer to callback
0084                                                   ; |            "loading indicator 1"
0085                                                   ; | i  parm3 = Pointer to callback
0086                                                   ; |            "loading indicator 2"
0087                                                   ; | i  parm4 = Pointer to callback
0088                                                   ; |            "loading indicator 3"
0089                                                   ; | i  parm5 = Pointer to callback
0090                                                   ; /            "File I/O error handler"
0091               
0092 64E4 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     64E6 A206 
0093                                                   ; longer dirty.
0094               
0095 64E8 0204  20         li    tmp0,txt.filetype.DV80
     64EA 35C4 
0096 64EC C804  38         mov   tmp0,@edb.filetype.ptr
     64EE A214 
0097                                                   ; Set filetype display string
0098               
0099 64F0 04E0  34         clr   @outparm1             ; Reset
     64F2 2F30 
0100               *--------------------------------------------------------------
0101               * Exit
0102               *--------------------------------------------------------------
0103               fm.loadfile.exit:
0104 64F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0105 64F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0106 64F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0107 64FA C2F9  30         mov   *stack+,r11           ; Pop R11
0108 64FC 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.488847
0099                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
**** **** ****     > fm.save.asm
0001               * FILE......: fm.save.asm
0002               * Purpose...: File Manager - Save file from editor buffer
0003               
0004               ***************************************************************
0005               * fm.savefile
0006               * Save file from editor buffer
0007               ***************************************************************
0008               * bl  @fm.savefile
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * parm1  = Pointer to length-prefixed string containing both
0012               *          device and filename
0013               *---------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ********|*****|*********************|**************************
0020               fm.savefile:
0021 64FE 0649  14         dect  stack
0022 6500 C64B  30         mov   r11,*stack            ; Save return address
0023 6502 0649  14         dect  stack
0024 6504 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 6506 0649  14         dect  stack
0026 6508 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;-------------------------------------------------------
0028                       ; Save DV80 file
0029                       ;-------------------------------------------------------
0030 650A 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     650C 6552 
0031 650E C804  38         mov   tmp0,@parm2           ; Register callback 1
     6510 2F22 
0032               
0033 6512 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     6514 65D4 
0034 6516 C804  38         mov   tmp0,@parm3           ; Register callback 2
     6518 2F24 
0035               
0036 651A 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     651C 6624 
0037 651E C804  38         mov   tmp0,@parm4           ; Register callback 3
     6520 2F26 
0038               
0039 6522 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     6524 666A 
0040 6526 C804  38         mov   tmp0,@parm5           ; Register callback 4
     6528 2F28 
0041               
0042 652A C820  54         mov   @parm1,@edb.filename.ptr
     652C 2F20 
     652E A212 
0043                                                   ; Set current filename
0044               
0045 6530 06A0  32         bl    @filv
     6532 2290 
0046 6534 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     6536 0000 
     6538 0004 
0047               
0048 653A 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     653C 631E 
0049                                                   ; \ i  parm1 = Pointer to length prefixed
0050                                                   ; |            file descriptor
0051                                                   ; | i  parm2 = Pointer to callback
0052                                                   ; |            "loading indicator 1"
0053                                                   ; | i  parm3 = Pointer to callback
0054                                                   ; |            "loading indicator 2"
0055                                                   ; | i  parm4 = Pointer to callback
0056                                                   ; |            "loading indicator 3"
0057                                                   ; | i  parm5 = Pointer to callback
0058                                                   ; /            "File I/O error handler"
0059               
0060 653E 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     6540 A206 
0061                                                   ; longer dirty.
0062               
0063 6542 0204  20         li    tmp0,txt.filetype.DV80
     6544 35C4 
0064 6546 C804  38         mov   tmp0,@edb.filetype.ptr
     6548 A214 
0065                                                   ; Set filetype display string
0066               *--------------------------------------------------------------
0067               * Exit
0068               *--------------------------------------------------------------
0069               fm.savefile.exit:
0070 654A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 654C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 654E C2F9  30         mov   *stack+,r11           ; Pop R11
0073 6550 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.488847
0100                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
**** **** ****     > fm.callbacks.asm
0001               * FILE......: fm.callbacks.asm
0002               * Purpose...: File Manager - Callbacks for file operations
0003               
0004               *---------------------------------------------------------------
0005               * Callback function "Show loading indicator 1"
0006               * Open file
0007               *---------------------------------------------------------------
0008               * Registered as pointer in @fh.callback1
0009               *---------------------------------------------------------------
0010               fm.loadsave.cb.indicator1:
0011 6552 0649  14         dect  stack
0012 6554 C64B  30         mov   r11,*stack            ; Save return address
0013 6556 0649  14         dect  stack
0014 6558 C644  30         mov   tmp0,*stack           ; Push tmp0
0015 655A 0649  14         dect  stack
0016 655C C645  30         mov   tmp1,*stack           ; Push tmp1
0017 655E 0649  14         dect  stack
0018 6560 C660  46         mov   @parm1,*stack         ; Push @parm1
     6562 2F20 
0019                       ;------------------------------------------------------
0020                       ; Check file operation mode
0021                       ;------------------------------------------------------
0022 6564 06A0  32         bl    @hchar
     6566 2788 
0023 6568 0000                   byte 0,0,32,50
     656A 2032 
0024 656C 1D00                   byte pane.botrow,0,32,50
     656E 2032 
0025 6570 FFFF                   data EOL              ; Clear filename
0026               
0027 6572 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     6574 A01C 
     6576 2F20 
0028 6578 06A0  32         bl    @pane.action.colorscheme.statlines
     657A 6764 
0029                                                   ; Set color combination for status lines
0030                                                   ; \ i  @parm1 = Color combination
0031                                                   ; /
0032               
0033 657C C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     657E A44A 
0034               
0035 6580 0284  22         ci    tmp0,fh.fopmode.writefile
     6582 0002 
0036 6584 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0037                                                   ; Saving file?
0038               
0039 6586 0284  22         ci    tmp0,fh.fopmode.readfile
     6588 0001 
0040 658A 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0041                                                   ; Loading file?
0042                       ;------------------------------------------------------
0043                       ; Display Saving....
0044                       ;------------------------------------------------------
0045               fm.loadsave.cb.indicator1.saving:
0046 658C 06A0  32         bl    @putat
     658E 2444 
0047 6590 1D00                   byte pane.botrow,0
0048 6592 3580                   data txt.saving       ; Display "Saving file...."
0049 6594 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0050                       ;------------------------------------------------------
0051                       ; Display Loading....
0052                       ;------------------------------------------------------
0053               fm.loadsave.cb.indicator1.loading:
0054 6596 06A0  32         bl    @putat
     6598 2444 
0055 659A 1D00                   byte pane.botrow,0
0056 659C 3574                   data txt.loading      ; Display "Loading file...."
0057                       ;------------------------------------------------------
0058                       ; Display device/filename
0059                       ;------------------------------------------------------
0060               fm.loadsave.cb.indicator1.filename:
0061 659E 06A0  32         bl    @at
     65A0 2694 
0062 65A2 1D0B                   byte pane.botrow,11   ; Cursor YX position
0063 65A4 C160  34         mov   @edb.filename.ptr,tmp1
     65A6 A212 
0064                                                   ; Get pointer to file descriptor
0065 65A8 06A0  32         bl    @xutst0               ; Display device/filename
     65AA 2422 
0066                       ;------------------------------------------------------
0067                       ; Show separators
0068                       ;------------------------------------------------------
0069 65AC 06A0  32         bl    @hchar
     65AE 2788 
0070 65B0 1D32                   byte pane.botrow,50,16,1       ; Vertical line 1
     65B2 1001 
0071 65B4 1D47                   byte pane.botrow,71,16,1       ; Vertical line 2
     65B6 1001 
0072 65B8 FFFF                   data eol
0073                       ;------------------------------------------------------
0074                       ; Display fast mode
0075                       ;------------------------------------------------------
0076 65BA 0760  38         abs   @fh.offsetopcode
     65BC A44E 
0077 65BE 1304  14         jeq   fm.loadsave.cb.indicator1.exit
0078               
0079 65C0 06A0  32         bl    @putat
     65C2 2444 
0080 65C4 1D26                   byte pane.botrow,38
0081 65C6 35A0                   data txt.fastmode     ; Display "FastMode"
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fm.loadsave.cb.indicator1.exit:
0086 65C8 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     65CA 2F20 
0087 65CC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0088 65CE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0089 65D0 C2F9  30         mov   *stack+,r11           ; Pop R11
0090 65D2 045B  20         b     *r11                  ; Return to caller
0091               
0092               
0093               
0094               
0095               *---------------------------------------------------------------
0096               * Callback function "Show loading indicator 2"
0097               * Read line from file / Write line to file
0098               *---------------------------------------------------------------
0099               * Registered as pointer in @fh.callback2
0100               *---------------------------------------------------------------
0101               fm.loadsave.cb.indicator2:
0102 65D4 0649  14         dect  stack
0103 65D6 C64B  30         mov   r11,*stack            ; Push return address
0104                       ;------------------------------------------------------
0105                       ; Check if first page processed (speedup impression)
0106                       ;------------------------------------------------------
0107 65D8 8820  54         c     @fh.records,@fb.scrrows.max
     65DA A43C 
     65DC A11C 
0108 65DE 1609  14         jne   fm.loadsave.cb.indicator2.kb
0109                                                   ; Skip framebuffer refresh
0110                       ;------------------------------------------------------
0111                       ; Refresh framebuffer if first page processed
0112                       ;------------------------------------------------------
0113 65E0 04E0  34         clr   @parm1
     65E2 2F20 
0114 65E4 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     65E6 671C 
0115                                                   ; \ i  @parm1 = Line to start with
0116                                                   ; /
0117               
0118 65E8 C820  54         mov   @fb.scrrows.max,@parm1
     65EA A11C 
     65EC 2F20 
0119 65EE 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     65F0 672E 
0120                                                   ; \ i  @parm1 = number of lines to dump
0121                                                   ; /
0122               
0123                       ;------------------------------------------------------
0124                       ; Check if updated counters should be displayed
0125                       ;------------------------------------------------------
0126               fm.loadsave.cb.indicator2.kb:
0127 65F2 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     65F4 A440 
     65F6 A458 
0128 65F8 1313  14         jeq   fm.loadsave.cb.indicator2.exit
0129                       ;------------------------------------------------------
0130                       ; Display updated counters
0131                       ;------------------------------------------------------
0132 65FA C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     65FC A440 
     65FE A458 
0133                                                   ; Save for compare
0134               
0135 6600 06A0  32         bl    @putnum
     6602 2A18 
0136 6604 0047                   byte 0,71             ; Show kilobytes processed
0137 6606 A440                   data fh.kilobytes,rambuf,>3020
     6608 2F6A 
     660A 3020 
0138               
0139 660C 06A0  32         bl    @putat
     660E 2444 
0140 6610 004C                   byte 0,76
0141 6612 35AA                   data txt.kb           ; Show "kb" string
0142               
0143 6614 06A0  32         bl    @putnum
     6616 2A18 
0144 6618 1D49                   byte pane.botrow,73   ; Show lines processed
0145 661A A43C                   data fh.records,rambuf,>3020
     661C 2F6A 
     661E 3020 
0146                       ;------------------------------------------------------
0147                       ; Exit
0148                       ;------------------------------------------------------
0149               fm.loadsave.cb.indicator2.exit:
0150 6620 C2F9  30         mov   *stack+,r11           ; Pop R11
0151 6622 045B  20         b     *r11                  ; Return to caller
0152               
0153               
0154               
0155               
0156               *---------------------------------------------------------------
0157               * Callback function "Show loading indicator 3"
0158               * Close file
0159               *---------------------------------------------------------------
0160               * Registered as pointer in @fh.callback3
0161               *---------------------------------------------------------------
0162               fm.loadsave.cb.indicator3:
0163 6624 0649  14         dect  stack
0164 6626 C64B  30         mov   r11,*stack            ; Save return address
0165 6628 0649  14         dect  stack
0166 662A C660  46         mov   @parm1,*stack         ; Push @parm1
     662C 2F20 
0167               
0168 662E 06A0  32         bl    @hchar
     6630 2788 
0169 6632 1D00                   byte pane.botrow,0,32,50
     6634 2032 
0170 6636 FFFF                   data EOL              ; Erase loading indicator
0171               
0172 6638 C820  54         mov   @tv.color,@parm1      ; Set normal color
     663A A018 
     663C 2F20 
0173 663E 06A0  32         bl    @pane.action.colorscheme.statlines
     6640 6764 
0174                                                   ; Set color combination for status lines
0175                                                   ; \ i  @parm1 = Color combination
0176                                                   ; /
0177               
0178 6642 06A0  32         bl    @putnum
     6644 2A18 
0179 6646 0047                   byte 0,71             ; Show kilobytes processed
0180 6648 A440                   data fh.kilobytes,rambuf,>3020
     664A 2F6A 
     664C 3020 
0181               
0182 664E 06A0  32         bl    @putat
     6650 2444 
0183 6652 004C                   byte 0,76
0184 6654 35AA                   data txt.kb           ; Show "kb" string
0185               
0186 6656 06A0  32         bl    @putnum
     6658 2A18 
0187 665A 1D49                   byte pane.botrow,73   ; Show lines processed
0188 665C A43C                   data fh.records,rambuf,>3020
     665E 2F6A 
     6660 3020 
0189                       ;------------------------------------------------------
0190                       ; Exit
0191                       ;------------------------------------------------------
0192               fm.loadsave.cb.indicator3.exit:
0193 6662 C839  50         mov   *stack+,@parm1        ; Pop @parm1
     6664 2F20 
0194 6666 C2F9  30         mov   *stack+,r11           ; Pop R11
0195 6668 045B  20         b     *r11                  ; Return to caller
0196               
0197               
0198               
0199               *---------------------------------------------------------------
0200               * Callback function "File I/O error handler"
0201               * I/O error
0202               *---------------------------------------------------------------
0203               * Registered as pointer in @fh.callback4
0204               *---------------------------------------------------------------
0205               fm.loadsave.cb.fioerr:
0206 666A 0649  14         dect  stack
0207 666C C64B  30         mov   r11,*stack            ; Save return address
0208 666E 0649  14         dect  stack
0209 6670 C644  30         mov   tmp0,*stack           ; Push tmp0
0210 6672 0649  14         dect  stack
0211 6674 C660  46         mov   @parm1,*stack         ; Push @parm1
     6676 2F20 
0212                       ;------------------------------------------------------
0213                       ; Build I/O error message
0214                       ;------------------------------------------------------
0215 6678 06A0  32         bl    @hchar
     667A 2788 
0216 667C 1D00                   byte pane.botrow,0,32,50
     667E 2032 
0217 6680 FFFF                   data EOL              ; Erase loading indicator
0218               
0219 6682 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     6684 A44A 
0220 6686 0284  22         ci    tmp0,fh.fopmode.writefile
     6688 0002 
0221 668A 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0222                       ;------------------------------------------------------
0223                       ; Failed loading file
0224                       ;------------------------------------------------------
0225               fm.loadsave.cb.fioerr.mgs1:
0226 668C 06A0  32         bl    @cpym2m
     668E 24A0 
0227 6690 386D                   data txt.ioerr.load+1
0228 6692 A027                   data tv.error.msg+1
0229 6694 0022                   data 34               ; Error message
0230 6696 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0231                       ;------------------------------------------------------
0232                       ; Failed saving file
0233                       ;------------------------------------------------------
0234               fm.loadsave.cb.fioerr.mgs2:
0235 6698 06A0  32         bl    @cpym2m
     669A 24A0 
0236 669C 388F                   data txt.ioerr.save+1
0237 669E A027                   data tv.error.msg+1
0238 66A0 0022                   data 34               ; Error message
0239                       ;------------------------------------------------------
0240                       ; Add filename to error message
0241                       ;------------------------------------------------------
0242               fm.loadsave.cb.fioerr.mgs3:
0243 66A2 C120  34         mov   @edb.filename.ptr,tmp0
     66A4 A212 
0244 66A6 D194  26         movb  *tmp0,tmp2            ; Get length byte
0245 66A8 0986  56         srl   tmp2,8                ; Right align
0246 66AA 0584  14         inc   tmp0                  ; Skip length byte
0247 66AC 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     66AE A047 
0248               
0249 66B0 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     66B2 24A6 
0250                                                   ; | i  tmp0 = ROM/RAM source
0251                                                   ; | i  tmp1 = RAM destination
0252                                                   ; / i  tmp2 = Bytes to copy
0253                       ;------------------------------------------------------
0254                       ; Reset filename to "new file"
0255                       ;------------------------------------------------------
0256 66B4 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     66B6 A44A 
0257               
0258 66B8 0284  22         ci    tmp0,fh.fopmode.readfile
     66BA 0001 
0259 66BC 1608  14         jne   !                     ; Only when reading file
0260               
0261 66BE 0204  20         li    tmp0,txt.newfile      ; New file
     66C0 35B8 
0262 66C2 C804  38         mov   tmp0,@edb.filename.ptr
     66C4 A212 
0263               
0264 66C6 0204  20         li    tmp0,txt.filetype.none
     66C8 3604 
0265 66CA C804  38         mov   tmp0,@edb.filetype.ptr
     66CC A214 
0266                                                   ; Empty filetype string
0267                       ;------------------------------------------------------
0268                       ; Display I/O error message
0269                       ;------------------------------------------------------
0270 66CE 06A0  32 !       bl    @pane.errline.show    ; Show error line
     66D0 6740 
0271               
0272 66D2 C820  54         mov   @tv.color,@parm1      ; Set normal color
     66D4 A018 
     66D6 2F20 
0273 66D8 06A0  32         bl    @pane.action.colorscheme.statlines
     66DA 6764 
0274                                                   ; Set color combination for status lines
0275                                                   ; \ i  @parm1 = Color combination
0276                                                   ; /
0277                       ;------------------------------------------------------
0278                       ; Exit
0279                       ;------------------------------------------------------
0280               fm.loadsave.cb.fioerr.exit:
0281 66DC C839  50         mov   *stack+,@parm1        ; Pop @parm1
     66DE 2F20 
0282 66E0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0283 66E2 C2F9  30         mov   *stack+,r11           ; Pop R11
0284 66E4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.488847
0101                       ;-----------------------------------------------------------------------
0102                       ; Stubs using trampoline
0103                       ;-----------------------------------------------------------------------
0104                       copy  "rom.stubs.bank2.asm" ; Stubs for functions in other banks
**** **** ****     > rom.stubs.bank2.asm
0001               * FILE......: rom.stubs.bank2.asm
0002               * Purpose...: Bank 2 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "idx.entry.update"
0006               * bank1 vec.2
0007               ********|*****|*********************|**************************
0008               idx.entry.update:
0009 66E6 0649  14         dect  stack
0010 66E8 C64B  30         mov   r11,*stack            ; Save return address
0011                       ;------------------------------------------------------
0012                       ; Call function in bank 1
0013                       ;------------------------------------------------------
0014 66EA 06A0  32         bl    @rom.farjump           ; \ Trampoline jump to bank
     66EC 3008 
0015 66EE 6002                   data bank1            ; | i  p0 = bank address
0016 66F0 7F9E                   data vec.2            ; | i  p1 = Vector with target address
0017 66F2 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0018                       ;------------------------------------------------------
0019                       ; Exit
0020                       ;------------------------------------------------------
0021 66F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0022 66F6 045B  20         b     *r11                  ; Return to caller
0023               
0024               
0025               ***************************************************************
0026               * Stub for "idx.pointer.get"
0027               * bank1 vec.4
0028               ********|*****|*********************|**************************
0029               idx.pointer.get:
0030 66F8 0649  14         dect  stack
0031 66FA C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Call function in bank 1
0034                       ;------------------------------------------------------
0035 66FC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     66FE 3008 
0036 6700 6002                   data bank1            ; | i  p0 = bank address
0037 6702 7FA2                   data vec.4            ; | i  p1 = Vector with target address
0038 6704 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042 6706 C2F9  30         mov   *stack+,r11           ; Pop r11
0043 6708 045B  20         b     *r11                  ; Return to caller
0044               
0045               
0046               
0047               ***************************************************************
0048               * Stub for "edb.line.unpack"
0049               * bank1 vec.11
0050               ********|*****|*********************|**************************
0051               edb.line.unpack:
0052 670A 0649  14         dect  stack
0053 670C C64B  30         mov   r11,*stack            ; Save return address
0054                       ;------------------------------------------------------
0055                       ; Call function in bank 1
0056                       ;------------------------------------------------------
0057 670E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6710 3008 
0058 6712 6002                   data bank1            ; | i  p0 = bank address
0059 6714 7FB0                   data vec.11           ; | i  p1 = Vector with target address
0060 6716 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064 6718 C2F9  30         mov   *stack+,r11           ; Pop r11
0065 671A 045B  20         b     *r11                  ; Return to caller
0066               
0067               
0068               ***************************************************************
0069               * Stub for "fb.refresh"
0070               * bank1 vec.20
0071               ********|*****|*********************|**************************
0072               fb.refresh:
0073 671C 0649  14         dect  stack
0074 671E C64B  30         mov   r11,*stack            ; Save return address
0075                       ;------------------------------------------------------
0076                       ; Call function in bank 1
0077                       ;------------------------------------------------------
0078 6720 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6722 3008 
0079 6724 6002                   data bank1            ; | i  p0 = bank address
0080 6726 7FC2                   data vec.20           ; | i  p1 = Vector with target address
0081 6728 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085 672A C2F9  30         mov   *stack+,r11           ; Pop r11
0086 672C 045B  20         b     *r11                  ; Return to caller
0087               
0088               
0089               
0090               ***************************************************************
0091               * Stub for "fb.vdpdump"
0092               * bank1 vec.21
0093               ********|*****|*********************|**************************
0094               fb.vdpdump:
0095 672E 0649  14         dect  stack
0096 6730 C64B  30         mov   r11,*stack            ; Save return address
0097                       ;------------------------------------------------------
0098                       ; Call function in bank 1
0099                       ;------------------------------------------------------
0100 6732 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6734 3008 
0101 6736 6002                   data bank1            ; | i  p0 = bank address
0102 6738 7FC4                   data vec.21           ; | i  p1 = Vector with target address
0103 673A 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107 673C C2F9  30         mov   *stack+,r11           ; Pop r11
0108 673E 045B  20         b     *r11                  ; Return to caller
0109               
0110               
0111               
0112               
0113               ***************************************************************
0114               * Stub for "pane.errline.show"
0115               * bank1 vec.30
0116               ********|*****|*********************|**************************
0117               pane.errline.show:
0118 6740 0649  14         dect  stack
0119 6742 C64B  30         mov   r11,*stack            ; Save return address
0120                       ;------------------------------------------------------
0121                       ; Call function in bank 1
0122                       ;------------------------------------------------------
0123 6744 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6746 3008 
0124 6748 6002                   data bank1            ; | i  p0 = bank address
0125 674A 7FD6                   data vec.30           ; | i  p1 = Vector with target address
0126 674C 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0127                       ;------------------------------------------------------
0128                       ; Exit
0129                       ;------------------------------------------------------
0130 674E C2F9  30         mov   *stack+,r11           ; Pop r11
0131 6750 045B  20         b     *r11                  ; Return to caller
0132               
0133               
0134               ***************************************************************
0135               * Stub for "pane.action.colorscheme.load"
0136               * bank1 vec.31
0137               ********|*****|*********************|**************************
0138               pane.action.colorscheme.load
0139 6752 0649  14         dect  stack
0140 6754 C64B  30         mov   r11,*stack            ; Save return address
0141                       ;------------------------------------------------------
0142                       ; Call function in bank 1
0143                       ;------------------------------------------------------
0144 6756 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6758 3008 
0145 675A 6002                   data bank1            ; | i  p0 = bank address
0146 675C 7FD8                   data vec.31           ; | i  p1 = Vector with target address
0147 675E 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0148                       ;------------------------------------------------------
0149                       ; Exit
0150                       ;------------------------------------------------------
0151 6760 C2F9  30         mov   *stack+,r11           ; Pop r11
0152 6762 045B  20         b     *r11                  ; Return to caller
0153               
0154               
0155               ***************************************************************
0156               * Stub for "pane.action.colorscheme.statuslines"
0157               * bank1 vec.32
0158               ********|*****|*********************|**************************
0159               pane.action.colorscheme.statlines
0160 6764 0649  14         dect  stack
0161 6766 C64B  30         mov   r11,*stack            ; Save return address
0162                       ;------------------------------------------------------
0163                       ; Call function in bank 1
0164                       ;------------------------------------------------------
0165 6768 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     676A 3008 
0166 676C 6002                   data bank1            ; | i  p0 = bank address
0167 676E 7FDA                   data vec.32           ; | i  p1 = Vector with target address
0168 6770 6004                   data bankid           ; / i  p2 = Source ROM bank for return
0169                       ;------------------------------------------------------
0170                       ; Exit
0171                       ;------------------------------------------------------
0172 6772 C2F9  30         mov   *stack+,r11           ; Pop r11
0173 6774 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b2.asm.488847
0105                       ;-----------------------------------------------------------------------
0106                       ; Bank specific vector table
0107                       ;-----------------------------------------------------------------------
0111 6776 6776                   data $                ; Bank 1 ROM size OK.
0113                       ;-------------------------------------------------------
0114                       ; Vector table bank 2: >7f9c - >7fff
0115                       ;-------------------------------------------------------
0116                       copy  "rom.vectors.bank2.asm"
**** **** ****     > rom.vectors.bank2.asm
0001               * FILE......: rom.vectors.bank2.asm
0002               * Purpose...: Bank 2 vectors for trampoline function
0003               
0004                       aorg  >7f9c
0005               
0006               *--------------------------------------------------------------
0007               * Vector table for trampoline functions
0008               *--------------------------------------------------------------
0009 7F9C 6474     vec.1   data  fm.loadfile           ;
0010 7F9E 64FE     vec.2   data  fm.savefile           ;
0011 7FA0 2026     vec.3   data  cpu.crash             ;
0012 7FA2 2026     vec.4   data  cpu.crash             ;
0013 7FA4 2026     vec.5   data  cpu.crash             ;
0014 7FA6 2026     vec.6   data  cpu.crash             ;
0015 7FA8 2026     vec.7   data  cpu.crash             ;
0016 7FAA 2026     vec.8   data  cpu.crash             ;
0017 7FAC 2026     vec.9   data  cpu.crash             ;
0018 7FAE 2026     vec.10  data  cpu.crash             ;
0019 7FB0 2026     vec.11  data  cpu.crash             ;
0020 7FB2 2026     vec.12  data  cpu.crash             ;
0021 7FB4 2026     vec.13  data  cpu.crash             ;
0022 7FB6 2026     vec.14  data  cpu.crash             ;
0023 7FB8 2026     vec.15  data  cpu.crash             ;
0024 7FBA 2026     vec.16  data  cpu.crash             ;
0025 7FBC 2026     vec.17  data  cpu.crash             ;
0026 7FBE 2026     vec.18  data  cpu.crash             ;
0027 7FC0 2026     vec.19  data  cpu.crash             ;
0028 7FC2 2026     vec.20  data  cpu.crash             ;
0029 7FC4 2026     vec.21  data  cpu.crash             ;
0030 7FC6 2026     vec.22  data  cpu.crash             ;
0031 7FC8 2026     vec.23  data  cpu.crash             ;
0032 7FCA 2026     vec.24  data  cpu.crash             ;
0033 7FCC 2026     vec.25  data  cpu.crash             ;
0034 7FCE 2026     vec.26  data  cpu.crash             ;
0035 7FD0 2026     vec.27  data  cpu.crash             ;
0036 7FD2 2026     vec.28  data  cpu.crash             ;
0037 7FD4 2026     vec.29  data  cpu.crash             ;
0038 7FD6 2026     vec.30  data  cpu.crash             ;
0039 7FD8 2026     vec.31  data  cpu.crash             ;
0040 7FDA 2026     vec.32  data  cpu.crash             ;
**** **** ****     > stevie_b2.asm.488847
0117               
0118               *--------------------------------------------------------------
0119               * Video mode configuration
0120               *--------------------------------------------------------------
0121      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0122      0004     spfbck  equ   >04                   ; Screen background color.
0123      32D6     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0124      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0125      0050     colrow  equ   80                    ; Columns per row
0126      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0127      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0128      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0129      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
