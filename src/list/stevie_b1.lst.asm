XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > stevie_b1.asm.2287273
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 201011-2287273
0010               
0011                       copy  "equates.equ"         ; Equates Stevie configuration
**** **** ****     > equates.equ
0001               ***************************************************************
0002               *                          Stevie Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: equates.equ                 ; Version %%build_date%%
0010               *--------------------------------------------------------------
0011               * Stevie memory map
0012               *
0013               *
0014               * LOW MEMORY EXPANSION (2000-2fff)
0015               *
0016               * Mem range   Bytes    SAMS   Purpose
0017               * =========   =====    ====   ==================================
0018               * 2000-2eff    3840           SP2 library
0019               * 2f00-2fff     256           SP2 work memory
0020               *
0021               * LOW MEMORY EXPANSION (3000-3fff)
0022               *
0023               * Mem range   Bytes    SAMS   Purpose
0024               * =========   =====    ====   ==================================
0025               * 3000-3fff    4096           Resident Stevie Modules
0026               *
0027               *
0028               * CARTRIDGE SPACE (6000-7fff)
0029               *
0030               * Mem range   Bytes    BANK   Purpose
0031               * =========   =====    ====   ==================================
0032               * 6000-7fff    8192       0   SP2 ROM CODE, copy to RAM code, resident modules
0033               * 6000-7fff    8192       1   Stevie program code
0034               *
0035               *
0036               * HIGH MEMORY EXPANSION (a000-ffff)
0037               *
0038               * Mem range   Bytes    SAMS   Purpose
0039               * =========   =====    ====   ==================================
0040               * a000-a0ff     256           Stevie Editor shared structure
0041               * a100-a1ff     256           Framebuffer structure
0042               * a200-a2ff     256           Editor buffer structure
0043               * a300-a3ff     256           Command buffer structure
0044               * a400-a4ff     256           File handle structure
0045               * a500-a5ff     256           Index structure
0046               * a600-af5f    2400           Frame buffer
0047               * af60-afff     ???           *FREE*
0048               *
0049               * b000-bfff    4096           Index buffer page
0050               * c000-cfff    4096           Editor buffer page
0051               * d000-dfff    4096           Command history buffer
0052               * e000-efff    4096           Heap
0053               * f000-ffff    4096           *FREE*
0054               *
0055               *
0056               * VDP RAM
0057               *
0058               * Mem range   Bytes    Hex    Purpose
0059               * =========   =====   =====   =================================
0060               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0061               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0062               * 0fc0                        PCT - Pattern Color Table
0063               * 1000-17ff    2048   >0800   PDT - Pattern Descriptor Table
0064               * 1800-215f    2400   >0960   TAT - Tile Attribute Table (pos. based colors)
0065               * 2180                        SAT - Sprite Attribute List
0066               * 2800                        SPT - Sprite Pattern Table. Must be on 2K boundary
0067               *--------------------------------------------------------------
0068               * Skip unused spectra2 code modules for reduced code size
0069               *--------------------------------------------------------------
0070      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0071      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0072      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0073      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0074      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0075      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0076      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0077      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0078      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0079      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0080      0001     skip_sound_player         equ  1       ; Skip inclusion of sound player code
0081      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0082      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0083      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0084      0001     skip_random_generator     equ  1       ; Skip random functions
0085      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0086      0001     skip_mem_paging           equ  1       ; Skip support for memory paging
0087               *--------------------------------------------------------------
0088               * Stevie specific equates
0089               *--------------------------------------------------------------
0090      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0091      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0092      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0093               
0094               *--------------------------------------------------------------
0095               * Stevie Dialog / Pane specific equates
0096               *--------------------------------------------------------------
0097      001D     pane.botrow               equ  29      ; Bottom row on screen
0098      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0099      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0100      000A     id.dialog.load            equ  10      ; ID dialog "Load DV 80 file"
0101      000B     id.dialog.save            equ  11      ; ID dialog "Save DV 80 file"
0102               ;-----------------------------------------------------------------
0103               ;   Dialog ID's > 100 indicate that command prompt should be
0104               ;   hidden and no characters added to buffer
0105               ;-----------------------------------------------------------------
0106      0065     id.dialog.unsaved         equ  101     ; ID dialog "Unsaved changes"
0107      0066     id.dialog.about           equ  102     ; ID dialog "About"
0108               *--------------------------------------------------------------
0109               * SPECTRA2 / Stevie startup options
0110               *--------------------------------------------------------------
0111      0001     debug                     equ  1       ; Turn on spectra2 debugging
0112      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram upon startup
0113      6030     kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
0114      6036     kickstart.code2           equ  >6036   ; Uniform aorg entry addr accross banks
0115               *--------------------------------------------------------------
0116               * Stevie work area (scratchpad)       @>2f00-2fff   (256 bytes)
0117               *--------------------------------------------------------------
0118      2F20     parm1             equ  >2f20           ; Function parameter 1
0119      2F22     parm2             equ  >2f22           ; Function parameter 2
0120      2F24     parm3             equ  >2f24           ; Function parameter 3
0121      2F26     parm4             equ  >2f26           ; Function parameter 4
0122      2F28     parm5             equ  >2f28           ; Function parameter 5
0123      2F2A     parm6             equ  >2f2a           ; Function parameter 6
0124      2F2C     parm7             equ  >2f2c           ; Function parameter 7
0125      2F2E     parm8             equ  >2f2e           ; Function parameter 8
0126      2F30     outparm1          equ  >2f30           ; Function output parameter 1
0127      2F32     outparm2          equ  >2f32           ; Function output parameter 2
0128      2F34     outparm3          equ  >2f34           ; Function output parameter 3
0129      2F36     outparm4          equ  >2f36           ; Function output parameter 4
0130      2F38     outparm5          equ  >2f38           ; Function output parameter 5
0131      2F3A     outparm6          equ  >2f3a           ; Function output parameter 6
0132      2F3C     outparm7          equ  >2f3c           ; Function output parameter 7
0133      2F3E     outparm8          equ  >2f3e           ; Function output parameter 8
0134      2F40     keycode1          equ  >2f40           ; Current key scanned
0135      2F42     keycode2          equ  >2f42           ; Previous key scanned
0136      2F44     timers            equ  >2f44           ; Timer table
0137      2F54     ramsat            equ  >2f54           ; Sprite Attribute Table in RAM
0138      2F64     rambuf            equ  >2f64           ; RAM workbuffer 1
0139               *--------------------------------------------------------------
0140               * Stevie Editor shared structures     @>a000-a0ff   (256 bytes)
0141               *--------------------------------------------------------------
0142      A000     tv.top            equ  >a000           ; Structure begin
0143      A000     tv.sams.2000      equ  tv.top + 0      ; SAMS window >2000-2fff
0144      A002     tv.sams.3000      equ  tv.top + 2      ; SAMS window >3000-3fff
0145      A004     tv.sams.a000      equ  tv.top + 4      ; SAMS window >a000-afff
0146      A006     tv.sams.b000      equ  tv.top + 6      ; SAMS window >b000-bfff
0147      A008     tv.sams.c000      equ  tv.top + 8      ; SAMS window >c000-cfff
0148      A00A     tv.sams.d000      equ  tv.top + 10     ; SAMS window >d000-dfff
0149      A00C     tv.sams.e000      equ  tv.top + 12     ; SAMS window >e000-efff
0150      A00E     tv.sams.f000      equ  tv.top + 14     ; SAMS window >f000-ffff
0151      A010     tv.act_buffer     equ  tv.top + 16     ; Active editor buffer (0-9)
0152      A012     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0153      A014     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0154      A016     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0155      A018     tv.color          equ  tv.top + 24     ; Foreground/Background color in editor
0156      A01A     tv.pane.focus     equ  tv.top + 26     ; Identify pane that has focus
0157      A01C     tv.task.oneshot   equ  tv.top + 28     ; Pointer to one-shot routine
0158      A01E     tv.error.visible  equ  tv.top + 30     ; Error pane visible
0159      A020     tv.error.msg      equ  tv.top + 32     ; Error message (max. 160 characters)
0160      A0C0     tv.free           equ  tv.top + 192    ; End of structure
0161               *--------------------------------------------------------------
0162               * Frame buffer structure              @>a100-a1ff   (256 bytes)
0163               *--------------------------------------------------------------
0164      A100     fb.struct         equ  >a100           ; Structure begin
0165      A100     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0166      A102     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0167      A104     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0168                                                      ; line X in editor buffer).
0169      A106     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0170                                                      ; (offset 0 .. @fb.scrrows)
0171      A108     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0172      A10A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0173      A10C     fb.column         equ  fb.struct + 12  ; Current column in frame buffer
0174      A10E     fb.colsline       equ  fb.struct + 14  ; Columns per row in frame buffer
0175      A110     fb.free1          equ  fb.struct + 16  ; **** free ****
0176      A112     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0177      A114     fb.yxsave         equ  fb.struct + 20  ; Copy of WYX
0178      A116     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0179      A118     fb.scrrows        equ  fb.struct + 24  ; Rows on physical screen for framebuffer
0180      A11A     fb.scrrows.max    equ  fb.struct + 26  ; Max # of rows on physical screen for fb
0181      A11C     fb.free           equ  fb.struct + 28  ; End of structure
0182               *--------------------------------------------------------------
0183               * Editor buffer structure             @>a200-a2ff   (256 bytes)
0184               *--------------------------------------------------------------
0185      A200     edb.struct        equ  >a200           ; Begin structure
0186      A200     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0187      A202     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0188      A204     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0189      A206     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0190      A208     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0191      A20A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0192      A20C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0193      A20E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0194                                                      ; with current filename.
0195      A210     edb.filetype.ptr  equ  edb.struct + 16 ; Pointer to length-prefixed string
0196                                                      ; with current file type.
0197      A212     edb.sams.page     equ  edb.struct + 18 ; Current SAMS page
0198      A214     edb.free          equ  edb.struct + 20 ; End of structure
0199               *--------------------------------------------------------------
0200               * Command buffer structure            @>a300-a3ff   (256 bytes)
0201               *--------------------------------------------------------------
0202      A300     cmdb.struct       equ  >a300           ; Command Buffer structure
0203      A300     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0204      A302     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0205      A304     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0206      A306     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0207      A308     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0208      A30A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0209      A30C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0210      A30E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0211      A310     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0212      A312     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0213      A314     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0214      A316     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0215      A318     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0216      A31A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0217      A31C     cmdb.panhead      equ  cmdb.struct + 28; Pointer to string with pane header
0218      A31E     cmdb.panhint      equ  cmdb.struct + 30; Pointer to string with pane hint
0219      A320     cmdb.pankeys      equ  cmdb.struct + 32; Pointer to string with pane keys
0220      A322     cmdb.action.ptr   equ  cmdb.struct + 34; Pointer to function to execute
0221      A324     cmdb.cmdlen       equ  cmdb.struct + 36; Length of current command (MSB byte!)
0222      A325     cmdb.cmd          equ  cmdb.struct + 37; Current command (80 bytes max.)
0223      A375     cmdb.free         equ  cmdb.struct +117; End of structure
0224               *--------------------------------------------------------------
0225               * File handle structure               @>a400-a4ff   (256 bytes)
0226               *--------------------------------------------------------------
0227      A400     fh.struct         equ  >a400           ; stevie file handling structures
0228               ;***********************************************************************
0229               ; ATTENTION
0230               ; The dsrlnk variables must form a continuous memory block and keep
0231               ; their order!
0232               ;***********************************************************************
0233      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0234      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0235      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0236      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0237      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0238      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0239      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0240      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0241      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0242      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0243      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0244      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0245      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0246      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0247      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0248      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0249      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0250      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0251      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0252      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0253      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0254      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0255      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0256      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0257      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0258      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0259      A458     fh.kilobytes.prev equ  fh.struct + 88  ; Kilobytes processed (previous)
0260      A45A     fh.membuffer      equ  fh.struct + 90  ; 80 bytes file memory buffer
0261      A4AA     fh.free           equ  fh.struct +170  ; End of structure
0262      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0263      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0264               *--------------------------------------------------------------
0265               * Index structure                     @>a500-a5ff   (256 bytes)
0266               *--------------------------------------------------------------
0267      A500     idx.struct        equ  >a500           ; stevie index structure
0268      A500     idx.sams.page     equ  idx.struct      ; Current SAMS page
0269      A502     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0270      A504     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0271               *--------------------------------------------------------------
0272               * Frame buffer                        @>a600-afff  (2560 bytes)
0273               *--------------------------------------------------------------
0274      A600     fb.top            equ  >a600           ; Frame buffer (80x30)
0275      0960     fb.size           equ  80*30           ; Frame buffer size
0276               *--------------------------------------------------------------
0277               * Index                               @>b000-bfff  (4096 bytes)
0278               *--------------------------------------------------------------
0279      B000     idx.top           equ  >b000           ; Top of index
0280      1000     idx.size          equ  4096            ; Index size
0281               *--------------------------------------------------------------
0282               * Editor buffer                       @>c000-cfff  (4096 bytes)
0283               *--------------------------------------------------------------
0284      C000     edb.top           equ  >c000           ; Editor buffer high memory
0285      1000     edb.size          equ  4096            ; Editor buffer size
0286               *--------------------------------------------------------------
0287               * Command history buffer              @>d000-dfff  (4096 bytes)
0288               *--------------------------------------------------------------
0289      D000     cmdb.top          equ  >d000           ; Top of command history buffer
0290      1000     cmdb.size         equ  4096            ; Command buffer size
0291               *--------------------------------------------------------------
0292               * Heap                                @>e000-efff  (4096 bytes)
0293               *--------------------------------------------------------------
0294      E000     heap.top          equ  >e000           ; Top of heap
**** **** ****     > stevie_b1.asm.2287273
0012               
0013               ***************************************************************
0014               * Spectra2 core configuration
0015               ********|*****|*********************|**************************
0016      3000     sp2.stktop    equ >3000             ; Top of SP2 stack starts at >2fff
0017                                                   ; and grows downwards
0018               
0019               ***************************************************************
0020               * BANK 1 - Stevie main editor modules
0021               ********|*****|*********************|**************************
0022                       aorg  >6000
0023                       save  >6000,>7fff           ; Save bank 1
0024               *--------------------------------------------------------------
0025               * Cartridge header
0026               ********|*****|*********************|**************************
0027 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0028 6006 6010             data  $+10
0029 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0030 6010 0000             data  0                     ; No more items following
0031 6012 6030             data  kickstart.code1
0032               
0034               
0035 6014 0C53             byte  12
0036 6015 ....             text  'STEVIE V0.1B'
0037                       even
0038               
0046               
0047               ***************************************************************
0048               * Step 1: Switch to bank 0 (uniform code accross all banks)
0049               ********|*****|*********************|**************************
0050                       aorg  kickstart.code1       ; >6030
0051 6030 04E0  34         clr   @>6000                ; Switch to bank 0
     6032 6000 
0052               ***************************************************************
0053               * Step 2: Satisfy assembler, must know SP2 in low MEMEXP
0054               ********|*****|*********************|**************************
0055                       aorg  >2000
0056                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0083                       copy  "rom_bankswitch.asm"       ; Bank switch routine
**** **** ****     > rom_bankswitch.asm
0001               * FILE......: rom_bankswitch.asm
0002               * Purpose...: ROM bankswitching Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                   BANKSWITCHING FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * SWBNK - Switch ROM bank
0010               ***************************************************************
0011               *  BL   @SWBNK
0012               *  DATA P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = Bank selection address (>600X)
0015               *  P1 = Vector address
0016               *--------------------------------------------------------------
0017               *  B    @SWBNKX
0018               *
0019               *  TMP0 = Bank selection address (>600X)
0020               *  TMP1 = Vector address
0021               *--------------------------------------------------------------
0022               *  Important! The bank-switch routine must be at the exact
0023               *  same location accross banks
0024               ********|*****|*********************|**************************
0025 2000 C13B  30 swbnk   mov   *r11+,tmp0
0026 2002 C17B  30         mov   *r11+,tmp1
0027 2004 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 2006 C155  26         mov   *tmp1,tmp1
0029 2008 0455  20         b     *tmp1                 ; Switch to routine in TMP1
**** **** ****     > runlib.asm
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
0012 200A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 200C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 200E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2010 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2012 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 2014 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 2016 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 2018 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 201A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 201C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 201E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2020 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2022 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 2024 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 2026 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 2028 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 202A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 202C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 202E D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      200A     hb$00   equ   w$0000                ; >0000
0035      201C     hb$01   equ   w$0100                ; >0100
0036      201E     hb$02   equ   w$0200                ; >0200
0037      2020     hb$04   equ   w$0400                ; >0400
0038      2022     hb$08   equ   w$0800                ; >0800
0039      2024     hb$10   equ   w$1000                ; >1000
0040      2026     hb$20   equ   w$2000                ; >2000
0041      2028     hb$40   equ   w$4000                ; >4000
0042      202A     hb$80   equ   w$8000                ; >8000
0043      202E     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      200A     lb$00   equ   w$0000                ; >0000
0048      200C     lb$01   equ   w$0001                ; >0001
0049      200E     lb$02   equ   w$0002                ; >0002
0050      2010     lb$04   equ   w$0004                ; >0004
0051      2012     lb$08   equ   w$0008                ; >0008
0052      2014     lb$10   equ   w$0010                ; >0010
0053      2016     lb$20   equ   w$0020                ; >0020
0054      2018     lb$40   equ   w$0040                ; >0040
0055      201A     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      200C     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      200E     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2010     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2012     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      2014     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      2016     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      2018     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      201A     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      201C     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      201E     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2020     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2022     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      2024     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      2026     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      2028     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      202A     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      2026     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      201C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      2018     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      2014     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0038 2030 022B  22         ai    r11,-4                ; Remove opcode offset
     2032 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 2034 C800  38         mov   r0,@>ffe0
     2036 FFE0 
0043 2038 C801  38         mov   r1,@>ffe2
     203A FFE2 
0044 203C C802  38         mov   r2,@>ffe4
     203E FFE4 
0045 2040 C803  38         mov   r3,@>ffe6
     2042 FFE6 
0046 2044 C804  38         mov   r4,@>ffe8
     2046 FFE8 
0047 2048 C805  38         mov   r5,@>ffea
     204A FFEA 
0048 204C C806  38         mov   r6,@>ffec
     204E FFEC 
0049 2050 C807  38         mov   r7,@>ffee
     2052 FFEE 
0050 2054 C808  38         mov   r8,@>fff0
     2056 FFF0 
0051 2058 C809  38         mov   r9,@>fff2
     205A FFF2 
0052 205C C80A  38         mov   r10,@>fff4
     205E FFF4 
0053 2060 C80B  38         mov   r11,@>fff6
     2062 FFF6 
0054 2064 C80C  38         mov   r12,@>fff8
     2066 FFF8 
0055 2068 C80D  38         mov   r13,@>fffa
     206A FFFA 
0056 206C C80E  38         mov   r14,@>fffc
     206E FFFC 
0057 2070 C80F  38         mov   r15,@>ffff
     2072 FFFF 
0058 2074 02A0  12         stwp  r0
0059 2076 C800  38         mov   r0,@>ffdc
     2078 FFDC 
0060 207A 02C0  12         stst  r0
0061 207C C800  38         mov   r0,@>ffde
     207E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2080 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2082 8300 
0067 2084 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2086 8302 
0068 2088 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     208A 4A4A 
0069 208C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     208E 2E16 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2090 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2092 2304 
0078 2094 21F4                   data graph1           ; Equate selected video mode table
0079               
0080 2096 06A0  32         bl    @ldfnt
     2098 236C 
0081 209A 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     209C 000C 
0082               
0083 209E 06A0  32         bl    @filv
     20A0 229A 
0084 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0 
     20A6 0300 
0085                       ;------------------------------------------------------
0086                       ; Show crash details
0087                       ;------------------------------------------------------
0088 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 244E 
0089 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2182 
0090               
0091 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 299A 
0092 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0093 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0094 20B8 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0095 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0096                                                   ; /         LSB offset for ASCII digit 0-9
0097                       ;------------------------------------------------------
0098                       ; Show caller details
0099                       ;------------------------------------------------------
0100 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 244E 
0101 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 2198 
0102               
0103 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 299A 
0104 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0105 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0106 20CC 2F64                   data rambuf           ; | i  p2 = Pointer to ram buffer
0107 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0108                                                   ; /         LSB offset for ASCII digit 0-9
0109                       ;------------------------------------------------------
0110                       ; Display labels
0111                       ;------------------------------------------------------
0112 20D0 06A0  32         bl    @putat
     20D2 244E 
0113 20D4 0300                   byte 3,0
0114 20D6 21B2                   data cpu.crash.msg.wp
0115 20D8 06A0  32         bl    @putat
     20DA 244E 
0116 20DC 0400                   byte 4,0
0117 20DE 21B8                   data cpu.crash.msg.st
0118 20E0 06A0  32         bl    @putat
     20E2 244E 
0119 20E4 1600                   byte 22,0
0120 20E6 21BE                   data cpu.crash.msg.source
0121 20E8 06A0  32         bl    @putat
     20EA 244E 
0122 20EC 1700                   byte 23,0
0123 20EE 21DA                   data cpu.crash.msg.id
0124                       ;------------------------------------------------------
0125                       ; Show crash registers WP, ST, R0 - R15
0126                       ;------------------------------------------------------
0127 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 269E 
0128 20F4 0304                   byte 3,4              ; \ i p0 = YX position
0129                                                   ; /
0130               
0131 20F6 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20F8 FFDC 
0132 20FA 04C6  14         clr   tmp2                  ; Loop counter
0133               
0134               cpu.crash.showreg:
0135 20FC C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0136               
0137 20FE 0649  14         dect  stack
0138 2100 C644  30         mov   tmp0,*stack           ; Push tmp0
0139 2102 0649  14         dect  stack
0140 2104 C645  30         mov   tmp1,*stack           ; Push tmp1
0141 2106 0649  14         dect  stack
0142 2108 C646  30         mov   tmp2,*stack           ; Push tmp2
0143                       ;------------------------------------------------------
0144                       ; Display crash register number
0145                       ;------------------------------------------------------
0146               cpu.crash.showreg.label:
0147 210A C046  18         mov   tmp2,r1               ; Save register number
0148 210C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     210E 0001 
0149 2110 121C  14         jle   cpu.crash.showreg.content
0150                                                   ; Yes, skip
0151               
0152 2112 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0153 2114 06A0  32         bl    @mknum
     2116 29A4 
0154 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0155 211A 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0156 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0157                                                   ; /         LSB offset for ASCII digit 0-9
0158               
0159 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26B4 
0160 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0161                                                   ; /
0162               
0163 2124 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2126 242A 
0164 2128 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0165                                                   ; /
0166               
0167 212A 06A0  32         bl    @setx                 ; Set cursor X position
     212C 26B4 
0168 212E 0002                   data 2                ; \ i  p0 =  Cursor Y position
0169                                                   ; /
0170               
0171 2130 0281  22         ci    r1,10
     2132 000A 
0172 2134 1102  14         jlt   !
0173 2136 0620  34         dec   @wyx                  ; x=x-1
     2138 832A 
0174               
0175 213A 06A0  32 !       bl    @putstr
     213C 242A 
0176 213E 21AE                   data cpu.crash.msg.r
0177               
0178 2140 06A0  32         bl    @mknum
     2142 29A4 
0179 2144 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0180 2146 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0181 2148 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0182                                                   ; /         LSB offset for ASCII digit 0-9
0183                       ;------------------------------------------------------
0184                       ; Display crash register content
0185                       ;------------------------------------------------------
0186               cpu.crash.showreg.content:
0187 214A 06A0  32         bl    @mkhex                ; Convert hex word to string
     214C 2916 
0188 214E 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0189 2150 2F64                   data rambuf           ; | i  p1 = Pointer to ram buffer
0190 2152 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0191                                                   ; /         LSB offset for ASCII digit 0-9
0192               
0193 2154 06A0  32         bl    @setx                 ; Set cursor X position
     2156 26B4 
0194 2158 0006                   data 6                ; \ i  p0 =  Cursor Y position
0195                                                   ; /
0196               
0197 215A 06A0  32         bl    @putstr
     215C 242A 
0198 215E 21B0                   data cpu.crash.msg.marker
0199               
0200 2160 06A0  32         bl    @setx                 ; Set cursor X position
     2162 26B4 
0201 2164 0007                   data 7                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2166 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2168 242A 
0205 216A 2F64                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0206                                                   ; /
0207               
0208 216C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0209 216E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0210 2170 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0211               
0212 2172 06A0  32         bl    @down                 ; y=y+1
     2174 26A4 
0213               
0214 2176 0586  14         inc   tmp2
0215 2178 0286  22         ci    tmp2,17
     217A 0011 
0216 217C 12BF  14         jle   cpu.crash.showreg     ; Show next register
0217                       ;------------------------------------------------------
0218                       ; Kernel takes over
0219                       ;------------------------------------------------------
0220 217E 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     2180 2D14 
0221               
0222               
0223               cpu.crash.msg.crashed
0224 2182 1553             byte  21
0225 2183 ....             text  'System crashed near >'
0226                       even
0227               
0228               cpu.crash.msg.caller
0229 2198 1543             byte  21
0230 2199 ....             text  'Caller address near >'
0231                       even
0232               
0233               cpu.crash.msg.r
0234 21AE 0152             byte  1
0235 21AF ....             text  'R'
0236                       even
0237               
0238               cpu.crash.msg.marker
0239 21B0 013E             byte  1
0240 21B1 ....             text  '>'
0241                       even
0242               
0243               cpu.crash.msg.wp
0244 21B2 042A             byte  4
0245 21B3 ....             text  '**WP'
0246                       even
0247               
0248               cpu.crash.msg.st
0249 21B8 042A             byte  4
0250 21B9 ....             text  '**ST'
0251                       even
0252               
0253               cpu.crash.msg.source
0254 21BE 1B53             byte  27
0255 21BF ....             text  'Source    stevie_b1.lst.asm'
0256                       even
0257               
0258               cpu.crash.msg.id
0259 21DA 1842             byte  24
0260 21DB ....             text  'Build-ID  201011-2287273'
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
0007 21F4 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     21F6 000E 
     21F8 0106 
     21FA 0204 
     21FC 0020 
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
0032 21FE 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2200 000E 
     2202 0106 
     2204 00F4 
     2206 0028 
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
0058 2208 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     220A 003F 
     220C 0240 
     220E 03F4 
     2210 0050 
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
0084 2212 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     2214 003F 
     2216 0240 
     2218 03F4 
     221A 0050 
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
0013 221C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 221E 16FD             data  >16fd                 ; |         jne   mcloop
0015 2220 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 2222 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 2224 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0036 2226 0201  20         li    r1,mccode             ; Machinecode to patch
     2228 221C 
0037 222A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     222C 8322 
0038 222E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2230 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 2232 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 2234 045B  20         b     *r11                  ; Return to caller
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
0056 2236 C0F9  30 popr3   mov   *stack+,r3
0057 2238 C0B9  30 popr2   mov   *stack+,r2
0058 223A C079  30 popr1   mov   *stack+,r1
0059 223C C039  30 popr0   mov   *stack+,r0
0060 223E C2F9  30 poprt   mov   *stack+,r11
0061 2240 045B  20         b     *r11
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
0085 2242 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 2244 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 2246 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Sanity check
0090               *--------------------------------------------------------------
0091 2248 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 224A 1604  14         jne   filchk                ; No, continue checking
0093               
0094 224C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     224E FFCE 
0095 2250 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2252 2030 
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 2254 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     2256 830B 
     2258 830A 
0100               
0101 225A 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     225C 0001 
0102 225E 1602  14         jne   filchk2
0103 2260 DD05  32         movb  tmp1,*tmp0+
0104 2262 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 2264 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     2266 0002 
0109 2268 1603  14         jne   filchk3
0110 226A DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 226C DD05  32         movb  tmp1,*tmp0+
0112 226E 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2270 C1C4  18 filchk3 mov   tmp0,tmp3
0117 2272 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2274 0001 
0118 2276 1605  14         jne   fil16b
0119 2278 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 227A 0606  14         dec   tmp2
0121 227C 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     227E 0002 
0122 2280 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 2282 C1C6  18 fil16b  mov   tmp2,tmp3
0127 2284 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2286 0001 
0128 2288 1301  14         jeq   dofill
0129 228A 0606  14         dec   tmp2                  ; Make TMP2 even
0130 228C CD05  34 dofill  mov   tmp1,*tmp0+
0131 228E 0646  14         dect  tmp2
0132 2290 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 2292 C1C7  18         mov   tmp3,tmp3
0137 2294 1301  14         jeq   fil.exit
0138 2296 DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 2298 045B  20         b     *r11
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
0159 229A C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 229C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 229E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A0 0264  22 xfilv   ori   tmp0,>4000
     22A2 4000 
0166 22A4 06C4  14         swpb  tmp0
0167 22A6 D804  38         movb  tmp0,@vdpa
     22A8 8C02 
0168 22AA 06C4  14         swpb  tmp0
0169 22AC D804  38         movb  tmp0,@vdpa
     22AE 8C02 
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B0 020F  20         li    r15,vdpw              ; Set VDP write address
     22B2 8C00 
0174 22B4 06C5  14         swpb  tmp1
0175 22B6 C820  54         mov   @filzz,@mcloop        ; Setup move command
     22B8 22C0 
     22BA 8320 
0176 22BC 0460  28         b     @mcloop               ; Write data to VDP
     22BE 8320 
0177               *--------------------------------------------------------------
0181 22C0 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0201 22C2 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22C4 4000 
0202 22C6 06C4  14 vdra    swpb  tmp0
0203 22C8 D804  38         movb  tmp0,@vdpa
     22CA 8C02 
0204 22CC 06C4  14         swpb  tmp0
0205 22CE D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D0 8C02 
0206 22D2 045B  20         b     *r11                  ; Exit
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
0217 22D4 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22D6 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22D8 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22DA 4000 
0223 22DC 06C4  14         swpb  tmp0                  ; \
0224 22DE D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E0 8C02 
0225 22E2 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22E4 D804  38         movb  tmp0,@vdpa            ; /
     22E6 8C02 
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22E8 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22EA D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22EC 045B  20         b     *r11                  ; Exit
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
0251 22EE C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F0 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22F2 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22F4 8C02 
0257 22F6 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 22F8 D804  38         movb  tmp0,@vdpa            ; /
     22FA 8C02 
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 22FC D120  34         movb  @vdpr,tmp0            ; Read byte
     22FE 8800 
0263 2300 0984  56         srl   tmp0,8                ; Right align
0264 2302 045B  20         b     *r11                  ; Exit
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
0283 2304 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 2306 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2308 C144  18         mov   tmp0,tmp1
0289 230A 05C5  14         inct  tmp1
0290 230C D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 230E 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2310 FF00 
0292 2312 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 2314 C805  38         mov   tmp1,@wbase           ; Store calculated base
     2316 8328 
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2318 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     231A 8000 
0298 231C 0206  20         li    tmp2,8
     231E 0008 
0299 2320 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     2322 830B 
0300 2324 06C5  14         swpb  tmp1
0301 2326 D805  38         movb  tmp1,@vdpa
     2328 8C02 
0302 232A 06C5  14         swpb  tmp1
0303 232C D805  38         movb  tmp1,@vdpa
     232E 8C02 
0304 2330 0225  22         ai    tmp1,>0100
     2332 0100 
0305 2334 0606  14         dec   tmp2
0306 2336 16F4  14         jne   vidta1                ; Next register
0307 2338 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     233A 833A 
0308 233C 045B  20         b     *r11
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
0325 233E C13B  30 putvr   mov   *r11+,tmp0
0326 2340 0264  22 putvrx  ori   tmp0,>8000
     2342 8000 
0327 2344 06C4  14         swpb  tmp0
0328 2346 D804  38         movb  tmp0,@vdpa
     2348 8C02 
0329 234A 06C4  14         swpb  tmp0
0330 234C D804  38         movb  tmp0,@vdpa
     234E 8C02 
0331 2350 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 2352 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 2354 C10E  18         mov   r14,tmp0
0341 2356 0984  56         srl   tmp0,8
0342 2358 06A0  32         bl    @putvrx               ; Write VR#0
     235A 2340 
0343 235C 0204  20         li    tmp0,>0100
     235E 0100 
0344 2360 D820  54         movb  @r14lb,@tmp0lb
     2362 831D 
     2364 8309 
0345 2366 06A0  32         bl    @putvrx               ; Write VR#1
     2368 2340 
0346 236A 0458  20         b     *tmp4                 ; Exit
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
0360 236C C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 236E 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2370 C11B  26         mov   *r11,tmp0             ; Get P0
0363 2372 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     2374 7FFF 
0364 2376 2120  38         coc   @wbit0,tmp0
     2378 202A 
0365 237A 1604  14         jne   ldfnt1
0366 237C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     237E 8000 
0367 2380 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     2382 7FFF 
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 2384 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     2386 23EE 
0372 2388 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     238A 9C02 
0373 238C 06C4  14         swpb  tmp0
0374 238E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2390 9C02 
0375 2392 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     2394 9800 
0376 2396 06C5  14         swpb  tmp1
0377 2398 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     239A 9800 
0378 239C 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 239E D805  38         movb  tmp1,@grmwa
     23A0 9C02 
0383 23A2 06C5  14         swpb  tmp1
0384 23A4 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23A6 9C02 
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23A8 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23AA 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23AC 22C2 
0390 23AE 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B0 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23B2 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23B4 7FFF 
0393 23B6 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23B8 23F0 
0394 23BA C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23BC 23F2 
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23BE 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C0 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23C2 D120  34         movb  @grmrd,tmp0
     23C4 9800 
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23C6 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23C8 202A 
0405 23CA 1603  14         jne   ldfnt3                ; No, so skip
0406 23CC D1C4  18         movb  tmp0,tmp3
0407 23CE 0917  56         srl   tmp3,1
0408 23D0 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23D2 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23D4 8C00 
0413 23D6 0606  14         dec   tmp2
0414 23D8 16F2  14         jne   ldfnt2
0415 23DA 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23DC 020F  20         li    r15,vdpw              ; Set VDP write address
     23DE 8C00 
0417 23E0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23E2 7FFF 
0418 23E4 0458  20         b     *tmp4                 ; Exit
0419 23E6 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23E8 200A 
     23EA 8C00 
0420 23EC 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23EE 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F0 0200 
     23F2 0000 
0425 23F4 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23F6 01C0 
     23F8 0101 
0426 23FA 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     23FC 02A0 
     23FE 0101 
0427 2400 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     2402 00E0 
     2404 0101 
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
0445 2406 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2408 C3A0  34         mov   @wyx,r14              ; Get YX
     240A 832A 
0447 240C 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 240E 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2410 833A 
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 2412 C3A0  34         mov   @wyx,r14              ; Get YX
     2414 832A 
0454 2416 024E  22         andi  r14,>00ff             ; Remove Y
     2418 00FF 
0455 241A A3CE  18         a     r14,r15               ; pos = pos + X
0456 241C A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     241E 8328 
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2420 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 2422 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 2424 020F  20         li    r15,vdpw              ; VDP write address
     2426 8C00 
0463 2428 045B  20         b     *r11
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
0478 242A C17B  30 putstr  mov   *r11+,tmp1
0479 242C D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0480 242E C1CB  18 xutstr  mov   r11,tmp3
0481 2430 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     2432 2406 
0482 2434 C2C7  18         mov   tmp3,r11
0483 2436 0986  56         srl   tmp2,8                ; Right justify length byte
0484               *--------------------------------------------------------------
0485               * Put string
0486               *--------------------------------------------------------------
0487 2438 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0488 243A 1305  14         jeq   !                     ; Yes, crash and burn
0489               
0490 243C 0286  22         ci    tmp2,255              ; Length > 255 ?
     243E 00FF 
0491 2440 1502  14         jgt   !                     ; Yes, crash and burn
0492               
0493 2442 0460  28         b     @xpym2v               ; Display string
     2444 245C 
0494               *--------------------------------------------------------------
0495               * Crash handler
0496               *--------------------------------------------------------------
0497 2446 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2448 FFCE 
0498 244A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     244C 2030 
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
0514 244E C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2450 832A 
0515 2452 0460  28         b     @putstr
     2454 242A 
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
0020 2456 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 2458 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 245A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Sanity check
0025               *--------------------------------------------------------------
0026 245C C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 245E 1604  14         jne   !                     ; No, continue
0028               
0029 2460 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2462 FFCE 
0030 2464 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2466 2030 
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 2468 0264  22 !       ori   tmp0,>4000
     246A 4000 
0035 246C 06C4  14         swpb  tmp0
0036 246E D804  38         movb  tmp0,@vdpa
     2470 8C02 
0037 2472 06C4  14         swpb  tmp0
0038 2474 D804  38         movb  tmp0,@vdpa
     2476 8C02 
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 2478 020F  20         li    r15,vdpw              ; Set VDP write address
     247A 8C00 
0043 247C C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     247E 2486 
     2480 8320 
0044 2482 0460  28         b     @mcloop               ; Write data to VDP and return
     2484 8320 
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 2486 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 2488 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 248A C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 248C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 248E 06C4  14 xpyv2m  swpb  tmp0
0027 2490 D804  38         movb  tmp0,@vdpa
     2492 8C02 
0028 2494 06C4  14         swpb  tmp0
0029 2496 D804  38         movb  tmp0,@vdpa
     2498 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 249A 020F  20         li    r15,vdpr              ; Set VDP read address
     249C 8800 
0034 249E C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24A0 24A8 
     24A2 8320 
0035 24A4 0460  28         b     @mcloop               ; Read data from VDP
     24A6 8320 
0036 24A8 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 24AA C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24AC C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24AE C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24B0 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24B2 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24B4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24B6 FFCE 
0034 24B8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24BA 2030 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 24BC 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     24BE 0001 
0039 24C0 1603  14         jne   cpym0                 ; No, continue checking
0040 24C2 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 24C4 04C6  14         clr   tmp2                  ; Reset counter
0042 24C6 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 24C8 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     24CA 7FFF 
0047 24CC C1C4  18         mov   tmp0,tmp3
0048 24CE 0247  22         andi  tmp3,1
     24D0 0001 
0049 24D2 1618  14         jne   cpyodd                ; Odd source address handling
0050 24D4 C1C5  18 cpym1   mov   tmp1,tmp3
0051 24D6 0247  22         andi  tmp3,1
     24D8 0001 
0052 24DA 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 24DC 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     24DE 202A 
0057 24E0 1605  14         jne   cpym3
0058 24E2 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     24E4 250A 
     24E6 8320 
0059 24E8 0460  28         b     @mcloop               ; Copy memory and exit
     24EA 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 24EC C1C6  18 cpym3   mov   tmp2,tmp3
0064 24EE 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     24F0 0001 
0065 24F2 1301  14         jeq   cpym4
0066 24F4 0606  14         dec   tmp2                  ; Make TMP2 even
0067 24F6 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 24F8 0646  14         dect  tmp2
0069 24FA 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 24FC C1C7  18         mov   tmp3,tmp3
0074 24FE 1301  14         jeq   cpymz
0075 2500 D554  38         movb  *tmp0,*tmp1
0076 2502 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2504 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     2506 8000 
0081 2508 10E9  14         jmp   cpym2
0082 250A DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
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
0062 250C C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 250E 0649  14         dect  stack
0065 2510 C64B  30         mov   r11,*stack            ; Push return address
0066 2512 0649  14         dect  stack
0067 2514 C640  30         mov   r0,*stack             ; Push r0
0068 2516 0649  14         dect  stack
0069 2518 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 251A 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 251C 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 251E 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2520 4000 
0077 2522 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2524 833E 
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 2526 020C  20         li    r12,>1e00             ; SAMS CRU address
     2528 1E00 
0082 252A 04C0  14         clr   r0
0083 252C 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 252E D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2530 D100  18         movb  r0,tmp0
0086 2532 0984  56         srl   tmp0,8                ; Right align
0087 2534 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     2536 833C 
0088 2538 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 253A C339  30         mov   *stack+,r12           ; Pop r12
0094 253C C039  30         mov   *stack+,r0            ; Pop r0
0095 253E C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2540 045B  20         b     *r11                  ; Return to caller
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
0131 2542 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2544 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 2546 0649  14         dect  stack
0135 2548 C64B  30         mov   r11,*stack            ; Push return address
0136 254A 0649  14         dect  stack
0137 254C C640  30         mov   r0,*stack             ; Push r0
0138 254E 0649  14         dect  stack
0139 2550 C64C  30         mov   r12,*stack            ; Push r12
0140 2552 0649  14         dect  stack
0141 2554 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 2556 0649  14         dect  stack
0143 2558 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 255A 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 255C 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS page number
0151               *--------------------------------------------------------------
0152 255E 0284  22         ci    tmp0,255              ; Crash if page > 255
     2560 00FF 
0153 2562 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Sanity check on SAMS register
0156               *--------------------------------------------------------------
0157 2564 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     2566 001E 
0158 2568 150A  14         jgt   !
0159 256A 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     256C 0004 
0160 256E 1107  14         jlt   !
0161 2570 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     2572 0012 
0162 2574 1508  14         jgt   sams.page.set.switch_page
0163 2576 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     2578 0006 
0164 257A 1501  14         jgt   !
0165 257C 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 257E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2580 FFCE 
0170 2582 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2584 2030 
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 2586 020C  20         li    r12,>1e00             ; SAMS CRU address
     2588 1E00 
0176 258A C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 258C 06C0  14         swpb  r0                    ; LSB to MSB
0178 258E 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 2590 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     2592 4000 
0180 2594 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 2596 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 2598 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 259A C339  30         mov   *stack+,r12           ; Pop r12
0188 259C C039  30         mov   *stack+,r0            ; Pop r0
0189 259E C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25A0 045B  20         b     *r11                  ; Return to caller
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
0204 25A2 020C  20         li    r12,>1e00             ; SAMS CRU address
     25A4 1E00 
0205 25A6 1D01  20         sbo   1                     ; Enable SAMS mapper
0206               *--------------------------------------------------------------
0207               * Exit
0208               *--------------------------------------------------------------
0209               sams.mapping.on.exit:
0210 25A8 045B  20         b     *r11                  ; Return to caller
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
0227 25AA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25AC 1E00 
0228 25AE 1E01  20         sbz   1                     ; Disable SAMS mapper
0229               *--------------------------------------------------------------
0230               * Exit
0231               *--------------------------------------------------------------
0232               sams.mapping.off.exit:
0233 25B0 045B  20         b     *r11                  ; Return to caller
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
0260 25B2 C1FB  30         mov   *r11+,tmp3            ; Get P0
0261               xsams.layout:
0262 25B4 0649  14         dect  stack
0263 25B6 C64B  30         mov   r11,*stack            ; Save return address
0264 25B8 0649  14         dect  stack
0265 25BA C644  30         mov   tmp0,*stack           ; Save tmp0
0266 25BC 0649  14         dect  stack
0267 25BE C645  30         mov   tmp1,*stack           ; Save tmp1
0268 25C0 0649  14         dect  stack
0269 25C2 C646  30         mov   tmp2,*stack           ; Save tmp2
0270 25C4 0649  14         dect  stack
0271 25C6 C647  30         mov   tmp3,*stack           ; Save tmp3
0272                       ;------------------------------------------------------
0273                       ; Initialize
0274                       ;------------------------------------------------------
0275 25C8 0206  20         li    tmp2,8                ; Set loop counter
     25CA 0008 
0276                       ;------------------------------------------------------
0277                       ; Set SAMS memory pages
0278                       ;------------------------------------------------------
0279               sams.layout.loop:
0280 25CC C177  30         mov   *tmp3+,tmp1           ; Get memory address
0281 25CE C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0282               
0283 25D0 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     25D2 2546 
0284                                                   ; | i  tmp0 = SAMS page
0285                                                   ; / i  tmp1 = Memory address
0286               
0287 25D4 0606  14         dec   tmp2                  ; Next iteration
0288 25D6 16FA  14         jne   sams.layout.loop      ; Loop until done
0289                       ;------------------------------------------------------
0290                       ; Exit
0291                       ;------------------------------------------------------
0292               sams.init.exit:
0293 25D8 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     25DA 25A2 
0294                                                   ; / activating changes.
0295               
0296 25DC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0297 25DE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0298 25E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0299 25E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0300 25E4 C2F9  30         mov   *stack+,r11           ; Pop r11
0301 25E6 045B  20         b     *r11                  ; Return to caller
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
0318 25E8 0649  14         dect  stack
0319 25EA C64B  30         mov   r11,*stack            ; Save return address
0320                       ;------------------------------------------------------
0321                       ; Set SAMS standard layout
0322                       ;------------------------------------------------------
0323 25EC 06A0  32         bl    @sams.layout
     25EE 25B2 
0324 25F0 25F6                   data sams.layout.standard
0325                       ;------------------------------------------------------
0326                       ; Exit
0327                       ;------------------------------------------------------
0328               sams.layout.reset.exit:
0329 25F2 C2F9  30         mov   *stack+,r11           ; Pop r11
0330 25F4 045B  20         b     *r11                  ; Return to caller
0331               ***************************************************************
0332               * SAMS standard page layout table (16 words)
0333               *--------------------------------------------------------------
0334               sams.layout.standard:
0335 25F6 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     25F8 0002 
0336 25FA 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     25FC 0003 
0337 25FE A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     2600 000A 
0338 2602 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     2604 000B 
0339 2606 C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     2608 000C 
0340 260A D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     260C 000D 
0341 260E E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     2610 000E 
0342 2612 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     2614 000F 
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
0363 2616 C1FB  30         mov   *r11+,tmp3            ; Get P0
0364               
0365 2618 0649  14         dect  stack
0366 261A C64B  30         mov   r11,*stack            ; Push return address
0367 261C 0649  14         dect  stack
0368 261E C644  30         mov   tmp0,*stack           ; Push tmp0
0369 2620 0649  14         dect  stack
0370 2622 C645  30         mov   tmp1,*stack           ; Push tmp1
0371 2624 0649  14         dect  stack
0372 2626 C646  30         mov   tmp2,*stack           ; Push tmp2
0373 2628 0649  14         dect  stack
0374 262A C647  30         mov   tmp3,*stack           ; Push tmp3
0375                       ;------------------------------------------------------
0376                       ; Copy SAMS layout
0377                       ;------------------------------------------------------
0378 262C 0205  20         li    tmp1,sams.layout.copy.data
     262E 264E 
0379 2630 0206  20         li    tmp2,8                ; Set loop counter
     2632 0008 
0380                       ;------------------------------------------------------
0381                       ; Set SAMS memory pages
0382                       ;------------------------------------------------------
0383               sams.layout.copy.loop:
0384 2634 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0385 2636 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2638 250E 
0386                                                   ; | i  tmp0   = Memory address
0387                                                   ; / o  @waux1 = SAMS page
0388               
0389 263A CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     263C 833C 
0390               
0391 263E 0606  14         dec   tmp2                  ; Next iteration
0392 2640 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0393                       ;------------------------------------------------------
0394                       ; Exit
0395                       ;------------------------------------------------------
0396               sams.layout.copy.exit:
0397 2642 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0398 2644 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0399 2646 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 2648 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 264A C2F9  30         mov   *stack+,r11           ; Pop r11
0402 264C 045B  20         b     *r11                  ; Return to caller
0403               ***************************************************************
0404               * SAMS memory range table (8 words)
0405               *--------------------------------------------------------------
0406               sams.layout.copy.data:
0407 264E 2000             data  >2000                 ; >2000-2fff
0408 2650 3000             data  >3000                 ; >3000-3fff
0409 2652 A000             data  >a000                 ; >a000-afff
0410 2654 B000             data  >b000                 ; >b000-bfff
0411 2656 C000             data  >c000                 ; >c000-cfff
0412 2658 D000             data  >d000                 ; >d000-dfff
0413 265A E000             data  >e000                 ; >e000-efff
0414 265C F000             data  >f000                 ; >f000-ffff
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
0009 265E 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     2660 FFBF 
0010 2662 0460  28         b     @putv01
     2664 2352 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 2666 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     2668 0040 
0018 266A 0460  28         b     @putv01
     266C 2352 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 266E 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     2670 FFDF 
0026 2672 0460  28         b     @putv01
     2674 2352 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 2676 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     2678 0020 
0034 267A 0460  28         b     @putv01
     267C 2352 
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
0010 267E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     2680 FFFE 
0011 2682 0460  28         b     @putv01
     2684 2352 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 2686 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     2688 0001 
0019 268A 0460  28         b     @putv01
     268C 2352 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 268E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     2690 FFFD 
0027 2692 0460  28         b     @putv01
     2694 2352 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 2696 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     2698 0002 
0035 269A 0460  28         b     @putv01
     269C 2352 
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
0018 269E C83B  50 at      mov   *r11+,@wyx
     26A0 832A 
0019 26A2 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26A4 B820  54 down    ab    @hb$01,@wyx
     26A6 201C 
     26A8 832A 
0028 26AA 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26AC 7820  54 up      sb    @hb$01,@wyx
     26AE 201C 
     26B0 832A 
0037 26B2 045B  20         b     *r11
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
0049 26B4 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26B6 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26B8 832A 
0051 26BA C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26BC 832A 
0052 26BE 045B  20         b     *r11
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
0021 26C0 C120  34 yx2px   mov   @wyx,tmp0
     26C2 832A 
0022 26C4 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 26C6 06C4  14         swpb  tmp0                  ; Y<->X
0024 26C8 04C5  14         clr   tmp1                  ; Clear before copy
0025 26CA D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 26CC 20A0  38         coc   @wbit1,config         ; f18a present ?
     26CE 2028 
0030 26D0 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 26D2 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     26D4 833A 
     26D6 2700 
0032 26D8 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 26DA 0A15  56         sla   tmp1,1                ; X = X * 2
0035 26DC B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 26DE 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     26E0 0500 
0037 26E2 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 26E4 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 26E6 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 26E8 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 26EA D105  18         movb  tmp1,tmp0
0051 26EC 06C4  14         swpb  tmp0                  ; X<->Y
0052 26EE 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     26F0 202A 
0053 26F2 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 26F4 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     26F6 201C 
0059 26F8 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     26FA 202E 
0060 26FC 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 26FE 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 2700 0050            data   80
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
0013 2702 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2704 06A0  32         bl    @putvr                ; Write once
     2706 233E 
0015 2708 391C             data  >391c                 ; VR1/57, value 00011100
0016 270A 06A0  32         bl    @putvr                ; Write twice
     270C 233E 
0017 270E 391C             data  >391c                 ; VR1/57, value 00011100
0018 2710 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 2712 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 2714 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2716 233E 
0028 2718 391C             data  >391c
0029 271A 0458  20         b     *tmp4                 ; Exit
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
0040 271C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 271E 06A0  32         bl    @cpym2v
     2720 2456 
0042 2722 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     2724 2760 
     2726 0006 
0043 2728 06A0  32         bl    @putvr
     272A 233E 
0044 272C 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 272E 06A0  32         bl    @putvr
     2730 233E 
0046 2732 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 2734 0204  20         li    tmp0,>3f00
     2736 3F00 
0052 2738 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     273A 22C6 
0053 273C D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     273E 8800 
0054 2740 0984  56         srl   tmp0,8
0055 2742 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2744 8800 
0056 2746 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 2748 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 274A 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     274C BFFF 
0060 274E 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 2750 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     2752 4000 
0063               f18chk_exit:
0064 2754 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     2756 229A 
0065 2758 3F00             data  >3f00,>00,6
     275A 0000 
     275C 0006 
0066 275E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 2760 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 2762 3F00             data  >3f00                 ; 3f02 / 3f00
0073 2764 0340             data  >0340                 ; 3f04   0340  idle
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
0092 2766 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 2768 06A0  32         bl    @putvr
     276A 233E 
0097 276C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 276E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     2770 233E 
0100 2772 391C             data  >391c                 ; Lock the F18a
0101 2774 0458  20         b     *tmp4                 ; Exit
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
0120 2776 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 2778 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     277A 2028 
0122 277C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 277E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     2780 8802 
0127 2782 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     2784 233E 
0128 2786 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 2788 04C4  14         clr   tmp0
0130 278A D120  34         movb  @vdps,tmp0
     278C 8802 
0131 278E 0984  56         srl   tmp0,8
0132 2790 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 2792 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     2794 832A 
0018 2796 D17B  28         movb  *r11+,tmp1
0019 2798 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 279A D1BB  28         movb  *r11+,tmp2
0021 279C 0986  56         srl   tmp2,8                ; Repeat count
0022 279E C1CB  18         mov   r11,tmp3
0023 27A0 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27A2 2406 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27A4 020B  20         li    r11,hchar1
     27A6 27AC 
0028 27A8 0460  28         b     @xfilv                ; Draw
     27AA 22A0 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 27AC 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     27AE 202C 
0033 27B0 1302  14         jeq   hchar2                ; Yes, exit
0034 27B2 C2C7  18         mov   tmp3,r11
0035 27B4 10EE  14         jmp   hchar                 ; Next one
0036 27B6 05C7  14 hchar2  inct  tmp3
0037 27B8 0457  20         b     *tmp3                 ; Exit
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
0016 27BA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     27BC 202A 
0017 27BE 020C  20         li    r12,>0024
     27C0 0024 
0018 27C2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     27C4 2856 
0019 27C6 04C6  14         clr   tmp2
0020 27C8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 27CA 04CC  14         clr   r12
0025 27CC 1F08  20         tb    >0008                 ; Shift-key ?
0026 27CE 1302  14         jeq   realk1                ; No
0027 27D0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     27D2 2886 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 27D4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 27D6 1302  14         jeq   realk2                ; No
0033 27D8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     27DA 28B6 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 27DC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 27DE 1302  14         jeq   realk3                ; No
0039 27E0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     27E2 28E6 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 27E4 40A0  34 realk3  szc   @wbit10,config        ; CONFIG register bit 10=0
     27E6 2016 
0044 27E8 1E15  20         sbz   >0015                 ; Set P5
0045 27EA 1F07  20         tb    >0007                 ; ALPHA-Lock key down?
0046 27EC 1302  14         jeq   realk4                ; No
0047 27EE E0A0  34         soc   @wbit10,config        ; Yes, CONFIG register bit 10=1
     27F0 2016 
0048               *--------------------------------------------------------------
0049               * Scan keyboard column
0050               *--------------------------------------------------------------
0051 27F2 1D15  20 realk4  sbo   >0015                 ; Reset P5
0052 27F4 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     27F6 0006 
0053 27F8 0606  14 realk5  dec   tmp2
0054 27FA 020C  20         li    r12,>24               ; CRU address for P2-P4
     27FC 0024 
0055 27FE 06C6  14         swpb  tmp2
0056 2800 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0057 2802 06C6  14         swpb  tmp2
0058 2804 020C  20         li    r12,6                 ; CRU read address
     2806 0006 
0059 2808 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0060 280A 0547  14         inv   tmp3                  ;
0061 280C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     280E FF00 
0062               *--------------------------------------------------------------
0063               * Scan keyboard row
0064               *--------------------------------------------------------------
0065 2810 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0066 2812 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombos scanned by shifting left.
0067 2814 1807  14         joc   realk8                ; If no carry after 8 loops, then no key
0068 2816 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0069 2818 0285  22         ci    tmp1,8
     281A 0008 
0070 281C 1AFA  14         jl    realk6
0071 281E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0072 2820 1BEB  14         jh    realk5                ; No, next column
0073 2822 1016  14         jmp   realkz                ; Yes, exit
0074               *--------------------------------------------------------------
0075               * Check for match in data table
0076               *--------------------------------------------------------------
0077 2824 C206  18 realk8  mov   tmp2,tmp4
0078 2826 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0079 2828 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0080 282A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base addr of data table(R15)
0081 282C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0082 282E 13F3  14         jeq   realk7                ; Yes, discard & continue scanning
0083                                                   ; (FCTN, SHIFT, CTRL)
0084               *--------------------------------------------------------------
0085               * Determine ASCII value of key
0086               *--------------------------------------------------------------
0087 2830 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0088 2832 20A0  38         coc   @wbit10,config        ; ALPHA-Lock key down ?
     2834 2016 
0089 2836 1608  14         jne   realka                ; No, continue saving key
0090 2838 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     283A 2880 
0091 283C 1A05  14         jl    realka
0092 283E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     2840 287E 
0093 2842 1B02  14         jh    realka                ; No, continue
0094 2844 0226  22         ai    tmp2,->2000           ; ASCII = ASCII-32 (lowercase to uppercase!)
     2846 E000 
0095 2848 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     284A 833C 
0096 284C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     284E 2014 
0097 2850 020F  20 realkz  li    r15,vdpw              ; \ Setup VDP write address again after
     2852 8C00 
0098                                                   ; / using R15 as temp storage
0099 2854 045B  20         b     *r11                  ; Exit
0100               ********|*****|*********************|**************************
0101 2856 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     2858 0000 
     285A FF0D 
     285C 203D 
0102 285E ....             text  'xws29ol.'
0103 2866 ....             text  'ced38ik,'
0104 286E ....             text  'vrf47ujm'
0105 2876 ....             text  'btg56yhn'
0106 287E ....             text  'zqa10p;/'
0107 2886 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     2888 0000 
     288A FF0D 
     288C 202B 
0108 288E ....             text  'XWS@(OL>'
0109 2896 ....             text  'CED#*IK<'
0110 289E ....             text  'VRF$&UJM'
0111 28A6 ....             text  'BTG%^YHN'
0112 28AE ....             text  'ZQA!)P:-'
0113 28B6 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     28B8 0000 
     28BA FF0D 
     28BC 2005 
0114 28BE 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     28C0 0804 
     28C2 0F27 
     28C4 C2B9 
0115 28C6 600B             data  >600b,>0907,>063f,>c1B8
     28C8 0907 
     28CA 063F 
     28CC C1B8 
0116 28CE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     28D0 7B02 
     28D2 015F 
     28D4 C0C3 
0117 28D6 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     28D8 7D0E 
     28DA 0CC6 
     28DC BFC4 
0118 28DE 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     28E0 7C03 
     28E2 BC22 
     28E4 BDBA 
0119 28E6 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     28E8 0000 
     28EA FF0D 
     28EC 209D 
0120 28EE 9897             data  >9897,>93b2,>9f8f,>8c9B
     28F0 93B2 
     28F2 9F8F 
     28F4 8C9B 
0121 28F6 8385             data  >8385,>84b3,>9e89,>8b80
     28F8 84B3 
     28FA 9E89 
     28FC 8B80 
0122 28FE 9692             data  >9692,>86b4,>b795,>8a8D
     2900 86B4 
     2902 B795 
     2904 8A8D 
0123 2906 8294             data  >8294,>87b5,>b698,>888E
     2908 87B5 
     290A B698 
     290C 888E 
0124 290E 9A91             data  >9a91,>81b1,>b090,>9cBB
     2910 81B1 
     2912 B090 
     2914 9CBB 
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
0023 2916 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 2918 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     291A 8340 
0025 291C 04E0  34         clr   @waux1
     291E 833C 
0026 2920 04E0  34         clr   @waux2
     2922 833E 
0027 2924 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     2926 833C 
0028 2928 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 292A 0205  20         li    tmp1,4                ; 4 nibbles
     292C 0004 
0033 292E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2930 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2932 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 2934 0286  22         ci    tmp2,>000a
     2936 000A 
0039 2938 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 293A C21B  26         mov   *r11,tmp4
0045 293C 0988  56         srl   tmp4,8                ; Right justify
0046 293E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2940 FFF6 
0047 2942 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 2944 C21B  26         mov   *r11,tmp4
0054 2946 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     2948 00FF 
0055               
0056 294A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 294C 06C6  14         swpb  tmp2
0058 294E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2950 0944  56         srl   tmp0,4                ; Next nibble
0060 2952 0605  14         dec   tmp1
0061 2954 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 2956 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     2958 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 295A C160  34         mov   @waux3,tmp1           ; Get pointer
     295C 8340 
0067 295E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2960 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2962 C120  34         mov   @waux2,tmp0
     2964 833E 
0070 2966 06C4  14         swpb  tmp0
0071 2968 DD44  32         movb  tmp0,*tmp1+
0072 296A 06C4  14         swpb  tmp0
0073 296C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 296E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2970 8340 
0078 2972 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     2974 2020 
0079 2976 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 2978 C120  34         mov   @waux1,tmp0
     297A 833C 
0084 297C 06C4  14         swpb  tmp0
0085 297E DD44  32         movb  tmp0,*tmp1+
0086 2980 06C4  14         swpb  tmp0
0087 2982 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 2984 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     2986 202A 
0092 2988 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 298A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 298C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     298E 7FFF 
0098 2990 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     2992 8340 
0099 2994 0460  28         b     @xutst0               ; Display string
     2996 242C 
0100 2998 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 299A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     299C 832A 
0122 299E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29A0 8000 
0123 29A2 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 29A4 0207  20 mknum   li    tmp3,5                ; Digit counter
     29A6 0005 
0020 29A8 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29AA C155  26         mov   *tmp1,tmp1            ; /
0022 29AC C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29AE 0228  22         ai    tmp4,4                ; Get end of buffer
     29B0 0004 
0024 29B2 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29B4 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29B6 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29B8 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29BA 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29BC B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29BE D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29C0 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29C2 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29C4 0607  14         dec   tmp3                  ; Decrease counter
0036 29C6 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29C8 0207  20         li    tmp3,4                ; Check first 4 digits
     29CA 0004 
0041 29CC 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29CE C11B  26         mov   *r11,tmp0
0043 29D0 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29D2 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29D4 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29D6 05CB  14 mknum3  inct  r11
0047 29D8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29DA 202A 
0048 29DC 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29DE 045B  20         b     *r11                  ; Exit
0050 29E0 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29E2 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29E4 13F8  14         jeq   mknum3                ; Yes, exit
0053 29E6 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29E8 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     29EA 7FFF 
0058 29EC C10B  18         mov   r11,tmp0
0059 29EE 0224  22         ai    tmp0,-4
     29F0 FFFC 
0060 29F2 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 29F4 0206  20         li    tmp2,>0500            ; String length = 5
     29F6 0500 
0062 29F8 0460  28         b     @xutstr               ; Display string
     29FA 242E 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1
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
0083               *  Before...:   XXXXX
0084               *  After....:   XXXXX|zY       where length byte z=1
0085               *               XXXXX|zYY      where length byte z=2
0086               *                 ..
0087               *               XXXXX|zYYYYY   where length byte z=5
0088               *--------------------------------------------------------------
0089               *  Destroys registers tmp0-tmp3
0090               ********|*****|*********************|**************************
0091               trimnum:
0092 29FC C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 29FE C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 2A00 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 2A02 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 2A04 0207  20         li    tmp3,5                ; Set counter
     2A06 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 2A08 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 2A0A 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 2A0C 0584  14         inc   tmp0                  ; Next character
0104 2A0E 0607  14         dec   tmp3                  ; Last digit reached ?
0105 2A10 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 2A12 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 2A14 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 2A16 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 2A18 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 2A1A DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 2A1C 0607  14         dec   tmp3                  ; Last character ?
0120 2A1E 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 2A20 045B  20         b     *r11                  ; Return
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * PUTNUM - Put unsigned number on screen
0128               ***************************************************************
0129               *  BL   @PUTNUM
0130               *  DATA P0,P1,P2,P3
0131               *--------------------------------------------------------------
0132               *  P0   = YX position
0133               *  P1   = Pointer to 16 bit unsigned number
0134               *  P2   = Pointer to 5 byte string buffer
0135               *  P3HB = Offset for ASCII digit
0136               *  P3LB = Character for replacing leading 0's
0137               ********|*****|*********************|**************************
0138 2A22 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A24 832A 
0139 2A26 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A28 8000 
0140 2A2A 10BC  14         jmp   mknum                 ; Convert number and display
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
0022 2A2C 0649  14         dect  stack
0023 2A2E C64B  30         mov   r11,*stack            ; Save return address
0024 2A30 0649  14         dect  stack
0025 2A32 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A34 0649  14         dect  stack
0027 2A36 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A38 0649  14         dect  stack
0029 2A3A C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A3C 0649  14         dect  stack
0031 2A3E C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A40 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A42 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A44 C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A46 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A48 0649  14         dect  stack
0044 2A4A C64B  30         mov   r11,*stack            ; Save return address
0045 2A4C 0649  14         dect  stack
0046 2A4E C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A50 0649  14         dect  stack
0048 2A52 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A54 0649  14         dect  stack
0050 2A56 C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A58 0649  14         dect  stack
0052 2A5A C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A5C C1D4  26 !       mov   *tmp0,tmp3
0057 2A5E 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A60 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A62 00FF 
0059 2A64 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A66 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A68 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A6A 0584  14         inc   tmp0                  ; Next byte
0067 2A6C 0607  14         dec   tmp3                  ; Shorten string length
0068 2A6E 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A70 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A72 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A74 C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A76 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A78 C187  18         mov   tmp3,tmp2
0078 2A7A 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A7C DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A7E 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A80 24B0 
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A82 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A84 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A86 FFCE 
0090 2A88 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2A8A 2030 
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2A8C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2A8E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2A90 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2A92 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2A94 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2A96 045B  20         b     *r11                  ; Return to caller
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
0123 2A98 0649  14         dect  stack
0124 2A9A C64B  30         mov   r11,*stack            ; Save return address
0125 2A9C 05D9  26         inct  *stack                ; Skip "data P0"
0126 2A9E 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AA0 0649  14         dect  stack
0128 2AA2 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2AA4 0649  14         dect  stack
0130 2AA6 C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2AA8 0649  14         dect  stack
0132 2AAA C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AAC C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AAE C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AB0 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AB2 0649  14         dect  stack
0144 2AB4 C64B  30         mov   r11,*stack            ; Save return address
0145 2AB6 0649  14         dect  stack
0146 2AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2ABA 0649  14         dect  stack
0148 2ABC C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2ABE 0649  14         dect  stack
0150 2AC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AC2 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2AC4 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2AC6 0586  14         inc   tmp2
0161 2AC8 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2ACA 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Sanity check on string length
0165                       ;-----------------------------------------------------------------------
0166 2ACC 0286  22         ci    tmp2,255
     2ACE 00FF 
0167 2AD0 1505  14         jgt   string.getlenc.panic
0168 2AD2 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AD4 0606  14         dec   tmp2                  ; One time adjustment
0174 2AD6 C806  38         mov   tmp2,@waux1           ; Store length
     2AD8 833C 
0175 2ADA 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2ADC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2ADE FFCE 
0181 2AE0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AE2 2030 
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AE4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AE6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AE8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2AEA C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2AEC 045B  20         b     *r11                  ; Return to caller
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
0056 2AEE A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2AF0 2AF2             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2AF2 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2AF4 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2AF6 A428 
0064 2AF8 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2AFA 2026 
0065 2AFC C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2AFE 8356 
0066 2B00 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2B02 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2B04 FFF8 
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2B06 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2B08 A434 
0073                       ;---------------------------; Inline VSBR start
0074 2B0A 06C0  14         swpb  r0                    ;
0075 2B0C D800  38         movb  r0,@vdpa              ; Send low byte
     2B0E 8C02 
0076 2B10 06C0  14         swpb  r0                    ;
0077 2B12 D800  38         movb  r0,@vdpa              ; Send high byte
     2B14 8C02 
0078 2B16 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2B18 8800 
0079                       ;---------------------------; Inline VSBR end
0080 2B1A 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2B1C 0704  14         seto  r4                    ; Init counter
0086 2B1E 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2B20 A420 
0087 2B22 0580  14 !       inc   r0                    ; Point to next char of name
0088 2B24 0584  14         inc   r4                    ; Increment char counter
0089 2B26 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2B28 0007 
0090 2B2A 1571  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2B2C 80C4  18         c     r4,r3                 ; End of name?
0093 2B2E 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2B30 06C0  14         swpb  r0                    ;
0098 2B32 D800  38         movb  r0,@vdpa              ; Send low byte
     2B34 8C02 
0099 2B36 06C0  14         swpb  r0                    ;
0100 2B38 D800  38         movb  r0,@vdpa              ; Send high byte
     2B3A 8C02 
0101 2B3C D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2B3E 8800 
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2B40 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2B42 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2B44 2C5A 
0109 2B46 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2B48 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2B4A 1361  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2B4C 04E0  34         clr   @>83d0
     2B4E 83D0 
0118 2B50 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2B52 8354 
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2B54 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2B56 A432 
0121               
0122 2B58 0584  14         inc   r4                    ; Adjust for dot
0123 2B5A A804  38         a     r4,@>8356             ; Point to position after name
     2B5C 8356 
0124 2B5E C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2B60 8356 
     2B62 A42E 
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2B64 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2B66 83E0 
0130 2B68 04C1  14         clr   r1                    ; Version found of dsr
0131 2B6A 020C  20         li    r12,>0f00             ; Init cru address
     2B6C 0F00 
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2B6E C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2B70 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2B72 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2B74 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2B76 0100 
0145 2B78 04E0  34         clr   @>83d0                ; Clear in case we are done
     2B7A 83D0 
0146 2B7C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2B7E 2000 
0147 2B80 1344  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2B82 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2B84 83D0 
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2B86 1D00  20         sbo   0                     ; Turn on ROM
0154 2B88 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2B8A 4000 
0155 2B8C 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2B8E 2C56 
0156 2B90 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2B92 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2B94 A40A 
0166 2B96 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2B98 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2B9A 83D2 
0172                                                   ; subprogram
0173               
0174 2B9C 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2B9E C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2BA0 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2BA2 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2BA4 83D2 
0183                                                   ; subprogram
0184               
0185 2BA6 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2BA8 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2BAA 04C5  14         clr   r5                    ; Remove any old stuff
0194 2BAC D160  34         movb  @>8355,r5             ; Get length as counter
     2BAE 8355 
0195 2BB0 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2BB2 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2BB4 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2BB6 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2BB8 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BBA A420 
0206 2BBC 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2BBE 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2BC0 0605  14         dec   r5                    ; Update loop counter
0211 2BC2 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2BC4 0581  14         inc   r1                    ; Next version found
0217 2BC6 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2BC8 A42A 
0218 2BCA C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2BCC A42C 
0219 2BCE C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2BD0 A430 
0220               
0221 2BD2 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2BD4 8C02 
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2BD6 0699  24         bl    *r9                   ; Execute DSR
0225                       ;
0226                       ; Depending on IO result the DSR in card ROM does RET
0227                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0228                       ;
0229 2BD8 10DF  14         jmp   dsrlnk.dsrscan.nextentry
0230                                                   ; (1) error return
0231 2BDA 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0232 2BDC 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2BDE A400 
0233 2BE0 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0234                       ;------------------------------------------------------
0235                       ; Returned from DSR
0236                       ;------------------------------------------------------
0237               dsrlnk.dsrscan.return_dsr:
0238 2BE2 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2BE4 A428 
0239                                                   ; (8 or >a)
0240 2BE6 0281  22         ci    r1,8                  ; was it 8?
     2BE8 0008 
0241 2BEA 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0242 2BEC D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2BEE 8350 
0243                                                   ; Get error byte from @>8350
0244 2BF0 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0245               
0246                       ;------------------------------------------------------
0247                       ; Read VDP PAB byte 1 after DSR call completed (status)
0248                       ;------------------------------------------------------
0249               dsrlnk.dsrscan.dsr.8:
0250                       ;---------------------------; Inline VSBR start
0251 2BF2 06C0  14         swpb  r0                    ;
0252 2BF4 D800  38         movb  r0,@vdpa              ; send low byte
     2BF6 8C02 
0253 2BF8 06C0  14         swpb  r0                    ;
0254 2BFA D800  38         movb  r0,@vdpa              ; send high byte
     2BFC 8C02 
0255 2BFE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2C00 8800 
0256                       ;---------------------------; Inline VSBR end
0257               
0258                       ;------------------------------------------------------
0259                       ; Return DSR error to caller
0260                       ;------------------------------------------------------
0261               dsrlnk.dsrscan.dsr.a:
0262 2C02 09D1  56         srl   r1,13                 ; just keep error bits
0263 2C04 1605  14         jne   dsrlnk.error.io_error
0264                                                   ; handle IO error
0265 2C06 0380  18         rtwp                        ; Return from DSR workspace to caller
0266                                                   ; workspace
0267               
0268                       ;------------------------------------------------------
0269                       ; IO-error handler
0270                       ;------------------------------------------------------
0271               dsrlnk.error.nodsr_found_off:
0272 2C08 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0273               dsrlnk.error.nodsr_found:
0274 2C0A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2C0C A400 
0275               dsrlnk.error.devicename_invalid:
0276 2C0E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0277               dsrlnk.error.io_error:
0278 2C10 06C1  14         swpb  r1                    ; put error in hi byte
0279 2C12 D741  30         movb  r1,*r13               ; store error flags in callers r0
0280 2C14 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2C16 2026 
0281                                                   ; / to indicate error
0282 2C18 0380  18         rtwp                        ; Return from DSR workspace to caller
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
0309 2C1A A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0310 2C1C 2C1E             data  dsrlnk.reuse.init     ; entry point
0311                       ;------------------------------------------------------
0312                       ; DSRLNK entry point
0313                       ;------------------------------------------------------
0314               dsrlnk.reuse.init:
0315 2C1E 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C20 83E0 
0316               
0317 2C22 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2C24 2026 
0318                       ;------------------------------------------------------
0319                       ; Restore dsrlnk variables of previous DSR call
0320                       ;------------------------------------------------------
0321 2C26 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2C28 A42A 
0322 2C2A C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0323 2C2C C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0324 2C2E C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2C30 8356 
0325                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0326 2C32 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0327 2C34 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2C36 8354 
0328                       ;------------------------------------------------------
0329                       ; Call DSR program in card/device
0330                       ;------------------------------------------------------
0331 2C38 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C3A 8C02 
0332                                                   ; lockup of TI Disk Controller DSR.
0333               
0334 2C3C 1D00  20         sbo   >00                   ; Open card/device ROM
0335               
0336 2C3E 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2C40 4000 
     2C42 2C56 
0337 2C44 16E2  14         jne   dsrlnk.error.nodsr_found
0338                                                   ; No, error code 0 = Bad Device name
0339                                                   ; The above jump may happen only in case of
0340                                                   ; either card hardware malfunction or if
0341                                                   ; there are 2 cards opened at the same time.
0342               
0343 2C46 0699  24         bl    *r9                   ; Execute DSR
0344                       ;
0345                       ; Depending on IO result the DSR in card ROM does RET
0346                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0347                       ;
0348 2C48 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0349                                                   ; (1) error return
0350 2C4A 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0351                       ;------------------------------------------------------
0352                       ; Now check if any DSR error occured
0353                       ;------------------------------------------------------
0354 2C4C 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2C4E A400 
0355 2C50 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2C52 A434 
0356               
0357 2C54 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0358                                                   ; Rest is the same as with normal DSRLNK
0359               
0360               
0361               ********************************************************************************
0362               
0363 2C56 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0364 2C58 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0365                                                   ; a @blwp @dsrlnk
0366 2C5A ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0045 2C5C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2C5E C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2C60 0649  14         dect  stack
0052 2C62 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2C64 0204  20         li    tmp0,dsrlnk.savcru
     2C66 A42A 
0057 2C68 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2C6A 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2C6C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2C6E 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2C70 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2C72 37D7 
0065 2C74 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2C76 8370 
0066                                                   ; / location
0067 2C78 C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2C7A A44C 
0068 2C7C 04C5  14         clr   tmp1                  ; io.op.open
0069 2C7E 101F  14         jmp   _file.record.fop      ; Do file operation
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
0091 2C80 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2C82 0649  14         dect  stack
0097 2C84 C64B  30         mov   r11,*stack            ; Save return address
0098 2C86 0205  20         li    tmp1,io.op.close      ; io.op.close
     2C88 0001 
0099 2C8A 1019  14         jmp   _file.record.fop      ; Do file operation
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
0120 2C8C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2C8E 0649  14         dect  stack
0125 2C90 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2C92 0205  20         li    tmp1,io.op.read       ; io.op.read
     2C94 0002 
0128 2C96 1013  14         jmp   _file.record.fop      ; Do file operation
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
0150 2C98 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2C9A 0649  14         dect  stack
0155 2C9C C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2C9E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2CA0 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2CA2 0005 
0159               
0160 2CA4 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2CA6 A43E 
0161               
0162 2CA8 06A0  32         bl    @xvputb               ; Write character count to PAB
     2CAA 22D8 
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2CAC 0205  20         li    tmp1,io.op.write      ; io.op.write
     2CAE 0003 
0167 2CB0 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2CB2 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2CB4 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2CB6 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2CB8 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2CBA 1000  14         nop
0189               
0190               
0191               file.status:
0192 2CBC 1000  14         nop
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
0227 2CBE C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2CC0 A436 
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2CC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2CC4 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2CC6 A44E 
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2CC8 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2CCA 22D8 
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2CCC C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2CCE 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2CD0 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2CD2 A44C 
0246               
0247 2CD4 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2CD6 22D8 
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2CD8 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2CDA 0009 
0254 2CDC C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2CDE 8356 
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2CE0 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2CE2 8322 
     2CE4 833C 
0259               
0260 2CE6 C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2CE8 A42A 
0261 2CEA 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2CEC 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2CEE 2AEE 
0268 2CF0 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2CF2 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2CF4 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2CF6 2C1A 
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2CF8 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2CFA C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2CFC 833C 
     2CFE 8322 
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2D00 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2D02 A436 
0292 2D04 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2D06 0005 
0293 2D08 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2D0A 22F0 
0294 2D0C C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2D0E C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0319 2D10 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2D12 045B  20         b     *r11                  ; Return to caller
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
0011               *  This is basically the kernel keeping everything togehter.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2D14 0300  24 tmgr    limi  0                     ; No interrupt processing
     2D16 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2D18 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2D1A 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2D1C 2360  38         coc   @wbit2,r13            ; C flag on ?
     2D1E 2026 
0029 2D20 1602  14         jne   tmgr1a                ; No, so move on
0030 2D22 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2D24 2012 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2D26 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2D28 202A 
0035 2D2A 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2D2C 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2D2E 201A 
0048 2D30 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2D32 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2D34 2018 
0050 2D36 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2D38 0460  28         b     @kthread              ; Run kernel thread
     2D3A 2DB2 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2D3C 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2D3E 201E 
0056 2D40 13EB  14         jeq   tmgr1
0057 2D42 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2D44 201C 
0058 2D46 16E8  14         jne   tmgr1
0059 2D48 C120  34         mov   @wtiusr,tmp0
     2D4A 832E 
0060 2D4C 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2D4E 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2D50 2DB0 
0065 2D52 C10A  18         mov   r10,tmp0
0066 2D54 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2D56 00FF 
0067 2D58 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2D5A 2026 
0068 2D5C 1303  14         jeq   tmgr5
0069 2D5E 0284  22         ci    tmp0,60               ; 1 second reached ?
     2D60 003C 
0070 2D62 1002  14         jmp   tmgr6
0071 2D64 0284  22 tmgr5   ci    tmp0,50
     2D66 0032 
0072 2D68 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2D6A 1001  14         jmp   tmgr8
0074 2D6C 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2D6E C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2D70 832C 
0079 2D72 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2D74 FF00 
0080 2D76 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2D78 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2D7A 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2D7C 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2D7E C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2D80 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2D82 830C 
     2D84 830D 
0089 2D86 1608  14         jne   tmgr10                ; No, get next slot
0090 2D88 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2D8A FF00 
0091 2D8C C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2D8E C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2D90 8330 
0096 2D92 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2D94 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2D96 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2D98 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2D9A 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2D9C 8315 
     2D9E 8314 
0103 2DA0 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2DA2 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2DA4 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2DA6 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2DA8 10F7  14         jmp   tmgr10                ; Process next slot
0108 2DAA 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2DAC FF00 
0109 2DAE 10B4  14         jmp   tmgr1
0110 2DB0 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 2DB2 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2DB4 201A 
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
0041 2DB6 06A0  32         bl    @realkb               ; Scan full keyboard
     2DB8 27BA 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 2DBA 0460  28         b     @tmgr3                ; Exit
     2DBC 2D3C 
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
0017 2DBE C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2DC0 832E 
0018 2DC2 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2DC4 201C 
0019 2DC6 045B  20 mkhoo1  b     *r11                  ; Return
0020      2D18     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2DC8 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2DCA 832E 
0029 2DCC 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2DCE FEFF 
0030 2DD0 045B  20         b     *r11                  ; Return
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
0017 2DD2 C13B  30 mkslot  mov   *r11+,tmp0
0018 2DD4 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2DD6 C184  18         mov   tmp0,tmp2
0023 2DD8 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2DDA A1A0  34         a     @wtitab,tmp2          ; Add table base
     2DDC 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2DDE CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2DE0 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2DE2 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2DE4 881B  46         c     *r11,@w$ffff          ; End of list ?
     2DE6 202C 
0035 2DE8 1301  14         jeq   mkslo1                ; Yes, exit
0036 2DEA 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2DEC 05CB  14 mkslo1  inct  r11
0041 2DEE 045B  20         b     *r11                  ; Exit
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
0052 2DF0 C13B  30 clslot  mov   *r11+,tmp0
0053 2DF2 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2DF4 A120  34         a     @wtitab,tmp0          ; Add table base
     2DF6 832C 
0055 2DF8 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2DFA 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2DFC 045B  20         b     *r11                  ; Exit
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
0068 2DFE C13B  30 rsslot  mov   *r11+,tmp0
0069 2E00 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2E02 A120  34         a     @wtitab,tmp0          ; Add table base
     2E04 832C 
0071 2E06 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2E08 C154  26         mov   *tmp0,tmp1
0073 2E0A 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2E0C FF00 
0074 2E0E C505  30         mov   tmp1,*tmp0
0075 2E10 045B  20         b     *r11                  ; Exit
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
0260 2E12 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2E14 8302 
0262               *--------------------------------------------------------------
0263               * Alternative entry point
0264               *--------------------------------------------------------------
0265 2E16 0300  24 runli1  limi  0                     ; Turn off interrupts
     2E18 0000 
0266 2E1A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2E1C 8300 
0267 2E1E C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2E20 83C0 
0268               *--------------------------------------------------------------
0269               * Clear scratch-pad memory from R4 upwards
0270               *--------------------------------------------------------------
0271 2E22 0202  20 runli2  li    r2,>8308
     2E24 8308 
0272 2E26 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0273 2E28 0282  22         ci    r2,>8400
     2E2A 8400 
0274 2E2C 16FC  14         jne   runli3
0275               *--------------------------------------------------------------
0276               * Exit to TI-99/4A title screen ?
0277               *--------------------------------------------------------------
0278 2E2E 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2E30 FFFF 
0279 2E32 1602  14         jne   runli4                ; No, continue
0280 2E34 0420  54         blwp  @0                    ; Yes, bye bye
     2E36 0000 
0281               *--------------------------------------------------------------
0282               * Determine if VDP is PAL or NTSC
0283               *--------------------------------------------------------------
0284 2E38 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2E3A 833C 
0285 2E3C 04C1  14         clr   r1                    ; Reset counter
0286 2E3E 0202  20         li    r2,10                 ; We test 10 times
     2E40 000A 
0287 2E42 C0E0  34 runli5  mov   @vdps,r3
     2E44 8802 
0288 2E46 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2E48 202A 
0289 2E4A 1302  14         jeq   runli6
0290 2E4C 0581  14         inc   r1                    ; Increase counter
0291 2E4E 10F9  14         jmp   runli5
0292 2E50 0602  14 runli6  dec   r2                    ; Next test
0293 2E52 16F7  14         jne   runli5
0294 2E54 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2E56 1250 
0295 2E58 1202  14         jle   runli7                ; No, so it must be NTSC
0296 2E5A 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2E5C 2026 
0297               *--------------------------------------------------------------
0298               * Copy machine code to scratchpad (prepare tight loop)
0299               *--------------------------------------------------------------
0300 2E5E 06A0  32 runli7  bl    @loadmc
     2E60 2226 
0301               *--------------------------------------------------------------
0302               * Initialize registers, memory, ...
0303               *--------------------------------------------------------------
0304 2E62 04C1  14 runli9  clr   r1
0305 2E64 04C2  14         clr   r2
0306 2E66 04C3  14         clr   r3
0307 2E68 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2E6A 3000 
0308 2E6C 020F  20         li    r15,vdpw              ; Set VDP write address
     2E6E 8C00 
0312               *--------------------------------------------------------------
0313               * Setup video memory
0314               *--------------------------------------------------------------
0316 2E70 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2E72 4A4A 
0317 2E74 1605  14         jne   runlia
0318 2E76 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2E78 229A 
0319 2E7A 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2E7C 0000 
     2E7E 3000 
0324 2E80 06A0  32 runlia  bl    @filv
     2E82 229A 
0325 2E84 0FC0             data  pctadr,spfclr,16      ; Load color table
     2E86 00F4 
     2E88 0010 
0326               *--------------------------------------------------------------
0327               * Check if there is a F18A present
0328               *--------------------------------------------------------------
0332 2E8A 06A0  32         bl    @f18unl               ; Unlock the F18A
     2E8C 2702 
0333 2E8E 06A0  32         bl    @f18chk               ; Check if F18A is there
     2E90 271C 
0334 2E92 06A0  32         bl    @f18lck               ; Lock the F18A again
     2E94 2712 
0335               
0336 2E96 06A0  32         bl    @putvr                ; Reset all F18a extended registers
     2E98 233E 
0337 2E9A 3201                   data >3201            ; F18a VR50 (>32), bit 1
0339               *--------------------------------------------------------------
0340               * Check if there is a speech synthesizer attached
0341               *--------------------------------------------------------------
0343               *       <<skipped>>
0347               *--------------------------------------------------------------
0348               * Load video mode table & font
0349               *--------------------------------------------------------------
0350 2E9C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2E9E 2304 
0351 2EA0 3008             data  spvmod                ; Equate selected video mode table
0352 2EA2 0204  20         li    tmp0,spfont           ; Get font option
     2EA4 000C 
0353 2EA6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0354 2EA8 1304  14         jeq   runlid                ; Yes, skip it
0355 2EAA 06A0  32         bl    @ldfnt
     2EAC 236C 
0356 2EAE 1100             data  fntadr,spfont         ; Load specified font
     2EB0 000C 
0357               *--------------------------------------------------------------
0358               * Did a system crash occur before runlib was called?
0359               *--------------------------------------------------------------
0360 2EB2 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2EB4 4A4A 
0361 2EB6 1602  14         jne   runlie                ; No, continue
0362 2EB8 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2EBA 2090 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 2EBC 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2EBE 0040 
0367 2EC0 0460  28         b     @main                 ; Give control to main program
     2EC2 6036 
**** **** ****     > stevie_b1.asm.2287273
0057                                                   ; Relocated spectra2 in low MEMEXP, was
0058                                                   ; copied to >2000 from ROM in bank 0
0059                       ;------------------------------------------------------
0060                       ; End of File marker
0061                       ;------------------------------------------------------
0062 2EC4 DEAD             data >dead,>beef,>dead,>beef
     2EC6 BEEF 
     2EC8 DEAD 
     2ECA BEEF 
0064               ***************************************************************
0065               * Step 3: Satisfy assembler, must know Stevie resident modules in low MEMEXP
0066               ********|*****|*********************|**************************
0067                       aorg  >3000
0068                       ;------------------------------------------------------
0069                       ; Activate bank 1
0070                       ;------------------------------------------------------
0071 3000 04E0  34         clr   @>6002                ; Activate bank 1 (2nd bank!)
     3002 6002 
0072 3004 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3006 6036 
0073                       ;------------------------------------------------------
0074                       ; Resident Stevie modules >3000 - >3fff
0075                       ;------------------------------------------------------
0076                       copy  "data.constants.asm"  ; Data Constants
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
0033 3008 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     300A 003F 
     300C 0243 
     300E 05F4 
     3010 0050 
0034               
0035               romsat:
0036 3012 0303             data  >0303,>0001             ; Cursor YX, initial shape and colour
     3014 0001 
0037               
0038               cursors:
0039 3016 0000             data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
     3018 0000 
     301A 0000 
     301C 001C 
0040 301E 1010             data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
     3020 1010 
     3022 1010 
     3024 1000 
0041 3026 1C1C             data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode
     3028 1C1C 
     302A 1C1C 
     302C 1C00 
0042               
0043               patterns:
0044 302E 0000             data  >0000,>0000,>00ff,>0000 ; 01. Single line
     3030 0000 
     3032 00FF 
     3034 0000 
0045 3036 0080             data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom
     3038 0000 
     303A FF00 
     303C FF00 
0046               
0047               patterns.box:
0048 303E 0000             data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
     3040 0000 
     3042 FF00 
     3044 FF00 
0049 3046 0000             data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
     3048 0000 
     304A FF80 
     304C BFA0 
0050 304E 0000             data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
     3050 0000 
     3052 FC04 
     3054 F414 
0051 3056 A0A0             data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
     3058 A0A0 
     305A A0A0 
     305C A0A0 
0052 305E 1414             data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
     3060 1414 
     3062 1414 
     3064 1414 
0053 3066 A0A0             data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
     3068 A0A0 
     306A BF80 
     306C FF00 
0054 306E 1414             data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
     3070 1414 
     3072 F404 
     3074 FC00 
0055 3076 0000             data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner
     3078 C0C0 
     307A C0C0 
     307C 0080 
0056 307E 0000             data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner
     3080 0F0F 
     3082 0F0F 
     3084 0000 
0057               
0058               alphalock:
0059 3086 0000             data  >0000,>00e0,>e0e0,>e0e0 ; 12. down
     3088 00E0 
     308A E0E0 
     308C E0E0 
0060 308E 00E0             data  >00e0,>e0e0,>e0e0,>0000 ; 13. up
     3090 E0E0 
     3092 E0E0 
     3094 0000 
0061               
0062               
0063               vertline:
0064 3096 1010             data  >1010,>1010,>1010,>1010 ; 14. Vertical line
     3098 1010 
     309A 1010 
     309C 1010 
0065               
0066               
0067               ***************************************************************
0068               * SAMS page layout table for Stevie (16 words)
0069               *--------------------------------------------------------------
0070               mem.sams.layout.data:
0071 309E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     30A0 0002 
0072 30A2 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     30A4 0003 
0073 30A6 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     30A8 000A 
0074               
0075 30AA B000             data  >b000,>0010           ; >b000-bfff, SAMS page >10
     30AC 0010 
0076                                                   ; \ The index can allocate
0077                                                   ; / pages >10 to >2f.
0078               
0079 30AE C000             data  >c000,>0030           ; >c000-cfff, SAMS page >30
     30B0 0030 
0080                                                   ; \ Editor buffer can allocate
0081                                                   ; / pages >30 to >ff.
0082               
0083 30B2 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     30B4 000D 
0084 30B6 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     30B8 000E 
0085 30BA F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     30BC 000F 
0086               
0087               
0088               
0089               
0090               
0091               ***************************************************************
0092               * Stevie color schemes table
0093               *--------------------------------------------------------------
0094               * Word 1
0095               *    MSB  high-nibble    Foreground color frame buffer
0096               *    MSB  low-nibble     Background color frame buffer
0097               *    LSB  high-nibble    Foreground color bottom line pane
0098               *    LSB  low-nibble     Background color bottom line pane
0099               *
0100               * Word 2
0101               *    MSB  high-nibble    Foreground color cmdb pane
0102               *    MSB  low-nibble     Background color cmdb pane
0103               *    LSB  high-nibble    0
0104               *    LSB  low-nibble     Cursor foreground color
0105               *--------------------------------------------------------------
0106      0009     tv.colorscheme.entries   equ 9      ; Entries in table
0107               
0108               tv.colorscheme.table:
0109                                        ; #  Framebuffer        | Status line        | CMDB
0110                                        ; ----------------------|--------------------|---------
0111 30BE F41F      data  >f41f,>f001       ; 1  White/dark blue    | Black/white        | White
     30C0 F001 
0112 30C2 F41C      data  >f41c,>f00f       ; 2  White/dark blue    | Black/dark green   | White
     30C4 F00F 
0113 30C6 A11A      data  >a11a,>f00f       ; 3  Dark yellow/black  | Black/dark yellow  | White
     30C8 F00F 
0114 30CA 2112      data  >2112,>f00f       ; 4  Medium green/black | Black/medium green | White
     30CC F00F 
0115 30CE E11E      data  >e11e,>f00f       ; 5  Grey/black         | Black/grey         | White
     30D0 F00F 
0116 30D2 1771      data  >1771,>1006       ; 6  Black/cyan         | Cyan/black         | Black
     30D4 1006 
0117 30D6 1FF1      data  >1ff1,>1001       ; 7  Black/white        | White/black        | Black
     30D8 1001 
0118 30DA A1F0      data  >a1f0,>1a0f       ; 8  Dark yellow/black  | White/transparent  | inverse
     30DC 1A0F 
0119 30DE 21F0      data  >21f0,>f20f       ; 9  Medium green/black | White/transparent  | inverse
     30E0 F20F 
0120               
**** **** ****     > stevie_b1.asm.2287273
0077                       copy  "data.strings.asm"    ; Data segment - Strings
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
0012 30E2 0C53             byte  12
0013 30E3 ....             text  'Stevie v0.1b'
0014                       even
0015               
0016               txt.about.purpose
0017 30F0 2350             byte  35
0018 30F1 ....             text  'Programming Editor for the TI-99/4a'
0019                       even
0020               
0021               txt.about.author
0022 3114 1D32             byte  29
0023 3115 ....             text  '2018-2020 by Filip Van Vooren'
0024                       even
0025               
0026               txt.about.website
0027 3132 1B68             byte  27
0028 3133 ....             text  'https://stevie.oratronik.de'
0029                       even
0030               
0031               txt.about.build
0032 314E 1542             byte  21
0033 314F ....             text  'Build: 201011-2287273'
0034                       even
0035               
0036               
0037               txt.about.msg1
0038 3164 2446             byte  36
0039 3165 ....             text  'FCTN-7 (F7)   Help, shortcuts, about'
0040                       even
0041               
0042               txt.about.msg2
0043 318A 2246             byte  34
0044 318B ....             text  'FCTN-9 (F9)   Toggle edit/cmd mode'
0045                       even
0046               
0047               txt.about.msg3
0048 31AE 1946             byte  25
0049 31AF ....             text  'FCTN-+        Quit Stevie'
0050                       even
0051               
0052               txt.about.msg4
0053 31C8 1C43             byte  28
0054 31C9 ....             text  'CTRL-L (^L)   Load DV80 file'
0055                       even
0056               
0057               txt.about.msg5
0058 31E6 1C43             byte  28
0059 31E7 ....             text  'CTRL-K (^K)   Save DV80 file'
0060                       even
0061               
0062               txt.about.msg6
0063 3204 1A43             byte  26
0064 3205 ....             text  'CTRL-Z (^Z)   Cycle colors'
0065                       even
0066               
0067               
0068 3220 380D     txt.about.msg7     byte    56,13
0069 3222 ....                        text    ' ALPHA LOCK up     '
0070                                  byte    12
0071 3236 ....                        text    ' ALPHA LOCK down   '
0072 3249 ....                        text    '  * Text changed'
0073               
0074               
0075               ;--------------------------------------------------------------
0076               ; Strings for status line pane
0077               ;--------------------------------------------------------------
0078               txt.delim
0079                       byte  1
0080 325A ....             text  ','
0081                       even
0082               
0083               txt.marker
0084 325C 052A             byte  5
0085 325D ....             text  '*EOF*'
0086                       even
0087               
0088               txt.bottom
0089 3262 0520             byte  5
0090 3263 ....             text  '  BOT'
0091                       even
0092               
0093               txt.ovrwrite
0094 3268 034F             byte  3
0095 3269 ....             text  'OVR'
0096                       even
0097               
0098               txt.insert
0099 326C 0349             byte  3
0100 326D ....             text  'INS'
0101                       even
0102               
0103               txt.star
0104 3270 012A             byte  1
0105 3271 ....             text  '*'
0106                       even
0107               
0108               txt.loading
0109 3272 0A4C             byte  10
0110 3273 ....             text  'Loading...'
0111                       even
0112               
0113               txt.saving
0114 327E 0953             byte  9
0115 327F ....             text  'Saving...'
0116                       even
0117               
0118               txt.fastmode
0119 3288 0846             byte  8
0120 3289 ....             text  'Fastmode'
0121                       even
0122               
0123               txt.kb
0124 3292 026B             byte  2
0125 3293 ....             text  'kb'
0126                       even
0127               
0128               txt.lines
0129 3296 054C             byte  5
0130 3297 ....             text  'Lines'
0131                       even
0132               
0133               txt.bufnum
0134 329C 0323             byte  3
0135 329D ....             text  '#1 '
0136                       even
0137               
0138               txt.newfile
0139 32A0 0A5B             byte  10
0140 32A1 ....             text  '[New file]'
0141                       even
0142               
0143               txt.filetype.dv80
0144 32AC 0444             byte  4
0145 32AD ....             text  'DV80'
0146                       even
0147               
0148               txt.filetype.none
0149 32B2 0420             byte  4
0150 32B3 ....             text  '    '
0151                       even
0152               
0153               
0154 32B8 010D     txt.alpha.up       data >010d
0155 32BA 010C     txt.alpha.down     data >010c
0156 32BC 010E     txt.vertline       data >010e
0157               
0158               
0159               ;--------------------------------------------------------------
0160               ; Dialog Load DV 80 file
0161               ;--------------------------------------------------------------
0162               txt.head.load
0163 32BE 0F4C             byte  15
0164 32BF ....             text  'Load DV80 file '
0165                       even
0166               
0167               txt.hint.load
0168 32CE 4D48             byte  77
0169 32CF ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
0170                       even
0171               
0172               txt.keys.load
0173 331C 3746             byte  55
0174 331D ....             text  'F9=Back    F3=Clear    F5=Fastmode    ^A=Home    ^F=End'
0175                       even
0176               
0177               txt.keys.load2
0178 3354 3746             byte  55
0179 3355 ....             text  'F9=Back    F3=Clear   *F5=Fastmode    ^A=Home    ^F=End'
0180                       even
0181               
0182               
0183               ;--------------------------------------------------------------
0184               ; Dialog Save DV 80 file
0185               ;--------------------------------------------------------------
0186               txt.head.save
0187 338C 0F53             byte  15
0188 338D ....             text  'Save DV80 file '
0189                       even
0190               
0191               txt.hint.save
0192 339C 3F48             byte  63
0193 339D ....             text  'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
0194                       even
0195               
0196               txt.keys.save
0197 33DC 2846             byte  40
0198 33DD ....             text  'F9=Back    F3=Clear    ^A=Home    ^F=End'
0199                       even
0200               
0201               
0202               ;--------------------------------------------------------------
0203               ; Dialog "Unsaved changes"
0204               ;--------------------------------------------------------------
0205               txt.head.unsaved
0206 3406 1055             byte  16
0207 3407 ....             text  'Unsaved changes '
0208                       even
0209               
0210               txt.hint.unsaved
0211 3418 3F48             byte  63
0212 3419 ....             text  'HINT: Press F6 to proceed without saving or ENTER to save file.'
0213                       even
0214               
0215               txt.keys.unsaved
0216 3458 2846             byte  40
0217 3459 ....             text  'F9=Back    F6=Proceed    ENTER=Save file'
0218                       even
0219               
0220               txt.warn.unsaved
0221 3482 3259             byte  50
0222 3483 ....             text  'You are about to lose changes to the current file!'
0223                       even
0224               
0225               
0226               ;--------------------------------------------------------------
0227               ; Dialog "About"
0228               ;--------------------------------------------------------------
0229               txt.head.about
0230 34B6 0D41             byte  13
0231 34B7 ....             text  'About Stevie '
0232                       even
0233               
0234               txt.hint.about
0235 34C4 2C48             byte  44
0236 34C5 ....             text  'HINT: Press F9 or ENTER to return to editor.'
0237                       even
0238               
0239               txt.keys.about
0240 34F2 1546             byte  21
0241 34F3 ....             text  'F9=Back    ENTER=Back'
0242                       even
0243               
0244               
0245               ;--------------------------------------------------------------
0246               ; Strings for error line pane
0247               ;--------------------------------------------------------------
0248               txt.ioerr.load
0249 3508 2049             byte  32
0250 3509 ....             text  'I/O error. Failed loading file: '
0251                       even
0252               
0253               txt.ioerr.save
0254 352A 1F49             byte  31
0255 352B ....             text  'I/O error. Failed saving file: '
0256                       even
0257               
0258               txt.io.nofile
0259 354A 2149             byte  33
0260 354B ....             text  'I/O error. No filename specified.'
0261                       even
0262               
0263               
0264               
0265               ;--------------------------------------------------------------
0266               ; Strings for command buffer
0267               ;--------------------------------------------------------------
0268               txt.cmdb.title
0269 356C 0E43             byte  14
0270 356D ....             text  'Command buffer'
0271                       even
0272               
0273               txt.cmdb.prompt
0274 357C 013E             byte  1
0275 357D ....             text  '>'
0276                       even
0277               
0278               
0279 357E 0C0A     txt.stevie         byte    12
0280                                  byte    10
0281 3580 ....                        text    'stevie v1.00'
0282 358C 0B00                        byte    11
0283                                  even
0284               
0285               txt.colorscheme
0286 358E 0E43             byte  14
0287 358F ....             text  'Color scheme: '
0288                       even
0289               
0290               
**** **** ****     > stevie_b1.asm.2287273
0078                       copy  "data.keymap.asm"     ; Data segment - Keaboard mapping
**** **** ****     > data.keymap.asm
0001               * FILE......: data.keymap.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard mapping)
0003               
0004               *---------------------------------------------------------------
0005               * Keyboard scancodes - Function keys
0006               *-------------|---------------------|---------------------------
0007      0000     key.fctn.0    equ >0000             ; fctn + 0
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
0018      0000     key.fctn.b    equ >0000             ; fctn + b
0019      0000     key.fctn.c    equ >0000             ; fctn + c
0020      0900     key.fctn.d    equ >0900             ; fctn + d
0021      0B00     key.fctn.e    equ >0b00             ; fctn + e
0022      0000     key.fctn.f    equ >0000             ; fctn + f
0023      0000     key.fctn.g    equ >0000             ; fctn + g
0024      0000     key.fctn.h    equ >0000             ; fctn + h
0025      0000     key.fctn.i    equ >0000             ; fctn + i
0026      0000     key.fctn.j    equ >0000             ; fctn + j
0027      0000     key.fctn.k    equ >0000             ; fctn + k
0028      0000     key.fctn.l    equ >0000             ; fctn + l
0029      0000     key.fctn.m    equ >0000             ; fctn + m
0030      0000     key.fctn.n    equ >0000             ; fctn + n
0031      0000     key.fctn.o    equ >0000             ; fctn + o
0032      0000     key.fctn.p    equ >0000             ; fctn + p
0033      0000     key.fctn.q    equ >0000             ; fctn + q
0034      0000     key.fctn.r    equ >0000             ; fctn + r
0035      0800     key.fctn.s    equ >0800             ; fctn + s
0036      0000     key.fctn.t    equ >0000             ; fctn + t
0037      0000     key.fctn.u    equ >0000             ; fctn + u
0038      0000     key.fctn.v    equ >0000             ; fctn + v
0039      0000     key.fctn.w    equ >0000             ; fctn + w
0040      0A00     key.fctn.x    equ >0a00             ; fctn + x
0041      0000     key.fctn.y    equ >0000             ; fctn + y
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
0064      0000     key.ctrl.c    equ >0000             ; ctrl + c
0065      8400     key.ctrl.d    equ >8400             ; ctrl + d
0066      8500     key.ctrl.e    equ >8500             ; ctrl + e
0067      8600     key.ctrl.f    equ >8600             ; ctrl + f
0068      0000     key.ctrl.g    equ >0000             ; ctrl + g
0069      0000     key.ctrl.h    equ >0000             ; ctrl + h
0070      0000     key.ctrl.i    equ >0000             ; ctrl + i
0071      0000     key.ctrl.j    equ >0000             ; ctrl + j
0072      8B00     key.ctrl.k    equ >8b00             ; ctrl + k
0073      8C00     key.ctrl.l    equ >8c00             ; ctrl + l
0074      0000     key.ctrl.m    equ >0000             ; ctrl + m
0075      0000     key.ctrl.n    equ >0000             ; ctrl + n
0076      0000     key.ctrl.o    equ >0000             ; ctrl + o
0077      0000     key.ctrl.p    equ >0000             ; ctrl + p
0078      0000     key.ctrl.q    equ >0000             ; ctrl + q
0079      0000     key.ctrl.r    equ >0000             ; ctrl + r
0080      9300     key.ctrl.s    equ >9300             ; ctrl + s
0081      9400     key.ctrl.t    equ >9400             ; ctrl + t
0082      0000     key.ctrl.u    equ >0000             ; ctrl + u
0083      0000     key.ctrl.v    equ >0000             ; ctrl + v
0084      0000     key.ctrl.w    equ >0000             ; ctrl + w
0085      9800     key.ctrl.x    equ >9800             ; ctrl + x
0086      0000     key.ctrl.y    equ >0000             ; ctrl + y
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
0105 359E 0866             byte  8
0106 359F ....             text  'fctn + 0'
0107                       even
0108               
0109               txt.fctn.1
0110 35A8 0866             byte  8
0111 35A9 ....             text  'fctn + 1'
0112                       even
0113               
0114               txt.fctn.2
0115 35B2 0866             byte  8
0116 35B3 ....             text  'fctn + 2'
0117                       even
0118               
0119               txt.fctn.3
0120 35BC 0866             byte  8
0121 35BD ....             text  'fctn + 3'
0122                       even
0123               
0124               txt.fctn.4
0125 35C6 0866             byte  8
0126 35C7 ....             text  'fctn + 4'
0127                       even
0128               
0129               txt.fctn.5
0130 35D0 0866             byte  8
0131 35D1 ....             text  'fctn + 5'
0132                       even
0133               
0134               txt.fctn.6
0135 35DA 0866             byte  8
0136 35DB ....             text  'fctn + 6'
0137                       even
0138               
0139               txt.fctn.7
0140 35E4 0866             byte  8
0141 35E5 ....             text  'fctn + 7'
0142                       even
0143               
0144               txt.fctn.8
0145 35EE 0866             byte  8
0146 35EF ....             text  'fctn + 8'
0147                       even
0148               
0149               txt.fctn.9
0150 35F8 0866             byte  8
0151 35F9 ....             text  'fctn + 9'
0152                       even
0153               
0154               txt.fctn.a
0155 3602 0866             byte  8
0156 3603 ....             text  'fctn + a'
0157                       even
0158               
0159               txt.fctn.b
0160 360C 0866             byte  8
0161 360D ....             text  'fctn + b'
0162                       even
0163               
0164               txt.fctn.c
0165 3616 0866             byte  8
0166 3617 ....             text  'fctn + c'
0167                       even
0168               
0169               txt.fctn.d
0170 3620 0866             byte  8
0171 3621 ....             text  'fctn + d'
0172                       even
0173               
0174               txt.fctn.e
0175 362A 0866             byte  8
0176 362B ....             text  'fctn + e'
0177                       even
0178               
0179               txt.fctn.f
0180 3634 0866             byte  8
0181 3635 ....             text  'fctn + f'
0182                       even
0183               
0184               txt.fctn.g
0185 363E 0866             byte  8
0186 363F ....             text  'fctn + g'
0187                       even
0188               
0189               txt.fctn.h
0190 3648 0866             byte  8
0191 3649 ....             text  'fctn + h'
0192                       even
0193               
0194               txt.fctn.i
0195 3652 0866             byte  8
0196 3653 ....             text  'fctn + i'
0197                       even
0198               
0199               txt.fctn.j
0200 365C 0866             byte  8
0201 365D ....             text  'fctn + j'
0202                       even
0203               
0204               txt.fctn.k
0205 3666 0866             byte  8
0206 3667 ....             text  'fctn + k'
0207                       even
0208               
0209               txt.fctn.l
0210 3670 0866             byte  8
0211 3671 ....             text  'fctn + l'
0212                       even
0213               
0214               txt.fctn.m
0215 367A 0866             byte  8
0216 367B ....             text  'fctn + m'
0217                       even
0218               
0219               txt.fctn.n
0220 3684 0866             byte  8
0221 3685 ....             text  'fctn + n'
0222                       even
0223               
0224               txt.fctn.o
0225 368E 0866             byte  8
0226 368F ....             text  'fctn + o'
0227                       even
0228               
0229               txt.fctn.p
0230 3698 0866             byte  8
0231 3699 ....             text  'fctn + p'
0232                       even
0233               
0234               txt.fctn.q
0235 36A2 0866             byte  8
0236 36A3 ....             text  'fctn + q'
0237                       even
0238               
0239               txt.fctn.r
0240 36AC 0866             byte  8
0241 36AD ....             text  'fctn + r'
0242                       even
0243               
0244               txt.fctn.s
0245 36B6 0866             byte  8
0246 36B7 ....             text  'fctn + s'
0247                       even
0248               
0249               txt.fctn.t
0250 36C0 0866             byte  8
0251 36C1 ....             text  'fctn + t'
0252                       even
0253               
0254               txt.fctn.u
0255 36CA 0866             byte  8
0256 36CB ....             text  'fctn + u'
0257                       even
0258               
0259               txt.fctn.v
0260 36D4 0866             byte  8
0261 36D5 ....             text  'fctn + v'
0262                       even
0263               
0264               txt.fctn.w
0265 36DE 0866             byte  8
0266 36DF ....             text  'fctn + w'
0267                       even
0268               
0269               txt.fctn.x
0270 36E8 0866             byte  8
0271 36E9 ....             text  'fctn + x'
0272                       even
0273               
0274               txt.fctn.y
0275 36F2 0866             byte  8
0276 36F3 ....             text  'fctn + y'
0277                       even
0278               
0279               txt.fctn.z
0280 36FC 0866             byte  8
0281 36FD ....             text  'fctn + z'
0282                       even
0283               
0284               *---------------------------------------------------------------
0285               * Keyboard labels - Function keys extra
0286               *---------------------------------------------------------------
0287               txt.fctn.dot
0288 3706 0866             byte  8
0289 3707 ....             text  'fctn + .'
0290                       even
0291               
0292               txt.fctn.plus
0293 3710 0866             byte  8
0294 3711 ....             text  'fctn + +'
0295                       even
0296               
0297               
0298               txt.ctrl.dot
0299 371A 0863             byte  8
0300 371B ....             text  'ctrl + .'
0301                       even
0302               
0303               txt.ctrl.comma
0304 3724 0863             byte  8
0305 3725 ....             text  'ctrl + ,'
0306                       even
0307               
0308               *---------------------------------------------------------------
0309               * Keyboard labels - Control keys
0310               *---------------------------------------------------------------
0311               txt.ctrl.0
0312 372E 0863             byte  8
0313 372F ....             text  'ctrl + 0'
0314                       even
0315               
0316               txt.ctrl.1
0317 3738 0863             byte  8
0318 3739 ....             text  'ctrl + 1'
0319                       even
0320               
0321               txt.ctrl.2
0322 3742 0863             byte  8
0323 3743 ....             text  'ctrl + 2'
0324                       even
0325               
0326               txt.ctrl.3
0327 374C 0863             byte  8
0328 374D ....             text  'ctrl + 3'
0329                       even
0330               
0331               txt.ctrl.4
0332 3756 0863             byte  8
0333 3757 ....             text  'ctrl + 4'
0334                       even
0335               
0336               txt.ctrl.5
0337 3760 0863             byte  8
0338 3761 ....             text  'ctrl + 5'
0339                       even
0340               
0341               txt.ctrl.6
0342 376A 0863             byte  8
0343 376B ....             text  'ctrl + 6'
0344                       even
0345               
0346               txt.ctrl.7
0347 3774 0863             byte  8
0348 3775 ....             text  'ctrl + 7'
0349                       even
0350               
0351               txt.ctrl.8
0352 377E 0863             byte  8
0353 377F ....             text  'ctrl + 8'
0354                       even
0355               
0356               txt.ctrl.9
0357 3788 0863             byte  8
0358 3789 ....             text  'ctrl + 9'
0359                       even
0360               
0361               txt.ctrl.a
0362 3792 0863             byte  8
0363 3793 ....             text  'ctrl + a'
0364                       even
0365               
0366               txt.ctrl.b
0367 379C 0863             byte  8
0368 379D ....             text  'ctrl + b'
0369                       even
0370               
0371               txt.ctrl.c
0372 37A6 0863             byte  8
0373 37A7 ....             text  'ctrl + c'
0374                       even
0375               
0376               txt.ctrl.d
0377 37B0 0863             byte  8
0378 37B1 ....             text  'ctrl + d'
0379                       even
0380               
0381               txt.ctrl.e
0382 37BA 0863             byte  8
0383 37BB ....             text  'ctrl + e'
0384                       even
0385               
0386               txt.ctrl.f
0387 37C4 0863             byte  8
0388 37C5 ....             text  'ctrl + f'
0389                       even
0390               
0391               txt.ctrl.g
0392 37CE 0863             byte  8
0393 37CF ....             text  'ctrl + g'
0394                       even
0395               
0396               txt.ctrl.h
0397 37D8 0863             byte  8
0398 37D9 ....             text  'ctrl + h'
0399                       even
0400               
0401               txt.ctrl.i
0402 37E2 0863             byte  8
0403 37E3 ....             text  'ctrl + i'
0404                       even
0405               
0406               txt.ctrl.j
0407 37EC 0863             byte  8
0408 37ED ....             text  'ctrl + j'
0409                       even
0410               
0411               txt.ctrl.k
0412 37F6 0863             byte  8
0413 37F7 ....             text  'ctrl + k'
0414                       even
0415               
0416               txt.ctrl.l
0417 3800 0863             byte  8
0418 3801 ....             text  'ctrl + l'
0419                       even
0420               
0421               txt.ctrl.m
0422 380A 0863             byte  8
0423 380B ....             text  'ctrl + m'
0424                       even
0425               
0426               txt.ctrl.n
0427 3814 0863             byte  8
0428 3815 ....             text  'ctrl + n'
0429                       even
0430               
0431               txt.ctrl.o
0432 381E 0863             byte  8
0433 381F ....             text  'ctrl + o'
0434                       even
0435               
0436               txt.ctrl.p
0437 3828 0863             byte  8
0438 3829 ....             text  'ctrl + p'
0439                       even
0440               
0441               txt.ctrl.q
0442 3832 0863             byte  8
0443 3833 ....             text  'ctrl + q'
0444                       even
0445               
0446               txt.ctrl.r
0447 383C 0863             byte  8
0448 383D ....             text  'ctrl + r'
0449                       even
0450               
0451               txt.ctrl.s
0452 3846 0863             byte  8
0453 3847 ....             text  'ctrl + s'
0454                       even
0455               
0456               txt.ctrl.t
0457 3850 0863             byte  8
0458 3851 ....             text  'ctrl + t'
0459                       even
0460               
0461               txt.ctrl.u
0462 385A 0863             byte  8
0463 385B ....             text  'ctrl + u'
0464                       even
0465               
0466               txt.ctrl.v
0467 3864 0863             byte  8
0468 3865 ....             text  'ctrl + v'
0469                       even
0470               
0471               txt.ctrl.w
0472 386E 0863             byte  8
0473 386F ....             text  'ctrl + w'
0474                       even
0475               
0476               txt.ctrl.x
0477 3878 0863             byte  8
0478 3879 ....             text  'ctrl + x'
0479                       even
0480               
0481               txt.ctrl.y
0482 3882 0863             byte  8
0483 3883 ....             text  'ctrl + y'
0484                       even
0485               
0486               txt.ctrl.z
0487 388C 0863             byte  8
0488 388D ....             text  'ctrl + z'
0489                       even
0490               
0491               *---------------------------------------------------------------
0492               * Keyboard labels - control keys extra
0493               *---------------------------------------------------------------
0494               txt.ctrl.plus
0495 3896 0863             byte  8
0496 3897 ....             text  'ctrl + +'
0497                       even
0498               
0499               *---------------------------------------------------------------
0500               * Special keys
0501               *---------------------------------------------------------------
0502               txt.enter
0503 38A0 0565             byte  5
0504 38A1 ....             text  'enter'
0505                       even
0506               
**** **** ****     > stevie_b1.asm.2287273
0079                       ;------------------------------------------------------
0080                       ; End of File marker
0081                       ;------------------------------------------------------
0082 38A6 DEAD             data  >dead,>beef,>dead,>beef
     38A8 BEEF 
     38AA DEAD 
     38AC BEEF 
0084               ***************************************************************
0085               * Step 4: Include main editor modules
0086               ********|*****|*********************|**************************
0087               main:
0088                       aorg  kickstart.code2       ; >6036
0089 6036 0460  28         b     @main.stevie          ; Start editor
     6038 603A 
0090                       ;-----------------------------------------------------------------------
0091                       ; Include files
0092                       ;-----------------------------------------------------------------------
0093                       copy  "main.asm"            ; Main file (entrypoint)
**** **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: Stevie Editor - Main editor module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *            Stevie Editor - Main editor module
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * main
0011               * Initialize editor
0012               ***************************************************************
0013               * b   @main.stevie
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * -
0023               *--------------------------------------------------------------
0024               * Notes
0025               * Main entry point for stevie editor
0026               ***************************************************************
0027               
0028               
0029               ***************************************************************
0030               * Main
0031               ********|*****|*********************|**************************
0032               main.stevie:
0033 603A 20A0  38         coc   @wbit1,config         ; F18a detected?
     603C 2028 
0034 603E 1302  14         jeq   main.continue
0035 6040 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6042 0000 
0036               
0037               main.continue:
0038                       ;------------------------------------------------------
0039                       ; Setup F18A VDP
0040                       ;------------------------------------------------------
0041 6044 06A0  32         bl    @scroff               ; Turn screen off
     6046 265E 
0042               
0043 6048 06A0  32         bl    @f18unl               ; Unlock the F18a
     604A 2702 
0044 604C 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     604E 233E 
0045 6050 3140                   data >3140            ; F18a VR49 (>31), bit 40
0046               
0047 6052 06A0  32         bl    @putvr                ; Turn on position based attributes
     6054 233E 
0048 6056 3202                   data >3202            ; F18a VR50 (>32), bit 2
0049               
0050 6058 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     605A 233E 
0051 605C 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0052                       ;------------------------------------------------------
0053                       ; Clear screen (VDP SIT)
0054                       ;------------------------------------------------------
0055 605E 06A0  32         bl    @filv
     6060 229A 
0056 6062 0000                   data >0000,32,30*80   ; Clear screen
     6064 0020 
     6066 0960 
0057                       ;------------------------------------------------------
0058                       ; Initialize high memory expansion
0059                       ;------------------------------------------------------
0060 6068 06A0  32         bl    @film
     606A 2242 
0061 606C A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     606E 0000 
     6070 6000 
0062                       ;------------------------------------------------------
0063                       ; Setup SAMS windows
0064                       ;------------------------------------------------------
0065 6072 06A0  32         bl    @mem.sams.layout      ; Initialize SAMS layout
     6074 6846 
0066                       ;------------------------------------------------------
0067                       ; Setup cursor, screen, etc.
0068                       ;------------------------------------------------------
0069 6076 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6078 267E 
0070 607A 06A0  32         bl    @s8x8                 ; Small sprite
     607C 268E 
0071               
0072 607E 06A0  32         bl    @cpym2m
     6080 24AA 
0073 6082 3012                   data romsat,ramsat,4  ; Load sprite SAT
     6084 2F54 
     6086 0004 
0074               
0075 6088 C820  54         mov   @romsat+2,@tv.curshape
     608A 3014 
     608C A014 
0076                                                   ; Save cursor shape & color
0077               
0078 608E 06A0  32         bl    @cpym2v
     6090 2456 
0079 6092 2800                   data sprpdt,cursors,3*8
     6094 3016 
     6096 0018 
0080                                                   ; Load sprite cursor patterns
0081               
0082 6098 06A0  32         bl    @cpym2v
     609A 2456 
0083 609C 1008                   data >1008,patterns,14*8
     609E 302E 
     60A0 0070 
0084                                                   ; Load character patterns
0085               *--------------------------------------------------------------
0086               * Initialize
0087               *--------------------------------------------------------------
0088 60A2 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A4 6810 
0089 60A6 06A0  32         bl    @tv.reset             ; Reset editor
     60A8 682A 
0090                       ;------------------------------------------------------
0091                       ; Load colorscheme amd turn on screen
0092                       ;------------------------------------------------------
0093 60AA 06A0  32         bl    @pane.action.colorscheme.Load
     60AC 7852 
0094                                                   ; Load color scheme and turn on screen
0095                       ;-------------------------------------------------------
0096                       ; Setup editor tasks & hook
0097                       ;-------------------------------------------------------
0098 60AE 0204  20         li    tmp0,>0300
     60B0 0300 
0099 60B2 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     60B4 8314 
0100               
0101 60B6 06A0  32         bl    @at
     60B8 269E 
0102 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0103               
0104 60BC 0204  20         li    tmp0,timers
     60BE 2F44 
0105 60C0 C804  38         mov   tmp0,@wtitab
     60C2 832C 
0106               
0107 60C4 06A0  32         bl    @mkslot
     60C6 2DD2 
0108 60C8 0001                   data >0001,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 75D6 
0109 60CC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     60CE 7694 
0110 60D0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     60D2 76C8 
0111 60D4 032F                   data >032f,task.oneshot      ; Task 3 - One shot task
     60D6 7716 
0112 60D8 FFFF                   data eol
0113               
0114 60DA 06A0  32         bl    @mkhook
     60DC 2DBE 
0115 60DE 7598                   data hook.keyscan     ; Setup user hook
0116               
0117 60E0 0460  28         b     @tmgr                 ; Start timers and kthread
     60E2 2D14 
**** **** ****     > stevie_b1.asm.2287273
0094                       ;-----------------------------------------------------------------------
0095                       ; Keyboard actions
0096                       ;-----------------------------------------------------------------------
0097                       copy  "edkey.key.process.asm"    ; Process keyboard actions
**** **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               
0005               ****************************************************************
0006               * Editor - Process action keys
0007               ****************************************************************
0008               edkey.key.process:
0009 60E4 C160  34         mov   @waux1,tmp1           ; Get key value
     60E6 833C 
0010 60E8 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     60EA FF00 
0011 60EC 0707  14         seto  tmp3                  ; EOL marker
0012                       ;-------------------------------------------------------
0013                       ; Process key depending on pane with focus
0014                       ;-------------------------------------------------------
0015 60EE C1A0  34         mov   @tv.pane.focus,tmp2
     60F0 A01A 
0016 60F2 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     60F4 0000 
0017 60F6 1307  14         jeq   edkey.key.process.loadmap.editor
0018                                                   ; Yes, so load editor keymap
0019               
0020 60F8 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     60FA 0001 
0021 60FC 1307  14         jeq   edkey.key.process.loadmap.cmdb
0022                                                   ; Yes, so load CMDB keymap
0023                       ;-------------------------------------------------------
0024                       ; Pane without focus, crash
0025                       ;-------------------------------------------------------
0026 60FE C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6100 FFCE 
0027 6102 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6104 2030 
0028                       ;-------------------------------------------------------
0029                       ; Load Editor keyboard map
0030                       ;-------------------------------------------------------
0031               edkey.key.process.loadmap.editor:
0032 6106 0206  20         li    tmp2,keymap_actions.editor
     6108 7D4C 
0033 610A 1003  14         jmp   edkey.key.check.next
0034                       ;-------------------------------------------------------
0035                       ; Load CMDB keyboard map
0036                       ;-------------------------------------------------------
0037               edkey.key.process.loadmap.cmdb:
0038 610C 0206  20         li    tmp2,keymap_actions.cmdb
     610E 7DEA 
0039 6110 1600  14         jne   edkey.key.check.next
0040                       ;-------------------------------------------------------
0041                       ; Iterate over keyboard map for matching action key
0042                       ;-------------------------------------------------------
0043               edkey.key.check.next:
0044 6112 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0045 6114 1319  14         jeq   edkey.key.process.addbuffer
0046                                                   ; Yes, means no action key pressed, so
0047                                                   ; add character to buffer
0048                       ;-------------------------------------------------------
0049                       ; Check for action key match
0050                       ;-------------------------------------------------------
0051 6116 8585  30         c     tmp1,*tmp2            ; Action key matched?
0052 6118 1303  14         jeq   edkey.key.check.scope
0053                                                   ; Yes, check scope
0054 611A 0226  22         ai    tmp2,6                ; Skip current entry
     611C 0006 
0055 611E 10F9  14         jmp   edkey.key.check.next  ; Check next entry
0056                       ;-------------------------------------------------------
0057                       ; Check scope of key
0058                       ;-------------------------------------------------------
0059               edkey.key.check.scope:
0060 6120 05C6  14         inct  tmp2                  ; Move to scope
0061 6122 8816  46         c     *tmp2,@tv.pane.focus  ; (1) Process key if scope matches pane
     6124 A01A 
0062 6126 1306  14         jeq   edkey.key.process.action
0063               
0064 6128 8816  46         c     *tmp2,@cmdb.dialog    ; (2) Process key if scope matches dialog
     612A A31A 
0065 612C 1303  14         jeq   edkey.key.process.action
0066                       ;-------------------------------------------------------
0067                       ; Key pressed outside valid scope, ignore action entry
0068                       ;-------------------------------------------------------
0069 612E 0226  22         ai    tmp2,4                ; Skip current entry
     6130 0004 
0070 6132 10EF  14         jmp   edkey.key.check.next  ; Process next action entry
0071                       ;-------------------------------------------------------
0072                       ; Trigger keyboard action
0073                       ;-------------------------------------------------------
0074               edkey.key.process.action:
0075 6134 05C6  14         inct  tmp2                  ; Move to action address
0076 6136 C196  26         mov   *tmp2,tmp2            ; Get action address
0077               
0078 6138 0204  20         li    tmp0,id.dialog.unsaved
     613A 0065 
0079 613C 8120  34         c     @cmdb.dialog,tmp0
     613E A31A 
0080 6140 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0081               
0082 6142 C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     6144 A322 
0083 6146 0456  20 !       b     *tmp2                 ; Process key action
0084                       ;-------------------------------------------------------
0085                       ; Add character to editor or cmdb buffer
0086                       ;-------------------------------------------------------
0087               edkey.key.process.addbuffer:
0088 6148 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     614A A01A 
0089 614C 1602  14         jne   !                     ; No, skip frame buffer
0090 614E 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6150 6618 
0091                       ;-------------------------------------------------------
0092                       ; CMDB buffer
0093                       ;-------------------------------------------------------
0094 6152 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     6154 0001 
0095 6156 1607  14         jne   edkey.key.process.crash
0096                                                   ; No, crash
0097                       ;-------------------------------------------------------
0098                       ; Don't add character if dialog has ID > 100
0099                       ;-------------------------------------------------------
0100 6158 C120  34         mov   @cmdb.dialog,tmp0
     615A A31A 
0101 615C 0284  22         ci    tmp0,100
     615E 0064 
0102 6160 1506  14         jgt   edkey.key.process.exit
0103                       ;-------------------------------------------------------
0104                       ; Add character to CMDB
0105                       ;-------------------------------------------------------
0106 6162 0460  28         b     @edkey.action.cmdb.char
     6164 6720 
0107                                                   ; Add character to CMDB buffer
0108                       ;-------------------------------------------------------
0109                       ; Crash
0110                       ;-------------------------------------------------------
0111               edkey.key.process.crash:
0112 6166 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6168 FFCE 
0113 616A 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     616C 2030 
0114                       ;-------------------------------------------------------
0115                       ; Exit
0116                       ;-------------------------------------------------------
0117               edkey.key.process.exit:
0118 616E 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     6170 75CA 
**** **** ****     > stevie_b1.asm.2287273
0098                       ;-----------------------------------------------------------------------
0099                       ; Keyboard actions - Framebuffer
0100                       ;-----------------------------------------------------------------------
0101                       copy  "edkey.fb.mov.asm"         ; Actions for movement keys
**** **** ****     > edkey.fb.mov.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.left:
0009 6172 C120  34         mov   @fb.column,tmp0
     6174 A10C 
0010 6176 1306  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 6178 0620  34         dec   @fb.column            ; Column-- in screen buffer
     617A A10C 
0015 617C 0620  34         dec   @wyx                  ; Column-- VDP cursor
     617E 832A 
0016 6180 0620  34         dec   @fb.current
     6182 A102 
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6184 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6186 75CA 
0021               
0022               
0023               *---------------------------------------------------------------
0024               * Cursor right
0025               *---------------------------------------------------------------
0026               edkey.action.right:
0027 6188 8820  54         c     @fb.column,@fb.row.length
     618A A10C 
     618C A108 
0028 618E 1406  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 6190 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6192 A10C 
0033 6194 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6196 832A 
0034 6198 05A0  34         inc   @fb.current
     619A A102 
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038 619C 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     619E 75CA 
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor up
0043               *---------------------------------------------------------------
0044               edkey.action.up:
0045                       ;-------------------------------------------------------
0046                       ; Crunch current line if dirty
0047                       ;-------------------------------------------------------
0048 61A0 8820  54         c     @fb.row.dirty,@w$ffff
     61A2 A10A 
     61A4 202C 
0049 61A6 1604  14         jne   edkey.action.up.cursor
0050 61A8 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     61AA 6C94 
0051 61AC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     61AE A10A 
0052                       ;-------------------------------------------------------
0053                       ; Move cursor
0054                       ;-------------------------------------------------------
0055               edkey.action.up.cursor:
0056 61B0 C120  34         mov   @fb.row,tmp0
     61B2 A106 
0057 61B4 1509  14         jgt   edkey.action.up.cursor_up
0058                                                   ; Move cursor up if fb.row > 0
0059 61B6 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     61B8 A104 
0060 61BA 130A  14         jeq   edkey.action.up.set_cursorx
0061                                                   ; At top, only position cursor X
0062                       ;-------------------------------------------------------
0063                       ; Scroll 1 line
0064                       ;-------------------------------------------------------
0065 61BC 0604  14         dec   tmp0                  ; fb.topline--
0066 61BE C804  38         mov   tmp0,@parm1
     61C0 2F20 
0067 61C2 06A0  32         bl    @fb.refresh           ; Scroll one line up
     61C4 6914 
0068 61C6 1004  14         jmp   edkey.action.up.set_cursorx
0069                       ;-------------------------------------------------------
0070                       ; Move cursor up
0071                       ;-------------------------------------------------------
0072               edkey.action.up.cursor_up:
0073 61C8 0620  34         dec   @fb.row               ; Row-- in screen buffer
     61CA A106 
0074 61CC 06A0  32         bl    @up                   ; Row-- VDP cursor
     61CE 26AC 
0075                       ;-------------------------------------------------------
0076                       ; Check line length and position cursor
0077                       ;-------------------------------------------------------
0078               edkey.action.up.set_cursorx:
0079 61D0 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     61D2 6E34 
0080                                                   ; | i  @fb.row        = Row in frame buffer
0081                                                   ; / o  @fb.row.length = Length of row
0082               
0083 61D4 8820  54         c     @fb.column,@fb.row.length
     61D6 A10C 
     61D8 A108 
0084 61DA 1207  14         jle   edkey.action.up.exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 61DC C820  54         mov   @fb.row.length,@fb.column
     61DE A108 
     61E0 A10C 
0089 61E2 C120  34         mov   @fb.column,tmp0
     61E4 A10C 
0090 61E6 06A0  32         bl    @xsetx                ; Set VDP cursor X
     61E8 26B6 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.up.exit:
0095 61EA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     61EC 68F8 
0096 61EE 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     61F0 75CA 
0097               
0098               
0099               
0100               *---------------------------------------------------------------
0101               * Cursor down
0102               *---------------------------------------------------------------
0103               edkey.action.down:
0104 61F2 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     61F4 A106 
     61F6 A204 
0105 61F8 1330  14         jeq   !                     ; Yes, skip further processing
0106                       ;-------------------------------------------------------
0107                       ; Crunch current row if dirty
0108                       ;-------------------------------------------------------
0109 61FA 8820  54         c     @fb.row.dirty,@w$ffff
     61FC A10A 
     61FE 202C 
0110 6200 1604  14         jne   edkey.action.down.move
0111 6202 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6204 6C94 
0112 6206 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6208 A10A 
0113                       ;-------------------------------------------------------
0114                       ; Move cursor
0115                       ;-------------------------------------------------------
0116               edkey.action.down.move:
0117                       ;-------------------------------------------------------
0118                       ; EOF reached?
0119                       ;-------------------------------------------------------
0120 620A C120  34         mov   @fb.topline,tmp0
     620C A104 
0121 620E A120  34         a     @fb.row,tmp0
     6210 A106 
0122 6212 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6214 A204 
0123 6216 1312  14         jeq   edkey.action.down.set_cursorx
0124                                                   ; Yes, only position cursor X
0125                       ;-------------------------------------------------------
0126                       ; Check if scrolling required
0127                       ;-------------------------------------------------------
0128 6218 C120  34         mov   @fb.scrrows,tmp0
     621A A118 
0129 621C 0604  14         dec   tmp0
0130 621E 8120  34         c     @fb.row,tmp0
     6220 A106 
0131 6222 1108  14         jlt   edkey.action.down.cursor
0132                       ;-------------------------------------------------------
0133                       ; Scroll 1 line
0134                       ;-------------------------------------------------------
0135 6224 C820  54         mov   @fb.topline,@parm1
     6226 A104 
     6228 2F20 
0136 622A 05A0  34         inc   @parm1
     622C 2F20 
0137 622E 06A0  32         bl    @fb.refresh
     6230 6914 
0138 6232 1004  14         jmp   edkey.action.down.set_cursorx
0139                       ;-------------------------------------------------------
0140                       ; Move cursor down a row, there are still rows left
0141                       ;-------------------------------------------------------
0142               edkey.action.down.cursor:
0143 6234 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6236 A106 
0144 6238 06A0  32         bl    @down                 ; Row++ VDP cursor
     623A 26A4 
0145                       ;-------------------------------------------------------
0146                       ; Check line length and position cursor
0147                       ;-------------------------------------------------------
0148               edkey.action.down.set_cursorx:
0149 623C 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     623E 6E34 
0150                                                   ; | i  @fb.row        = Row in frame buffer
0151                                                   ; / o  @fb.row.length = Length of row
0152               
0153 6240 8820  54         c     @fb.column,@fb.row.length
     6242 A10C 
     6244 A108 
0154 6246 1207  14         jle   edkey.action.down.exit
0155                                                   ; Exit
0156                       ;-------------------------------------------------------
0157                       ; Adjust cursor column position
0158                       ;-------------------------------------------------------
0159 6248 C820  54         mov   @fb.row.length,@fb.column
     624A A108 
     624C A10C 
0160 624E C120  34         mov   @fb.column,tmp0
     6250 A10C 
0161 6252 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6254 26B6 
0162                       ;-------------------------------------------------------
0163                       ; Exit
0164                       ;-------------------------------------------------------
0165               edkey.action.down.exit:
0166 6256 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6258 68F8 
0167 625A 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     625C 75CA 
0168               
0169               
0170               
0171               *---------------------------------------------------------------
0172               * Cursor beginning of line
0173               *---------------------------------------------------------------
0174               edkey.action.home:
0175 625E C120  34         mov   @wyx,tmp0
     6260 832A 
0176 6262 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6264 FF00 
0177 6266 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6268 832A 
0178 626A 04E0  34         clr   @fb.column
     626C A10C 
0179 626E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6270 68F8 
0180 6272 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6274 75CA 
0181               
0182               *---------------------------------------------------------------
0183               * Cursor end of line
0184               *---------------------------------------------------------------
0185               edkey.action.end:
0186 6276 C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     6278 A108 
0187 627A 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     627C 0050 
0188 627E 1102  14         jlt   !                     ; | is right of last character on line,
0189 6280 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     6282 004F 
0190                       ;-------------------------------------------------------
0191                       ; Set cursor X position
0192                       ;-------------------------------------------------------
0193 6284 C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     6286 A10C 
0194 6288 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     628A 26B6 
0195 628C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     628E 68F8 
0196 6290 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6292 75CA 
**** **** ****     > stevie_b1.asm.2287273
0102                       copy  "edkey.fb.mov.word.asm"    ; Move to previous / next word
**** **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor beginning of word or previous word
0007               *---------------------------------------------------------------
0008               edkey.action.pword:
0009 6294 C120  34         mov   @fb.column,tmp0
     6296 A10C 
0010 6298 1324  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 629A C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     629C A102 
0015 629E 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 62A0 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 62A2 0605  14         dec   tmp1
0022 62A4 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 62A6 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 62A8 D195  26         movb  *tmp1,tmp2            ; Get character
0030 62AA 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 62AC D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 62AE 0986  56         srl   tmp2,8                ; Right justify
0033 62B0 0286  22         ci    tmp2,32               ; Space character found?
     62B2 0020 
0034 62B4 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 62B6 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62B8 2020 
0040 62BA 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 62BC 0287  22         ci    tmp3,>20ff            ; First character is space
     62BE 20FF 
0043 62C0 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 62C2 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     62C4 A10C 
0048 62C6 61C4  18         s     tmp0,tmp3
0049 62C8 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     62CA 0002 
0050 62CC 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 62CE 0585  14         inc   tmp1
0056 62D0 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 62D2 C805  38         mov   tmp1,@fb.current
     62D4 A102 
0062 62D6 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62D8 A10C 
0063 62DA 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62DC 26B6 
0064                       ;-------------------------------------------------------
0065                       ; Exit
0066                       ;-------------------------------------------------------
0067               edkey.action.pword.exit:
0068 62DE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62E0 68F8 
0069 62E2 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     62E4 75CA 
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Cursor next word
0075               *---------------------------------------------------------------
0076               edkey.action.nword:
0077 62E6 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 62E8 C120  34         mov   @fb.column,tmp0
     62EA A10C 
0079 62EC 8804  38         c     tmp0,@fb.row.length
     62EE A108 
0080 62F0 1428  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 62F2 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62F4 A102 
0085 62F6 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 62F8 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 62FA 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 62FC 0585  14         inc   tmp1
0097 62FE 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 6300 8804  38         c     tmp0,@fb.row.length
     6302 A108 
0099 6304 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6306 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6308 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 630A D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 630C 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 630E 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     6310 FFFF 
0111 6312 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 6314 0286  22         ci    tmp2,32
     6316 0020 
0117 6318 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 631A 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 631C 0286  22         ci    tmp2,32               ; Space character found?
     631E 0020 
0125 6320 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 6322 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     6324 2020 
0131 6326 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 6328 0287  22         ci    tmp3,>20ff            ; First characer is space?
     632A 20FF 
0134 632C 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 632E 0585  14         inc   tmp1
0139 6330 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 6332 C805  38         mov   tmp1,@fb.current
     6334 A102 
0145 6336 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     6338 A10C 
0146 633A 06A0  32         bl    @xsetx                ; Set VDP cursor X
     633C 26B6 
0147                       ;-------------------------------------------------------
0148                       ; Exit
0149                       ;-------------------------------------------------------
0150               edkey.action.nword.exit:
0151 633E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6340 68F8 
0152 6342 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     6344 75CA 
0153               
0154               
**** **** ****     > stevie_b1.asm.2287273
0103                       copy  "edkey.fb.mov.paging.asm"  ; Move page up / down
**** **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Previous page
0007               *---------------------------------------------------------------
0008               edkey.action.ppage:
0009                       ;-------------------------------------------------------
0010                       ; Sanity check
0011                       ;-------------------------------------------------------
0012 6346 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     6348 A104 
0013 634A 1315  14         jeq   edkey.action.ppage.exit
0014                       ;-------------------------------------------------------
0015                       ; Special treatment top page
0016                       ;-------------------------------------------------------
0017 634C 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     634E A118 
0018 6350 1503  14         jgt   edkey.action.ppage.topline
0019 6352 04E0  34         clr   @fb.topline           ; topline = 0
     6354 A104 
0020 6356 1003  14         jmp   edkey.action.ppage.crunch
0021                       ;-------------------------------------------------------
0022                       ; Adjust topline
0023                       ;-------------------------------------------------------
0024               edkey.action.ppage.topline:
0025 6358 6820  54         s     @fb.scrrows,@fb.topline
     635A A118 
     635C A104 
0026                       ;-------------------------------------------------------
0027                       ; Crunch current row if dirty
0028                       ;-------------------------------------------------------
0029               edkey.action.ppage.crunch:
0030 635E 8820  54         c     @fb.row.dirty,@w$ffff
     6360 A10A 
     6362 202C 
0031 6364 1604  14         jne   edkey.action.ppage.refresh
0032 6366 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6368 6C94 
0033 636A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     636C A10A 
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 636E C820  54         mov   @fb.topline,@parm1
     6370 A104 
     6372 2F20 
0039               
0040 6374 101A  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0041                                                   ; / i  @parm1 = Line in editor buffer
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               edkey.action.ppage.exit:
0046 6376 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6378 75CA 
0047               
0048               
0049               
0050               
0051               *---------------------------------------------------------------
0052               * Next page
0053               *---------------------------------------------------------------
0054               edkey.action.npage:
0055                       ;-------------------------------------------------------
0056                       ; Sanity check
0057                       ;-------------------------------------------------------
0058 637A C120  34         mov   @fb.topline,tmp0
     637C A104 
0059 637E A120  34         a     @fb.scrrows,tmp0
     6380 A118 
0060 6382 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     6384 A204 
0061 6386 150F  14         jgt   edkey.action.npage.exit
0062                       ;-------------------------------------------------------
0063                       ; Adjust topline
0064                       ;-------------------------------------------------------
0065               edkey.action.npage.topline:
0066 6388 A820  54         a     @fb.scrrows,@fb.topline
     638A A118 
     638C A104 
0067                       ;-------------------------------------------------------
0068                       ; Crunch current row if dirty
0069                       ;-------------------------------------------------------
0070               edkey.action.npage.crunch:
0071 638E 8820  54         c     @fb.row.dirty,@w$ffff
     6390 A10A 
     6392 202C 
0072 6394 1604  14         jne   edkey.action.npage.refresh
0073 6396 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6398 6C94 
0074 639A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     639C A10A 
0075                       ;-------------------------------------------------------
0076                       ; Refresh page
0077                       ;-------------------------------------------------------
0078               edkey.action.npage.refresh:
0079 639E C820  54         mov   @fb.topline,@parm1
     63A0 A104 
     63A2 2F20 
0080               
0081 63A4 1002  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0082                                                   ; / i  @parm1 = Line in editor buffer
0083                       ;-------------------------------------------------------
0084                       ; Exit
0085                       ;-------------------------------------------------------
0086               edkey.action.npage.exit:
0087 63A6 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63A8 75CA 
**** **** ****     > stevie_b1.asm.2287273
0104                       copy  "edkey.fb.mov.topbot.asm"  ; Move to top / bottom of buffer
**** **** ****     > edkey.fb.mov.topbot.asm
0001               * FILE......: edkey.fb.mov.topbot.asm
0002               * Purpose...: Move to top / bottom in editor buffer
0003               
0004               ***************************************************************
0005               * _edkey.goto.fb.toprow
0006               *
0007               * Position cursor on first row in frame buffer and
0008               * align variables in editor buffer to match with that position.
0009               *
0010               * Internal method that needs to be called via jmp or branch
0011               * instruction.
0012               ***************************************************************
0013               * b    _edkey.goto.fb.toprow
0014               * jmp  _edkey.goto.fb.toprow
0015               *--------------------------------------------------------------
0016               * INPUT
0017               * @parm1  = Line in editor buffer to display as top row (goto)
0018               *
0019               * Register usage
0020               * none
0021               *--------------------------------------------------------------
0022               *  Remarks
0023               *  Private, only to be called from inside edkey submodules
0024               ********|*****|*********************|**************************
0025               _edkey.goto.fb.toprow:
0026 63AA 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     63AC 6914 
0027                                                   ; | i  @parm1 = Line to start with
0028                                                   ; /             (becomes @fb.topline)
0029               
0030 63AE 04E0  34         clr   @fb.row               ; Frame buffer line 0
     63B0 A106 
0031 63B2 04E0  34         clr   @fb.column            ; Frame buffer column 0
     63B4 A10C 
0032 63B6 04E0  34         clr   @wyx                  ; Set VDP cursor on row 0, column 0
     63B8 832A 
0033               
0034 63BA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     63BC 68F8 
0035               
0036 63BE 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     63C0 6E34 
0037                                                   ; | i  @fb.row        = Row in frame buffer
0038                                                   ; / o  @fb.row.length = Length of row
0039               
0040 63C2 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     63C4 75CA 
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Goto top of file
0045               *---------------------------------------------------------------
0046               edkey.action.top:
0047                       ;-------------------------------------------------------
0048                       ; Crunch current row if dirty
0049                       ;-------------------------------------------------------
0050 63C6 8820  54         c     @fb.row.dirty,@w$ffff
     63C8 A10A 
     63CA 202C 
0051 63CC 1604  14         jne   edkey.action.top.refresh
0052 63CE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63D0 6C94 
0053 63D2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D4 A10A 
0054                       ;-------------------------------------------------------
0055                       ; Refresh page
0056                       ;-------------------------------------------------------
0057               edkey.action.top.refresh:
0058 63D6 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     63D8 2F20 
0059               
0060 63DA 10E7  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0061                                                   ; / i  @parm1 = Line in editor buffer
0062               
0063               
0064               
0065               
0066               *---------------------------------------------------------------
0067               * Goto bottom of file
0068               *---------------------------------------------------------------
0069               edkey.action.bot:
0070                       ;-------------------------------------------------------
0071                       ; Crunch current row if dirty
0072                       ;-------------------------------------------------------
0073 63DC 8820  54         c     @fb.row.dirty,@w$ffff
     63DE A10A 
     63E0 202C 
0074 63E2 1604  14         jne   edkey.action.bot.refresh
0075 63E4 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     63E6 6C94 
0076 63E8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63EA A10A 
0077                       ;-------------------------------------------------------
0078                       ; Refresh page
0079                       ;-------------------------------------------------------
0080               edkey.action.bot.refresh:
0081 63EC 8820  54         c     @edb.lines,@fb.scrrows
     63EE A204 
     63F0 A118 
0082 63F2 1207  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0083               
0084 63F4 C120  34         mov   @edb.lines,tmp0
     63F6 A204 
0085 63F8 6120  34         s     @fb.scrrows,tmp0
     63FA A118 
0086 63FC C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     63FE 2F20 
0087               
0088 6400 10D4  14         jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
0089                                                   ; / i  @parm1 = Line in editor buffer
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.bot.exit:
0094 6402 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6404 75CA 
**** **** ****     > stevie_b1.asm.2287273
0105                       copy  "edkey.fb.del.asm"         ; Delete characters or lines
**** **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Delete character
0007               *---------------------------------------------------------------
0008               edkey.action.del_char:
0009 6406 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6408 A206 
0010 640A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     640C 68F8 
0011                       ;-------------------------------------------------------
0012                       ; Sanity check 1 - Empty line
0013                       ;-------------------------------------------------------
0014 640E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6410 A102 
0015 6412 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6414 A108 
0016 6416 1319  14         jeq   edkey.action.del_char.exit
0017                                                   ; Exit if empty line
0018                       ;-------------------------------------------------------
0019                       ; Sanity check 2 - Already at EOL
0020                       ;-------------------------------------------------------
0021 6418 8820  54         c     @fb.column,@fb.row.length
     641A A10C 
     641C A108 
0022 641E 1315  14         jeq   edkey.action.del_char.exit
0023                                                   ; Exit if at EOL
0024                       ;-------------------------------------------------------
0025                       ; Prepare for delete operation
0026                       ;-------------------------------------------------------
0027 6420 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6422 A102 
0028 6424 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0029 6426 0585  14         inc   tmp1                  ; / tmp1 = Next character
0030                       ;-------------------------------------------------------
0031                       ; Loop until end of line
0032                       ;-------------------------------------------------------
0033               edkey.action.del_char_loop:
0034 6428 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0035 642A 0606  14         dec   tmp2
0036 642C 16FD  14         jne   edkey.action.del_char_loop
0037                       ;-------------------------------------------------------
0038                       ; Special treatment if line 80 characters long
0039                       ;-------------------------------------------------------
0040 642E 0206  20         li    tmp2,colrow
     6430 0050 
0041 6432 81A0  34         c     @fb.row.length,tmp2
     6434 A108 
0042 6436 1603  14         jne   !
0043 6438 0604  14         dec   tmp0                  ; One time adjustment
0044 643A 04C5  14         clr   tmp1
0045 643C D505  30         movb  tmp1,*tmp0            ; Write >00 character
0046                       ;-------------------------------------------------------
0047                       ; Save variables
0048                       ;-------------------------------------------------------
0049 643E 0720  34 !       seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6440 A10A 
0050 6442 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6444 A116 
0051 6446 0620  34         dec   @fb.row.length        ; @fb.row.length--
     6448 A108 
0052                       ;-------------------------------------------------------
0053                       ; Exit
0054                       ;-------------------------------------------------------
0055               edkey.action.del_char.exit:
0056 644A 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     644C 75CA 
0057               
0058               
0059               *---------------------------------------------------------------
0060               * Delete until end of line
0061               *---------------------------------------------------------------
0062               edkey.action.del_eol:
0063 644E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6450 A206 
0064 6452 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6454 68F8 
0065 6456 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     6458 A108 
0066 645A 1311  14         jeq   edkey.action.del_eol.exit
0067                                                   ; Exit if empty line
0068                       ;-------------------------------------------------------
0069                       ; Prepare for erase operation
0070                       ;-------------------------------------------------------
0071 645C C120  34         mov   @fb.current,tmp0      ; Get pointer
     645E A102 
0072 6460 C1A0  34         mov   @fb.colsline,tmp2
     6462 A10E 
0073 6464 61A0  34         s     @fb.column,tmp2
     6466 A10C 
0074 6468 04C5  14         clr   tmp1
0075                       ;-------------------------------------------------------
0076                       ; Loop until last column in frame buffer
0077                       ;-------------------------------------------------------
0078               edkey.action.del_eol_loop:
0079 646A DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0080 646C 0606  14         dec   tmp2
0081 646E 16FD  14         jne   edkey.action.del_eol_loop
0082                       ;-------------------------------------------------------
0083                       ; Save variables
0084                       ;-------------------------------------------------------
0085 6470 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6472 A10A 
0086 6474 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6476 A116 
0087               
0088 6478 C820  54         mov   @fb.column,@fb.row.length
     647A A10C 
     647C A108 
0089                                                   ; Set new row length
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_eol.exit:
0094 647E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6480 75CA 
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete current line
0099               *---------------------------------------------------------------
0100               edkey.action.del_line:
0101 6482 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6484 A206 
0102                       ;-------------------------------------------------------
0103                       ; Special treatment if only 1 line in file
0104                       ;-------------------------------------------------------
0105 6486 C120  34         mov   @edb.lines,tmp0
     6488 A204 
0106 648A 1606  14         jne   !
0107 648C 04E0  34         clr   @fb.column            ; Column 0
     648E A10C 
0108 6490 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6492 68F8 
0109 6494 0460  28         b     @edkey.action.del_eol ; Delete until end of line
     6496 644E 
0110                       ;-------------------------------------------------------
0111                       ; Delete entry in index
0112                       ;-------------------------------------------------------
0113 6498 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     649A 68F8 
0114 649C 04E0  34         clr   @fb.row.dirty         ; Discard current line
     649E A10A 
0115 64A0 C820  54         mov   @fb.topline,@parm1
     64A2 A104 
     64A4 2F20 
0116 64A6 A820  54         a     @fb.row,@parm1        ; Line number to remove
     64A8 A106 
     64AA 2F20 
0117 64AC C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     64AE A204 
     64B0 2F22 
0118 64B2 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     64B4 6B7C 
0119 64B6 0620  34         dec   @edb.lines            ; One line less in editor buffer
     64B8 A204 
0120                       ;-------------------------------------------------------
0121                       ; Refresh frame buffer and physical screen
0122                       ;-------------------------------------------------------
0123 64BA C820  54         mov   @fb.topline,@parm1
     64BC A104 
     64BE 2F20 
0124 64C0 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     64C2 6914 
0125 64C4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     64C6 A116 
0126                       ;-------------------------------------------------------
0127                       ; Special treatment if current line was last line
0128                       ;-------------------------------------------------------
0129 64C8 C120  34         mov   @fb.topline,tmp0
     64CA A104 
0130 64CC A120  34         a     @fb.row,tmp0
     64CE A106 
0131 64D0 8804  38         c     tmp0,@edb.lines       ; Was last line?
     64D2 A204 
0132 64D4 1202  14         jle   edkey.action.del_line.exit
0133 64D6 0460  28         b     @edkey.action.up      ; One line up
     64D8 61A0 
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137               edkey.action.del_line.exit:
0138 64DA 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     64DC 625E 
**** **** ****     > stevie_b1.asm.2287273
0106                       copy  "edkey.fb.ins.asm"         ; Insert characters or lines
**** **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Insert character
0007               *
0008               * @parm1 = high byte has character to insert
0009               *---------------------------------------------------------------
0010               edkey.action.ins_char.ws:
0011 64DE 0204  20         li    tmp0,>2000            ; White space
     64E0 2000 
0012 64E2 C804  38         mov   tmp0,@parm1
     64E4 2F20 
0013               edkey.action.ins_char:
0014 64E6 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64E8 A206 
0015 64EA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64EC 68F8 
0016                       ;-------------------------------------------------------
0017                       ; Sanity check 1 - Empty line
0018                       ;-------------------------------------------------------
0019 64EE C120  34         mov   @fb.current,tmp0      ; Get pointer
     64F0 A102 
0020 64F2 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64F4 A108 
0021 64F6 132B  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Sanity check 2 - EOL
0025                       ;-------------------------------------------------------
0026 64F8 8820  54         c     @fb.column,@fb.row.length
     64FA A10C 
     64FC A108 
0027 64FE 1327  14         jeq   edkey.action.ins_char.append
0028                                                   ; Add character in append mode
0029                       ;-------------------------------------------------------
0030                       ; Sanity check 3 - Overwrite if at column 80
0031                       ;-------------------------------------------------------
0032 6500 C160  34         mov   @fb.column,tmp1
     6502 A10C 
0033 6504 0285  22         ci    tmp1,colrow - 1       ; Overwrite if last column in row
     6506 004F 
0034 6508 1102  14         jlt   !
0035 650A 0460  28         b     @edkey.action.char.overwrite
     650C 663A 
0036                       ;-------------------------------------------------------
0037                       ; Sanity check 4 - 80 characters maximum
0038                       ;-------------------------------------------------------
0039 650E C160  34 !       mov   @fb.row.length,tmp1
     6510 A108 
0040 6512 0285  22         ci    tmp1,colrow
     6514 0050 
0041 6516 131D  14         jeq   edkey.action.ins_char.exit
0042                       ;-------------------------------------------------------
0043                       ; Prepare for insert operation
0044                       ;-------------------------------------------------------
0045               edkey.action.skipsanity:
0046 6518 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0047 651A 61E0  34         s     @fb.column,tmp3
     651C A10C 
0048 651E A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0049 6520 C144  18         mov   tmp0,tmp1
0050 6522 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0051 6524 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6526 A10C 
0052 6528 0586  14         inc   tmp2
0053                       ;-------------------------------------------------------
0054                       ; Loop from end of line until current character
0055                       ;-------------------------------------------------------
0056               edkey.action.ins_char.loop:
0057 652A D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0058 652C 0604  14         dec   tmp0
0059 652E 0605  14         dec   tmp1
0060 6530 0606  14         dec   tmp2
0061 6532 16FB  14         jne   edkey.action.ins_char.loop
0062                       ;-------------------------------------------------------
0063                       ; Set specified character on current position
0064                       ;-------------------------------------------------------
0065 6534 D560  46         movb  @parm1,*tmp1
     6536 2F20 
0066                       ;-------------------------------------------------------
0067                       ; Save variables and exit
0068                       ;-------------------------------------------------------
0069 6538 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     653A A10A 
0070 653C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     653E A116 
0071 6540 05A0  34         inc   @fb.column
     6542 A10C 
0072 6544 05A0  34         inc   @wyx
     6546 832A 
0073 6548 05A0  34         inc   @fb.row.length        ; @fb.row.length
     654A A108 
0074 654C 1002  14         jmp   edkey.action.ins_char.exit
0075                       ;-------------------------------------------------------
0076                       ; Add character in append mode
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.append:
0079 654E 0460  28         b     @edkey.action.char.overwrite
     6550 663A 
0080                       ;-------------------------------------------------------
0081                       ; Exit
0082                       ;-------------------------------------------------------
0083               edkey.action.ins_char.exit:
0084 6552 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6554 75CA 
0085               
0086               
0087               
0088               
0089               
0090               
0091               *---------------------------------------------------------------
0092               * Insert new line
0093               *---------------------------------------------------------------
0094               edkey.action.ins_line:
0095 6556 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6558 A206 
0096                       ;-------------------------------------------------------
0097                       ; Crunch current line if dirty
0098                       ;-------------------------------------------------------
0099 655A 8820  54         c     @fb.row.dirty,@w$ffff
     655C A10A 
     655E 202C 
0100 6560 1604  14         jne   edkey.action.ins_line.insert
0101 6562 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6564 6C94 
0102 6566 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6568 A10A 
0103                       ;-------------------------------------------------------
0104                       ; Insert entry in index
0105                       ;-------------------------------------------------------
0106               edkey.action.ins_line.insert:
0107 656A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     656C 68F8 
0108 656E C820  54         mov   @fb.topline,@parm1
     6570 A104 
     6572 2F20 
0109 6574 A820  54         a     @fb.row,@parm1        ; Line number to insert
     6576 A106 
     6578 2F20 
0110 657A C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     657C A204 
     657E 2F22 
0111               
0112 6580 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6582 6C06 
0113                                                   ; \ i  parm1 = Line for insert
0114                                                   ; / i  parm2 = Last line to reorg
0115               
0116 6584 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6586 A204 
0117                       ;-------------------------------------------------------
0118                       ; Refresh frame buffer and physical screen
0119                       ;-------------------------------------------------------
0120 6588 C820  54         mov   @fb.topline,@parm1
     658A A104 
     658C 2F20 
0121 658E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     6590 6914 
0122 6592 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6594 A116 
0123                       ;-------------------------------------------------------
0124                       ; Exit
0125                       ;-------------------------------------------------------
0126               edkey.action.ins_line.exit:
0127 6596 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6598 75CA 
**** **** ****     > stevie_b1.asm.2287273
0107                       copy  "edkey.fb.mod.asm"         ; Actions for modifier keys
**** **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               
0005               
0006               
0007               
0008               
0009               
0010               
0011               *---------------------------------------------------------------
0012               * Enter
0013               *---------------------------------------------------------------
0014               edkey.action.enter:
0015                       ;-------------------------------------------------------
0016                       ; Crunch current line if dirty
0017                       ;-------------------------------------------------------
0018 659A 8820  54         c     @fb.row.dirty,@w$ffff
     659C A10A 
     659E 202C 
0019 65A0 1606  14         jne   edkey.action.enter.upd_counter
0020 65A2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65A4 A206 
0021 65A6 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     65A8 6C94 
0022 65AA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     65AC A10A 
0023                       ;-------------------------------------------------------
0024                       ; Update line counter
0025                       ;-------------------------------------------------------
0026               edkey.action.enter.upd_counter:
0027 65AE C120  34         mov   @fb.topline,tmp0
     65B0 A104 
0028 65B2 A120  34         a     @fb.row,tmp0
     65B4 A106 
0029 65B6 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     65B8 A204 
0030 65BA 1602  14         jne   edkey.action.newline  ; No, continue newline
0031 65BC 05A0  34         inc   @edb.lines            ; Total lines++
     65BE A204 
0032                       ;-------------------------------------------------------
0033                       ; Process newline
0034                       ;-------------------------------------------------------
0035               edkey.action.newline:
0036                       ;-------------------------------------------------------
0037                       ; Scroll 1 line if cursor at bottom row of screen
0038                       ;-------------------------------------------------------
0039 65C0 C120  34         mov   @fb.scrrows,tmp0
     65C2 A118 
0040 65C4 0604  14         dec   tmp0
0041 65C6 8120  34         c     @fb.row,tmp0
     65C8 A106 
0042 65CA 110A  14         jlt   edkey.action.newline.down
0043                       ;-------------------------------------------------------
0044                       ; Scroll
0045                       ;-------------------------------------------------------
0046 65CC C120  34         mov   @fb.scrrows,tmp0
     65CE A118 
0047 65D0 C820  54         mov   @fb.topline,@parm1
     65D2 A104 
     65D4 2F20 
0048 65D6 05A0  34         inc   @parm1
     65D8 2F20 
0049 65DA 06A0  32         bl    @fb.refresh
     65DC 6914 
0050 65DE 1004  14         jmp   edkey.action.newline.rest
0051                       ;-------------------------------------------------------
0052                       ; Move cursor down a row, there are still rows left
0053                       ;-------------------------------------------------------
0054               edkey.action.newline.down:
0055 65E0 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     65E2 A106 
0056 65E4 06A0  32         bl    @down                 ; Row++ VDP cursor
     65E6 26A4 
0057                       ;-------------------------------------------------------
0058                       ; Set VDP cursor and save variables
0059                       ;-------------------------------------------------------
0060               edkey.action.newline.rest:
0061 65E8 06A0  32         bl    @fb.get.firstnonblank
     65EA 6984 
0062 65EC C120  34         mov   @outparm1,tmp0
     65EE 2F30 
0063 65F0 C804  38         mov   tmp0,@fb.column
     65F2 A10C 
0064 65F4 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     65F6 26B6 
0065 65F8 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     65FA 6E34 
0066 65FC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65FE 68F8 
0067 6600 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6602 A116 
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071               edkey.action.newline.exit:
0072 6604 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6606 75CA 
0073               
0074               
0075               
0076               
0077               *---------------------------------------------------------------
0078               * Toggle insert/overwrite mode
0079               *---------------------------------------------------------------
0080               edkey.action.ins_onoff:
0081 6608 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     660A A20A 
0082                       ;-------------------------------------------------------
0083                       ; Delay
0084                       ;-------------------------------------------------------
0085 660C 0204  20         li    tmp0,2000
     660E 07D0 
0086               edkey.action.ins_onoff.loop:
0087 6610 0604  14         dec   tmp0
0088 6612 16FE  14         jne   edkey.action.ins_onoff.loop
0089                       ;-------------------------------------------------------
0090                       ; Exit
0091                       ;-------------------------------------------------------
0092               edkey.action.ins_onoff.exit:
0093 6614 0460  28         b     @task.vdp.cursor      ; Update cursor shape
     6616 76C8 
0094               
0095               
0096               
0097               
0098               *---------------------------------------------------------------
0099               * Add character (frame buffer)
0100               *---------------------------------------------------------------
0101               edkey.action.char:
0102                       ;-------------------------------------------------------
0103                       ; Sanity checks
0104                       ;-------------------------------------------------------
0105 6618 D105  18         movb  tmp1,tmp0             ; Get keycode
0106 661A 0984  56         srl   tmp0,8                ; MSB to LSB
0107               
0108 661C 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     661E 0020 
0109 6620 1126  14         jlt   edkey.action.char.exit
0110                                                   ; Yes, skip
0111               
0112 6622 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     6624 007E 
0113 6626 1523  14         jgt   edkey.action.char.exit
0114                                                   ; Yes, skip
0115                       ;-------------------------------------------------------
0116                       ; Setup
0117                       ;-------------------------------------------------------
0118 6628 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     662A A206 
0119 662C D805  38         movb  tmp1,@parm1           ; Store character for insert
     662E 2F20 
0120 6630 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     6632 A20A 
0121 6634 1302  14         jeq   edkey.action.char.overwrite
0122                       ;-------------------------------------------------------
0123                       ; Insert mode
0124                       ;-------------------------------------------------------
0125               edkey.action.char.insert:
0126 6636 0460  28         b     @edkey.action.ins_char
     6638 64E6 
0127                       ;-------------------------------------------------------
0128                       ; Overwrite mode
0129                       ;-------------------------------------------------------
0130               edkey.action.char.overwrite:
0131 663A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     663C 68F8 
0132 663E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6640 A102 
0133               
0134 6642 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     6644 2F20 
0135 6646 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6648 A10A 
0136 664A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     664C A116 
0137                       ;-------------------------------------------------------
0138                       ; Last column on screen reached?
0139                       ;-------------------------------------------------------
0140 664E C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6650 A10C 
0141 6652 0285  22         ci    tmp1,colrow - 2       ; | Last column on screen (X > 78)?
     6654 004E 
0142 6656 1504  14         jgt   !                     ; / Yes, only overwrite don't increase.
0143               
0144 6658 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     665A A10C 
0145 665C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     665E 832A 
0146                       ;-------------------------------------------------------
0147                       ; Update line length in frame buffer
0148                       ;-------------------------------------------------------
0149 6660 8820  54 !       c     @fb.column,@fb.row.length
     6662 A10C 
     6664 A108 
0150 6666 1103  14         jlt   edkey.action.char.exit
0151                                                   ; column < length line ? Skip processing
0152               
0153 6668 C820  54         mov   @fb.column,@fb.row.length
     666A A10C 
     666C A108 
0154                       ;-------------------------------------------------------
0155                       ; Exit
0156                       ;-------------------------------------------------------
0157               edkey.action.char.exit:
0158 666E 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6670 75CA 
**** **** ****     > stevie_b1.asm.2287273
0108                       copy  "edkey.fb.misc.asm"        ; Miscelanneous actions
**** **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Quit stevie
0007               *---------------------------------------------------------------
0008               edkey.action.quit:
0009                       ;-------------------------------------------------------
0010                       ; Show dialog "unsaved changes" if editor buffer dirty
0011                       ;-------------------------------------------------------
0012 6672 C120  34         mov   @edb.dirty,tmp0
     6674 A206 
0013 6676 1302  14         jeq   !
0014 6678 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     667A 7D24 
0015                       ;-------------------------------------------------------
0016                       ; Reset and lock F18a
0017                       ;-------------------------------------------------------
0018 667C 06A0  32 !       bl    @f18rst               ; Reset and lock the F18A
     667E 2766 
0019 6680 0420  54         blwp  @0                    ; Exit
     6682 0000 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * No action at all
0024               *---------------------------------------------------------------
0025               edkey.action.noop:
0026 6684 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6686 75CA 
**** **** ****     > stevie_b1.asm.2287273
0109                       copy  "edkey.fb.file.asm"        ; File related actions
**** **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load next or previous file based on last char in suffix
0006               *---------------------------------------------------------------
0007               * b   @edkey.action.fb.fname.inc.load
0008               * b   @edkey.action.fb.fname.dec.load
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.fb.fname.dec.load:
0017 6688 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     668A A444 
     668C 2F20 
0018 668E 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6690 2F22 
0019 6692 1005  14         jmp   _edkey.action.fb.fname.doit
0020               
0021               edkey.action.fb.fname.inc.load:
0022 6694 C820  54         mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
     6696 A444 
     6698 2F20 
0023 669A 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     669C 2F22 
0024               
0025               _edkey.action.fb.fname.doit:
0026                       ;------------------------------------------------------
0027                       ; Sanity check
0028                       ;------------------------------------------------------
0029 669E C120  34         mov   @parm1,tmp0
     66A0 2F20 
0030 66A2 130B  14         jeq   _edkey.action.fb.fname.doit.exit
0031                                                   ; Exit early if "New file"
0032                       ;------------------------------------------------------
0033                       ; Show dialog "Unsaved changed" if editor buffer dirty
0034                       ;------------------------------------------------------
0035 66A4 C120  34         mov   @edb.dirty,tmp0
     66A6 A206 
0036 66A8 1302  14         jeq   !
0037 66AA 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     66AC 7D24 
0038                       ;------------------------------------------------------
0039                       ; Update suffix and load file
0040                       ;------------------------------------------------------
0041 66AE 06A0  32 !       bl    @fm.browse.fname.suffix.incdec
     66B0 7516 
0042                                                   ; Filename suffix adjust
0043                                                   ; i  \ parm1 = Pointer to filename
0044                                                   ; i  / parm2 = >FFFF or >0000
0045               
0046 66B2 0204  20         li    tmp0,heap.top         ; 1st line in heap
     66B4 E000 
0047 66B6 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     66B8 72D8 
0048                                                   ; \ i  tmp0 = Pointer to length-prefixed
0049                                                   ; /           device/filename string
0050                       ;------------------------------------------------------
0051                       ; Exit
0052                       ;------------------------------------------------------
0053               _edkey.action.fb.fname.doit.exit:
0054 66BA 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     66BC 63C6 
**** **** ****     > stevie_b1.asm.2287273
0110                       ;-----------------------------------------------------------------------
0111                       ; Keyboard actions - Command Buffer
0112                       ;-----------------------------------------------------------------------
0113                       copy  "edkey.cmdb.mov.asm"    ; Actions for movement keys
**** **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Cursor left
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.left:
0009 66BE C120  34         mov   @cmdb.column,tmp0
     66C0 A312 
0010 66C2 1304  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Update
0013                       ;-------------------------------------------------------
0014 66C4 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     66C6 A312 
0015 66C8 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     66CA A30A 
0016                       ;-------------------------------------------------------
0017                       ; Exit
0018                       ;-------------------------------------------------------
0019 66CC 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66CE 75CA 
0020               
0021               
0022               *---------------------------------------------------------------
0023               * Cursor right
0024               *---------------------------------------------------------------
0025               edkey.action.cmdb.right:
0026 66D0 06A0  32         bl    @cmdb.cmd.getlength
     66D2 6F12 
0027 66D4 8820  54         c     @cmdb.column,@outparm1
     66D6 A312 
     66D8 2F30 
0028 66DA 1404  14         jhe   !                     ; column > length line ? Skip processing
0029                       ;-------------------------------------------------------
0030                       ; Update
0031                       ;-------------------------------------------------------
0032 66DC 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     66DE A312 
0033 66E0 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     66E2 A30A 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037 66E4 0460  28 !       b     @hook.keyscan.bounce  ; Back to editor main
     66E6 75CA 
0038               
0039               
0040               
0041               *---------------------------------------------------------------
0042               * Cursor beginning of line
0043               *---------------------------------------------------------------
0044               edkey.action.cmdb.home:
0045 66E8 04C4  14         clr   tmp0
0046 66EA C804  38         mov   tmp0,@cmdb.column      ; First column
     66EC A312 
0047 66EE 0584  14         inc   tmp0
0048 66F0 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     66F2 A30A 
0049 66F4 C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     66F6 A30A 
0050               
0051 66F8 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     66FA 75CA 
0052               
0053               *---------------------------------------------------------------
0054               * Cursor end of line
0055               *---------------------------------------------------------------
0056               edkey.action.cmdb.end:
0057 66FC D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     66FE A324 
0058 6700 0984  56         srl   tmp0,8                 ; Right justify
0059 6702 C804  38         mov   tmp0,@cmdb.column      ; Save column position
     6704 A312 
0060 6706 0584  14         inc   tmp0                   ; One time adjustment command prompt
0061 6708 0224  22         ai    tmp0,>1a00             ; Y=26
     670A 1A00 
0062 670C C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     670E A30A 
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066 6710 0460  28         b     @hook.keyscan.bounce   ; Back to editor main
     6712 75CA 
**** **** ****     > stevie_b1.asm.2287273
0114                       copy  "edkey.cmdb.mod.asm"    ; Actions for modifier keys
**** **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               
0005               ***************************************************************
0006               * edkey.action.cmdb.clear
0007               * Clear current command
0008               ***************************************************************
0009               * b  @edkey.action.cmdb.clear
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               *--------------------------------------------------------------
0020               * Notes
0021               ********|*****|*********************|**************************
0022               edkey.action.cmdb.clear:
0023                       ;-------------------------------------------------------
0024                       ; Clear current command
0025                       ;-------------------------------------------------------
0026 6714 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6716 6EE0 
0027 6718 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     671A A318 
0028                       ;-------------------------------------------------------
0029                       ; Exit
0030                       ;-------------------------------------------------------
0031               edkey.action.cmdb.clear.exit:
0032 671C 0460  28         b     @edkey.action.cmdb.home
     671E 66E8 
0033                                                   ; Reposition cursor
0034               
0035               
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * edkey.action.cmdb.char
0042               * Add character to command line
0043               ***************************************************************
0044               * b  @edkey.action.cmdb.char
0045               *--------------------------------------------------------------
0046               * INPUT
0047               * tmp1
0048               *--------------------------------------------------------------
0049               * OUTPUT
0050               * none
0051               *--------------------------------------------------------------
0052               * Register usage
0053               * tmp0
0054               *--------------------------------------------------------------
0055               * Notes
0056               ********|*****|*********************|**************************
0057               edkey.action.cmdb.char:
0058                       ;-------------------------------------------------------
0059                       ; Sanity checks
0060                       ;-------------------------------------------------------
0061 6720 D105  18         movb  tmp1,tmp0             ; Get keycode
0062 6722 0984  56         srl   tmp0,8                ; MSB to LSB
0063               
0064 6724 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6726 0020 
0065 6728 1115  14         jlt   edkey.action.cmdb.char.exit
0066                                                   ; Yes, skip
0067               
0068 672A 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     672C 007E 
0069 672E 1512  14         jgt   edkey.action.cmdb.char.exit
0070                                                   ; Yes, skip
0071                       ;-------------------------------------------------------
0072                       ; Add character
0073                       ;-------------------------------------------------------
0074 6730 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6732 A318 
0075               
0076 6734 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6736 A325 
0077 6738 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     673A A312 
0078 673C D505  30         movb  tmp1,*tmp0            ; Add character
0079 673E 05A0  34         inc   @cmdb.column          ; Next column
     6740 A312 
0080 6742 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6744 A30A 
0081               
0082 6746 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6748 6F12 
0083                                                   ; \ i  @cmdb.cmd = Command string
0084                                                   ; / o  @outparm1 = Length of command
0085                       ;-------------------------------------------------------
0086                       ; Addjust length
0087                       ;-------------------------------------------------------
0088 674A C120  34         mov   @outparm1,tmp0
     674C 2F30 
0089 674E 0A84  56         sla   tmp0,8               ; LSB to MSB
0090 6750 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6752 A324 
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               edkey.action.cmdb.char.exit:
0095 6754 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6756 75CA 
0096               
0097               
0098               
0099               
0100               *---------------------------------------------------------------
0101               * Enter
0102               *---------------------------------------------------------------
0103               edkey.action.cmdb.enter:
0104                       ;-------------------------------------------------------
0105                       ; Show Load or Save dialog depending on current mode
0106                       ;-------------------------------------------------------
0107               edkey.action.cmdb.enter.loadsave:
0108 6758 0460  28         b     @edkey.action.cmdb.loadsave
     675A 6778 
0109                       ;-------------------------------------------------------
0110                       ; Exit
0111                       ;-------------------------------------------------------
0112               edkey.action.cmdb.enter.exit:
0113 675C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     675E 75CA 
**** **** ****     > stevie_b1.asm.2287273
0115                       copy  "edkey.cmdb.misc.asm"   ; Miscelanneous actions
**** **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Show/Hide command buffer pane
0007               ********|*****|*********************|**************************
0008               edkey.action.cmdb.toggle:
0009 6760 C120  34         mov   @cmdb.visible,tmp0
     6762 A302 
0010 6764 1605  14         jne   edkey.action.cmdb.hide
0011                       ;-------------------------------------------------------
0012                       ; Show pane
0013                       ;-------------------------------------------------------
0014               edkey.action.cmdb.show:
0015 6766 04E0  34         clr   @cmdb.column          ; Column = 0
     6768 A312 
0016 676A 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     676C 79FE 
0017 676E 1002  14         jmp   edkey.action.cmdb.toggle.exit
0018                       ;-------------------------------------------------------
0019                       ; Hide pane
0020                       ;-------------------------------------------------------
0021               edkey.action.cmdb.hide:
0022 6770 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6772 7A4E 
0023                       ;-------------------------------------------------------
0024                       ; Exit
0025                       ;-------------------------------------------------------
0026               edkey.action.cmdb.toggle.exit:
0027 6774 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     6776 75CA 
0028               
0029               
0030               
**** **** ****     > stevie_b1.asm.2287273
0116                       copy  "edkey.cmdb.file.asm"   ; File related actions
**** **** ****     > edkey.cmdb.file.asm
0001               * FILE......: edkey.cmdb.fíle.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Load or save DV 80 file
0007               *---------------------------------------------------------------
0008               edkey.action.cmdb.loadsave:
0009                       ;-------------------------------------------------------
0010                       ; Load or save file
0011                       ;-------------------------------------------------------
0012 6778 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     677A 7A4E 
0013               
0014 677C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     677E 6F12 
0015 6780 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6782 2F30 
0016 6784 1607  14         jne   !                     ; No, prepare for load/save
0017                       ;-------------------------------------------------------
0018                       ; No filename specified
0019                       ;-------------------------------------------------------
0020 6786 06A0  32         bl    @pane.errline.show    ; Show error line
     6788 7A90 
0021               
0022 678A 06A0  32         bl    @pane.show_hint
     678C 7778 
0023 678E 1C00                   byte 28,0
0024 6790 354A                   data txt.io.nofile
0025               
0026 6792 1019  14         jmp   edkey.action.cmdb.loadsave.exit
0027                       ;-------------------------------------------------------
0028                       ; Prepare for loading or saving file
0029                       ;-------------------------------------------------------
0030 6794 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 6796 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6798 A324 
0032               
0033 679A 06A0  32         bl    @cpym2m
     679C 24AA 
0034 679E A324                   data cmdb.cmdlen,heap.top,80
     67A0 E000 
     67A2 0050 
0035                                                   ; Copy filename from command line to buffer
0036               
0037 67A4 C120  34         mov   @cmdb.dialog,tmp0
     67A6 A31A 
0038 67A8 0284  22         ci    tmp0,id.dialog.load   ; Dialog is "Load DV80 file" ?
     67AA 000A 
0039 67AC 1303  14         jeq   edkey.action.cmdb.load.loadfile
0040               
0041 67AE 0284  22         ci    tmp0,id.dialog.save   ; Dialog is "Save DV80 file" ?
     67B0 000B 
0042 67B2 1305  14         jeq   edkey.action.cmdb.load.savefile
0043                       ;-------------------------------------------------------
0044                       ; Load specified file
0045                       ;-------------------------------------------------------
0046               edkey.action.cmdb.load.loadfile:
0047 67B4 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67B6 E000 
0048 67B8 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     67BA 72D8 
0049                                                   ; \ i  tmp0 = Pointer to length-prefixed
0050                                                   ; /           device/filename string
0051 67BC 1004  14         jmp   edkey.action.cmdb.loadsave.exit
0052                       ;-------------------------------------------------------
0053                       ; Save specified file
0054                       ;-------------------------------------------------------
0055               edkey.action.cmdb.load.savefile:
0056 67BE 0204  20         li    tmp0,heap.top         ; 1st line in heap
     67C0 E000 
0057 67C2 06A0  32         bl    @fm.savefile          ; Save DV80 file
     67C4 7390 
0058                                                   ; \ i  tmp0 = Pointer to length-prefixed
0059                                                   ; /           device/filename string
0060                       ;-------------------------------------------------------
0061                       ; Exit
0062                       ;-------------------------------------------------------
0063               edkey.action.cmdb.loadsave.exit:
0064 67C6 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     67C8 63C6 
**** **** ****     > stevie_b1.asm.2287273
0117                       copy  "edkey.cmdb.dialog.asm" ; Dialog specific actions
**** **** ****     > edkey.cmdb.dialog.asm
0001               * FILE......: edkey.cmdb.dialog.asm
0002               * Purpose...: Dialog specific actions in command buffer pane.
0003               
0004               
0005               
0006               *---------------------------------------------------------------
0007               * Proceed with action
0008               *---------------------------------------------------------------
0009               edkey.action.cmdb.proceed:
0010                       ;-------------------------------------------------------
0011                       ; Intialisation
0012                       ;-------------------------------------------------------
0013 67CA 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     67CC A206 
0014 67CE 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     67D0 77AA 
0015 67D2 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     67D4 6EE0 
0016 67D6 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     67D8 A322 
0017                       ;-------------------------------------------------------
0018                       ; Sanity checks
0019                       ;-------------------------------------------------------
0020 67DA 0284  22         ci    tmp0,>2000
     67DC 2000 
0021 67DE 1104  14         jlt   !                     ; Invalid address, crash
0022               
0023 67E0 0284  22         ci    tmp0,>7fff
     67E2 7FFF 
0024 67E4 1501  14         jgt   !                     ; Invalid address, crash
0025                       ;------------------------------------------------------
0026                       ; All sanity checks passed
0027                       ;------------------------------------------------------
0028 67E6 0454  20         b     *tmp0                 ; Execute action
0029                       ;------------------------------------------------------
0030                       ; Sanity checks failed
0031                       ;------------------------------------------------------
0032 67E8 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     67EA FFCE 
0033 67EC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     67EE 2030 
0034                       ;-------------------------------------------------------
0035                       ; Exit
0036                       ;-------------------------------------------------------
0037               edkey.action.cmdb.proceed.exit:
0038 67F0 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     67F2 75CA 
0039               
0040               
0041               
0042               
0043               *---------------------------------------------------------------
0044               * Toggle fastmode on/off
0045               *---------------------------------------------------------------
0046               edkey.action.cmdb.fastmode.toggle:
0047 67F4 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     67F6 735E 
0048 67F8 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     67FA A318 
0049 67FC 0460  28        b     @hook.keyscan.bounce   ; Back to editor main
     67FE 75CA 
0050               
0051               
0052               
0053               
0054               ***************************************************************
0055               * dialog.close
0056               * Close dialog
0057               ***************************************************************
0058               * b   @edkey.action.cmdb.close.dialog
0059               *--------------------------------------------------------------
0060               * OUTPUT
0061               * none
0062               *--------------------------------------------------------------
0063               * Register usage
0064               * none
0065               ********|*****|*********************|**************************
0066               edkey.action.cmdb.close.dialog:
0067                       ;------------------------------------------------------
0068                       ; Close dialog
0069                       ;------------------------------------------------------
0070 6800 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6802 A31A 
0071 6804 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6806 77AA 
0072 6808 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     680A 7A4E 
0073                       ;-------------------------------------------------------
0074                       ; Exit
0075                       ;-------------------------------------------------------
0076               edkey.action.cmdb.close.dialog.exit:
0077 680C 0460  28         b     @hook.keyscan.bounce  ; Back to editor main
     680E 75CA 
**** **** ****     > stevie_b1.asm.2287273
0118                       ;-----------------------------------------------------------------------
0119                       ; Logic for Memory, Framebuffer, Index, Editor buffer, Error line
0120                       ;-----------------------------------------------------------------------
0121                       copy  "tv.asm"              ; Main editor configuration
**** **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Stevie Editor - Main editor configuration
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Main editor configuration
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * tv.init
0011               * Initialize editor settings
0012               ***************************************************************
0013               * bl @tv.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ***************************************************************
0026               tv.init:
0027 6810 0649  14         dect  stack
0028 6812 C64B  30         mov   r11,*stack            ; Save return address
0029 6814 0649  14         dect  stack
0030 6816 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6818 04E0  34         clr   @tv.colorscheme       ; Set default color scheme
     681A A012 
0035 681C 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     681E A01C 
0036 6820 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     6822 2016 
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040               tv.init.exit:
0041 6824 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0042 6826 C2F9  30         mov   *stack+,r11           ; Pop R11
0043 6828 045B  20         b     *r11                  ; Return to caller
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
0065 682A 0649  14         dect  stack
0066 682C C64B  30         mov   r11,*stack            ; Save return address
0067                       ;------------------------------------------------------
0068                       ; Reset editor
0069                       ;------------------------------------------------------
0070 682E 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     6830 6E52 
0071 6832 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6834 6C5E 
0072 6836 06A0  32         bl    @idx.init             ; Initialize index
     6838 69CC 
0073 683A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     683C 68A2 
0074 683E 06A0  32         bl    @errline.init         ; Initialize error line
     6840 6F40 
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               tv.reset.exit:
0079 6842 C2F9  30         mov   *stack+,r11           ; Pop R11
0080 6844 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0122                       copy  "mem.asm"             ; Memory Management
**** **** ****     > mem.asm
0001               * FILE......: mem.asm
0002               * Purpose...: Stevie Editor - Memory management (SAMS)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Memory Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.sams.layout
0010               * Setup SAMS memory pages for Stevie
0011               ***************************************************************
0012               * bl  @mem.setup.sams.layout
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ***************************************************************
0020               mem.sams.layout:
0021 6846 0649  14         dect  stack
0022 6848 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Set SAMS standard layout
0025                       ;------------------------------------------------------
0026 684A 06A0  32         bl    @sams.layout
     684C 25B2 
0027 684E 309E                   data mem.sams.layout.data
0028               
0029 6850 06A0  32         bl    @sams.layout.copy
     6852 2616 
0030 6854 A000                   data tv.sams.2000     ; Get SAMS windows
0031               
0032 6856 C820  54         mov   @tv.sams.c000,@edb.sams.page
     6858 A008 
     685A A212 
0033                                                   ; Track editor buffer SAMS page
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               mem.sams.layout.exit:
0038 685C C2F9  30         mov   *stack+,r11           ; Pop r11
0039 685E 045B  20         b     *r11                  ; Return to caller
0040               
0041               
0042               
0043               ***************************************************************
0044               * mem.edb.sams.mappage
0045               * Activate editor buffer SAMS page for line
0046               ***************************************************************
0047               * bl  @mem.edb.sams.mappage
0048               *     data p0
0049               *--------------------------------------------------------------
0050               * p0 = Line number in editor buffer
0051               *--------------------------------------------------------------
0052               * bl  @xmem.edb.sams.mappage
0053               *
0054               * tmp0 = Line number in editor buffer
0055               *--------------------------------------------------------------
0056               * OUTPUT
0057               * outparm1 = Pointer to line in editor buffer
0058               * outparm2 = SAMS page
0059               *--------------------------------------------------------------
0060               * Register usage
0061               * tmp0, tmp1
0062               ***************************************************************
0063               mem.edb.sams.mappage:
0064 6860 C13B  30         mov   *r11+,tmp0            ; Get p0
0065               xmem.edb.sams.mappage:
0066 6862 0649  14         dect  stack
0067 6864 C64B  30         mov   r11,*stack            ; Push return address
0068 6866 0649  14         dect  stack
0069 6868 C644  30         mov   tmp0,*stack           ; Push tmp0
0070 686A 0649  14         dect  stack
0071 686C C645  30         mov   tmp1,*stack           ; Push tmp1
0072                       ;------------------------------------------------------
0073                       ; Sanity check
0074                       ;------------------------------------------------------
0075 686E 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     6870 A204 
0076 6872 1204  14         jle   mem.edb.sams.mappage.lookup
0077                                                   ; All checks passed, continue
0078                                                   ;--------------------------
0079                                                   ; Sanity check failed
0080                                                   ;--------------------------
0081 6874 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6876 FFCE 
0082 6878 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     687A 2030 
0083                       ;------------------------------------------------------
0084                       ; Lookup SAMS page for line in parm1
0085                       ;------------------------------------------------------
0086               mem.edb.sams.mappage.lookup:
0087 687C 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     687E 6B20 
0088                                                   ; \ i  parm1    = Line number
0089                                                   ; | o  outparm1 = Pointer to line
0090                                                   ; / o  outparm2 = SAMS page
0091               
0092 6880 C120  34         mov   @outparm2,tmp0        ; SAMS page
     6882 2F32 
0093 6884 C160  34         mov   @outparm1,tmp1        ; Pointer to line
     6886 2F30 
0094 6888 1308  14         jeq   mem.edb.sams.mappage.exit
0095                                                   ; Nothing to page-in if NULL pointer
0096                                                   ; (=empty line)
0097                       ;------------------------------------------------------
0098                       ; Determine if requested SAMS page is already active
0099                       ;------------------------------------------------------
0100 688A 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     688C A008 
0101 688E 1305  14         jeq   mem.edb.sams.mappage.exit
0102                                                   ; Request page already active. Exit.
0103                       ;------------------------------------------------------
0104                       ; Activate requested SAMS page
0105                       ;-----------------------------------------------------
0106 6890 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     6892 2546 
0107                                                   ; \ i  tmp0 = SAMS page
0108                                                   ; / i  tmp1 = Memory address
0109               
0110 6894 C820  54         mov   @outparm2,@tv.sams.c000
     6896 2F32 
     6898 A008 
0111                                                   ; Set page in shadow registers
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               mem.edb.sams.mappage.exit:
0116 689A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0117 689C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0118 689E C2F9  30         mov   *stack+,r11           ; Pop r11
0119 68A0 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
**** **** ****     > stevie_b1.asm.2287273
0123                       copy  "fb.asm"              ; Framebuffer
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: Stevie Editor - Framebuffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *          RAM Framebuffer for handling screen output
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * fb.init
0010               * Initialize framebuffer
0011               ***************************************************************
0012               *  bl   @fb.init
0013               *--------------------------------------------------------------
0014               *  INPUT
0015               *  none
0016               *--------------------------------------------------------------
0017               *  OUTPUT
0018               *  none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               ********|*****|*********************|**************************
0023               fb.init:
0024 68A2 0649  14         dect  stack
0025 68A4 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 68A6 0204  20         li    tmp0,fb.top
     68A8 A600 
0030 68AA C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     68AC A100 
0031 68AE 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     68B0 A104 
0032 68B2 04E0  34         clr   @fb.row               ; Current row=0
     68B4 A106 
0033 68B6 04E0  34         clr   @fb.column            ; Current column=0
     68B8 A10C 
0034               
0035 68BA 0204  20         li    tmp0,80
     68BC 0050 
0036 68BE C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     68C0 A10E 
0037               
0038 68C2 0204  20         li    tmp0,29
     68C4 001D 
0039 68C6 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
     68C8 A118 
0040 68CA C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     68CC A11A 
0041               
0042 68CE 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     68D0 A01A 
0043 68D2 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     68D4 A116 
0044                       ;------------------------------------------------------
0045                       ; Clear frame buffer
0046                       ;------------------------------------------------------
0047 68D6 06A0  32         bl    @film
     68D8 2242 
0048 68DA A600             data  fb.top,>00,fb.size    ; Clear it all the way
     68DC 0000 
     68DE 0960 
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052               fb.init.exit:
0053 68E0 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 68E2 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
0059               ***************************************************************
0060               * fb.row2line
0061               * Calculate line in editor buffer
0062               ***************************************************************
0063               * bl @fb.row2line
0064               *--------------------------------------------------------------
0065               * INPUT
0066               * @fb.topline = Top line in frame buffer
0067               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0068               *--------------------------------------------------------------
0069               * OUTPUT
0070               * @outparm1 = Matching line in editor buffer
0071               *--------------------------------------------------------------
0072               * Register usage
0073               * tmp2,tmp3
0074               *--------------------------------------------------------------
0075               * Formula
0076               * outparm1 = @fb.topline + @parm1
0077               ********|*****|*********************|**************************
0078               fb.row2line:
0079 68E4 0649  14         dect  stack
0080 68E6 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;------------------------------------------------------
0082                       ; Calculate line in editor buffer
0083                       ;------------------------------------------------------
0084 68E8 C120  34         mov   @parm1,tmp0
     68EA 2F20 
0085 68EC A120  34         a     @fb.topline,tmp0
     68EE A104 
0086 68F0 C804  38         mov   tmp0,@outparm1
     68F2 2F30 
0087                       ;------------------------------------------------------
0088                       ; Exit
0089                       ;------------------------------------------------------
0090               fb.row2line.exit:
0091 68F4 C2F9  30         mov   *stack+,r11           ; Pop r11
0092 68F6 045B  20         b     *r11                  ; Return to caller
0093               
0094               
0095               
0096               
0097               ***************************************************************
0098               * fb.calc_pointer
0099               * Calculate pointer address in frame buffer
0100               ***************************************************************
0101               * bl @fb.calc_pointer
0102               *--------------------------------------------------------------
0103               * INPUT
0104               * @fb.top       = Address of top row in frame buffer
0105               * @fb.topline   = Top line in frame buffer
0106               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0107               * @fb.column    = Current column in frame buffer
0108               * @fb.colsline  = Columns per line in frame buffer
0109               *--------------------------------------------------------------
0110               * OUTPUT
0111               * @fb.current   = Updated pointer
0112               *--------------------------------------------------------------
0113               * Register usage
0114               * tmp2,tmp3
0115               *--------------------------------------------------------------
0116               * Formula
0117               * pointer = row * colsline + column + deref(@fb.top.ptr)
0118               ********|*****|*********************|**************************
0119               fb.calc_pointer:
0120 68F8 0649  14         dect  stack
0121 68FA C64B  30         mov   r11,*stack            ; Save return address
0122                       ;------------------------------------------------------
0123                       ; Calculate pointer
0124                       ;------------------------------------------------------
0125 68FC C1A0  34         mov   @fb.row,tmp2
     68FE A106 
0126 6900 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     6902 A10E 
0127 6904 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     6906 A10C 
0128 6908 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     690A A100 
0129 690C C807  38         mov   tmp3,@fb.current
     690E A102 
0130                       ;------------------------------------------------------
0131                       ; Exit
0132                       ;------------------------------------------------------
0133               fb.calc_pointer.exit:
0134 6910 C2F9  30         mov   *stack+,r11           ; Pop r11
0135 6912 045B  20         b     *r11                  ; Return to caller
0136               
0137               
0138               
0139               
0140               
0141               ***************************************************************
0142               * fb.refresh
0143               * Refresh frame buffer with editor buffer content
0144               ***************************************************************
0145               * bl @fb.refresh
0146               *--------------------------------------------------------------
0147               * INPUT
0148               * @parm1 = Line to start with (becomes @fb.topline)
0149               *--------------------------------------------------------------
0150               * OUTPUT
0151               * none
0152               *--------------------------------------------------------------
0153               * Register usage
0154               * tmp0,tmp1,tmp2
0155               ********|*****|*********************|**************************
0156               fb.refresh:
0157 6914 0649  14         dect  stack
0158 6916 C64B  30         mov   r11,*stack            ; Push return address
0159 6918 0649  14         dect  stack
0160 691A C644  30         mov   tmp0,*stack           ; Push tmp0
0161 691C 0649  14         dect  stack
0162 691E C645  30         mov   tmp1,*stack           ; Push tmp1
0163 6920 0649  14         dect  stack
0164 6922 C646  30         mov   tmp2,*stack           ; Push tmp2
0165                       ;------------------------------------------------------
0166                       ; Setup starting position in index
0167                       ;------------------------------------------------------
0168 6924 C820  54         mov   @parm1,@fb.topline
     6926 2F20 
     6928 A104 
0169 692A 04E0  34         clr   @parm2                ; Target row in frame buffer
     692C 2F22 
0170                       ;------------------------------------------------------
0171                       ; Check if already at EOF
0172                       ;------------------------------------------------------
0173 692E 8820  54         c     @parm1,@edb.lines    ; EOF reached?
     6930 2F20 
     6932 A204 
0174 6934 130A  14         jeq   fb.refresh.erase_eob ; Yes, no need to unpack
0175                       ;------------------------------------------------------
0176                       ; Unpack line to frame buffer
0177                       ;------------------------------------------------------
0178               fb.refresh.unpack_line:
0179 6936 06A0  32         bl    @edb.line.unpack      ; Unpack line
     6938 6D4A 
0180                                                   ; \ i  parm1    = Line to unpack
0181                                                   ; | i  parm2    = Target row in frame buffer
0182                                                   ; / o  outparm1 = Length of line
0183               
0184 693A 05A0  34         inc   @parm1                ; Next line in editor buffer
     693C 2F20 
0185 693E 05A0  34         inc   @parm2                ; Next row in frame buffer
     6940 2F22 
0186                       ;------------------------------------------------------
0187                       ; Last row in editor buffer reached ?
0188                       ;------------------------------------------------------
0189 6942 8820  54         c     @parm1,@edb.lines
     6944 2F20 
     6946 A204 
0190 6948 1212  14         jle   !                     ; no, do next check
0191                                                   ; yes, erase until end of frame buffer
0192                       ;------------------------------------------------------
0193                       ; Erase until end of frame buffer
0194                       ;------------------------------------------------------
0195               fb.refresh.erase_eob:
0196 694A C120  34         mov   @parm2,tmp0           ; Current row
     694C 2F22 
0197 694E C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6950 A118 
0198 6952 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0199 6954 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6956 A10E 
0200               
0201 6958 C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0202 695A 130D  14         jeq   fb.refresh.exit       ; Yes, so exit
0203               
0204 695C 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     695E A10E 
0205 6960 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6962 A100 
0206               
0207 6964 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0208 6966 04C5  14         clr   tmp1                  ; Clear with >00 character
0209               
0210 6968 06A0  32         bl    @xfilm                ; \ Fill memory
     696A 2248 
0211                                                   ; | i  tmp0 = Memory start address
0212                                                   ; | i  tmp1 = Byte to fill
0213                                                   ; / i  tmp2 = Number of bytes to fill
0214 696C 1004  14         jmp   fb.refresh.exit
0215                       ;------------------------------------------------------
0216                       ; Bottom row in frame buffer reached ?
0217                       ;------------------------------------------------------
0218 696E 8820  54 !       c     @parm2,@fb.scrrows
     6970 2F22 
     6972 A118 
0219 6974 11E0  14         jlt   fb.refresh.unpack_line
0220                                                   ; No, unpack next line
0221                       ;------------------------------------------------------
0222                       ; Exit
0223                       ;------------------------------------------------------
0224               fb.refresh.exit:
0225 6976 0720  34         seto  @fb.dirty             ; Refresh screen
     6978 A116 
0226 697A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0227 697C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0228 697E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0229 6980 C2F9  30         mov   *stack+,r11           ; Pop r11
0230 6982 045B  20         b     *r11                  ; Return to caller
0231               
0232               
0233               ***************************************************************
0234               * fb.get.firstnonblank
0235               * Get column of first non-blank character in specified line
0236               ***************************************************************
0237               * bl @fb.get.firstnonblank
0238               *--------------------------------------------------------------
0239               * OUTPUT
0240               * @outparm1 = Column containing first non-blank character
0241               * @outparm2 = Character
0242               ********|*****|*********************|**************************
0243               fb.get.firstnonblank:
0244 6984 0649  14         dect  stack
0245 6986 C64B  30         mov   r11,*stack            ; Save return address
0246                       ;------------------------------------------------------
0247                       ; Prepare for scanning
0248                       ;------------------------------------------------------
0249 6988 04E0  34         clr   @fb.column
     698A A10C 
0250 698C 06A0  32         bl    @fb.calc_pointer
     698E 68F8 
0251 6990 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6992 6E34 
0252 6994 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6996 A108 
0253 6998 1313  14         jeq   fb.get.firstnonblank.nomatch
0254                                                   ; Exit if empty line
0255 699A C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     699C A102 
0256 699E 04C5  14         clr   tmp1
0257                       ;------------------------------------------------------
0258                       ; Scan line for non-blank character
0259                       ;------------------------------------------------------
0260               fb.get.firstnonblank.loop:
0261 69A0 D174  28         movb  *tmp0+,tmp1           ; Get character
0262 69A2 130E  14         jeq   fb.get.firstnonblank.nomatch
0263                                                   ; Exit if empty line
0264 69A4 0285  22         ci    tmp1,>2000            ; Whitespace?
     69A6 2000 
0265 69A8 1503  14         jgt   fb.get.firstnonblank.match
0266 69AA 0606  14         dec   tmp2                  ; Counter--
0267 69AC 16F9  14         jne   fb.get.firstnonblank.loop
0268 69AE 1008  14         jmp   fb.get.firstnonblank.nomatch
0269                       ;------------------------------------------------------
0270                       ; Non-blank character found
0271                       ;------------------------------------------------------
0272               fb.get.firstnonblank.match:
0273 69B0 6120  34         s     @fb.current,tmp0      ; Calculate column
     69B2 A102 
0274 69B4 0604  14         dec   tmp0
0275 69B6 C804  38         mov   tmp0,@outparm1        ; Save column
     69B8 2F30 
0276 69BA D805  38         movb  tmp1,@outparm2        ; Save character
     69BC 2F32 
0277 69BE 1004  14         jmp   fb.get.firstnonblank.exit
0278                       ;------------------------------------------------------
0279                       ; No non-blank character found
0280                       ;------------------------------------------------------
0281               fb.get.firstnonblank.nomatch:
0282 69C0 04E0  34         clr   @outparm1             ; X=0
     69C2 2F30 
0283 69C4 04E0  34         clr   @outparm2             ; Null
     69C6 2F32 
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               fb.get.firstnonblank.exit:
0288 69C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0289 69CA 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0124                       copy  "idx.asm"             ; Index management
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Stevie Editor - Index module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               *  Size of index page is 4K and allows indexing of 2048 lines
0010               *  per page.
0011               *
0012               *  Each index slot (word) has the format:
0013               *    +-----+-----+
0014               *    | MSB | LSB |
0015               *    +-----|-----+   LSB = Pointer offset 00-ff.
0016               *
0017               *  MSB = SAMS Page 00-ff
0018               *        Allows addressing of up to 256 4K SAMS pages (1024 KB)
0019               *
0020               *  LSB = Pointer offset in range 00-ff
0021               *
0022               *        To calculate pointer to line in Editor buffer:
0023               *        Pointer address = edb.top + (LSB * 16)
0024               *
0025               *        Note that the editor buffer itself resides in own 4K memory range
0026               *        starting at edb.top
0027               *
0028               *        All support routines must assure that length-prefixed string in
0029               *        Editor buffer always start on a 16 byte boundary for being
0030               *        accessible via index.
0031               ***************************************************************
0032               
0033               
0034               ***************************************************************
0035               * idx.init
0036               * Initialize index
0037               ***************************************************************
0038               * bl @idx.init
0039               *--------------------------------------------------------------
0040               * INPUT
0041               * none
0042               *--------------------------------------------------------------
0043               * OUTPUT
0044               * none
0045               *--------------------------------------------------------------
0046               * Register usage
0047               * tmp0
0048               ********|*****|*********************|**************************
0049               idx.init:
0050 69CC 0649  14         dect  stack
0051 69CE C64B  30         mov   r11,*stack            ; Save return address
0052 69D0 0649  14         dect  stack
0053 69D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0054                       ;------------------------------------------------------
0055                       ; Initialize
0056                       ;------------------------------------------------------
0057 69D4 0204  20         li    tmp0,idx.top
     69D6 B000 
0058 69D8 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     69DA A202 
0059               
0060 69DC C120  34         mov   @tv.sams.b000,tmp0
     69DE A006 
0061 69E0 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     69E2 A500 
0062 69E4 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     69E6 A502 
0063 69E8 C804  38         mov   tmp0,@idx.sams.hipage ; Set last SAMS page
     69EA A504 
0064                       ;------------------------------------------------------
0065                       ; Clear index page
0066                       ;------------------------------------------------------
0067 69EC 06A0  32         bl    @film
     69EE 2242 
0068 69F0 B000                   data idx.top,>00,idx.size
     69F2 0000 
     69F4 1000 
0069                                                   ; Clear index
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.init.exit:
0074 69F6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 69F8 C2F9  30         mov   *stack+,r11           ; Pop r11
0076 69FA 045B  20         b     *r11                  ; Return to caller
0077               
0078               
0079               
0080               ***************************************************************
0081               * _idx.sams.mapcolumn.on
0082               * Flatten SAMS index pages into continious memory region.
0083               * Gives 20 KB of index space (2048 * 5 = 10240 lines per file)
0084               *
0085               * >b000  1st index page
0086               * >c000  2nd index page
0087               * >d000  3rd index page
0088               * >e000  4th index page
0089               * >f000  5th index page
0090               ***************************************************************
0091               * bl @_idx.sams.mapcolumn.on
0092               *--------------------------------------------------------------
0093               * Register usage
0094               * tmp0, tmp1, tmp2
0095               *--------------------------------------------------------------
0096               *  Remarks
0097               *  Private, only to be called from inside idx module
0098               ********|*****|*********************|**************************
0099               _idx.sams.mapcolumn.on:
0100 69FC 0649  14         dect  stack
0101 69FE C64B  30         mov   r11,*stack            ; Push return address
0102 6A00 0649  14         dect  stack
0103 6A02 C644  30         mov   tmp0,*stack           ; Push tmp0
0104 6A04 0649  14         dect  stack
0105 6A06 C645  30         mov   tmp1,*stack           ; Push tmp1
0106 6A08 0649  14         dect  stack
0107 6A0A C646  30         mov   tmp2,*stack           ; Push tmp2
0108               *--------------------------------------------------------------
0109               * Map index pages into memory window  (b000-ffff)
0110               *--------------------------------------------------------------
0111 6A0C C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     6A0E A502 
0112 6A10 0205  20         li    tmp1,idx.top
     6A12 B000 
0113               
0114 6A14 C1A0  34         mov   @idx.sams.hipage,tmp2 ; Get highest index page
     6A16 A504 
0115 6A18 0586  14         inc   tmp2                  ; +1 loop adjustment
0116 6A1A 61A0  34         s     @idx.sams.lopage,tmp2 ; Set loop counter
     6A1C A502 
0117                       ;-------------------------------------------------------
0118                       ; Sanity check
0119                       ;-------------------------------------------------------
0120 6A1E 0286  22         ci    tmp2,5                ; Crash if too many index pages
     6A20 0005 
0121 6A22 1104  14         jlt   !
0122 6A24 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6A26 FFCE 
0123 6A28 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6A2A 2030 
0124                       ;-------------------------------------------------------
0125                       ; Loop over banks
0126                       ;-------------------------------------------------------
0127 6A2C 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     6A2E 2546 
0128                                                   ; \ i  tmp0  = SAMS page number
0129                                                   ; / i  tmp1  = Memory address
0130               
0131 6A30 0584  14         inc   tmp0                  ; Next SAMS index page
0132 6A32 0225  22         ai    tmp1,>1000            ; Next memory region
     6A34 1000 
0133 6A36 0606  14         dec   tmp2                  ; Update loop counter
0134 6A38 15F9  14         jgt   -!                    ; Next iteration
0135               *--------------------------------------------------------------
0136               * Exit
0137               *--------------------------------------------------------------
0138               _idx.sams.mapcolumn.on.exit:
0139 6A3A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0140 6A3C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0141 6A3E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0142 6A40 C2F9  30         mov   *stack+,r11           ; Pop return address
0143 6A42 045B  20         b     *r11                  ; Return to caller
0144               
0145               
0146               ***************************************************************
0147               * _idx.sams.mapcolumn.off
0148               * Restore normal SAMS layout again (single index page)
0149               ***************************************************************
0150               * bl @_idx.sams.mapcolumn.off
0151               *--------------------------------------------------------------
0152               * Register usage
0153               * tmp0, tmp1, tmp2, tmp3
0154               *--------------------------------------------------------------
0155               *  Remarks
0156               *  Private, only to be called from inside idx module
0157               ********|*****|*********************|**************************
0158               _idx.sams.mapcolumn.off:
0159 6A44 0649  14         dect  stack
0160 6A46 C64B  30         mov   r11,*stack            ; Push return address
0161 6A48 0649  14         dect  stack
0162 6A4A C644  30         mov   tmp0,*stack           ; Push tmp0
0163 6A4C 0649  14         dect  stack
0164 6A4E C645  30         mov   tmp1,*stack           ; Push tmp1
0165 6A50 0649  14         dect  stack
0166 6A52 C646  30         mov   tmp2,*stack           ; Push tmp2
0167 6A54 0649  14         dect  stack
0168 6A56 C647  30         mov   tmp3,*stack           ; Push tmp3
0169               *--------------------------------------------------------------
0170               * Map index pages into memory window  (b000-?????)
0171               *--------------------------------------------------------------
0172 6A58 0205  20         li    tmp1,idx.top
     6A5A B000 
0173 6A5C 0206  20         li    tmp2,5                ; Always 5 pages
     6A5E 0005 
0174 6A60 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     6A62 A006 
0175                       ;-------------------------------------------------------
0176                       ; Loop over banks
0177                       ;-------------------------------------------------------
0178 6A64 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0179               
0180 6A66 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6A68 2546 
0181                                                   ; \ i  tmp0  = SAMS page number
0182                                                   ; / i  tmp1  = Memory address
0183               
0184 6A6A 0225  22         ai    tmp1,>1000            ; Next memory region
     6A6C 1000 
0185 6A6E 0606  14         dec   tmp2                  ; Update loop counter
0186 6A70 15F9  14         jgt   -!                    ; Next iteration
0187               *--------------------------------------------------------------
0188               * Exit
0189               *--------------------------------------------------------------
0190               _idx.sams.mapcolumn.off.exit:
0191 6A72 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0192 6A74 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 6A76 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6A78 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195 6A7A C2F9  30         mov   *stack+,r11           ; Pop return address
0196 6A7C 045B  20         b     *r11                  ; Return to caller
0197               
0198               
0199               
0200               ***************************************************************
0201               * idx._samspage.get
0202               * Get SAMS page for index
0203               ***************************************************************
0204               * bl @idx._samspage.get
0205               *--------------------------------------------------------------
0206               * INPUT
0207               * tmp0 = Line number
0208               *--------------------------------------------------------------
0209               * OUTPUT
0210               * @outparm1 = Offset for index entry in index SAMS page
0211               *--------------------------------------------------------------
0212               * Register usage
0213               * tmp0, tmp1, tmp2
0214               *--------------------------------------------------------------
0215               *  Remarks
0216               *  Private, only to be called from inside idx module.
0217               *  Activates SAMS page containing required index slot entry.
0218               ********|*****|*********************|**************************
0219               _idx.samspage.get:
0220 6A7E 0649  14         dect  stack
0221 6A80 C64B  30         mov   r11,*stack            ; Save return address
0222 6A82 0649  14         dect  stack
0223 6A84 C644  30         mov   tmp0,*stack           ; Push tmp0
0224 6A86 0649  14         dect  stack
0225 6A88 C645  30         mov   tmp1,*stack           ; Push tmp1
0226 6A8A 0649  14         dect  stack
0227 6A8C C646  30         mov   tmp2,*stack           ; Push tmp2
0228                       ;------------------------------------------------------
0229                       ; Determine SAMS index page
0230                       ;------------------------------------------------------
0231 6A8E C184  18         mov   tmp0,tmp2             ; Line number
0232 6A90 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0233 6A92 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     6A94 0800 
0234               
0235 6A96 3D44  128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0236                                                   ; | tmp1 = quotient  (SAMS page offset)
0237                                                   ; / tmp2 = remainder
0238               
0239 6A98 0A16  56         sla   tmp2,1                ; line number * 2
0240 6A9A C806  38         mov   tmp2,@outparm1        ; Offset index entry
     6A9C 2F30 
0241               
0242 6A9E A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     6AA0 A502 
0243 6AA2 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     6AA4 A500 
0244               
0245 6AA6 130E  14         jeq   _idx.samspage.get.exit
0246                                                   ; Yes, so exit
0247                       ;------------------------------------------------------
0248                       ; Activate SAMS index page
0249                       ;------------------------------------------------------
0250 6AA8 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     6AAA A500 
0251 6AAC C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     6AAE A006 
0252               
0253 6AB0 C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0254 6AB2 0205  20         li    tmp1,>b000            ; Memory window for index page
     6AB4 B000 
0255               
0256 6AB6 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6AB8 2546 
0257                                                   ; \ i  tmp0 = SAMS page
0258                                                   ; / i  tmp1 = Memory address
0259                       ;------------------------------------------------------
0260                       ; Check if new highest SAMS index page
0261                       ;------------------------------------------------------
0262 6ABA 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     6ABC A504 
0263 6ABE 1202  14         jle   _idx.samspage.get.exit
0264                                                   ; No, exit
0265 6AC0 C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     6AC2 A504 
0266                       ;------------------------------------------------------
0267                       ; Exit
0268                       ;------------------------------------------------------
0269               _idx.samspage.get.exit:
0270 6AC4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0271 6AC6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0272 6AC8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0273 6ACA C2F9  30         mov   *stack+,r11           ; Pop r11
0274 6ACC 045B  20         b     *r11                  ; Return to caller
0275               
0276               
0277               ***************************************************************
0278               * idx.entry.update
0279               * Update index entry - Each entry corresponds to a line
0280               ***************************************************************
0281               * bl @idx.entry.update
0282               *--------------------------------------------------------------
0283               * INPUT
0284               * @parm1    = Line number in editor buffer
0285               * @parm2    = Pointer to line in editor buffer
0286               * @parm3    = SAMS page
0287               *--------------------------------------------------------------
0288               * OUTPUT
0289               * @outparm1 = Pointer to updated index entry
0290               *--------------------------------------------------------------
0291               * Register usage
0292               * tmp0,tmp1,tmp2
0293               ********|*****|*********************|**************************
0294               idx.entry.update:
0295 6ACE 0649  14         dect  stack
0296 6AD0 C64B  30         mov   r11,*stack            ; Save return address
0297 6AD2 0649  14         dect  stack
0298 6AD4 C644  30         mov   tmp0,*stack           ; Push tmp0
0299 6AD6 0649  14         dect  stack
0300 6AD8 C645  30         mov   tmp1,*stack           ; Push tmp1
0301                       ;------------------------------------------------------
0302                       ; Get parameters
0303                       ;------------------------------------------------------
0304 6ADA C120  34         mov   @parm1,tmp0           ; Get line number
     6ADC 2F20 
0305 6ADE C160  34         mov   @parm2,tmp1           ; Get pointer
     6AE0 2F22 
0306 6AE2 1312  14         jeq   idx.entry.update.clear
0307                                                   ; Special handling for "null"-pointer
0308                       ;------------------------------------------------------
0309                       ; Calculate LSB value index slot (pointer offset)
0310                       ;------------------------------------------------------
0311 6AE4 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     6AE6 0FFF 
0312 6AE8 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0313                       ;------------------------------------------------------
0314                       ; Calculate MSB value index slot (SAMS page editor buffer)
0315                       ;------------------------------------------------------
0316 6AEA 06E0  34         swpb  @parm3
     6AEC 2F24 
0317 6AEE D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     6AF0 2F24 
0318 6AF2 06E0  34         swpb  @parm3                ; \ Restore original order again,
     6AF4 2F24 
0319                                                   ; / important for messing up caller parm3!
0320                       ;------------------------------------------------------
0321                       ; Update index slot
0322                       ;------------------------------------------------------
0323               idx.entry.update.save:
0324 6AF6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6AF8 6A7E 
0325                                                   ; \ i  tmp0     = Line number
0326                                                   ; / o  outparm1 = Slot offset in SAMS page
0327               
0328 6AFA C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     6AFC 2F30 
0329 6AFE C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     6B00 B000 
0330 6B02 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6B04 2F30 
0331 6B06 1008  14         jmp   idx.entry.update.exit
0332                       ;------------------------------------------------------
0333                       ; Special handling for "null"-pointer
0334                       ;------------------------------------------------------
0335               idx.entry.update.clear:
0336 6B08 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B0A 6A7E 
0337                                                   ; \ i  tmp0     = Line number
0338                                                   ; / o  outparm1 = Slot offset in SAMS page
0339               
0340 6B0C C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     6B0E 2F30 
0341 6B10 04E4  34         clr   @idx.top(tmp0)        ; /
     6B12 B000 
0342 6B14 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     6B16 2F30 
0343                       ;------------------------------------------------------
0344                       ; Exit
0345                       ;------------------------------------------------------
0346               idx.entry.update.exit:
0347 6B18 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0348 6B1A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0349 6B1C C2F9  30         mov   *stack+,r11           ; Pop r11
0350 6B1E 045B  20         b     *r11                  ; Return to caller
0351               
0352               
0353               
0354               
0355               
0356               ***************************************************************
0357               * idx.pointer.get
0358               * Get pointer to editor buffer line content
0359               ***************************************************************
0360               * bl @idx.pointer.get
0361               *--------------------------------------------------------------
0362               * INPUT
0363               * @parm1 = Line number in editor buffer
0364               *--------------------------------------------------------------
0365               * OUTPUT
0366               * @outparm1 = Pointer to editor buffer line content
0367               * @outparm2 = SAMS page
0368               *--------------------------------------------------------------
0369               * Register usage
0370               * tmp0,tmp1,tmp2
0371               ********|*****|*********************|**************************
0372               idx.pointer.get:
0373 6B20 0649  14         dect  stack
0374 6B22 C64B  30         mov   r11,*stack            ; Save return address
0375 6B24 0649  14         dect  stack
0376 6B26 C644  30         mov   tmp0,*stack           ; Push tmp0
0377 6B28 0649  14         dect  stack
0378 6B2A C645  30         mov   tmp1,*stack           ; Push tmp1
0379 6B2C 0649  14         dect  stack
0380 6B2E C646  30         mov   tmp2,*stack           ; Push tmp2
0381                       ;------------------------------------------------------
0382                       ; Get slot entry
0383                       ;------------------------------------------------------
0384 6B30 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6B32 2F20 
0385               
0386 6B34 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     6B36 6A7E 
0387                                                   ; \ i  tmp0     = Line number
0388                                                   ; / o  outparm1 = Slot offset in SAMS page
0389               
0390 6B38 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     6B3A 2F30 
0391 6B3C C164  34         mov   @idx.top(tmp0),tmp1   ; /
     6B3E B000 
0392               
0393 6B40 130C  14         jeq   idx.pointer.get.parm.null
0394                                                   ; Skip if index slot empty
0395                       ;------------------------------------------------------
0396                       ; Calculate MSB (SAMS page)
0397                       ;------------------------------------------------------
0398 6B42 C185  18         mov   tmp1,tmp2             ; \
0399 6B44 0986  56         srl   tmp2,8                ; / Right align SAMS page
0400                       ;------------------------------------------------------
0401                       ; Calculate LSB (pointer address)
0402                       ;------------------------------------------------------
0403 6B46 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     6B48 00FF 
0404 6B4A 0A45  56         sla   tmp1,4                ; Multiply with 16
0405 6B4C 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     6B4E C000 
0406                       ;------------------------------------------------------
0407                       ; Return parameters
0408                       ;------------------------------------------------------
0409               idx.pointer.get.parm:
0410 6B50 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     6B52 2F30 
0411 6B54 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     6B56 2F32 
0412 6B58 1004  14         jmp   idx.pointer.get.exit
0413                       ;------------------------------------------------------
0414                       ; Special handling for "null"-pointer
0415                       ;------------------------------------------------------
0416               idx.pointer.get.parm.null:
0417 6B5A 04E0  34         clr   @outparm1
     6B5C 2F30 
0418 6B5E 04E0  34         clr   @outparm2
     6B60 2F32 
0419                       ;------------------------------------------------------
0420                       ; Exit
0421                       ;------------------------------------------------------
0422               idx.pointer.get.exit:
0423 6B62 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0424 6B64 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0425 6B66 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0426 6B68 C2F9  30         mov   *stack+,r11           ; Pop r11
0427 6B6A 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0125                       copy  "idx.delete.asm"      ; Index management - delete slot
**** **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: Stevie Editor - Delete index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               
0012               ***************************************************************
0013               * _idx.entry.delete.reorg
0014               * Reorganize index slot entries
0015               ***************************************************************
0016               * bl @_idx.entry.delete.reorg
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  Private, only to be called from idx_entry_delete
0020               ********|*****|*********************|**************************
0021               _idx.entry.delete.reorg:
0022                       ;------------------------------------------------------
0023                       ; Reorganize index entries
0024                       ;------------------------------------------------------
0025 6B6C 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     6B6E B000 
0026 6B70 C144  18         mov   tmp0,tmp1             ; a = current slot
0027 6B72 05C5  14         inct  tmp1                  ; b = current slot + 2
0028                       ;------------------------------------------------------
0029                       ; Loop forward until end of index
0030                       ;------------------------------------------------------
0031               _idx.entry.delete.reorg.loop:
0032 6B74 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0033 6B76 0606  14         dec   tmp2                  ; tmp2--
0034 6B78 16FD  14         jne   _idx.entry.delete.reorg.loop
0035                                                   ; Loop unless completed
0036 6B7A 045B  20         b     *r11                  ; Return to caller
0037               
0038               
0039               
0040               ***************************************************************
0041               * idx.entry.delete
0042               * Delete index entry - Close gap created by delete
0043               ***************************************************************
0044               * bl @idx.entry.delete
0045               *--------------------------------------------------------------
0046               * INPUT
0047               * @parm1    = Line number in editor buffer to delete
0048               * @parm2    = Line number of last line to check for reorg
0049               *--------------------------------------------------------------
0050               * Register usage
0051               * tmp0,tmp2
0052               ********|*****|*********************|**************************
0053               idx.entry.delete:
0054 6B7C 0649  14         dect  stack
0055 6B7E C64B  30         mov   r11,*stack            ; Save return address
0056 6B80 0649  14         dect  stack
0057 6B82 C644  30         mov   tmp0,*stack           ; Push tmp0
0058 6B84 0649  14         dect  stack
0059 6B86 C645  30         mov   tmp1,*stack           ; Push tmp1
0060 6B88 0649  14         dect  stack
0061 6B8A C646  30         mov   tmp2,*stack           ; Push tmp2
0062 6B8C 0649  14         dect  stack
0063 6B8E C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Get index slot
0066                       ;------------------------------------------------------
0067 6B90 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     6B92 2F20 
0068               
0069 6B94 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6B96 6A7E 
0070                                                   ; \ i  tmp0     = Line number
0071                                                   ; / o  outparm1 = Slot offset in SAMS page
0072               
0073 6B98 C120  34         mov   @outparm1,tmp0        ; Index offset
     6B9A 2F30 
0074                       ;------------------------------------------------------
0075                       ; Prepare for index reorg
0076                       ;------------------------------------------------------
0077 6B9C C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6B9E 2F22 
0078 6BA0 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6BA2 2F20 
0079 6BA4 130E  14         jeq   idx.entry.delete.lastline
0080                                                   ; Special treatment if last line
0081                       ;------------------------------------------------------
0082                       ; Reorganize index entries
0083                       ;------------------------------------------------------
0084               idx.entry.delete.reorg:
0085 6BA6 C1E0  34         mov   @parm2,tmp3
     6BA8 2F22 
0086 6BAA 0287  22         ci    tmp3,2048
     6BAC 0800 
0087 6BAE 1207  14         jle   idx.entry.delete.reorg.simple
0088                                                   ; Do simple reorg only if single
0089                                                   ; SAMS index page, otherwise complex reorg.
0090                       ;------------------------------------------------------
0091                       ; Complex index reorganization (multiple SAMS pages)
0092                       ;------------------------------------------------------
0093               idx.entry.delete.reorg.complex:
0094 6BB0 06A0  32         bl    @_idx.sams.mapcolumn.on
     6BB2 69FC 
0095                                                   ; Index in continious memory region
0096               
0097 6BB4 06A0  32         bl    @_idx.entry.delete.reorg
     6BB6 6B6C 
0098                                                   ; Reorganize index
0099               
0100               
0101 6BB8 06A0  32         bl    @_idx.sams.mapcolumn.off
     6BBA 6A44 
0102                                                   ; Restore memory window layout
0103               
0104 6BBC 1002  14         jmp   idx.entry.delete.lastline
0105                       ;------------------------------------------------------
0106                       ; Simple index reorganization
0107                       ;------------------------------------------------------
0108               idx.entry.delete.reorg.simple:
0109 6BBE 06A0  32         bl    @_idx.entry.delete.reorg
     6BC0 6B6C 
0110                       ;------------------------------------------------------
0111                       ; Last line
0112                       ;------------------------------------------------------
0113               idx.entry.delete.lastline:
0114 6BC2 04D4  26         clr   *tmp0
0115                       ;------------------------------------------------------
0116                       ; Exit
0117                       ;------------------------------------------------------
0118               idx.entry.delete.exit:
0119 6BC4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0120 6BC6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0121 6BC8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0122 6BCA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0123 6BCC C2F9  30         mov   *stack+,r11           ; Pop r11
0124 6BCE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0126                       copy  "idx.insert.asm"      ; Index management - insert slot
**** **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Stevie Editor - Insert index slot
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Stevie Editor - Index Management
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               
0010               
0011               
0012               ***************************************************************
0013               * _idx.entry.insert.reorg
0014               * Reorganize index slot entries
0015               ***************************************************************
0016               * bl @_idx.entry.insert.reorg
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  Private, only to be called from idx_entry_delete
0020               ********|*****|*********************|**************************
0021               _idx.entry.insert.reorg:
0022                       ;------------------------------------------------------
0023                       ; sanity check 1
0024                       ;------------------------------------------------------
0025 6BD0 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     6BD2 2800 
0026                                                   ; (max 5 SAMS pages with 2048 index entries)
0027               
0028 6BD4 1204  14         jle   !                     ; Continue if ok
0029                       ;------------------------------------------------------
0030                       ; Crash and burn
0031                       ;------------------------------------------------------
0032               _idx.entry.insert.reorg.crash:
0033 6BD6 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6BD8 FFCE 
0034 6BDA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6BDC 2030 
0035                       ;------------------------------------------------------
0036                       ; Reorganize index entries
0037                       ;------------------------------------------------------
0038 6BDE 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     6BE0 B000 
0039 6BE2 C144  18         mov   tmp0,tmp1             ; a = current slot
0040 6BE4 05C5  14         inct  tmp1                  ; b = current slot + 2
0041 6BE6 0586  14         inc   tmp2                  ; One time adjustment for current line
0042                       ;------------------------------------------------------
0043                       ; Sanity check 2
0044                       ;------------------------------------------------------
0045 6BE8 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0046 6BEA 0A17  56         sla   tmp3,1                ; adjust to slot size
0047 6BEC 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0048 6BEE A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0049 6BF0 0287  22         ci    tmp3,idx.top - 2      ; Address before top of index ?
     6BF2 AFFE 
0050 6BF4 11F0  14         jlt   _idx.entry.insert.reorg.crash
0051                                                   ; If yes, crash
0052                       ;------------------------------------------------------
0053                       ; Loop backwards from end of index up to insert point
0054                       ;------------------------------------------------------
0055               _idx.entry.insert.reorg.loop:
0056 6BF6 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0057 6BF8 0644  14         dect  tmp0                  ; Move pointer up
0058 6BFA 0645  14         dect  tmp1                  ; Move pointer up
0059 6BFC 0606  14         dec   tmp2                  ; Next index entry
0060 6BFE 15FB  14         jgt   _idx.entry.insert.reorg.loop
0061                                                   ; Repeat until done
0062                       ;------------------------------------------------------
0063                       ; Clear index entry at insert point
0064                       ;------------------------------------------------------
0065 6C00 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0066 6C02 04D4  26         clr   *tmp0                 ; / following insert point
0067               
0068 6C04 045B  20         b     *r11                  ; Return to caller
0069               
0070               
0071               
0072               
0073               ***************************************************************
0074               * idx.entry.insert
0075               * Insert index entry
0076               ***************************************************************
0077               * bl @idx.entry.insert
0078               *--------------------------------------------------------------
0079               * INPUT
0080               * @parm1    = Line number in editor buffer to insert
0081               * @parm2    = Line number of last line to check for reorg
0082               *--------------------------------------------------------------
0083               * OUTPUT
0084               * NONE
0085               *--------------------------------------------------------------
0086               * Register usage
0087               * tmp0,tmp2
0088               ********|*****|*********************|**************************
0089               idx.entry.insert:
0090 6C06 0649  14         dect  stack
0091 6C08 C64B  30         mov   r11,*stack            ; Save return address
0092 6C0A 0649  14         dect  stack
0093 6C0C C644  30         mov   tmp0,*stack           ; Push tmp0
0094 6C0E 0649  14         dect  stack
0095 6C10 C645  30         mov   tmp1,*stack           ; Push tmp1
0096 6C12 0649  14         dect  stack
0097 6C14 C646  30         mov   tmp2,*stack           ; Push tmp2
0098 6C16 0649  14         dect  stack
0099 6C18 C647  30         mov   tmp3,*stack           ; Push tmp3
0100                       ;------------------------------------------------------
0101                       ; Prepare for index reorg
0102                       ;------------------------------------------------------
0103 6C1A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     6C1C 2F22 
0104 6C1E 61A0  34         s     @parm1,tmp2           ; Calculate loop
     6C20 2F20 
0105 6C22 130F  14         jeq   idx.entry.insert.reorg.simple
0106                                                   ; Special treatment if last line
0107                       ;------------------------------------------------------
0108                       ; Reorganize index entries
0109                       ;------------------------------------------------------
0110               idx.entry.insert.reorg:
0111 6C24 C1E0  34         mov   @parm2,tmp3
     6C26 2F22 
0112 6C28 0287  22         ci    tmp3,2048
     6C2A 0800 
0113 6C2C 120A  14         jle   idx.entry.insert.reorg.simple
0114                                                   ; Do simple reorg only if single
0115                                                   ; SAMS index page, otherwise complex reorg.
0116                       ;------------------------------------------------------
0117                       ; Complex index reorganization (multiple SAMS pages)
0118                       ;------------------------------------------------------
0119               idx.entry.insert.reorg.complex:
0120 6C2E 06A0  32         bl    @_idx.sams.mapcolumn.on
     6C30 69FC 
0121                                                   ; Index in continious memory region
0122                                                   ; b000 - ffff (5 SAMS pages)
0123               
0124 6C32 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6C34 2F22 
0125 6C36 0A14  56         sla   tmp0,1                ; tmp0 * 2
0126               
0127 6C38 06A0  32         bl    @_idx.entry.insert.reorg
     6C3A 6BD0 
0128                                                   ; Reorganize index
0129                                                   ; \ i  tmp0 = Last line in index
0130                                                   ; / i  tmp2 = Num. of index entries to move
0131               
0132 6C3C 06A0  32         bl    @_idx.sams.mapcolumn.off
     6C3E 6A44 
0133                                                   ; Restore memory window layout
0134               
0135 6C40 1008  14         jmp   idx.entry.insert.exit
0136                       ;------------------------------------------------------
0137                       ; Simple index reorganization
0138                       ;------------------------------------------------------
0139               idx.entry.insert.reorg.simple:
0140 6C42 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     6C44 2F22 
0141               
0142 6C46 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     6C48 6A7E 
0143                                                   ; \ i  tmp0     = Line number
0144                                                   ; / o  outparm1 = Slot offset in SAMS page
0145               
0146 6C4A C120  34         mov   @outparm1,tmp0        ; Index offset
     6C4C 2F30 
0147               
0148 6C4E 06A0  32         bl    @_idx.entry.insert.reorg
     6C50 6BD0 
0149                       ;------------------------------------------------------
0150                       ; Exit
0151                       ;------------------------------------------------------
0152               idx.entry.insert.exit:
0153 6C52 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0154 6C54 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0155 6C56 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0156 6C58 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0157 6C5A C2F9  30         mov   *stack+,r11           ; Pop r11
0158 6C5C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0127                       copy  "edb.asm"             ; Editor Buffer
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: Stevie Editor - Editor Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Editor Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * edb.init
0010               * Initialize Editor buffer
0011               ***************************************************************
0012               * bl @edb.init
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               edb.init:
0026 6C5E 0649  14         dect  stack
0027 6C60 C64B  30         mov   r11,*stack            ; Save return address
0028 6C62 0649  14         dect  stack
0029 6C64 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6C66 0204  20         li    tmp0,edb.top          ; \
     6C68 C000 
0034 6C6A C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     6C6C A200 
0035 6C6E C804  38         mov   tmp0,@edb.next_free.ptr
     6C70 A208 
0036                                                   ; Set pointer to next free line
0037               
0038 6C72 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     6C74 A20A 
0039 6C76 04E0  34         clr   @edb.lines            ; Lines=0
     6C78 A204 
0040 6C7A 04E0  34         clr   @edb.rle              ; RLE compression off
     6C7C A20C 
0041               
0042 6C7E 0204  20         li    tmp0,txt.newfile      ; "New file"
     6C80 32A0 
0043 6C82 C804  38         mov   tmp0,@edb.filename.ptr
     6C84 A20E 
0044               
0045 6C86 0204  20         li    tmp0,txt.filetype.none
     6C88 32B2 
0046 6C8A C804  38         mov   tmp0,@edb.filetype.ptr
     6C8C A210 
0047               
0048               edb.init.exit:
0049                       ;------------------------------------------------------
0050                       ; Exit
0051                       ;------------------------------------------------------
0052 6C8E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6C90 C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6C92 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               ***************************************************************
0059               * edb.line.pack
0060               * Pack current line in framebuffer
0061               ***************************************************************
0062               *  bl   @edb.line.pack
0063               *--------------------------------------------------------------
0064               * INPUT
0065               * @fb.top       = Address of top row in frame buffer
0066               * @fb.row       = Current row in frame buffer
0067               * @fb.column    = Current column in frame buffer
0068               * @fb.colsline  = Columns per line in frame buffer
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               *--------------------------------------------------------------
0072               * Register usage
0073               * tmp0,tmp1,tmp2
0074               *--------------------------------------------------------------
0075               * Memory usage
0076               * rambuf   = Saved @fb.column
0077               * rambuf+2 = Saved beginning of row
0078               * rambuf+4 = Saved length of row
0079               ********|*****|*********************|**************************
0080               edb.line.pack:
0081 6C94 0649  14         dect  stack
0082 6C96 C64B  30         mov   r11,*stack            ; Save return address
0083                       ;------------------------------------------------------
0084                       ; Get values
0085                       ;------------------------------------------------------
0086 6C98 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     6C9A A10C 
     6C9C 2F64 
0087 6C9E 04E0  34         clr   @fb.column
     6CA0 A10C 
0088 6CA2 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     6CA4 68F8 
0089                       ;------------------------------------------------------
0090                       ; Prepare scan
0091                       ;------------------------------------------------------
0092 6CA6 04C4  14         clr   tmp0                  ; Counter
0093 6CA8 C160  34         mov   @fb.current,tmp1      ; Get position
     6CAA A102 
0094 6CAC C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     6CAE 2F66 
0095               
0096                       ;------------------------------------------------------
0097                       ; Scan line for >00 byte termination
0098                       ;------------------------------------------------------
0099               edb.line.pack.scan:
0100 6CB0 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0101 6CB2 0986  56         srl   tmp2,8                ; Right justify
0102 6CB4 1302  14         jeq   edb.line.pack.prepare ; Stop scan if >00 found
0103 6CB6 0584  14         inc   tmp0                  ; Increase string length
0104 6CB8 10FB  14         jmp   edb.line.pack.scan    ; Next character
0105               
0106                       ;------------------------------------------------------
0107                       ; Prepare for storing line
0108                       ;------------------------------------------------------
0109               edb.line.pack.prepare:
0110 6CBA C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     6CBC A104 
     6CBE 2F20 
0111 6CC0 A820  54         a     @fb.row,@parm1        ; /
     6CC2 A106 
     6CC4 2F20 
0112               
0113 6CC6 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     6CC8 2F68 
0114                       ;------------------------------------------------------
0115                       ; 1. Update index
0116                       ;------------------------------------------------------
0117               edb.line.pack.update_index:
0118 6CCA C120  34         mov   @edb.next_free.ptr,tmp0
     6CCC A208 
0119 6CCE C804  38         mov   tmp0,@parm2           ; Block where line will reside
     6CD0 2F22 
0120               
0121 6CD2 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6CD4 250E 
0122                                                   ; \ i  tmp0  = Memory address
0123                                                   ; | o  waux1 = SAMS page number
0124                                                   ; / o  waux2 = Address of SAMS register
0125               
0126 6CD6 C820  54         mov   @waux1,@parm3         ; Setup parm3
     6CD8 833C 
     6CDA 2F24 
0127               
0128 6CDC 06A0  32         bl    @idx.entry.update     ; Update index
     6CDE 6ACE 
0129                                                   ; \ i  parm1 = Line number in editor buffer
0130                                                   ; | i  parm2 = pointer to line in
0131                                                   ; |            editor buffer
0132                                                   ; / i  parm3 = SAMS page
0133               
0134                       ;------------------------------------------------------
0135                       ; 2. Switch to required SAMS page
0136                       ;------------------------------------------------------
0137 6CE0 8820  54         c     @edb.sams.page,@parm3 ; Stay on page?
     6CE2 A212 
     6CE4 2F24 
0138 6CE6 1308  14         jeq   !                     ; Yes, skip setting page
0139               
0140 6CE8 C120  34         mov   @parm3,tmp0           ; get SAMS page
     6CEA 2F24 
0141 6CEC C160  34         mov   @edb.next_free.ptr,tmp1
     6CEE A208 
0142                                                   ; Pointer to line in editor buffer
0143 6CF0 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     6CF2 2546 
0144                                                   ; \ i  tmp0 = SAMS page
0145                                                   ; / i  tmp1 = Memory address
0146               
0147 6CF4 C804  38         mov   tmp0,@fh.sams.page    ; Save current SAMS page
     6CF6 A446 
0148                                                   ; TODO - Why is @fh.xxx accessed here?
0149               
0150                       ;------------------------------------------------------
0151                       ; 3. Set line prefix in editor buffer
0152                       ;------------------------------------------------------
0153 6CF8 C120  34 !       mov   @rambuf+2,tmp0        ; Source for memory copy
     6CFA 2F66 
0154 6CFC C160  34         mov   @edb.next_free.ptr,tmp1
     6CFE A208 
0155                                                   ; Address of line in editor buffer
0156               
0157 6D00 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6D02 A208 
0158               
0159 6D04 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     6D06 2F68 
0160 6D08 0585  14         inc   tmp1                  ; Skip MSB for now (compressed length)
0161 6D0A 06C6  14         swpb  tmp2
0162 6D0C DD46  32         movb  tmp2,*tmp1+           ; Set line length as line prefix
0163 6D0E 06C6  14         swpb  tmp2
0164 6D10 1317  14         jeq   edb.line.pack.exit    ; Nothing to copy if empty line
0165               
0166                       ;------------------------------------------------------
0167                       ; 4. Copy line from framebuffer to editor buffer
0168                       ;------------------------------------------------------
0169               edb.line.pack.copyline:
0170 6D12 0286  22         ci    tmp2,2
     6D14 0002 
0171 6D16 1603  14         jne   edb.line.pack.copyline.checkbyte
0172 6D18 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0173 6D1A DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0174 6D1C 1007  14         jmp   !
0175               
0176               edb.line.pack.copyline.checkbyte:
0177 6D1E 0286  22         ci    tmp2,1
     6D20 0001 
0178 6D22 1602  14         jne   edb.line.pack.copyline.block
0179 6D24 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0180 6D26 1002  14         jmp   !
0181               
0182               edb.line.pack.copyline.block:
0183 6D28 06A0  32         bl    @xpym2m               ; Copy memory block
     6D2A 24B0 
0184                                                   ; \ i  tmp0 = source
0185                                                   ; | i  tmp1 = destination
0186                                                   ; / i  tmp2 = bytes to copy
0187                       ;------------------------------------------------------
0188                       ; 5: Align pointer to multiple of 16 memory address
0189                       ;------------------------------------------------------
0190 6D2C A820  54 !       a     @rambuf+4,@edb.next_free.ptr
     6D2E 2F68 
     6D30 A208 
0191                                                      ; Add length of line
0192               
0193 6D32 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6D34 A208 
0194 6D36 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0195 6D38 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6D3A 000F 
0196 6D3C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6D3E A208 
0197                       ;------------------------------------------------------
0198                       ; Exit
0199                       ;------------------------------------------------------
0200               edb.line.pack.exit:
0201 6D40 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     6D42 2F64 
     6D44 A10C 
0202 6D46 C2F9  30         mov   *stack+,r11           ; Pop R11
0203 6D48 045B  20         b     *r11                  ; Return to caller
0204               
0205               
0206               
0207               
0208               ***************************************************************
0209               * edb.line.unpack
0210               * Unpack specified line to framebuffer
0211               ***************************************************************
0212               *  bl   @edb.line.unpack
0213               *--------------------------------------------------------------
0214               * INPUT
0215               * @parm1 = Line to unpack in editor buffer
0216               * @parm2 = Target row in frame buffer
0217               *--------------------------------------------------------------
0218               * OUTPUT
0219               * @outparm1 = Length of unpacked line
0220               *--------------------------------------------------------------
0221               * Register usage
0222               * tmp0,tmp1,tmp2
0223               *--------------------------------------------------------------
0224               * Memory usage
0225               * rambuf    = Saved @parm1 of edb.line.unpack
0226               * rambuf+2  = Saved @parm2 of edb.line.unpack
0227               * rambuf+4  = Source memory address in editor buffer
0228               * rambuf+6  = Destination memory address in frame buffer
0229               * rambuf+8  = Length of line
0230               ********|*****|*********************|**************************
0231               edb.line.unpack:
0232 6D4A 0649  14         dect  stack
0233 6D4C C64B  30         mov   r11,*stack            ; Save return address
0234 6D4E 0649  14         dect  stack
0235 6D50 C644  30         mov   tmp0,*stack           ; Push tmp0
0236 6D52 0649  14         dect  stack
0237 6D54 C645  30         mov   tmp1,*stack           ; Push tmp1
0238 6D56 0649  14         dect  stack
0239 6D58 C646  30         mov   tmp2,*stack           ; Push tmp2
0240                       ;------------------------------------------------------
0241                       ; Sanity check
0242                       ;------------------------------------------------------
0243 6D5A 8820  54         c     @parm1,@edb.lines     ; Beyond editor buffer ?
     6D5C 2F20 
     6D5E A204 
0244 6D60 1204  14         jle   !
0245 6D62 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6D64 FFCE 
0246 6D66 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D68 2030 
0247                       ;------------------------------------------------------
0248                       ; Save parameters
0249                       ;------------------------------------------------------
0250 6D6A C820  54 !       mov   @parm1,@rambuf
     6D6C 2F20 
     6D6E 2F64 
0251 6D70 C820  54         mov   @parm2,@rambuf+2
     6D72 2F22 
     6D74 2F66 
0252                       ;------------------------------------------------------
0253                       ; Calculate offset in frame buffer
0254                       ;------------------------------------------------------
0255 6D76 C120  34         mov   @fb.colsline,tmp0
     6D78 A10E 
0256 6D7A 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     6D7C 2F22 
0257 6D7E C1A0  34         mov   @fb.top.ptr,tmp2
     6D80 A100 
0258 6D82 A146  18         a     tmp2,tmp1             ; Add base to offset
0259 6D84 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     6D86 2F6A 
0260                       ;------------------------------------------------------
0261                       ; Get pointer to line & page-in editor buffer page
0262                       ;------------------------------------------------------
0263 6D88 C120  34         mov   @parm1,tmp0
     6D8A 2F20 
0264 6D8C 06A0  32         bl    @xmem.edb.sams.mappage
     6D8E 6862 
0265                                                   ; Activate editor buffer SAMS page for line
0266                                                   ; \ i  tmp0     = Line number
0267                                                   ; | o  outparm1 = Pointer to line
0268                                                   ; / o  outparm2 = SAMS page
0269               
0270 6D90 C820  54         mov   @outparm2,@edb.sams.page
     6D92 2F32 
     6D94 A212 
0271                                                   ; Save current SAMS page
0272                       ;------------------------------------------------------
0273                       ; Handle empty line
0274                       ;------------------------------------------------------
0275 6D96 C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     6D98 2F30 
0276 6D9A 1603  14         jne   !                     ; Check if pointer is set
0277 6D9C 04E0  34         clr   @rambuf+8             ; Set length=0
     6D9E 2F6C 
0278 6DA0 1011  14         jmp   edb.line.unpack.clear
0279                       ;------------------------------------------------------
0280                       ; Get line length
0281                       ;------------------------------------------------------
0282 6DA2 C154  26 !       mov   *tmp0,tmp1            ; Get line length
0283 6DA4 0245  22         andi  tmp1,>00ff            ; Line can never be more than 80 characters
     6DA6 00FF 
0284 6DA8 C805  38         mov   tmp1,@rambuf+8        ; Save line length
     6DAA 2F6C 
0285               
0286 6DAC 05E0  34         inct  @outparm1             ; Skip line prefix
     6DAE 2F30 
0287 6DB0 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address for block copy
     6DB2 2F30 
     6DB4 2F68 
0288                       ;------------------------------------------------------
0289                       ; Sanity check on line length
0290                       ;------------------------------------------------------
0291 6DB6 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     6DB8 0050 
0292 6DBA 1204  14         jle   edb.line.unpack.clear ; /
0293               
0294 6DBC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DBE FFCE 
0295 6DC0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DC2 2030 
0296                       ;------------------------------------------------------
0297                       ; Erase chars from last column until column 80
0298                       ;------------------------------------------------------
0299               edb.line.unpack.clear:
0300 6DC4 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     6DC6 2F6A 
0301 6DC8 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     6DCA 2F6C 
0302               
0303 6DCC 04C5  14         clr   tmp1                  ; Fill with >00
0304 6DCE C1A0  34         mov   @fb.colsline,tmp2
     6DD0 A10E 
0305 6DD2 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     6DD4 2F6C 
0306 6DD6 0586  14         inc   tmp2
0307               
0308 6DD8 06A0  32         bl    @xfilm                ; Fill CPU memory
     6DDA 2248 
0309                                                   ; \ i  tmp0 = Target address
0310                                                   ; | i  tmp1 = Byte to fill
0311                                                   ; / i  tmp2 = Repeat count
0312                       ;------------------------------------------------------
0313                       ; Prepare for unpacking data
0314                       ;------------------------------------------------------
0315               edb.line.unpack.prepare:
0316 6DDC C1A0  34         mov   @rambuf+8,tmp2        ; Line length
     6DDE 2F6C 
0317 6DE0 130F  14         jeq   edb.line.unpack.exit  ; Exit if length = 0
0318 6DE2 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     6DE4 2F68 
0319 6DE6 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     6DE8 2F6A 
0320                       ;------------------------------------------------------
0321                       ; Check before copy
0322                       ;------------------------------------------------------
0323               edb.line.unpack.copy:
0324 6DEA 0286  22         ci    tmp2,80               ; Check line length
     6DEC 0050 
0325 6DEE 1204  14         jle   !
0326 6DF0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6DF2 FFCE 
0327 6DF4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6DF6 2030 
0328                       ;------------------------------------------------------
0329                       ; Copy memory block
0330                       ;------------------------------------------------------
0331 6DF8 C806  38 !       mov   tmp2,@outparm1        ; Length of unpacked line
     6DFA 2F30 
0332               
0333 6DFC 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     6DFE 24B0 
0334                                                   ; \ i  tmp0 = Source address
0335                                                   ; | i  tmp1 = Target address
0336                                                   ; / i  tmp2 = Bytes to copy
0337                       ;------------------------------------------------------
0338                       ; Exit
0339                       ;------------------------------------------------------
0340               edb.line.unpack.exit:
0341 6E00 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0342 6E02 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0343 6E04 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0344 6E06 C2F9  30         mov   *stack+,r11           ; Pop r11
0345 6E08 045B  20         b     *r11                  ; Return to caller
0346               
0347               
0348               
0349               ***************************************************************
0350               * edb.line.getlength
0351               * Get length of specified line
0352               ***************************************************************
0353               *  bl   @edb.line.getlength
0354               *--------------------------------------------------------------
0355               * INPUT
0356               * @parm1 = Line number
0357               *--------------------------------------------------------------
0358               * OUTPUT
0359               * @outparm1 = Length of line
0360               * @outparm2 = SAMS page
0361               *--------------------------------------------------------------
0362               * Register usage
0363               * tmp0,tmp1
0364               *--------------------------------------------------------------
0365               * Remarks
0366               * Expects that the affected SAMS page is already paged-in!
0367               ********|*****|*********************|**************************
0368               edb.line.getlength:
0369 6E0A 0649  14         dect  stack
0370 6E0C C64B  30         mov   r11,*stack            ; Push return address
0371 6E0E 0649  14         dect  stack
0372 6E10 C644  30         mov   tmp0,*stack           ; Push tmp0
0373 6E12 0649  14         dect  stack
0374 6E14 C645  30         mov   tmp1,*stack           ; Push tmp1
0375                       ;------------------------------------------------------
0376                       ; Initialisation
0377                       ;------------------------------------------------------
0378 6E16 04E0  34         clr   @outparm1             ; Reset length
     6E18 2F30 
0379 6E1A 04E0  34         clr   @outparm2             ; Reset SAMS bank
     6E1C 2F32 
0380                       ;------------------------------------------------------
0381                       ; Get length
0382                       ;------------------------------------------------------
0383 6E1E 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     6E20 6B20 
0384                                                   ; \ i  parm1    = Line number
0385                                                   ; | o  outparm1 = Pointer to line
0386                                                   ; / o  outparm2 = SAMS page
0387               
0388 6E22 C120  34         mov   @outparm1,tmp0        ; Is pointer set?
     6E24 2F30 
0389 6E26 1302  14         jeq   edb.line.getlength.exit
0390                                                   ; Exit early if NULL pointer
0391                       ;------------------------------------------------------
0392                       ; Process line prefix
0393                       ;------------------------------------------------------
0394 6E28 C814  46         mov   *tmp0,@outparm1       ; Save length
     6E2A 2F30 
0395                       ;------------------------------------------------------
0396                       ; Exit
0397                       ;------------------------------------------------------
0398               edb.line.getlength.exit:
0399 6E2C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0400 6E2E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0401 6E30 C2F9  30         mov   *stack+,r11           ; Pop r11
0402 6E32 045B  20         b     *r11                  ; Return to caller
0403               
0404               
0405               
0406               ***************************************************************
0407               * edb.line.getlength2
0408               * Get length of current row (as seen from editor buffer side)
0409               ***************************************************************
0410               *  bl   @edb.line.getlength2
0411               *--------------------------------------------------------------
0412               * INPUT
0413               * @fb.row = Row in frame buffer
0414               *--------------------------------------------------------------
0415               * OUTPUT
0416               * @fb.row.length = Length of row
0417               *--------------------------------------------------------------
0418               * Register usage
0419               * tmp0
0420               ********|*****|*********************|**************************
0421               edb.line.getlength2:
0422 6E34 0649  14         dect  stack
0423 6E36 C64B  30         mov   r11,*stack            ; Save return address
0424                       ;------------------------------------------------------
0425                       ; Calculate line in editor buffer
0426                       ;------------------------------------------------------
0427 6E38 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     6E3A A104 
0428 6E3C A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     6E3E A106 
0429                       ;------------------------------------------------------
0430                       ; Get length
0431                       ;------------------------------------------------------
0432 6E40 C804  38         mov   tmp0,@parm1
     6E42 2F20 
0433 6E44 06A0  32         bl    @edb.line.getlength
     6E46 6E0A 
0434 6E48 C820  54         mov   @outparm1,@fb.row.length
     6E4A 2F30 
     6E4C A108 
0435                                                   ; Save row length
0436                       ;------------------------------------------------------
0437                       ; Exit
0438                       ;------------------------------------------------------
0439               edb.line.getlength2.exit:
0440 6E4E C2F9  30         mov   *stack+,r11           ; Pop R11
0441 6E50 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0128                       ;-----------------------------------------------------------------------
0129                       ; Command buffer handling
0130                       ;-----------------------------------------------------------------------
0131                       copy  "cmdb.asm"            ; Command buffer shared code
**** **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Command Buffer implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cmdb.init
0011               * Initialize Command Buffer
0012               ***************************************************************
0013               * bl @cmdb.init
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * none
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               cmdb.init:
0027 6E52 0649  14         dect  stack
0028 6E54 C64B  30         mov   r11,*stack            ; Save return address
0029 6E56 0649  14         dect  stack
0030 6E58 C644  30         mov   tmp0,*stack           ; Push tmp0
0031                       ;------------------------------------------------------
0032                       ; Initialize
0033                       ;------------------------------------------------------
0034 6E5A 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     6E5C D000 
0035 6E5E C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     6E60 A300 
0036               
0037 6E62 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     6E64 A302 
0038 6E66 0204  20         li    tmp0,4
     6E68 0004 
0039 6E6A C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     6E6C A306 
0040 6E6E C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     6E70 A308 
0041               
0042 6E72 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     6E74 A316 
0043 6E76 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     6E78 A318 
0044 6E7A 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     6E7C A322 
0045                       ;------------------------------------------------------
0046                       ; Clear command buffer
0047                       ;------------------------------------------------------
0048 6E7E 06A0  32         bl    @film
     6E80 2242 
0049 6E82 D000             data  cmdb.top,>00,cmdb.size
     6E84 0000 
     6E86 1000 
0050                                                   ; Clear it all the way
0051               cmdb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 6E88 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 6E8A C2F9  30         mov   *stack+,r11           ; Pop r11
0057 6E8C 045B  20         b     *r11                  ; Return to caller
0058               
0059               
0060               
0061               
0062               
0063               
0064               
0065               ***************************************************************
0066               * cmdb.refresh
0067               * Refresh command buffer content
0068               ***************************************************************
0069               * bl @cmdb.refresh
0070               *--------------------------------------------------------------
0071               * INPUT
0072               * none
0073               *--------------------------------------------------------------
0074               * OUTPUT
0075               * none
0076               *--------------------------------------------------------------
0077               * Register usage
0078               * none
0079               *--------------------------------------------------------------
0080               * Notes
0081               ********|*****|*********************|**************************
0082               cmdb.refresh:
0083 6E8E 0649  14         dect  stack
0084 6E90 C64B  30         mov   r11,*stack            ; Save return address
0085 6E92 0649  14         dect  stack
0086 6E94 C644  30         mov   tmp0,*stack           ; Push tmp0
0087 6E96 0649  14         dect  stack
0088 6E98 C645  30         mov   tmp1,*stack           ; Push tmp1
0089 6E9A 0649  14         dect  stack
0090 6E9C C646  30         mov   tmp2,*stack           ; Push tmp2
0091                       ;------------------------------------------------------
0092                       ; Dump Command buffer content
0093                       ;------------------------------------------------------
0094 6E9E C820  54         mov   @wyx,@cmdb.yxsave     ; Save YX position
     6EA0 832A 
     6EA2 A30C 
0095 6EA4 C820  54         mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
     6EA6 A310 
     6EA8 832A 
0096               
0097 6EAA 05A0  34         inc   @wyx                  ; X +1 for prompt
     6EAC 832A 
0098               
0099 6EAE 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     6EB0 2406 
0100                                                   ; \ i  @wyx = Cursor position
0101                                                   ; / o  tmp0 = VDP target address
0102               
0103 6EB2 0205  20         li    tmp1,cmdb.cmd         ; Address of current command
     6EB4 A325 
0104 6EB6 0206  20         li    tmp2,1*79             ; Command length
     6EB8 004F 
0105               
0106 6EBA 06A0  32         bl    @xpym2v               ; \ Copy CPU memory to VDP memory
     6EBC 245C 
0107                                                   ; | i  tmp0 = VDP target address
0108                                                   ; | i  tmp1 = RAM source address
0109                                                   ; / i  tmp2 = Number of bytes to copy
0110                       ;------------------------------------------------------
0111                       ; Show command buffer prompt
0112                       ;------------------------------------------------------
0113 6EBE C820  54         mov   @cmdb.yxprompt,@wyx
     6EC0 A310 
     6EC2 832A 
0114 6EC4 06A0  32         bl    @putstr
     6EC6 242A 
0115 6EC8 357C                   data txt.cmdb.prompt
0116               
0117 6ECA C820  54         mov   @cmdb.yxsave,@fb.yxsave
     6ECC A30C 
     6ECE A114 
0118 6ED0 C820  54         mov   @cmdb.yxsave,@wyx
     6ED2 A30C 
     6ED4 832A 
0119                                                   ; Restore YX position
0120                       ;------------------------------------------------------
0121                       ; Exit
0122                       ;------------------------------------------------------
0123               cmdb.refresh.exit:
0124 6ED6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0125 6ED8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0126 6EDA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0127 6EDC C2F9  30         mov   *stack+,r11           ; Pop r11
0128 6EDE 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0132                       copy  "cmdb.cmd.asm"        ; Command line handling
**** **** ****     > cmdb.cmd.asm
0001               * FILE......: cmdb_cmd.asm
0002               * Purpose...: Stevie Editor - Command line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Command line handling
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cmdb.cmd.clear
0010               * Clear current command
0011               ***************************************************************
0012               * bl @cmdb.cmd.clear
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0,tmp1,tmp2
0022               *--------------------------------------------------------------
0023               * Notes
0024               ********|*****|*********************|**************************
0025               cmdb.cmd.clear:
0026 6EE0 0649  14         dect  stack
0027 6EE2 C64B  30         mov   r11,*stack            ; Save return address
0028 6EE4 0649  14         dect  stack
0029 6EE6 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 6EE8 0649  14         dect  stack
0031 6EEA C645  30         mov   tmp1,*stack           ; Push tmp1
0032 6EEC 0649  14         dect  stack
0033 6EEE C646  30         mov   tmp2,*stack           ; Push tmp2
0034                       ;------------------------------------------------------
0035                       ; Clear command
0036                       ;------------------------------------------------------
0037 6EF0 04E0  34         clr   @cmdb.cmdlen          ; Reset length
     6EF2 A324 
0038 6EF4 06A0  32         bl    @film                 ; Clear command
     6EF6 2242 
0039 6EF8 A325                   data  cmdb.cmd,>00,80
     6EFA 0000 
     6EFC 0050 
0040                       ;------------------------------------------------------
0041                       ; Put cursor at beginning of line
0042                       ;------------------------------------------------------
0043 6EFE C120  34         mov   @cmdb.yxprompt,tmp0
     6F00 A310 
0044 6F02 0584  14         inc   tmp0
0045 6F04 C804  38         mov   tmp0,@cmdb.cursor     ; Position cursor
     6F06 A30A 
0046                       ;------------------------------------------------------
0047                       ; Exit
0048                       ;------------------------------------------------------
0049               cmdb.cmd.clear.exit:
0050 6F08 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0051 6F0A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0052 6F0C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0053 6F0E C2F9  30         mov   *stack+,r11           ; Pop r11
0054 6F10 045B  20         b     *r11                  ; Return to caller
0055               
0056               
0057               
0058               
0059               
0060               
0061               ***************************************************************
0062               * cmdb.cmdb.getlength
0063               * Get length of current command
0064               ***************************************************************
0065               * bl @cmdb.cmd.getlength
0066               *--------------------------------------------------------------
0067               * INPUT
0068               * @cmdb.cmd
0069               *--------------------------------------------------------------
0070               * OUTPUT
0071               * @outparm1
0072               *--------------------------------------------------------------
0073               * Register usage
0074               * none
0075               *--------------------------------------------------------------
0076               * Notes
0077               ********|*****|*********************|**************************
0078               cmdb.cmd.getlength:
0079 6F12 0649  14         dect  stack
0080 6F14 C64B  30         mov   r11,*stack            ; Save return address
0081                       ;-------------------------------------------------------
0082                       ; Get length of null terminated string
0083                       ;-------------------------------------------------------
0084 6F16 06A0  32         bl    @string.getlenc      ; Get length of C-style string
     6F18 2A98 
0085 6F1A A325                   data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
     6F1C 0000 
0086                                                  ; | i  p1    = Termination character
0087                                                  ; / o  waux1 = Length of string
0088 6F1E C820  54         mov   @waux1,@outparm1     ; Save length of string
     6F20 833C 
     6F22 2F30 
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cmdb.cmd.getlength.exit:
0093 6F24 C2F9  30         mov   *stack+,r11           ; Pop r11
0094 6F26 045B  20         b     *r11                  ; Return to caller
0095               
0096               
0097               
0098               
0099               
0100               ***************************************************************
0101               * cmdb.cmd.addhist
0102               * Add command to history
0103               ***************************************************************
0104               * bl @cmdb.cmd.addhist
0105               *--------------------------------------------------------------
0106               * INPUT
0107               *
0108               * @cmdb.cmd
0109               *--------------------------------------------------------------
0110               * OUTPUT
0111               * @outparm1     (Length in LSB)
0112               *--------------------------------------------------------------
0113               * Register usage
0114               * tmp0
0115               *--------------------------------------------------------------
0116               * Notes
0117               ********|*****|*********************|**************************
0118               cmdb.cmd.history.add:
0119 6F28 0649  14         dect  stack
0120 6F2A C64B  30         mov   r11,*stack            ; Save return address
0121 6F2C 0649  14         dect  stack
0122 6F2E C644  30         mov   tmp0,*stack           ; Push tmp0
0123               
0124 6F30 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of command
     6F32 6F12 
0125                                                   ; \ i  @cmdb.cmd
0126                                                   ; / o  @outparm1
0127                       ;------------------------------------------------------
0128                       ; Sanity check
0129                       ;------------------------------------------------------
0130 6F34 C120  34         mov   @outparm1,tmp0        ; Check length
     6F36 2F30 
0131 6F38 1300  14         jeq   cmdb.cmd.history.add.exit
0132                                                   ; Exit early if length = 0
0133                       ;------------------------------------------------------
0134                       ; Add command to history
0135                       ;------------------------------------------------------
0136               
0137               
0138               
0139                       ;------------------------------------------------------
0140                       ; Exit
0141                       ;------------------------------------------------------
0142               cmdb.cmd.history.add.exit:
0143 6F3A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0144 6F3C C2F9  30         mov   *stack+,r11           ; Pop r11
0145 6F3E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0133                       copy  "errline.asm"         ; Error line
**** **** ****     > errline.asm
0001               * FILE......: errline.asm
0002               * Purpose...: Stevie Editor - Error line utilities
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Error line utilities
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * errline.init
0010               * Initialize error line
0011               ***************************************************************
0012               * bl @errline.init
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0
0022               *--------------------------------------------------------------
0023               * Notes
0024               ***************************************************************
0025               errline.init:
0026 6F40 0649  14         dect  stack
0027 6F42 C64B  30         mov   r11,*stack            ; Save return address
0028 6F44 0649  14         dect  stack
0029 6F46 C644  30         mov   tmp0,*stack           ; Push tmp0
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 6F48 04E0  34         clr   @tv.error.visible     ; Set to hidden
     6F4A A01E 
0034               
0035 6F4C 06A0  32         bl    @film
     6F4E 2242 
0036 6F50 A020                   data tv.error.msg,0,160
     6F52 0000 
     6F54 00A0 
0037               
0038 6F56 0204  20         li    tmp0,>A000            ; Length of error message (160 bytes)
     6F58 A000 
0039 6F5A D804  38         movb  tmp0,@tv.error.msg    ; Set length byte
     6F5C A020 
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               errline.exit:
0044 6F5E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0045 6F60 C2F9  30         mov   *stack+,r11           ; Pop R11
0046 6F62 045B  20         b     *r11                  ; Return to caller
0047               
**** **** ****     > stevie_b1.asm.2287273
0134                       ;-----------------------------------------------------------------------
0135                       ; File handling
0136                       ;-----------------------------------------------------------------------
0137                       copy  "fh.read.edb.asm"     ; Read file to editor buffer
**** **** ****     > fh.read.edb.asm
0001               * FILE......: fh.read.edb.asm
0002               * Purpose...: File reader module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                  Read file into editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.read.edb
0011               * Read file into editor buffer
0012               ***************************************************************
0013               *  bl   @fh.file.read.edb
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "Before Open file"
0018               * parm3 = Pointer to callback function "Read line from file"
0019               * parm4 = Pointer to callback function "Close file"
0020               * parm5 = Pointer to callback function "File I/O error"
0021               *--------------------------------------------------------------
0022               * OUTPUT
0023               *--------------------------------------------------------------
0024               * Register usage
0025               * tmp0, tmp1, tmp2
0026               ********|*****|*********************|**************************
0027               fh.file.read.edb:
0028 6F64 0649  14         dect  stack
0029 6F66 C64B  30         mov   r11,*stack            ; Save return address
0030 6F68 0649  14         dect  stack
0031 6F6A C644  30         mov   tmp0,*stack           ; Push tmp0
0032 6F6C 0649  14         dect  stack
0033 6F6E C645  30         mov   tmp1,*stack           ; Push tmp1
0034 6F70 0649  14         dect  stack
0035 6F72 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 6F74 04E0  34         clr   @fh.records           ; Reset records counter
     6F76 A43C 
0040 6F78 04E0  34         clr   @fh.counter           ; Clear internal counter
     6F7A A442 
0041 6F7C 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     6F7E A440 
0042 6F80 04E0  34         clr   @fh.kilobytes.prev    ; /
     6F82 A458 
0043 6F84 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     6F86 A438 
0044 6F88 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     6F8A A43A 
0045               
0046 6F8C C120  34         mov   @edb.top.ptr,tmp0
     6F8E A200 
0047 6F90 06A0  32         bl    @xsams.page.get       ; Get SAMS page
     6F92 250E 
0048                                                   ; \ i  tmp0  = Memory address
0049                                                   ; | o  waux1 = SAMS page number
0050                                                   ; / o  waux2 = Address of SAMS register
0051               
0052 6F94 C820  54         mov   @waux1,@fh.sams.page  ; Set current SAMS page
     6F96 833C 
     6F98 A446 
0053 6F9A C820  54         mov   @waux1,@fh.sams.hipage
     6F9C 833C 
     6F9E A448 
0054                                                   ; Set highest SAMS page in use
0055                       ;------------------------------------------------------
0056                       ; Save parameters / callback functions
0057                       ;------------------------------------------------------
0058 6FA0 0204  20         li    tmp0,fh.fopmode.readfile
     6FA2 0001 
0059                                                   ; We are going to read a file
0060 6FA4 C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     6FA6 A44A 
0061               
0062 6FA8 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     6FAA 2F20 
     6FAC A444 
0063 6FAE C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     6FB0 2F22 
     6FB2 A450 
0064 6FB4 C820  54         mov   @parm3,@fh.callback2  ; Callback function "Read line from file"
     6FB6 2F24 
     6FB8 A452 
0065 6FBA C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     6FBC 2F26 
     6FBE A454 
0066 6FC0 C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     6FC2 2F28 
     6FC4 A456 
0067                       ;------------------------------------------------------
0068                       ; Sanity check
0069                       ;------------------------------------------------------
0070 6FC6 C120  34         mov   @fh.callback1,tmp0
     6FC8 A450 
0071 6FCA 0284  22         ci    tmp0,>6000            ; Insane address ?
     6FCC 6000 
0072 6FCE 1114  14         jlt   fh.file.read.crash    ; Yes, crash!
0073               
0074 6FD0 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6FD2 7FFF 
0075 6FD4 1511  14         jgt   fh.file.read.crash    ; Yes, crash!
0076               
0077 6FD6 C120  34         mov   @fh.callback2,tmp0
     6FD8 A452 
0078 6FDA 0284  22         ci    tmp0,>6000            ; Insane address ?
     6FDC 6000 
0079 6FDE 110C  14         jlt   fh.file.read.crash    ; Yes, crash!
0080               
0081 6FE0 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6FE2 7FFF 
0082 6FE4 1509  14         jgt   fh.file.read.crash    ; Yes, crash!
0083               
0084 6FE6 C120  34         mov   @fh.callback3,tmp0
     6FE8 A454 
0085 6FEA 0284  22         ci    tmp0,>6000            ; Insane address ?
     6FEC 6000 
0086 6FEE 1104  14         jlt   fh.file.read.crash    ; Yes, crash!
0087               
0088 6FF0 0284  22         ci    tmp0,>7fff            ; Insane address ?
     6FF2 7FFF 
0089 6FF4 1501  14         jgt   fh.file.read.crash    ; Yes, crash!
0090               
0091 6FF6 1004  14         jmp   fh.file.read.edb.load1
0092                                                   ; All checks passed, continue
0093                       ;------------------------------------------------------
0094                       ; Check failed, crash CPU!
0095                       ;------------------------------------------------------
0096               fh.file.read.crash:
0097 6FF8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6FFA FFCE 
0098 6FFC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6FFE 2030 
0099                       ;------------------------------------------------------
0100                       ; Callback "Before Open file"
0101                       ;------------------------------------------------------
0102               fh.file.read.edb.load1:
0103 7000 C120  34         mov   @fh.callback1,tmp0
     7002 A450 
0104 7004 0694  24         bl    *tmp0                 ; Run callback function
0105                       ;------------------------------------------------------
0106                       ; Copy PAB header to VDP
0107                       ;------------------------------------------------------
0108               fh.file.read.edb.pabheader:
0109 7006 06A0  32         bl    @cpym2v
     7008 2456 
0110 700A 0A60                   data fh.vpab,fh.file.pab.header,9
     700C 7178 
     700E 0009 
0111                                                   ; Copy PAB header to VDP
0112                       ;------------------------------------------------------
0113                       ; Append file descriptor to PAB header in VDP
0114                       ;------------------------------------------------------
0115 7010 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     7012 0A69 
0116 7014 C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     7016 A444 
0117 7018 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0118 701A 0986  56         srl   tmp2,8                ; Right justify
0119 701C 0586  14         inc   tmp2                  ; Include length byte as well
0120               
0121 701E 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     7020 245C 
0122                                                   ; \ i  tmp0 = VDP destination
0123                                                   ; | i  tmp1 = CPU source
0124                                                   ; / i  tmp2 = Number of bytes to copy
0125                       ;------------------------------------------------------
0126                       ; Open file
0127                       ;------------------------------------------------------
0128 7022 06A0  32         bl    @file.open            ; Open file
     7024 2C5C 
0129 7026 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0130 7028 0014                   data io.seq.inp.dis.var
0131                                                   ; / i  p1 = File type/mode
0132               
0133 702A 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     702C 2026 
0134 702E 1602  14         jne   fh.file.read.edb.check_setpage
0135               
0136 7030 0460  28         b     @fh.file.read.edb.error
     7032 713C 
0137                                                   ; Yes, IO error occured
0138                       ;------------------------------------------------------
0139                       ; 1a: Check if SAMS page needs to be set
0140                       ;------------------------------------------------------
0141               fh.file.read.edb.check_setpage:
0142 7034 C120  34         mov   @edb.next_free.ptr,tmp0
     7036 A208 
0143                                                   ;--------------------------
0144                                                   ; Sanity check
0145                                                   ;--------------------------
0146 7038 0284  22         ci    tmp0,edb.top + edb.size
     703A D000 
0147                                                   ; Insane address ?
0148 703C 15DD  14         jgt   fh.file.read.crash    ; Yes, crash!
0149                                                   ;--------------------------
0150                                                   ; Check for page overflow
0151                                                   ;--------------------------
0152 703E 0244  22         andi  tmp0,>0fff            ; Get rid off highest nibble
     7040 0FFF 
0153 7042 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     7044 0052 
0154 7046 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     7048 0FF0 
0155 704A 110E  14         jlt   fh.file.read.edb.record
0156                                                   ; Not yet so skip SAMS page switch
0157                       ;------------------------------------------------------
0158                       ; 1b: Increase SAMS page
0159                       ;------------------------------------------------------
0160 704C 05A0  34         inc   @fh.sams.page         ; Next SAMS page
     704E A446 
0161 7050 C820  54         mov   @fh.sams.page,@fh.sams.hipage
     7052 A446 
     7054 A448 
0162                                                   ; Set highest SAMS page
0163 7056 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     7058 A200 
     705A A208 
0164                                                   ; Start at top of SAMS page again
0165                       ;------------------------------------------------------
0166                       ; 1c: Switch to SAMS page
0167                       ;------------------------------------------------------
0168 705C C120  34         mov   @fh.sams.page,tmp0
     705E A446 
0169 7060 C160  34         mov   @edb.top.ptr,tmp1
     7062 A200 
0170 7064 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7066 2546 
0171                                                   ; \ i  tmp0 = SAMS page number
0172                                                   ; / i  tmp1 = Memory address
0173                       ;------------------------------------------------------
0174                       ; Step 2: Read file record
0175                       ;------------------------------------------------------
0176               fh.file.read.edb.record:
0177 7068 05A0  34         inc   @fh.records           ; Update counter
     706A A43C 
0178 706C 04E0  34         clr   @fh.reclen            ; Reset record length
     706E A43E 
0179               
0180 7070 0760  38         abs   @fh.offsetopcode
     7072 A44E 
0181 7074 1310  14         jeq   !                     ; Skip CPU buffer logic if offset = 0
0182                       ;------------------------------------------------------
0183                       ; 2a: Write address of CPU buffer to VDP PAB bytes 2-3
0184                       ;------------------------------------------------------
0185 7076 C160  34         mov   @edb.next_free.ptr,tmp1
     7078 A208 
0186 707A 05C5  14         inct  tmp1
0187 707C 0204  20         li    tmp0,fh.vpab + 2
     707E 0A62 
0188               
0189 7080 0264  22         ori   tmp0,>4000            ; Prepare VDP address for write
     7082 4000 
0190 7084 06C4  14         swpb  tmp0                  ; \
0191 7086 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     7088 8C02 
0192 708A 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0193 708C D804  38         movb  tmp0,@vdpa            ; /
     708E 8C02 
0194               
0195 7090 D7C5  30         movb  tmp1,*r15             ; Write MSB
0196 7092 06C5  14         swpb  tmp1
0197 7094 D7C5  30         movb  tmp1,*r15             ; Write LSB
0198                       ;------------------------------------------------------
0199                       ; 2b: Read file record
0200                       ;------------------------------------------------------
0201 7096 06A0  32 !       bl    @file.record.read     ; Read file record
     7098 2C8C 
0202 709A 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0203                                                   ; |           (without +9 offset!)
0204                                                   ; | o  tmp0 = Status byte
0205                                                   ; | o  tmp1 = Bytes read
0206                                                   ; | o  tmp2 = Status register contents
0207                                                   ; /           upon DSRLNK return
0208               
0209 709C C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     709E A438 
0210 70A0 C805  38         mov   tmp1,@fh.reclen       ; Save bytes read
     70A2 A43E 
0211 70A4 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     70A6 A43A 
0212                       ;------------------------------------------------------
0213                       ; 2c: Calculate kilobytes processed
0214                       ;------------------------------------------------------
0215 70A8 A805  38         a     tmp1,@fh.counter      ; Add record length to counter
     70AA A442 
0216 70AC C160  34         mov   @fh.counter,tmp1      ;
     70AE A442 
0217 70B0 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     70B2 0400 
0218 70B4 1106  14         jlt   fh.file.read.edb.check_fioerr
0219                                                   ; Not yet, goto (2d)
0220 70B6 05A0  34         inc   @fh.kilobytes
     70B8 A440 
0221 70BA 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     70BC FC00 
0222 70BE C805  38         mov   tmp1,@fh.counter      ; Update counter
     70C0 A442 
0223                       ;------------------------------------------------------
0224                       ; 2d: Check if a file error occured
0225                       ;------------------------------------------------------
0226               fh.file.read.edb.check_fioerr:
0227 70C2 C1A0  34         mov   @fh.ioresult,tmp2
     70C4 A43A 
0228 70C6 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     70C8 2026 
0229 70CA 1602  14         jne   fh.file.read.edb.process_line
0230                                                   ; No, goto (3)
0231 70CC 0460  28         b     @fh.file.read.edb.error
     70CE 713C 
0232                                                   ; Yes, so handle file error
0233                       ;------------------------------------------------------
0234                       ; Step 3: Process line
0235                       ;------------------------------------------------------
0236               fh.file.read.edb.process_line:
0237 70D0 0204  20         li    tmp0,fh.vrecbuf       ; VDP source address
     70D2 0960 
0238 70D4 C160  34         mov   @edb.next_free.ptr,tmp1
     70D6 A208 
0239                                                   ; RAM target in editor buffer
0240               
0241 70D8 C805  38         mov   tmp1,@parm2           ; Needed in step 4b (index update)
     70DA 2F22 
0242               
0243 70DC C1A0  34         mov   @fh.reclen,tmp2       ; Number of bytes to copy
     70DE A43E 
0244 70E0 131B  14         jeq   fh.file.read.edb.prepindex.emptyline
0245                                                   ; Handle empty line
0246                       ;------------------------------------------------------
0247                       ; 3a: Set length of line in CPU editor buffer
0248                       ;------------------------------------------------------
0249 70E2 04D5  26         clr   *tmp1                 ; Clear word before string
0250 70E4 0585  14         inc   tmp1                  ; Adjust position for length byte string
0251 70E6 DD60  48         movb  @fh.reclen+1,*tmp1+   ; Put line length byte before string
     70E8 A43F 
0252               
0253 70EA 05E0  34         inct  @edb.next_free.ptr    ; Keep pointer synced with tmp1
     70EC A208 
0254 70EE A806  38         a     tmp2,@edb.next_free.ptr
     70F0 A208 
0255                                                   ; Add line length
0256               
0257 70F2 0760  38         abs   @fh.offsetopcode      ; Use CPU buffer if offset > 0
     70F4 A44E 
0258 70F6 1602  14         jne   fh.file.read.edb.preppointer
0259                       ;------------------------------------------------------
0260                       ; 3b: Copy line from VDP to CPU editor buffer
0261                       ;------------------------------------------------------
0262               fh.file.read.edb.vdp2cpu:
0263                       ;
0264                       ; Executed for devices that need their disk buffer in VDP memory
0265                       ; (TI Disk Controller, tipi, nanopeb, ...).
0266                       ;
0267 70F8 06A0  32         bl    @xpyv2m               ; Copy memory block from VDP to CPU
     70FA 248E 
0268                                                   ; \ i  tmp0 = VDP source address
0269                                                   ; | i  tmp1 = RAM target address
0270                                                   ; / i  tmp2 = Bytes to copy
0271                       ;------------------------------------------------------
0272                       ; 3c: Align pointer for next line
0273                       ;------------------------------------------------------
0274               fh.file.read.edb.preppointer:
0275 70FC C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     70FE A208 
0276 7100 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0277 7102 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7104 000F 
0278 7106 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     7108 A208 
0279                       ;------------------------------------------------------
0280                       ; Step 4: Update index
0281                       ;------------------------------------------------------
0282               fh.file.read.edb.prepindex:
0283 710A C820  54         mov   @edb.lines,@parm1     ; parm1 = Line number
     710C A204 
     710E 2F20 
0284                                                   ; parm2 = Must allready be set!
0285 7110 C820  54         mov   @fh.sams.page,@parm3  ; parm3 = SAMS page number
     7112 A446 
     7114 2F24 
0286               
0287 7116 1009  14         jmp   fh.file.read.edb.updindex
0288                                                   ; Update index
0289                       ;------------------------------------------------------
0290                       ; 4a: Special handling for empty line
0291                       ;------------------------------------------------------
0292               fh.file.read.edb.prepindex.emptyline:
0293 7118 C820  54         mov   @fh.records,@parm1    ; parm1 = Line number
     711A A43C 
     711C 2F20 
0294 711E 0620  34         dec   @parm1                ;         Adjust for base 0 index
     7120 2F20 
0295 7122 04E0  34         clr   @parm2                ; parm2 = Pointer to >0000
     7124 2F22 
0296 7126 0720  34         seto  @parm3                ; parm3 = SAMS not used >FFFF
     7128 2F24 
0297                       ;------------------------------------------------------
0298                       ; 4b: Do actual index update
0299                       ;------------------------------------------------------
0300               fh.file.read.edb.updindex:
0301 712A 06A0  32         bl    @idx.entry.update     ; Update index
     712C 6ACE 
0302                                                   ; \ i  parm1    = Line num in editor buffer
0303                                                   ; | i  parm2    = Pointer to line in editor
0304                                                   ; |               buffer
0305                                                   ; | i  parm3    = SAMS page
0306                                                   ; | o  outparm1 = Pointer to updated index
0307                                                   ; /               entry
0308               
0309 712E 05A0  34         inc   @edb.lines            ; lines=lines+1
     7130 A204 
0310                       ;------------------------------------------------------
0311                       ; Step 5: Callback "Read line from file"
0312                       ;------------------------------------------------------
0313               fh.file.read.edb.display:
0314 7132 C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Loading indicator 2"
     7134 A452 
0315 7136 0694  24         bl    *tmp0                 ; Run callback function
0316                       ;------------------------------------------------------
0317                       ; 5a: Next record
0318                       ;------------------------------------------------------
0319               fh.file.read.edb.next:
0320 7138 0460  28         b     @fh.file.read.edb.check_setpage
     713A 7034 
0321                                                   ; Next record
0322                       ;------------------------------------------------------
0323                       ; Error handler
0324                       ;------------------------------------------------------
0325               fh.file.read.edb.error:
0326 713C C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     713E A438 
0327 7140 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0328 7142 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7144 0005 
0329 7146 1309  14         jeq   fh.file.read.edb.eof  ; All good. File closed by DSRLNK
0330                       ;------------------------------------------------------
0331                       ; File error occured
0332                       ;------------------------------------------------------
0333 7148 06A0  32         bl    @file.close           ; Close file
     714A 2C80 
0334 714C 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0335               
0336 714E 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     7150 6846 
0337                       ;------------------------------------------------------
0338                       ; Callback "File I/O error"
0339                       ;------------------------------------------------------
0340 7152 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     7154 A456 
0341 7156 0694  24         bl    *tmp0                 ; Run callback function
0342 7158 1008  14         jmp   fh.file.read.edb.exit
0343                       ;------------------------------------------------------
0344                       ; End-Of-File reached
0345                       ;------------------------------------------------------
0346               fh.file.read.edb.eof:
0347 715A 06A0  32         bl    @file.close           ; Close file
     715C 2C80 
0348 715E 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0349               
0350 7160 06A0  32         bl    @mem.sams.layout      ; Restore SAMS windows
     7162 6846 
0351                       ;------------------------------------------------------
0352                       ; Callback "Close file"
0353                       ;------------------------------------------------------
0354 7164 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     7166 A454 
0355 7168 0694  24         bl    *tmp0                 ; Run callback function
0356               *--------------------------------------------------------------
0357               * Exit
0358               *--------------------------------------------------------------
0359               fh.file.read.edb.exit:
0360 716A 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     716C A44A 
0361 716E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0362 7170 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0363 7172 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0364 7174 C2F9  30         mov   *stack+,r11           ; Pop R11
0365 7176 045B  20         b     *r11                  ; Return to caller
0366               
0367               
0368               ***************************************************************
0369               * PAB for accessing DV/80 file
0370               ********|*****|*********************|**************************
0371               fh.file.pab.header:
0372 7178 0014             byte  io.op.open            ;  0    - OPEN
0373                       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
0374 717A 0960             data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
0375 717C 5000             byte  80                    ;  4    - Record length (80 chars max)
0376                       byte  00                    ;  5    - Character count
0377 717E 0000             data  >0000                 ;  6-7  - Seek record (only for fixed recs)
0378 7180 0000             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0379                       ;------------------------------------------------------
0380                       ; File descriptor part (variable length)
0381                       ;------------------------------------------------------
0382                       ; byte  12                  ;  9    - File descriptor length
0383                       ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor
0384                                                   ;         (Device + '.' + File name)
**** **** ****     > stevie_b1.asm.2287273
0138                       copy  "fh.write.edb.asm"    ; Write editor buffer to file
**** **** ****     > fh.write.edb.asm
0001               * FILE......: fh.write.edb.asm
0002               * Purpose...: File write module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *               Write editor buffer to file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * fh.file.write.edb
0011               * Write editor buffer to file
0012               ***************************************************************
0013               *  bl   @fh.file.write.edb
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * parm1 = Pointer to length-prefixed file descriptor
0017               * parm2 = Pointer to callback function "Before Open file"
0018               * parm3 = Pointer to callback function "Write line to file"
0019               * parm4 = Pointer to callback function "Close file"
0020               * parm5 = Pointer to callback function "File I/O error"
0021               *--------------------------------------------------------------
0022               * OUTPUT
0023               *--------------------------------------------------------------
0024               * Register usage
0025               * tmp0, tmp1, tmp2
0026               ********|*****|*********************|**************************
0027               fh.file.write.edb:
0028 7182 0649  14         dect  stack
0029 7184 C64B  30         mov   r11,*stack            ; Save return address
0030 7186 0649  14         dect  stack
0031 7188 C644  30         mov   tmp0,*stack           ; Push tmp0
0032 718A 0649  14         dect  stack
0033 718C C645  30         mov   tmp1,*stack           ; Push tmp1
0034 718E 0649  14         dect  stack
0035 7190 C646  30         mov   tmp2,*stack           ; Push tmp2
0036                       ;------------------------------------------------------
0037                       ; Initialisation
0038                       ;------------------------------------------------------
0039 7192 04E0  34         clr   @fh.records           ; Reset records counter
     7194 A43C 
0040 7196 04E0  34         clr   @fh.counter           ; Clear internal counter
     7198 A442 
0041 719A 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     719C A440 
0042 719E 04E0  34         clr   @fh.kilobytes.prev    ; /
     71A0 A458 
0043 71A2 04E0  34         clr   @fh.pabstat           ; Clear copy of VDP PAB status byte
     71A4 A438 
0044 71A6 04E0  34         clr   @fh.ioresult          ; Clear status register contents
     71A8 A43A 
0045                       ;------------------------------------------------------
0046                       ; Save parameters / callback functions
0047                       ;------------------------------------------------------
0048 71AA 0204  20         li    tmp0,fh.fopmode.writefile
     71AC 0002 
0049                                                   ; We are going to write to a file
0050 71AE C804  38         mov   tmp0,@fh.fopmode      ; Set file operations mode
     71B0 A44A 
0051               
0052 71B2 C820  54         mov   @parm1,@fh.fname.ptr  ; Pointer to file descriptor
     71B4 2F20 
     71B6 A444 
0053 71B8 C820  54         mov   @parm2,@fh.callback1  ; Callback function "Open file"
     71BA 2F22 
     71BC A450 
0054 71BE C820  54         mov   @parm3,@fh.callback2  ; Callback function "Write line to file"
     71C0 2F24 
     71C2 A452 
0055 71C4 C820  54         mov   @parm4,@fh.callback3  ; Callback function "Close" file"
     71C6 2F26 
     71C8 A454 
0056 71CA C820  54         mov   @parm5,@fh.callback4  ; Callback function "File I/O error"
     71CC 2F28 
     71CE A456 
0057                       ;------------------------------------------------------
0058                       ; Sanity check
0059                       ;------------------------------------------------------
0060 71D0 C120  34         mov   @fh.callback1,tmp0
     71D2 A450 
0061 71D4 0284  22         ci    tmp0,>6000            ; Insane address ?
     71D6 6000 
0062 71D8 1114  14         jlt   fh.file.write.crash   ; Yes, crash!
0063               
0064 71DA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     71DC 7FFF 
0065 71DE 1511  14         jgt   fh.file.write.crash   ; Yes, crash!
0066               
0067 71E0 C120  34         mov   @fh.callback2,tmp0
     71E2 A452 
0068 71E4 0284  22         ci    tmp0,>6000            ; Insane address ?
     71E6 6000 
0069 71E8 110C  14         jlt   fh.file.write.crash   ; Yes, crash!
0070               
0071 71EA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     71EC 7FFF 
0072 71EE 1509  14         jgt   fh.file.write.crash   ; Yes, crash!
0073               
0074 71F0 C120  34         mov   @fh.callback3,tmp0
     71F2 A454 
0075 71F4 0284  22         ci    tmp0,>6000            ; Insane address ?
     71F6 6000 
0076 71F8 1104  14         jlt   fh.file.write.crash   ; Yes, crash!
0077               
0078 71FA 0284  22         ci    tmp0,>7fff            ; Insane address ?
     71FC 7FFF 
0079 71FE 1501  14         jgt   fh.file.write.crash   ; Yes, crash!
0080               
0081 7200 1004  14         jmp   fh.file.write.edb.save1
0082                                                   ; All checks passed, continue.
0083                       ;------------------------------------------------------
0084                       ; Check failed, crash CPU!
0085                       ;------------------------------------------------------
0086               fh.file.write.crash:
0087 7202 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7204 FFCE 
0088 7206 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7208 2030 
0089                       ;------------------------------------------------------
0090                       ; Callback "Before Open file"
0091                       ;------------------------------------------------------
0092               fh.file.write.edb.save1:
0093 720A C120  34         mov   @fh.callback1,tmp0
     720C A450 
0094 720E 0694  24         bl    *tmp0                 ; Run callback function
0095                       ;------------------------------------------------------
0096                       ; Copy PAB header to VDP
0097                       ;------------------------------------------------------
0098               fh.file.write.edb.pabheader:
0099 7210 06A0  32         bl    @cpym2v
     7212 2456 
0100 7214 0A60                   data fh.vpab,fh.file.pab.header,9
     7216 7178 
     7218 0009 
0101                                                   ; Copy PAB header to VDP
0102                       ;------------------------------------------------------
0103                       ; Append file descriptor to PAB header in VDP
0104                       ;------------------------------------------------------
0105 721A 0204  20         li    tmp0,fh.vpab + 9      ; VDP destination
     721C 0A69 
0106 721E C160  34         mov   @fh.fname.ptr,tmp1    ; Get pointer to file descriptor
     7220 A444 
0107 7222 D195  26         movb  *tmp1,tmp2            ; Get file descriptor length
0108 7224 0986  56         srl   tmp2,8                ; Right justify
0109 7226 0586  14         inc   tmp2                  ; Include length byte as well
0110               
0111 7228 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     722A 245C 
0112                                                   ; \ i  tmp0 = VDP destination
0113                                                   ; | i  tmp1 = CPU source
0114                                                   ; / i  tmp2 = Number of bytes to copy
0115                       ;------------------------------------------------------
0116                       ; Open file
0117                       ;------------------------------------------------------
0118 722C 06A0  32         bl    @file.open            ; Open file
     722E 2C5C 
0119 7230 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0120 7232 0012                   data io.seq.out.dis.var
0121                                                   ; / i  p1 = File type/mode
0122               
0123 7234 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     7236 2026 
0124 7238 1338  14         jeq   fh.file.write.edb.error
0125                                                   ; Yes, IO error occured
0126                       ;------------------------------------------------------
0127                       ; Step 1: Write file record
0128                       ;------------------------------------------------------
0129               fh.file.write.edb.record:
0130 723A 8820  54         c     @fh.records,@edb.lines
     723C A43C 
     723E A204 
0131 7240 153E  14         jgt   fh.file.write.edb.done
0132                                                   ; Exit when all records processed
0133                       ;------------------------------------------------------
0134                       ; 1a: Unpack current line to framebuffer
0135                       ;------------------------------------------------------
0136 7242 C820  54         mov   @fh.records,@parm1    ; Line to unpack
     7244 A43C 
     7246 2F20 
0137 7248 04E0  34         clr   @parm2                ; 1st row in frame buffer
     724A 2F22 
0138               
0139 724C 06A0  32         bl    @edb.line.unpack      ; Unpack line
     724E 6D4A 
0140                                                   ; \ i  parm1    = Line to unpack
0141                                                   ; | i  parm2    = Target row in frame buffer
0142                                                   ; / o  outparm1 = Length of line
0143                       ;------------------------------------------------------
0144                       ; 1b: Copy unpacked line to VDP memory
0145                       ;------------------------------------------------------
0146 7250 0204  20         li    tmp0,fh.vrecbuf       ; VDP target address
     7252 0960 
0147 7254 0205  20         li    tmp1,fb.top           ; Top of frame buffer in CPU memory
     7256 A600 
0148               
0149 7258 C1A0  34         mov   @outparm1,tmp2        ; Length of line
     725A 2F30 
0150 725C C806  38         mov   tmp2,@fh.reclen       ; Set record length
     725E A43E 
0151 7260 1302  14         jeq   !                     ; Skip VDP copy if empty line
0152               
0153 7262 06A0  32         bl    @xpym2v               ; Copy CPU memory to VDP memory
     7264 245C 
0154                                                   ; \ i  tmp0 = VDP target address
0155                                                   ; | i  tmp1 = CPU source address
0156                                                   ; / i  tmp2 = Number of bytes to copy
0157                       ;------------------------------------------------------
0158                       ; 1c: Write file record
0159                       ;------------------------------------------------------
0160 7266 06A0  32 !       bl    @file.record.write    ; Write file record
     7268 2C98 
0161 726A 0A60                   data fh.vpab          ; \ i  p0   = Address of PAB in VDP RAM
0162                                                   ; |           (without +9 offset!)
0163                                                   ; | o  tmp0 = Status byte
0164                                                   ; | o  tmp1 = ?????
0165                                                   ; | o  tmp2 = Status register contents
0166                                                   ; /           upon DSRLNK return
0167               
0168 726C C804  38         mov   tmp0,@fh.pabstat      ; Save VDP PAB status byte
     726E A438 
0169 7270 C806  38         mov   tmp2,@fh.ioresult     ; Save status register contents
     7272 A43A 
0170                       ;------------------------------------------------------
0171                       ; 1d: Calculate kilobytes processed
0172                       ;------------------------------------------------------
0173 7274 A820  54         a     @fh.reclen,@fh.counter
     7276 A43E 
     7278 A442 
0174                                                   ; Add record length to counter
0175 727A C160  34         mov   @fh.counter,tmp1      ;
     727C A442 
0176 727E 0285  22         ci    tmp1,1024             ; 1 KB boundary reached ?
     7280 0400 
0177 7282 1106  14         jlt   fh.file.write.edb.check_fioerr
0178                                                   ; Not yet, goto (1e)
0179 7284 05A0  34         inc   @fh.kilobytes
     7286 A440 
0180 7288 0225  22         ai    tmp1,-1024            ; Remove KB portion, only keep bytes
     728A FC00 
0181 728C C805  38         mov   tmp1,@fh.counter      ; Update counter
     728E A442 
0182                       ;------------------------------------------------------
0183                       ; 1e: Check if a file error occured
0184                       ;------------------------------------------------------
0185               fh.file.write.edb.check_fioerr:
0186 7290 C1A0  34         mov   @fh.ioresult,tmp2
     7292 A43A 
0187 7294 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7296 2026 
0188 7298 1602  14         jne   fh.file.write.edb.display
0189                                                   ; No, goto (2)
0190 729A 0460  28         b     @fh.file.write.edb.error
     729C 72AA 
0191                                                   ; Yes, so handle file error
0192                       ;------------------------------------------------------
0193                       ; Step 2: Callback "Write line to  file"
0194                       ;------------------------------------------------------
0195               fh.file.write.edb.display:
0196 729E C120  34         mov   @fh.callback2,tmp0    ; Get pointer to "Saving indicator 2"
     72A0 A452 
0197 72A2 0694  24         bl    *tmp0                 ; Run callback function
0198                       ;------------------------------------------------------
0199                       ; Step 3: Next record
0200                       ;------------------------------------------------------
0201 72A4 05A0  34         inc   @fh.records           ; Update counter
     72A6 A43C 
0202 72A8 10C8  14         jmp   fh.file.write.edb.record
0203                       ;------------------------------------------------------
0204                       ; Error handler
0205                       ;------------------------------------------------------
0206               fh.file.write.edb.error:
0207 72AA C120  34         mov   @fh.pabstat,tmp0      ; Get VDP PAB status byte
     72AC A438 
0208 72AE 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0209                       ;------------------------------------------------------
0210                       ; File error occured
0211                       ;------------------------------------------------------
0212 72B0 06A0  32         bl    @file.close           ; Close file
     72B2 2C80 
0213 72B4 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0214                       ;------------------------------------------------------
0215                       ; Callback "File I/O error"
0216                       ;------------------------------------------------------
0217 72B6 C120  34         mov   @fh.callback4,tmp0    ; Get pointer to Callback "File I/O error"
     72B8 A456 
0218 72BA 0694  24         bl    *tmp0                 ; Run callback function
0219 72BC 1006  14         jmp   fh.file.write.edb.exit
0220                       ;------------------------------------------------------
0221                       ; All records written. Close file
0222                       ;------------------------------------------------------
0223               fh.file.write.edb.done:
0224 72BE 06A0  32         bl    @file.close           ; Close file
     72C0 2C80 
0225 72C2 0A60                   data fh.vpab          ; \ i  p0 = Address of PAB in VRAM
0226                       ;------------------------------------------------------
0227                       ; Callback "Close file"
0228                       ;------------------------------------------------------
0229 72C4 C120  34         mov   @fh.callback3,tmp0    ; Get pointer to Callback "Close file"
     72C6 A454 
0230 72C8 0694  24         bl    *tmp0                 ; Run callback function
0231               *--------------------------------------------------------------
0232               * Exit
0233               *--------------------------------------------------------------
0234               fh.file.write.edb.exit:
0235 72CA 04E0  34         clr   @fh.fopmode           ; Set FOP mode to idle operation
     72CC A44A 
0236 72CE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0237 72D0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0238 72D2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0239 72D4 C2F9  30         mov   *stack+,r11           ; Pop R11
0240 72D6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0139                       copy  "fm.load.asm"         ; Load DV80 file into editor buffer
**** **** ****     > fm.load.asm
0001               * FILE......: fm.load.asm
0002               * Purpose...: File Manager - Load file into editor buffer
0003               
0004               
0005               ***************************************************************
0006               * fm.loadfile
0007               * Load file into editor buffer
0008               ***************************************************************
0009               * bl  @fm.loadfile
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * tmp0  = Pointer to length-prefixed string containing both
0013               *         device and filename
0014               *---------------------------------------------------------------
0015               * OUTPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0, tmp1
0020               ********|*****|*********************|**************************
0021               fm.loadfile:
0022 72D8 0649  14         dect  stack
0023 72DA C64B  30         mov   r11,*stack            ; Save return address
0024 72DC 0649  14         dect  stack
0025 72DE C644  30         mov   tmp0,*stack           ; Push tmp0
0026 72E0 0649  14         dect  stack
0027 72E2 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Show dialog "Unsaved changes" and exit if buffer dirty
0030                       ;-------------------------------------------------------
0031 72E4 C160  34         mov   @edb.dirty,tmp1
     72E6 A206 
0032 72E8 1305  14         jeq   !
0033 72EA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0034 72EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0035 72EE C2F9  30         mov   *stack+,r11           ; Pop R11
0036 72F0 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     72F2 7D24 
0037                       ;-------------------------------------------------------
0038                       ; Reset editor
0039                       ;-------------------------------------------------------
0040 72F4 C804  38 !       mov   tmp0,@parm1           ; Setup file to load
     72F6 2F20 
0041 72F8 06A0  32         bl    @tv.reset             ; Reset editor
     72FA 682A 
0042 72FC C820  54         mov   @parm1,@edb.filename.ptr
     72FE 2F20 
     7300 A20E 
0043                                                   ; Set filename
0044                       ;-------------------------------------------------------
0045                       ; Clear VDP screen buffer
0046                       ;-------------------------------------------------------
0047 7302 06A0  32         bl    @filv
     7304 229A 
0048 7306 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     7308 0000 
     730A 0004 
0049               
0050 730C C160  34         mov   @fb.scrrows,tmp1
     730E A118 
0051 7310 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7312 A10E 
0052                                                   ; 16 bit part is in tmp2!
0053               
0054 7314 06A0  32         bl    @scroff               ; Turn off screen
     7316 265E 
0055               
0056 7318 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0057 731A 0205  20         li    tmp1,32               ; Character to fill
     731C 0020 
0058               
0059 731E 06A0  32         bl    @xfilv                ; Fill VDP memory
     7320 22A0 
0060                                                   ; \ i  tmp0 = VDP target address
0061                                                   ; | i  tmp1 = Byte to fill
0062                                                   ; / i  tmp2 = Bytes to copy
0063               
0064 7322 06A0  32         bl    @pane.action.colorscheme.Load
     7324 7852 
0065                                                   ; Load color scheme and turn on screen
0066                       ;-------------------------------------------------------
0067                       ; Read DV80 file and display
0068                       ;-------------------------------------------------------
0069 7326 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     7328 73E8 
0070 732A C804  38         mov   tmp0,@parm2           ; Register callback 1
     732C 2F22 
0071               
0072 732E 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     7330 7446 
0073 7332 C804  38         mov   tmp0,@parm3           ; Register callback 2
     7334 2F24 
0074               
0075 7336 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     7338 747C 
0076 733A C804  38         mov   tmp0,@parm4           ; Register callback 3
     733C 2F26 
0077               
0078 733E 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     7340 74AE 
0079 7342 C804  38         mov   tmp0,@parm5           ; Register callback 4
     7344 2F28 
0080               
0081 7346 06A0  32         bl    @fh.file.read.edb     ; Read file into editor buffer
     7348 6F64 
0082                                                   ; \ i  parm1 = Pointer to length prefixed
0083                                                   ; |            file descriptor
0084                                                   ; | i  parm2 = Pointer to callback
0085                                                   ; |            "loading indicator 1"
0086                                                   ; | i  parm3 = Pointer to callback
0087                                                   ; |            "loading indicator 2"
0088                                                   ; | i  parm4 = Pointer to callback
0089                                                   ; |            "loading indicator 3"
0090                                                   ; | i  parm5 = Pointer to callback
0091                                                   ; /            "File I/O error handler"
0092               
0093 734A 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     734C A206 
0094                                                   ; longer dirty.
0095               
0096 734E 0204  20         li    tmp0,txt.filetype.DV80
     7350 32AC 
0097 7352 C804  38         mov   tmp0,@edb.filetype.ptr
     7354 A210 
0098                                                   ; Set filetype display string
0099               *--------------------------------------------------------------
0100               * Exit
0101               *--------------------------------------------------------------
0102               fm.loadfile.exit:
0103 7356 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 7358 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 735A C2F9  30         mov   *stack+,r11           ; Pop R11
0106 735C 045B  20         b     *r11                  ; Return to caller
0107               
0108               
0109               ***************************************************************
0110               * fm.fastmode
0111               * Turn on fast mode for supported devices
0112               ***************************************************************
0113               * bl  @fm.fastmode
0114               *--------------------------------------------------------------
0115               * INPUT
0116               * none
0117               *---------------------------------------------------------------
0118               * OUTPUT
0119               * none
0120               *--------------------------------------------------------------
0121               * Register usage
0122               * tmp0, tmp1
0123               ********|*****|*********************|**************************
0124               fm.fastmode:
0125 735E 0649  14         dect  stack
0126 7360 C64B  30         mov   r11,*stack            ; Save return address
0127 7362 0649  14         dect  stack
0128 7364 C644  30         mov   tmp0,*stack           ; Push tmp0
0129               
0130 7366 C120  34         mov   @fh.offsetopcode,tmp0
     7368 A44E 
0131 736A 1307  14         jeq   !
0132                       ;------------------------------------------------------
0133                       ; Turn fast mode off
0134                       ;------------------------------------------------------
0135 736C 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     736E A44E 
0136 7370 0204  20         li    tmp0,txt.keys.load
     7372 331C 
0137 7374 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7376 A320 
0138 7378 1008  14         jmp   fm.fastmode.exit
0139                       ;------------------------------------------------------
0140                       ; Turn fast mode on
0141                       ;------------------------------------------------------
0142 737A 0204  20 !       li    tmp0,>40              ; Data buffer in CPU RAM
     737C 0040 
0143 737E C804  38         mov   tmp0,@fh.offsetopcode
     7380 A44E 
0144 7382 0204  20         li    tmp0,txt.keys.load2
     7384 3354 
0145 7386 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7388 A320 
0146               *--------------------------------------------------------------
0147               * Exit
0148               *--------------------------------------------------------------
0149               fm.fastmode.exit:
0150 738A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 738C C2F9  30         mov   *stack+,r11           ; Pop R11
0152 738E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0140                       copy  "fm.save.asm"         ; Save DV80 file from editor buffer
**** **** ****     > fm.save.asm
0001               * FILE......: fm.save.asm
0002               * Purpose...: File Manager - Save file from editor buffer
0003               
0004               
0005               ***************************************************************
0006               * fm.savefile
0007               * Save file from editor buffer
0008               ***************************************************************
0009               * bl  @fm.savefile
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * tmp0  = Pointer to length-prefixed string containing both
0013               *         device and filename
0014               *---------------------------------------------------------------
0015               * OUTPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0, tmp1
0020               ********|*****|*********************|**************************
0021               fm.savefile:
0022 7390 0649  14         dect  stack
0023 7392 C64B  30         mov   r11,*stack            ; Save return address
0024 7394 0649  14         dect  stack
0025 7396 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 7398 0649  14         dect  stack
0027 739A C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Save DV80 file
0030                       ;-------------------------------------------------------
0031 739C C804  38         mov   tmp0,@parm1           ; Set device and filename
     739E 2F20 
0032               
0033 73A0 0204  20         li    tmp0,fm.loadsave.cb.indicator1
     73A2 73E8 
0034 73A4 C804  38         mov   tmp0,@parm2           ; Register callback 1
     73A6 2F22 
0035               
0036 73A8 0204  20         li    tmp0,fm.loadsave.cb.indicator2
     73AA 7446 
0037 73AC C804  38         mov   tmp0,@parm3           ; Register callback 2
     73AE 2F24 
0038               
0039 73B0 0204  20         li    tmp0,fm.loadsave.cb.indicator3
     73B2 747C 
0040 73B4 C804  38         mov   tmp0,@parm4           ; Register callback 3
     73B6 2F26 
0041               
0042 73B8 0204  20         li    tmp0,fm.loadsave.cb.fioerr
     73BA 74AE 
0043 73BC C804  38         mov   tmp0,@parm5           ; Register callback 4
     73BE 2F28 
0044               
0045 73C0 C820  54         mov   @parm1,@edb.filename.ptr
     73C2 2F20 
     73C4 A20E 
0046                                                   ; Set current filename
0047               
0048 73C6 06A0  32         bl    @filv
     73C8 229A 
0049 73CA 2180                   data sprsat,>0000,4   ; Turn off sprites (cursor)
     73CC 0000 
     73CE 0004 
0050               
0051 73D0 06A0  32         bl    @fh.file.write.edb    ; Save file from editor buffer
     73D2 7182 
0052                                                   ; \ i  parm1 = Pointer to length prefixed
0053                                                   ; |            file descriptor
0054                                                   ; | i  parm2 = Pointer to callback
0055                                                   ; |            "loading indicator 1"
0056                                                   ; | i  parm3 = Pointer to callback
0057                                                   ; |            "loading indicator 2"
0058                                                   ; | i  parm4 = Pointer to callback
0059                                                   ; |            "loading indicator 3"
0060                                                   ; | i  parm5 = Pointer to callback
0061                                                   ; /            "File I/O error handler"
0062               
0063 73D4 04E0  34         clr   @edb.dirty            ; Editor buffer content replaced, not
     73D6 A206 
0064                                                   ; longer dirty.
0065               
0066 73D8 0204  20         li    tmp0,txt.filetype.DV80
     73DA 32AC 
0067 73DC C804  38         mov   tmp0,@edb.filetype.ptr
     73DE A210 
0068                                                   ; Set filetype display string
0069               *--------------------------------------------------------------
0070               * Exit
0071               *--------------------------------------------------------------
0072               fm.savefile.exit:
0073 73E0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0074 73E2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0075 73E4 C2F9  30         mov   *stack+,r11           ; Pop R11
0076 73E6 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0141                       copy  "fm.callbacks.asm"    ; Callbacks for file operations
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
0011 73E8 0649  14         dect  stack
0012 73EA C64B  30         mov   r11,*stack            ; Save return address
0013 73EC 0649  14         dect  stack
0014 73EE C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;------------------------------------------------------
0016                       ; Check file operation mode
0017                       ;------------------------------------------------------
0018 73F0 06A0  32         bl    @hchar
     73F2 2792 
0019 73F4 1D00                   byte pane.botrow,0,32,80
     73F6 2050 
0020 73F8 FFFF                   data EOL              ; Clear until end of line
0021               
0022 73FA C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     73FC A44A 
0023               
0024 73FE 0284  22         ci    tmp0,fh.fopmode.writefile
     7400 0002 
0025 7402 1303  14         jeq   fm.loadsave.cb.indicator1.saving
0026                                                   ; Saving file?
0027               
0028 7404 0284  22         ci    tmp0,fh.fopmode.readfile
     7406 0001 
0029 7408 1305  14         jeq   fm.loadsave.cb.indicator1.loading
0030                                                   ; Loading file?
0031                       ;------------------------------------------------------
0032                       ; Display Saving....
0033                       ;------------------------------------------------------
0034               fm.loadsave.cb.indicator1.saving:
0035 740A 06A0  32         bl    @putat
     740C 244E 
0036 740E 1D00                   byte pane.botrow,0
0037 7410 327E                   data txt.saving       ; Display "Saving...."
0038 7412 1004  14         jmp   fm.loadsave.cb.indicator1.filename
0039                       ;------------------------------------------------------
0040                       ; Display Loading....
0041                       ;------------------------------------------------------
0042               fm.loadsave.cb.indicator1.loading:
0043 7414 06A0  32         bl    @putat
     7416 244E 
0044 7418 1D00                   byte pane.botrow,0
0045 741A 3272                   data txt.loading      ; Display "Loading...."
0046                       ;------------------------------------------------------
0047                       ; Display device/filename
0048                       ;------------------------------------------------------
0049               fm.loadsave.cb.indicator1.filename:
0050 741C 06A0  32         bl    @at
     741E 269E 
0051 7420 1D0B                   byte pane.botrow,11   ; Cursor YX position
0052 7422 C160  34         mov   @parm1,tmp1           ; Get pointer to file descriptor
     7424 2F20 
0053 7426 06A0  32         bl    @xutst0               ; Display device/filename
     7428 242C 
0054                       ;------------------------------------------------------
0055                       ; Display separators
0056                       ;------------------------------------------------------
0057 742A 06A0  32         bl    @putat
     742C 244E 
0058 742E 1D47                   byte pane.botrow,71
0059 7430 32BC                   data txt.vertline     ; Vertical line
0060                       ;------------------------------------------------------
0061                       ; Display fast mode
0062                       ;------------------------------------------------------
0063 7432 0760  38         abs   @fh.offsetopcode
     7434 A44E 
0064 7436 1304  14         jeq   fm.loadsave.cb.indicator1.exit
0065               
0066 7438 06A0  32         bl    @putat
     743A 244E 
0067 743C 1D26                   byte pane.botrow,38
0068 743E 3288                   data txt.fastmode     ; Display "FastMode"
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               fm.loadsave.cb.indicator1.exit:
0073 7440 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 7442 C2F9  30         mov   *stack+,r11           ; Pop R11
0075 7444 045B  20         b     *r11                  ; Return to caller
0076               
0077               
0078               
0079               
0080               *---------------------------------------------------------------
0081               * Callback function "Show loading indicator 2"
0082               * Read line from file / Write line to file
0083               *---------------------------------------------------------------
0084               * Registered as pointer in @fh.callback2
0085               *---------------------------------------------------------------
0086               fm.loadsave.cb.indicator2:
0087                       ;------------------------------------------------------
0088                       ; Check if updated counters should be displayed
0089                       ;------------------------------------------------------
0090 7446 8820  54         c     @fh.kilobytes,@fh.kilobytes.prev
     7448 A440 
     744A A458 
0091 744C 1316  14         jeq   !
0092                       ;------------------------------------------------------
0093                       ; Display updated counters
0094                       ;------------------------------------------------------
0095 744E 0649  14         dect  stack
0096 7450 C64B  30         mov   r11,*stack            ; Save return address
0097               
0098 7452 C820  54         mov   @fh.kilobytes,@fh.kilobytes.prev
     7454 A440 
     7456 A458 
0099                                                   ; Save for compare
0100               
0101 7458 06A0  32         bl    @putnum
     745A 2A22 
0102 745C 1D34                   byte pane.botrow,52   ; Show kilobytes processed
0103 745E A440                   data fh.kilobytes,rambuf,>3020
     7460 2F64 
     7462 3020 
0104               
0105 7464 06A0  32         bl    @putat
     7466 244E 
0106 7468 1D39                   byte pane.botrow,57
0107 746A 3292                   data txt.kb           ; Show "kb" string
0108               
0109 746C 06A0  32         bl    @putnum
     746E 2A22 
0110 7470 1D49                   byte pane.botrow,73   ; Show lines processed
0111 7472 A43C                   data fh.records,rambuf,>3020
     7474 2F64 
     7476 3020 
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115               fm.loadsave.cb.indicator2.exit:
0116 7478 C2F9  30         mov   *stack+,r11           ; Pop R11
0117 747A 045B  20 !       b     *r11                  ; Return to caller
0118               
0119               
0120               
0121               
0122               *---------------------------------------------------------------
0123               * Callback function "Show loading indicator 3"
0124               * Close file
0125               *---------------------------------------------------------------
0126               * Registered as pointer in @fh.callback3
0127               *---------------------------------------------------------------
0128               fm.loadsave.cb.indicator3:
0129 747C 0649  14         dect  stack
0130 747E C64B  30         mov   r11,*stack            ; Save return address
0131               
0132 7480 06A0  32         bl    @hchar
     7482 2792 
0133 7484 1D03                   byte pane.botrow,3,32,50
     7486 2032 
0134 7488 FFFF                   data EOL              ; Erase loading indicator
0135               
0136 748A 06A0  32         bl    @putnum
     748C 2A22 
0137 748E 1D34                   byte pane.botrow,52   ; Show kilobytes processed
0138 7490 A440                   data fh.kilobytes,rambuf,>3020
     7492 2F64 
     7494 3020 
0139               
0140 7496 06A0  32         bl    @putat
     7498 244E 
0141 749A 1D39                   byte pane.botrow,57
0142 749C 3292                   data txt.kb           ; Show "kb" string
0143               
0144 749E 06A0  32         bl    @putnum
     74A0 2A22 
0145 74A2 1D49                   byte pane.botrow,73   ; Show lines processed
0146 74A4 A43C                   data fh.records,rambuf,>3020
     74A6 2F64 
     74A8 3020 
0147                       ;------------------------------------------------------
0148                       ; Exit
0149                       ;------------------------------------------------------
0150               fm.loadsave.cb.indicator3.exit:
0151 74AA C2F9  30         mov   *stack+,r11           ; Pop R11
0152 74AC 045B  20         b     *r11                  ; Return to caller
0153               
0154               
0155               
0156               *---------------------------------------------------------------
0157               * Callback function "File I/O error handler"
0158               * I/O error
0159               *---------------------------------------------------------------
0160               * Registered as pointer in @fh.callback4
0161               *---------------------------------------------------------------
0162               fm.loadsave.cb.fioerr:
0163 74AE 0649  14         dect  stack
0164 74B0 C64B  30         mov   r11,*stack            ; Save return address
0165 74B2 0649  14         dect  stack
0166 74B4 C644  30         mov   tmp0,*stack           ; Push tmp0
0167                       ;------------------------------------------------------
0168                       ; Build I/O error message
0169                       ;------------------------------------------------------
0170 74B6 06A0  32         bl    @hchar
     74B8 2792 
0171 74BA 1D00                   byte pane.botrow,0,32,50
     74BC 2032 
0172 74BE FFFF                   data EOL              ; Erase loading indicator
0173               
0174 74C0 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     74C2 A44A 
0175 74C4 0284  22         ci    tmp0,fh.fopmode.writefile
     74C6 0002 
0176 74C8 1306  14         jeq   fm.loadsave.cb.fioerr.mgs2
0177                       ;------------------------------------------------------
0178                       ; Failed loading file
0179                       ;------------------------------------------------------
0180               fm.loadsave.cb.fioerr.mgs1:
0181 74CA 06A0  32         bl    @cpym2m
     74CC 24AA 
0182 74CE 3509                   data txt.ioerr.load+1
0183 74D0 A021                   data tv.error.msg+1
0184 74D2 0022                   data 34               ; Error message
0185 74D4 1005  14         jmp   fm.loadsave.cb.fioerr.mgs3
0186                       ;------------------------------------------------------
0187                       ; Failed saving file
0188                       ;------------------------------------------------------
0189               fm.loadsave.cb.fioerr.mgs2:
0190 74D6 06A0  32         bl    @cpym2m
     74D8 24AA 
0191 74DA 352B                   data txt.ioerr.save+1
0192 74DC A021                   data tv.error.msg+1
0193 74DE 0022                   data 34               ; Error message
0194                       ;------------------------------------------------------
0195                       ; Add filename to error message
0196                       ;------------------------------------------------------
0197               fm.loadsave.cb.fioerr.mgs3:
0198 74E0 C120  34         mov   @edb.filename.ptr,tmp0
     74E2 A20E 
0199 74E4 D194  26         movb  *tmp0,tmp2            ; Get length byte
0200 74E6 0986  56         srl   tmp2,8                ; Right align
0201 74E8 0584  14         inc   tmp0                  ; Skip length byte
0202 74EA 0205  20         li    tmp1,tv.error.msg+33  ; RAM destination address
     74EC A041 
0203               
0204 74EE 06A0  32         bl    @xpym2m               ; \ Copy CPU memory to CPU memory
     74F0 24B0 
0205                                                   ; | i  tmp0 = ROM/RAM source
0206                                                   ; | i  tmp1 = RAM destination
0207                                                   ; / i  tmp2 = Bytes to copy
0208                       ;------------------------------------------------------
0209                       ; Reset filename to "new file"
0210                       ;------------------------------------------------------
0211 74F2 C120  34         mov   @fh.fopmode,tmp0      ; Check file operation mode
     74F4 A44A 
0212               
0213 74F6 0284  22         ci    tmp0,fh.fopmode.readfile
     74F8 0001 
0214 74FA 1608  14         jne   !                     ; Only when reading file
0215               
0216 74FC 0204  20         li    tmp0,txt.newfile      ; New file
     74FE 32A0 
0217 7500 C804  38         mov   tmp0,@edb.filename.ptr
     7502 A20E 
0218               
0219 7504 0204  20         li    tmp0,txt.filetype.none
     7506 32B2 
0220 7508 C804  38         mov   tmp0,@edb.filetype.ptr
     750A A210 
0221                                                   ; Empty filetype string
0222                       ;------------------------------------------------------
0223                       ; Display I/O error message
0224                       ;------------------------------------------------------
0225 750C 06A0  32 !       bl    @pane.errline.show    ; Show error line
     750E 7A90 
0226                       ;------------------------------------------------------
0227                       ; Exit
0228                       ;------------------------------------------------------
0229               fm.loadsave.cb.fioerr.exit:
0230 7510 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0231 7512 C2F9  30         mov   *stack+,r11           ; Pop R11
0232 7514 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0142                       copy  "fm.browse.asm"       ; File manager browse support routines
**** **** ****     > fm.browse.asm
0001               * FILE......: fm.browse.asm
0002               * Purpose...: File Manager - File browse support routines
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Increase/Decrease last-character of current filename
0007               *---------------------------------------------------------------
0008               * bl   @fm.browse.fname.suffix
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * parm1        = Pointer to device and filename
0012               * parm2        = Increase (>FFFF) or Decrease (>0000) ASCII
0013               *--------------------------------------------------------------
0014               * Register usage
0015               * tmp0, tmp1
0016               ********|*****|*********************|**************************
0017               fm.browse.fname.suffix.incdec:
0018 7516 0649  14         dect  stack
0019 7518 C64B  30         mov   r11,*stack            ; Save return address
0020 751A 0649  14         dect  stack
0021 751C C644  30         mov   tmp0,*stack           ; Push tmp0
0022 751E 0649  14         dect  stack
0023 7520 C645  30         mov   tmp1,*stack           ; Push tmp1
0024                       ;------------------------------------------------------
0025                       ; Sanity check
0026                       ;------------------------------------------------------
0027 7522 C120  34         mov   @parm1,tmp0           ; Get pointer to filename
     7524 2F20 
0028 7526 1334  14         jeq   fm.browse.fname.suffix.exit
0029                                                   ; Exit early if pointer is nill
0030               
0031 7528 0284  22         ci    tmp0,txt.newfile
     752A 32A0 
0032 752C 1331  14         jeq   fm.browse.fname.suffix.exit
0033                                                   ; Exit early if "New file"
0034                       ;------------------------------------------------------
0035                       ; Get last character in filename
0036                       ;------------------------------------------------------
0037 752E D154  26         movb  *tmp0,tmp1            ; Get length of current filename
0038 7530 0985  56         srl   tmp1,8                ; MSB to LSB
0039               
0040 7532 A105  18         a     tmp1,tmp0             ; Move to last character
0041 7534 04C5  14         clr   tmp1
0042 7536 D154  26         movb  *tmp0,tmp1            ; Get character
0043 7538 0985  56         srl   tmp1,8                ; MSB to LSB
0044 753A 132A  14         jeq   fm.browse.fname.suffix.exit
0045                                                   ; Exit early if empty filename
0046                       ;------------------------------------------------------
0047                       ; Check mode (increase/decrease) character ASCII value
0048                       ;------------------------------------------------------
0049 753C C1A0  34         mov   @parm2,tmp2           ; Get mode
     753E 2F22 
0050 7540 1314  14         jeq   fm.browse.fname.suffix.dec
0051                                                   ; Decrease ASCII if mode = 0
0052                       ;------------------------------------------------------
0053                       ; Increase ASCII value last character in filename
0054                       ;------------------------------------------------------
0055               fm.browse.fname.suffix.inc:
0056 7542 0285  22         ci    tmp1,48               ; ASCI  48 (char 0) ?
     7544 0030 
0057 7546 1108  14         jlt   fm.browse.fname.suffix.inc.crash
0058 7548 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     754A 0039 
0059 754C 1109  14         jlt   !                     ; Next character
0060 754E 130A  14         jeq   fm.browse.fname.suffix.inc.alpha
0061                                                   ; Swith to alpha range A..Z
0062 7550 0285  22         ci    tmp1,90               ; ASCII 132 (char Z) ?
     7552 005A 
0063 7554 131D  14         jeq   fm.browse.fname.suffix.exit
0064                                                   ; Already last alpha character, so exit
0065 7556 1104  14         jlt   !                     ; Next character
0066                       ;------------------------------------------------------
0067                       ; Invalid character, crash and burn
0068                       ;------------------------------------------------------
0069               fm.browse.fname.suffix.inc.crash:
0070 7558 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     755A FFCE 
0071 755C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     755E 2030 
0072                       ;------------------------------------------------------
0073                       ; Increase ASCII value last character in filename
0074                       ;------------------------------------------------------
0075 7560 0585  14 !       inc   tmp1                  ; Increase ASCII value
0076 7562 1014  14         jmp   fm.browse.fname.suffix.store
0077               fm.browse.fname.suffix.inc.alpha:
0078 7564 0205  20         li    tmp1,65               ; Set ASCII 65 (char A)
     7566 0041 
0079 7568 1011  14         jmp   fm.browse.fname.suffix.store
0080                       ;------------------------------------------------------
0081                       ; Decrease ASCII value last character in filename
0082                       ;------------------------------------------------------
0083               fm.browse.fname.suffix.dec:
0084 756A 0285  22         ci    tmp1,48               ; ASCII 48 (char 0) ?
     756C 0030 
0085 756E 1310  14         jeq   fm.browse.fname.suffix.exit
0086                                                   ; Already first numeric character, so exit
0087 7570 0285  22         ci    tmp1,57               ; ASCII 57 (char 9) ?
     7572 0039 
0088 7574 1207  14         jle   !                     ; Previous character
0089 7576 0285  22         ci    tmp1,65               ; ASCII 65 (char A) ?
     7578 0041 
0090 757A 1306  14         jeq   fm.browse.fname.suffix.dec.numeric
0091                                                   ; Switch to numeric range 0..9
0092 757C 11ED  14         jlt   fm.browse.fname.suffix.inc.crash
0093                                                   ; Invalid character
0094 757E 0285  22         ci    tmp1,132              ; ASCII 132 (char Z) ?
     7580 0084 
0095 7582 1306  14         jeq   fm.browse.fname.suffix.exit
0096 7584 0605  14 !       dec   tmp1                  ; Decrease ASCII value
0097 7586 1002  14         jmp   fm.browse.fname.suffix.store
0098               fm.browse.fname.suffix.dec.numeric:
0099 7588 0205  20         li    tmp1,57               ; Set ASCII 57 (char 9)
     758A 0039 
0100                       ;------------------------------------------------------
0101                       ; Store updatec character
0102                       ;------------------------------------------------------
0103               fm.browse.fname.suffix.store:
0104 758C 0A85  56         sla   tmp1,8                ; LSB to MSB
0105 758E D505  30         movb  tmp1,*tmp0            ; Store updated character
0106                       ;------------------------------------------------------
0107                       ; Exit
0108                       ;------------------------------------------------------
0109               fm.browse.fname.suffix.exit:
0110 7590 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0111 7592 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0112 7594 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 7596 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0143                       ;-----------------------------------------------------------------------
0144                       ; User hook, background tasks
0145                       ;-----------------------------------------------------------------------
0146                       copy  "hook.keyscan.asm"    ; spectra2 user hook: keyboard scanning
**** **** ****     > hook.keyscan.asm
0001               * FILE......: hook.keyscan.asm
0002               * Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Keyboard handling (spectra2 user hook)
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ****************************************************************
0009               * Editor - spectra2 user hook
0010               ****************************************************************
0011               hook.keyscan:
0012 7598 20A0  38         coc   @wbit11,config        ; ANYKEY pressed ?
     759A 2014 
0013 759C 1612  14         jne   hook.keyscan.clear_kbbuffer
0014                                                   ; No, clear buffer and exit
0015 759E C820  54         mov   @waux1,@keycode1      ; Save current key pressed
     75A0 833C 
     75A2 2F40 
0016               *---------------------------------------------------------------
0017               * Identical key pressed ?
0018               *---------------------------------------------------------------
0019 75A4 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     75A6 2014 
0020 75A8 8820  54         c     @keycode1,@keycode2   ; Still pressing previous key?
     75AA 2F40 
     75AC 2F42 
0021 75AE 130D  14         jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
0022               *--------------------------------------------------------------
0023               * New key pressed
0024               *--------------------------------------------------------------
0025 75B0 0204  20         li    tmp0,2000             ; \
     75B2 07D0 
0026 75B4 0604  14 !       dec   tmp0                  ; | Inline keyboard bounce delay
0027 75B6 16FE  14         jne   -!                    ; /
0028 75B8 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     75BA 2F40 
     75BC 2F42 
0029 75BE 0460  28         b     @edkey.key.process    ; Process key
     75C0 60E4 
0030               *--------------------------------------------------------------
0031               * Clear keyboard buffer if no key pressed
0032               *--------------------------------------------------------------
0033               hook.keyscan.clear_kbbuffer:
0034 75C2 04E0  34         clr   @keycode1
     75C4 2F40 
0035 75C6 04E0  34         clr   @keycode2
     75C8 2F42 
0036               *--------------------------------------------------------------
0037               * Delay to avoid key bouncing
0038               *--------------------------------------------------------------
0039               hook.keyscan.bounce:
0040 75CA 0204  20         li    tmp0,2000             ; Avoid key bouncing
     75CC 07D0 
0041                       ;------------------------------------------------------
0042                       ; Delay loop
0043                       ;------------------------------------------------------
0044               hook.keyscan.bounce.loop:
0045 75CE 0604  14         dec   tmp0
0046 75D0 16FE  14         jne   hook.keyscan.bounce.loop
0047 75D2 0460  28         b     @hookok               ; Return
     75D4 2D18 
0048               
**** **** ****     > stevie_b1.asm.2287273
0147                       copy  "task.vdp.panes.asm"  ; Task - VDP draw editor panes
**** **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0010               ********|*****|*********************|**************************
0011               task.vdp.panes:
0012 75D6 C820  54         mov   @wyx,@fb.yxsave       ; Backup cursor
     75D8 832A 
     75DA A114 
0013                       ;------------------------------------------------------
0014                       ; ALPHA-Lock key down?
0015                       ;------------------------------------------------------
0016               task.vdp.panes.alpha_lock:
0017 75DC 20A0  38         coc   @wbit10,config
     75DE 2016 
0018 75E0 1305  14         jeq   task.vdp.panes.alpha_lock.down
0019                       ;------------------------------------------------------
0020                       ; AlPHA-Lock is up
0021                       ;------------------------------------------------------
0022 75E2 06A0  32         bl    @putat
     75E4 244E 
0023 75E6 1D4F                   byte   pane.botrow,79
0024 75E8 32B8                   data   txt.alpha.up
0025 75EA 1004  14         jmp   task.vdp.panes.cmdb.check
0026                       ;------------------------------------------------------
0027                       ; AlPHA-Lock is down
0028                       ;------------------------------------------------------
0029               task.vdp.panes.alpha_lock.down:
0030 75EC 06A0  32         bl    @putat
     75EE 244E 
0031 75F0 1D4F                   byte   pane.botrow,79
0032 75F2 32BA                   data   txt.alpha.down
0033                       ;------------------------------------------------------
0034                       ; Command buffer visible ?
0035                       ;------------------------------------------------------
0036               task.vdp.panes.cmdb.check
0037 75F4 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor
     75F6 A114 
     75F8 832A 
0038 75FA C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     75FC A302 
0039 75FE 1309  14         jeq   !                     ; No, skip CMDB pane
0040 7600 1000  14         jmp   task.vdp.panes.cmdb.draw
0041                       ;-------------------------------------------------------
0042                       ; Draw command buffer pane if dirty
0043                       ;-------------------------------------------------------
0044               task.vdp.panes.cmdb.draw:
0045 7602 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     7604 A318 
0046 7606 1344  14         jeq   task.vdp.panes.exit   ; No, skip update
0047               
0048 7608 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     760A 7936 
0049 760C 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     760E A318 
0050 7610 103F  14         jmp   task.vdp.panes.exit   ; Exit early
0051                       ;-------------------------------------------------------
0052                       ; Check if frame buffer dirty
0053                       ;-------------------------------------------------------
0054 7612 C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7614 A116 
0055 7616 133C  14         jeq   task.vdp.panes.exit   ; No, skip update
0056 7618 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     761A 832A 
     761C A114 
0057                       ;------------------------------------------------------
0058                       ; Determine how many rows to copy
0059                       ;------------------------------------------------------
0060 761E 8820  54         c     @edb.lines,@fb.scrrows
     7620 A204 
     7622 A118 
0061 7624 1103  14         jlt   task.vdp.panes.setrows.small
0062 7626 C160  34         mov   @fb.scrrows,tmp1      ; Lines to copy
     7628 A118 
0063 762A 1003  14         jmp   task.vdp.panes.copy.framebuffer
0064                       ;------------------------------------------------------
0065                       ; Less lines in editor buffer as rows in frame buffer
0066                       ;------------------------------------------------------
0067               task.vdp.panes.setrows.small:
0068 762C C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     762E A204 
0069 7630 0585  14         inc   tmp1
0070                       ;------------------------------------------------------
0071                       ; Determine area to copy
0072                       ;------------------------------------------------------
0073               task.vdp.panes.copy.framebuffer:
0074 7632 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7634 A10E 
0075                                                   ; 16 bit part is in tmp2!
0076 7636 04C4  14         clr   tmp0                  ; VDP target address (1nd line on screen!)
0077 7638 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     763A A100 
0078                       ;------------------------------------------------------
0079                       ; Copy memory block
0080                       ;------------------------------------------------------
0081 763C 06A0  32         bl    @xpym2v               ; Copy to VDP
     763E 245C 
0082                                                   ; \ i  tmp0 = VDP target address
0083                                                   ; | i  tmp1 = RAM source address
0084                                                   ; / i  tmp2 = Bytes to copy
0085 7640 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7642 A116 
0086                       ;-------------------------------------------------------
0087                       ; Draw EOF marker at end-of-file
0088                       ;-------------------------------------------------------
0089 7644 C120  34         mov   @edb.lines,tmp0
     7646 A204 
0090 7648 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     764A A104 
0091 764C 0584  14         inc   tmp0                  ; Y = Y + 1
0092 764E 8120  34         c     @fb.scrrows,tmp0      ; Hide if last line on screen
     7650 A118 
0093 7652 121C  14         jle   task.vdp.panes.botline.draw
0094                                                   ; Skip drawing EOF maker
0095                       ;-------------------------------------------------------
0096                       ; Do actual drawing of EOF marker
0097                       ;-------------------------------------------------------
0098               task.vdp.panes.draw_marker:
0099 7654 0A84  56         sla   tmp0,8                ; Move LSB to MSB (Y), X=0
0100 7656 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7658 832A 
0101               
0102 765A 06A0  32         bl    @putstr
     765C 242A 
0103 765E 325C                   data txt.marker       ; Display *EOF*
0104               
0105 7660 06A0  32         bl    @setx
     7662 26B4 
0106 7664 0005                   data  5               ; Cursor after *EOF* string
0107                       ;-------------------------------------------------------
0108                       ; Clear rest of screen
0109                       ;-------------------------------------------------------
0110               task.vdp.panes.clear_screen:
0111 7666 C120  34         mov   @fb.colsline,tmp0     ; tmp0 = Columns per line
     7668 A10E 
0112               
0113 766A C160  34         mov   @wyx,tmp1             ;
     766C 832A 
0114 766E 0985  56         srl   tmp1,8                ; tmp1 = cursor Y position
0115 7670 0505  16         neg   tmp1                  ; tmp1 = -Y position
0116 7672 A160  34         a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows
     7674 A118 
0117               
0118 7676 3944  56         mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
0119 7678 0226  22         ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)
     767A FFFB 
0120               
0121 767C 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     767E 2406 
0122                                                   ; \ i  @wyx = Cursor position
0123                                                   ; / o  tmp0 = VDP address
0124               
0125 7680 04C5  14         clr   tmp1                  ; Character to write (null!)
0126 7682 06A0  32         bl    @xfilv                ; Fill VDP memory
     7684 22A0 
0127                                                   ; \ i  tmp0 = VDP destination
0128                                                   ; | i  tmp1 = byte to write
0129                                                   ; / i  tmp2 = Number of bytes to write
0130               
0131 7686 C820  54         mov   @fb.yxsave,@wyx       ; Restore cursor postion
     7688 A114 
     768A 832A 
0132                       ;-------------------------------------------------------
0133                       ; Draw status line
0134                       ;-------------------------------------------------------
0135               task.vdp.panes.botline.draw:
0136 768C 06A0  32         bl    @pane.botline.draw    ; Draw status bottom line
     768E 7AE6 
0137                       ;------------------------------------------------------
0138                       ; Exit task
0139                       ;------------------------------------------------------
0140               task.vdp.panes.exit:
0141 7690 0460  28         b     @slotok
     7692 2D94 
**** **** ****     > stevie_b1.asm.2287273
0148                       copy  "task.vdp.sat.asm"    ; Task - VDP copy SAT
**** **** ****     > task.vdp.sat.asm
0001               * FILE......: task.vdp.sat.asm
0002               * Purpose...: Stevie Editor - VDP copy SAT
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Copy Sprite Attribute Table (SAT) to VDP
0010               ********|*****|*********************|**************************
0011               task.vdp.copy.sat:
0012 7694 C120  34         mov   @tv.pane.focus,tmp0
     7696 A01A 
0013 7698 130A  14         jeq   !                     ; Frame buffer has focus
0014               
0015 769A 0284  22         ci    tmp0,pane.focus.cmdb
     769C 0001 
0016 769E 1304  14         jeq   task.vdp.copy.sat.cmdb
0017                                                   ; Command buffer has focus
0018                       ;------------------------------------------------------
0019                       ; Assert failed. Invalid value
0020                       ;------------------------------------------------------
0021 76A0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     76A2 FFCE 
0022 76A4 06A0  32         bl    @cpu.crash            ; / Halt system.
     76A6 2030 
0023                       ;------------------------------------------------------
0024                       ; Command buffer has focus, position cursor
0025                       ;------------------------------------------------------
0026               task.vdp.copy.sat.cmdb:
0027 76A8 C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     76AA A30A 
     76AC 832A 
0028                       ;------------------------------------------------------
0029                       ; Position cursor
0030                       ;------------------------------------------------------
0031 76AE E0A0  34 !       soc   @wbit0,config         ; Sprite adjustment on
     76B0 202A 
0032 76B2 06A0  32         bl    @yx2px                ; \ Calculate pixel position
     76B4 26C0 
0033                                                   ; | i  @WYX = Cursor YX
0034                                                   ; / o  tmp0 = Pixel YX
0035 76B6 C804  38         mov   tmp0,@ramsat          ; Set cursor YX
     76B8 2F54 
0036               
0037 76BA 06A0  32         bl    @cpym2v               ; Copy sprite SAT to VDP
     76BC 2456 
0038 76BE 2180                   data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
     76C0 2F54 
     76C2 0004 
0039                                                   ; | i  tmp1 = ROM/RAM source
0040                                                   ; / i  tmp2 = Number of bytes to write
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044               task.vdp.copy.sat.exit:
0045 76C4 0460  28         b     @slotok               ; Exit task
     76C6 2D94 
**** **** ****     > stevie_b1.asm.2287273
0149                       copy  "task.vdp.cursor.asm" ; Task - VDP set cursor shape
**** **** ****     > task.vdp.cursor.asm
0001               * FILE......: task.vdp.cursor.asm
0002               * Purpose...: Stevie Editor - VDP sprite cursor
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *        Stevie Editor - Tasks implementation
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * Task - Update cursor shape (blink)
0010               ***************************************************************
0011               task.vdp.cursor:
0012 76C8 0560  34         inv   @fb.curtoggle          ; Flip cursor shape flag
     76CA A112 
0013 76CC 1303  14         jeq   task.vdp.cursor.visible
0014 76CE 04E0  34         clr   @ramsat+2              ; Hide cursor
     76D0 2F56 
0015 76D2 1015  14         jmp   task.vdp.cursor.copy.sat
0016                                                    ; Update VDP SAT and exit task
0017               task.vdp.cursor.visible:
0018 76D4 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     76D6 A20A 
0019 76D8 130B  14         jeq   task.vdp.cursor.visible.overwrite_mode
0020                       ;------------------------------------------------------
0021                       ; Cursor in insert mode
0022                       ;------------------------------------------------------
0023               task.vdp.cursor.visible.insert_mode:
0024 76DA C120  34         mov   @tv.pane.focus,tmp0    ; Get pane with focus
     76DC A01A 
0025 76DE 1303  14         jeq   task.vdp.cursor.visible.insert_mode.fb
0026                                                    ; Framebuffer has focus
0027 76E0 0284  22         ci    tmp0,pane.focus.cmdb
     76E2 0001 
0028 76E4 1302  14         jeq   task.vdp.cursor.visible.insert_mode.cmdb
0029                       ;------------------------------------------------------
0030                       ; Editor cursor (insert mode)
0031                       ;------------------------------------------------------
0032               task.vdp.cursor.visible.insert_mode.fb:
0033 76E6 04C4  14         clr   tmp0                   ; Cursor FB insert mode
0034 76E8 1005  14         jmp   task.vdp.cursor.visible.cursorshape
0035                       ;------------------------------------------------------
0036                       ; Command buffer cursor (insert mode)
0037                       ;------------------------------------------------------
0038               task.vdp.cursor.visible.insert_mode.cmdb:
0039 76EA 0204  20         li    tmp0,>0100             ; Cursor CMDB insert mode
     76EC 0100 
0040 76EE 1002  14         jmp   task.vdp.cursor.visible.cursorshape
0041                       ;------------------------------------------------------
0042                       ; Cursor in overwrite mode
0043                       ;------------------------------------------------------
0044               task.vdp.cursor.visible.overwrite_mode:
0045 76F0 0204  20         li    tmp0,>0200             ; Cursor overwrite mode
     76F2 0200 
0046                       ;------------------------------------------------------
0047                       ; Set cursor shape
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.visible.cursorshape:
0050 76F4 D804  38         movb  tmp0,@tv.curshape      ; Save cursor shape
     76F6 A014 
0051 76F8 C820  54         mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
     76FA A014 
     76FC 2F56 
0052                       ;------------------------------------------------------
0053                       ; Copy SAT
0054                       ;------------------------------------------------------
0055               task.vdp.cursor.copy.sat:
0056 76FE 06A0  32         bl    @cpym2v                ; Copy sprite SAT to VDP
     7700 2456 
0057 7702 2180                   data sprsat,ramsat,4   ; \ i  p0 = VDP destination
     7704 2F54 
     7706 0004 
0058                                                    ; | i  p1 = ROM/RAM source
0059                                                    ; / i  p2 = Number of bytes to write
0060                       ;-------------------------------------------------------
0061                       ; Show status bottom line
0062                       ;-------------------------------------------------------
0063 7708 C120  34         mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
     770A A302 
0064 770C 1602  14         jne   task.vdp.cursor.exit   ; Exit, if visible
0065 770E 06A0  32         bl    @pane.botline.draw     ; Draw status bottom line
     7710 7AE6 
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               task.vdp.cursor.exit:
0070 7712 0460  28         b     @slotok                ; Exit task
     7714 2D94 
**** **** ****     > stevie_b1.asm.2287273
0150                       copy  "task.oneshot.asm"    ; Task - One shot
**** **** ****     > task.oneshot.asm
0001               task.oneshot:
0002 7716 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7718 A01C 
0003 771A 1301  14         jeq   task.oneshot.exit
0004               
0005 771C 0694  24         bl    *tmp0                  ; Execute one-shot task
0006                       ;------------------------------------------------------
0007                       ; Exit
0008                       ;------------------------------------------------------
0009               task.oneshot.exit:
0010 771E 0460  28         b     @slotok                ; Exit task
     7720 2D94 
**** **** ****     > stevie_b1.asm.2287273
0151                       ;-----------------------------------------------------------------------
0152                       ; Screen pane utilities
0153                       ;-----------------------------------------------------------------------
0154                       copy  "pane.utils.asm"      ; Pane utility functions
**** **** ****     > pane.utils.asm
0001               * FILE......: pane.utils.asm
0002               * Purpose...: Some utility functions. Shared code for all panes
0003               
0004               
0005               *//////////////////////////////////////////////////////////////
0006               *              Stevie Editor - Pane utility functions
0007               *//////////////////////////////////////////////////////////////
0008               
0009               ***************************************************************
0010               * pane.show_hintx
0011               * Show hint message
0012               ***************************************************************
0013               * bl  @pane.show_hintx
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1 = Cursor YX position
0017               * @parm2 = Pointer to Length-prefixed string
0018               *--------------------------------------------------------------
0019               * OUTPUT test
0020               * none
0021               *--------------------------------------------------------------
0022               * Register usage
0023               * tmp0, tmp1, tmp2
0024               ********|*****|*********************|**************************
0025               pane.show_hintx:
0026 7722 0649  14         dect  stack
0027 7724 C64B  30         mov   r11,*stack            ; Save return address
0028 7726 0649  14         dect  stack
0029 7728 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 772A 0649  14         dect  stack
0031 772C C645  30         mov   tmp1,*stack           ; Push tmp1
0032 772E 0649  14         dect  stack
0033 7730 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 7732 0649  14         dect  stack
0035 7734 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;-------------------------------------------------------
0037                       ; Display string
0038                       ;-------------------------------------------------------
0039 7736 C820  54         mov   @parm1,@wyx           ; Set cursor
     7738 2F20 
     773A 832A 
0040 773C C160  34         mov   @parm2,tmp1           ; Get string to display
     773E 2F22 
0041 7740 06A0  32         bl    @xutst0               ; Display string
     7742 242C 
0042                       ;-------------------------------------------------------
0043                       ; Get number of bytes to fill ...
0044                       ;-------------------------------------------------------
0045 7744 C120  34         mov   @parm2,tmp0
     7746 2F22 
0046 7748 D114  26         movb  *tmp0,tmp0            ; Get length byte of hint
0047 774A 0984  56         srl   tmp0,8                ; Right justify
0048 774C C184  18         mov   tmp0,tmp2
0049 774E C1C4  18         mov   tmp0,tmp3             ; Work copy
0050 7750 0506  16         neg   tmp2
0051 7752 0226  22         ai    tmp2,80               ; Number of bytes to fill
     7754 0050 
0052                       ;-------------------------------------------------------
0053                       ; ... and clear until end of line
0054                       ;-------------------------------------------------------
0055 7756 C120  34         mov   @parm1,tmp0           ; \ Restore YX position
     7758 2F20 
0056 775A A107  18         a     tmp3,tmp0             ; | Adjust X position to end of string
0057 775C C804  38         mov   tmp0,@wyx             ; / Set cursor
     775E 832A 
0058               
0059 7760 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7762 2406 
0060                                                   ; \ i  @wyx = Cursor position
0061                                                   ; / o  tmp0 = VDP target address
0062               
0063 7764 0205  20         li    tmp1,32               ; Byte to fill
     7766 0020 
0064               
0065 7768 06A0  32         bl    @xfilv                ; Clear line
     776A 22A0 
0066                                                   ; i \  tmp0 = start address
0067                                                   ; i |  tmp1 = byte to fill
0068                                                   ; i /  tmp2 = number of bytes to fill
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               pane.show_hintx.exit:
0073 776C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0074 776E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0075 7770 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0076 7772 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0077 7774 C2F9  30         mov   *stack+,r11           ; Pop R11
0078 7776 045B  20         b     *r11                  ; Return to caller
0079               
0080               
0081               
0082               ***************************************************************
0083               * pane.show_hint
0084               * Show hint message (data parameter version)
0085               ***************************************************************
0086               * bl  @pane.show_hint
0087               *     data p1,p2
0088               *--------------------------------------------------------------
0089               * INPUT
0090               * p1 = Cursor YX position
0091               * p2 = Pointer to Length-prefixed string
0092               *--------------------------------------------------------------
0093               * OUTPUT
0094               * none
0095               *--------------------------------------------------------------
0096               * Register usage
0097               * none
0098               ********|*****|*********************|**************************
0099               pane.show_hint:
0100 7778 C83B  50         mov   *r11+,@parm1          ; Get parameter 1
     777A 2F20 
0101 777C C83B  50         mov   *r11+,@parm2          ; Get parameter 2
     777E 2F22 
0102 7780 0649  14         dect  stack
0103 7782 C64B  30         mov   r11,*stack            ; Save return address
0104                       ;-------------------------------------------------------
0105                       ; Display pane hint
0106                       ;-------------------------------------------------------
0107 7784 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     7786 7722 
0108                       ;-------------------------------------------------------
0109                       ; Exit
0110                       ;-------------------------------------------------------
0111               pane.show_hint.exit:
0112 7788 C2F9  30         mov   *stack+,r11           ; Pop R11
0113 778A 045B  20         b     *r11                  ; Return to caller
0114               
0115               
0116               
0117               ***************************************************************
0118               * pane.cursor.hide
0119               * Hide cursor
0120               ***************************************************************
0121               * bl  @pane.cursor.hide
0122               *--------------------------------------------------------------
0123               * INPUT
0124               * none
0125               *--------------------------------------------------------------
0126               * OUTPUT
0127               * none
0128               *--------------------------------------------------------------
0129               * Register usage
0130               * none
0131               ********|*****|*********************|**************************
0132               pane.cursor.hide:
0133 778C 0649  14         dect  stack
0134 778E C64B  30         mov   r11,*stack            ; Save return address
0135                       ;-------------------------------------------------------
0136                       ; Hide cursor
0137                       ;-------------------------------------------------------
0138 7790 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     7792 229A 
0139 7794 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7796 0000 
     7798 0004 
0140                                                   ; | i  p1 = Byte to write
0141                                                   ; / i  p2 = Number of bytes to write
0142               
0143 779A 06A0  32         bl    @clslot
     779C 2DF0 
0144 779E 0001                   data 1                ; Terminate task.vdp.copy.sat
0145               
0146 77A0 06A0  32         bl    @clslot
     77A2 2DF0 
0147 77A4 0002                   data 2                ; Terminate task.vdp.copy.sat
0148               
0149                       ;-------------------------------------------------------
0150                       ; Exit
0151                       ;-------------------------------------------------------
0152               pane.cursor.hide.exit:
0153 77A6 C2F9  30         mov   *stack+,r11           ; Pop R11
0154 77A8 045B  20         b     *r11                  ; Return to caller
0155               
0156               
0157               
0158               ***************************************************************
0159               * pane.cursor.blink
0160               * Blink cursor
0161               ***************************************************************
0162               * bl  @pane.cursor.blink
0163               *--------------------------------------------------------------
0164               * INPUT
0165               * none
0166               *--------------------------------------------------------------
0167               * OUTPUT
0168               * none
0169               *--------------------------------------------------------------
0170               * Register usage
0171               * none
0172               ********|*****|*********************|**************************
0173               pane.cursor.blink:
0174 77AA 0649  14         dect  stack
0175 77AC C64B  30         mov   r11,*stack            ; Save return address
0176                       ;-------------------------------------------------------
0177                       ; Hide cursor
0178                       ;-------------------------------------------------------
0179 77AE 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     77B0 229A 
0180 77B2 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     77B4 0000 
     77B6 0004 
0181                                                   ; | i  p1 = Byte to write
0182                                                   ; / i  p2 = Number of bytes to write
0183               
0184 77B8 06A0  32         bl    @mkslot
     77BA 2DD2 
0185 77BC 0102                   data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
     77BE 7694 
0186 77C0 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     77C2 76C8 
0187 77C4 FFFF                   data eol
0188                       ;-------------------------------------------------------
0189                       ; Exit
0190                       ;-------------------------------------------------------
0191               pane.cursor.blink.exit:
0192 77C6 C2F9  30         mov   *stack+,r11           ; Pop R11
0193 77C8 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0155                       copy  "pane.utils.colorscheme.asm"
**** **** ****     > pane.utils.colorscheme.asm
0001               * FILE......: pane.utils.colorscheme.asm
0002               * Purpose...: Stevie Editor - Color scheme for panes
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Colorscheme for panes
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.action.color.cycle
0010               * Cycle through available color scheme
0011               ***************************************************************
0012               * bl  @pane.action.colorscheme.cycle
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.action.colorscheme.cycle:
0021 77CA 0649  14         dect  stack
0022 77CC C64B  30         mov   r11,*stack            ; Push return address
0023 77CE 0649  14         dect  stack
0024 77D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 77D2 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     77D4 A012 
0027 77D6 0284  22         ci    tmp0,tv.colorscheme.entries - 1
     77D8 0008 
0028                                                   ; Last entry reached?
0029 77DA 1102  14         jlt   !
0030 77DC 04C4  14         clr   tmp0
0031 77DE 1001  14         jmp   pane.action.colorscheme.switch
0032 77E0 0584  14 !       inc   tmp0
0033                       ;-------------------------------------------------------
0034                       ; switch to new color scheme
0035                       ;-------------------------------------------------------
0036               pane.action.colorscheme.switch:
0037 77E2 C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     77E4 A012 
0038 77E6 06A0  32         bl    @pane.action.colorscheme.load
     77E8 7852 
0039                       ;-------------------------------------------------------
0040                       ; Show current color scheme message
0041                       ;-------------------------------------------------------
0042 77EA C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     77EC 832A 
     77EE 833C 
0043               
0044 77F0 06A0  32         bl    @filv
     77F2 229A 
0045 77F4 1840                   data >1840,>1F,16     ; VDP start address (frame buffer area)
     77F6 001F 
     77F8 0010 
0046               
0047 77FA 06A0  32         bl    @putnum
     77FC 2A22 
0048 77FE 004B                   byte 0,75
0049 7800 A012                   data tv.colorscheme,rambuf,>3020
     7802 2F64 
     7804 3020 
0050               
0051 7806 06A0  32         bl    @putat
     7808 244E 
0052 780A 0040                   byte 0,64
0053 780C 358E                   data txt.colorscheme  ; Show color scheme message
0054               
0055               
0056 780E C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     7810 833C 
     7812 832A 
0057                       ;-------------------------------------------------------
0058                       ; Delay
0059                       ;-------------------------------------------------------
0060 7814 0204  20         li    tmp0,12000
     7816 2EE0 
0061 7818 0604  14 !       dec   tmp0
0062 781A 16FE  14         jne   -!
0063                       ;-------------------------------------------------------
0064                       ; Setup one shot task for removing message
0065                       ;-------------------------------------------------------
0066 781C 0204  20         li    tmp0,pane.action.colorscheme.task.callback
     781E 7830 
0067 7820 C804  38         mov   tmp0,@tv.task.oneshot
     7822 A01C 
0068               
0069 7824 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     7826 2DFE 
0070 7828 0003                   data 3                ; / for getting consistent delay
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074               pane.action.colorscheme.cycle.exit:
0075 782A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 782C C2F9  30         mov   *stack+,r11           ; Pop R11
0077 782E 045B  20         b     *r11                  ; Return to caller
0078                       ;-------------------------------------------------------
0079                       ; Remove colorscheme message (triggered by oneshot task)
0080                       ;-------------------------------------------------------
0081               pane.action.colorscheme.task.callback:
0082 7830 0649  14         dect  stack
0083 7832 C64B  30         mov   r11,*stack            ; Push return address
0084               
0085 7834 06A0  32         bl    @filv
     7836 229A 
0086 7838 003C                   data >003C,>00,20     ; Remove message
     783A 0000 
     783C 0014 
0087               
0088 783E 0720  34         seto  @parm1
     7840 2F20 
0089 7842 06A0  32         bl    @pane.action.colorscheme.load
     7844 7852 
0090                                                   ; Reload current colorscheme
0091                                                   ; \ i  parm1 = Do not turn screen off
0092                                                   ; /
0093               
0094 7846 0720  34         seto  @fb.dirty             ; Trigger frame buffer refresh
     7848 A116 
0095 784A 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     784C A01C 
0096               
0097 784E C2F9  30         mov   *stack+,r11           ; Pop R11
0098 7850 045B  20         b     *r11                  ; Return to task
0099               
0100               
0101               
0102               ***************************************************************
0103               * pane.action.colorscheme.load
0104               * Load color scheme
0105               ***************************************************************
0106               * bl  @pane.action.colorscheme.load
0107               *--------------------------------------------------------------
0108               * INPUT
0109               * @tv.colorscheme = Index into color scheme table
0110               * @parm1          = Skip screen off if >FFFF
0111               *--------------------------------------------------------------
0112               * OUTPUT
0113               * none
0114               *--------------------------------------------------------------
0115               * Register usage
0116               * tmp0,tmp1,tmp2,tmp3,tmp4
0117               ********|*****|*********************|**************************
0118               pane.action.colorscheme.load:
0119 7852 0649  14         dect  stack
0120 7854 C64B  30         mov   r11,*stack            ; Save return address
0121 7856 0649  14         dect  stack
0122 7858 C644  30         mov   tmp0,*stack           ; Push tmp0
0123 785A 0649  14         dect  stack
0124 785C C645  30         mov   tmp1,*stack           ; Push tmp1
0125 785E 0649  14         dect  stack
0126 7860 C646  30         mov   tmp2,*stack           ; Push tmp2
0127 7862 0649  14         dect  stack
0128 7864 C647  30         mov   tmp3,*stack           ; Push tmp3
0129 7866 0649  14         dect  stack
0130 7868 C648  30         mov   tmp4,*stack           ; Push tmp4
0131                       ;-------------------------------------------------------
0132                       ; Turn screen of
0133                       ;-------------------------------------------------------
0134 786A C120  34         mov   @parm1,tmp0
     786C 2F20 
0135 786E 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     7870 FFFF 
0136 7872 1302  14         jeq   !                     ; Yes, so skip screen off
0137 7874 06A0  32         bl    @scroff               ; Turn screen off
     7876 265E 
0138                       ;-------------------------------------------------------
0139                       ; Get framebuffer foreground/background color
0140                       ;-------------------------------------------------------
0141 7878 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     787A A012 
0142 787C 0A24  56         sla   tmp0,2                ; Offset into color scheme data table
0143 787E 0224  22         ai    tmp0,tv.colorscheme.table
     7880 30BE 
0144                                                   ; Add base for color scheme data table
0145 7882 C1F4  30         mov   *tmp0+,tmp3           ; Get colors  (fb + status line)
0146 7884 C807  38         mov   tmp3,@tv.color        ; Save colors
     7886 A018 
0147                       ;-------------------------------------------------------
0148                       ; Get and save cursor color
0149                       ;-------------------------------------------------------
0150 7888 C214  26         mov   *tmp0,tmp4            ; Get cursor color
0151 788A 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     788C 00FF 
0152 788E C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7890 A016 
0153                       ;-------------------------------------------------------
0154                       ; Get CMDB pane foreground/background color
0155                       ;-------------------------------------------------------
0156 7892 C214  26         mov   *tmp0,tmp4            ; Get CMDB pane
0157 7894 0248  22         andi  tmp4,>ff00            ; Only keep MSB
     7896 FF00 
0158 7898 0988  56         srl   tmp4,8                ; MSB to LSB
0159                       ;-------------------------------------------------------
0160                       ; Dump colors to VDP register 7 (text mode)
0161                       ;-------------------------------------------------------
0162 789A C147  18         mov   tmp3,tmp1             ; Get work copy
0163 789C 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0164 789E 0265  22         ori   tmp1,>0700
     78A0 0700 
0165 78A2 C105  18         mov   tmp1,tmp0
0166 78A4 06A0  32         bl    @putvrx               ; Write VDP register
     78A6 2340 
0167                       ;-------------------------------------------------------
0168                       ; Dump colors for frame buffer pane (TAT)
0169                       ;-------------------------------------------------------
0170 78A8 0204  20         li    tmp0,>1800            ; VDP start address (frame buffer area)
     78AA 1800 
0171 78AC C147  18         mov   tmp3,tmp1             ; Get work copy of colors
0172 78AE 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0173 78B0 0206  20         li    tmp2,29*80            ; Number of bytes to fill
     78B2 0910 
0174 78B4 06A0  32         bl    @xfilv                ; Fill colors
     78B6 22A0 
0175                                                   ; i \  tmp0 = start address
0176                                                   ; i |  tmp1 = byte to fill
0177                                                   ; i /  tmp2 = number of bytes to fill
0178                       ;-------------------------------------------------------
0179                       ; Dump colors for CMDB pane (TAT)
0180                       ;-------------------------------------------------------
0181               pane.action.colorscheme.cmdbpane:
0182 78B8 C120  34         mov   @cmdb.visible,tmp0
     78BA A302 
0183 78BC 1307  14         jeq   pane.action.colorscheme.errpane
0184                                                   ; Skip if CMDB pane is hidden
0185               
0186 78BE 0204  20         li    tmp0,>1fd0            ; VDP start address (bottom status line)
     78C0 1FD0 
0187 78C2 C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0188 78C4 0206  20         li    tmp2,5*80             ; Number of bytes to fill
     78C6 0190 
0189 78C8 06A0  32         bl    @xfilv                ; Fill colors
     78CA 22A0 
0190                                                   ; i \  tmp0 = start address
0191                                                   ; i |  tmp1 = byte to fill
0192                                                   ; i /  tmp2 = number of bytes to fill
0193                       ;-------------------------------------------------------
0194                       ; Dump colors for error line pane (TAT)
0195                       ;-------------------------------------------------------
0196               pane.action.colorscheme.errpane:
0197 78CC C120  34         mov   @tv.error.visible,tmp0
     78CE A01E 
0198 78D0 1304  14         jeq   pane.action.colorscheme.statusline
0199                                                   ; Skip if error line pane is hidden
0200               
0201 78D2 0205  20         li    tmp1,>00f6            ; White on dark red
     78D4 00F6 
0202 78D6 06A0  32         bl    @pane.action.colorscheme.errline
     78D8 790C 
0203                                                   ; Load color combination for error line
0204                       ;-------------------------------------------------------
0205                       ; Dump colors for bottom status line pane (TAT)
0206                       ;-------------------------------------------------------
0207               pane.action.colorscheme.statusline:
0208 78DA 0204  20         li    tmp0,>2110            ; VDP start address (bottom status line)
     78DC 2110 
0209 78DE C147  18         mov   tmp3,tmp1             ; Get work copy fg/bg color
0210 78E0 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     78E2 00FF 
0211 78E4 0206  20         li    tmp2,80               ; Number of bytes to fill
     78E6 0050 
0212 78E8 06A0  32         bl    @xfilv                ; Fill colors
     78EA 22A0 
0213                                                   ; i \  tmp0 = start address
0214                                                   ; i |  tmp1 = byte to fill
0215                                                   ; i /  tmp2 = number of bytes to fill
0216                       ;-------------------------------------------------------
0217                       ; Dump cursor FG color to sprite table (SAT)
0218                       ;-------------------------------------------------------
0219               pane.action.colorscheme.cursorcolor:
0220 78EC C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     78EE A016 
0221 78F0 0A88  56         sla   tmp4,8                ; Move to MSB
0222 78F2 D808  38         movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     78F4 2F57 
0223 78F6 D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     78F8 A015 
0224                       ;-------------------------------------------------------
0225                       ; Exit
0226                       ;-------------------------------------------------------
0227               pane.action.colorscheme.load.exit:
0228 78FA 06A0  32         bl    @scron                ; Turn screen on
     78FC 2666 
0229 78FE C239  30         mov   *stack+,tmp4          ; Pop tmp4
0230 7900 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0231 7902 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0232 7904 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0233 7906 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0234 7908 C2F9  30         mov   *stack+,r11           ; Pop R11
0235 790A 045B  20         b     *r11                  ; Return to caller
0236               
0237               
0238               
0239               ***************************************************************
0240               * pane.action.colorscheme.errline
0241               * Load color scheme for error line
0242               ***************************************************************
0243               * bl  @pane.action.colorscheme.errline
0244               *--------------------------------------------------------------
0245               * INPUT
0246               * @parm1 = Foreground / Background color
0247               *--------------------------------------------------------------
0248               * OUTPUT
0249               * none
0250               *--------------------------------------------------------------
0251               * Register usage
0252               * tmp0,tmp1,tmp2
0253               ********|*****|*********************|**************************
0254               pane.action.colorscheme.errline:
0255 790C 0649  14         dect  stack
0256 790E C64B  30         mov   r11,*stack            ; Save return address
0257 7910 0649  14         dect  stack
0258 7912 C644  30         mov   tmp0,*stack           ; Push tmp0
0259 7914 0649  14         dect  stack
0260 7916 C645  30         mov   tmp1,*stack           ; Push tmp1
0261 7918 0649  14         dect  stack
0262 791A C646  30         mov   tmp2,*stack           ; Push tmp2
0263                       ;-------------------------------------------------------
0264                       ; Load error line colors
0265                       ;-------------------------------------------------------
0266 791C C160  34         mov   @parm1,tmp1           ; Get FG/BG color
     791E 2F20 
0267               
0268 7920 0204  20         li    tmp0,>20C0            ; VDP start address (error line)
     7922 20C0 
0269 7924 0206  20         li    tmp2,80               ; Number of bytes to fill
     7926 0050 
0270 7928 06A0  32         bl    @xfilv                ; Fill colors
     792A 22A0 
0271                                                   ; i \  tmp0 = start address
0272                                                   ; i |  tmp1 = byte to fill
0273                                                   ; i /  tmp2 = number of bytes to fill
0274                       ;-------------------------------------------------------
0275                       ; Exit
0276                       ;-------------------------------------------------------
0277               pane.action.colorscheme.errline.exit:
0278 792C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0279 792E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0280 7930 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0281 7932 C2F9  30         mov   *stack+,r11           ; Pop R11
0282 7934 045B  20         b     *r11                  ; Return to caller
0283               
**** **** ****     > stevie_b1.asm.2287273
0156                                                   ; Colorscheme handling in panes
0157                       ;-----------------------------------------------------------------------
0158                       ; Screen panes
0159                       ;-----------------------------------------------------------------------
0160                       copy  "pane.cmdb.asm"       ; Command buffer
**** **** ****     > pane.cmdb.asm
0001               * FILE......: pane.cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer pane
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Command Buffer pane
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.cmdb.draw
0010               * Draw Stevie Command Buffer in pane
0011               ***************************************************************
0012               * bl  @pane.cmdb.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2
0019               ********|*****|*********************|**************************
0020               pane.cmdb.draw:
0021 7936 0649  14         dect  stack
0022 7938 C64B  30         mov   r11,*stack            ; Save return address
0023 793A 0649  14         dect  stack
0024 793C C644  30         mov   tmp0,*stack           ; Push tmp0
0025 793E 0649  14         dect  stack
0026 7940 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 7942 0649  14         dect  stack
0028 7944 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Command buffer header line
0031                       ;------------------------------------------------------
0032 7946 06A0  32         bl    @hchar
     7948 2792 
0033 794A 190F                   byte pane.botrow-4,15,1,65
     794C 0141 
0034 794E FFFF                   data eol
0035               
0036 7950 C820  54         mov   @cmdb.yxtop,@wyx      ; \
     7952 A30E 
     7954 832A 
0037 7956 C160  34         mov   @cmdb.panhead,tmp1    ; | Display pane header
     7958 A31C 
0038 795A 06A0  32         bl    @xutst0               ; /
     795C 242C 
0039               
0040                       ;------------------------------------------------------
0041                       ; Check dialog id
0042                       ;------------------------------------------------------
0043 795E 04E0  34         clr   @waux1                ; Default is show prompt
     7960 833C 
0044               
0045 7962 C120  34         mov   @cmdb.dialog,tmp0
     7964 A31A 
0046 7966 0284  22         ci    tmp0,100              ; \ Hide prompt and no keyboard
     7968 0064 
0047 796A 120C  14         jle   pane.cmdb.draw.clear  ; | buffer input if dialog ID > 100
0048 796C 0720  34         seto  @waux1                ; /
     796E 833C 
0049                       ;------------------------------------------------------
0050                       ; Show warning message if in "Unsaved changes" dialog
0051                       ;------------------------------------------------------
0052 7970 0284  22         ci    tmp0,id.dialog.unsaved
     7972 0065 
0053 7974 1607  14         jne   pane.cmdb.draw.clear  ; Display normal prompt
0054               
0055 7976 06A0  32         bl    @putat                ; \ Show warning message
     7978 244E 
0056 797A 1A00                   byte pane.botrow-3,0  ; |
0057 797C 3482                   data txt.warn.unsaved ; /
0058               
0059 797E C820  54         mov   @txt.warn.unsaved,@cmdb.cmdlen
     7980 3482 
     7982 A324 
0060                       ;------------------------------------------------------
0061                       ; Clear lines after prompt in command buffer
0062                       ;------------------------------------------------------
0063               pane.cmdb.draw.clear:
0064 7984 C120  34         mov   @cmdb.cmdlen,tmp0     ; \
     7986 A324 
0065 7988 0984  56         srl   tmp0,8                ; | Set cursor after command prompt
0066 798A A120  34         a     @cmdb.yxprompt,tmp0   ; |
     798C A310 
0067 798E C804  38         mov   tmp0,@wyx             ; /
     7990 832A 
0068               
0069 7992 06A0  32         bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
     7994 2406 
0070                                                   ; \ i  @wyx = Cursor position
0071                                                   ; / o  tmp0 = VDP target address
0072               
0073 7996 0205  20         li    tmp1,32
     7998 0020 
0074               
0075 799A C1A0  34         mov   @cmdb.cmdlen,tmp2     ; \
     799C A324 
0076 799E 0986  56         srl   tmp2,8                ; | Determine number of bytes to fill.
0077 79A0 0506  16         neg   tmp2                  ; | Based on command & prompt length
0078 79A2 0226  22         ai    tmp2,2*80 - 1         ; /
     79A4 009F 
0079               
0080 79A6 06A0  32         bl    @xfilv                ; \ Copy CPU memory to VDP memory
     79A8 22A0 
0081                                                   ; | i  tmp0 = VDP target address
0082                                                   ; | i  tmp1 = Byte to fill
0083                                                   ; / i  tmp2 = Number of bytes to fill
0084                       ;------------------------------------------------------
0085                       ; Display pane hint in command buffer
0086                       ;------------------------------------------------------
0087               pane.cmdb.draw.hint:
0088 79AA 0204  20         li    tmp0,pane.botrow - 1  ; \
     79AC 001C 
0089 79AE 0A84  56         sla   tmp0,8                ; / Y=bottom row - 1, X=0
0090 79B0 C804  38         mov   tmp0,@parm1           ; Set parameter
     79B2 2F20 
0091 79B4 C820  54         mov   @cmdb.panhint,@parm2  ; Pane hint to display
     79B6 A31E 
     79B8 2F22 
0092               
0093 79BA 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     79BC 7722 
0094                                                   ; \ i  parm1 = Pointer to string with hint
0095                                                   ; / i  parm2 = YX position
0096                       ;------------------------------------------------------
0097                       ; Display keys in status line
0098                       ;------------------------------------------------------
0099 79BE 0204  20         li    tmp0,pane.botrow      ; \
     79C0 001D 
0100 79C2 0A84  56         sla   tmp0,8                ; / Y=bottom row, X=0
0101 79C4 C804  38         mov   tmp0,@parm1           ; Set parameter
     79C6 2F20 
0102 79C8 C820  54         mov   @cmdb.pankeys,@parm2  ; Pane hint to display
     79CA A320 
     79CC 2F22 
0103               
0104 79CE 06A0  32         bl    @pane.show_hintx      ; Display pane hint
     79D0 7722 
0105                                                   ; \ i  parm1 = Pointer to string with hint
0106                                                   ; / i  parm2 = YX position
0107                       ;------------------------------------------------------
0108                       ; ALPHA-Lock key down?
0109                       ;------------------------------------------------------
0110 79D2 20A0  38         coc   @wbit10,config
     79D4 2016 
0111 79D6 1305  14         jeq   pane.cmdb.draw.alpha.down
0112                       ;------------------------------------------------------
0113                       ; AlPHA-Lock is up
0114                       ;------------------------------------------------------
0115 79D8 06A0  32         bl    @putat
     79DA 244E 
0116 79DC 1D4F                   byte   pane.botrow,79
0117 79DE 32B8                   data   txt.alpha.up
0118               
0119 79E0 1004  14         jmp   pane.cmdb.draw.promptcmd
0120                       ;------------------------------------------------------
0121                       ; AlPHA-Lock is down
0122                       ;------------------------------------------------------
0123               pane.cmdb.draw.alpha.down:
0124 79E2 06A0  32         bl    @putat
     79E4 244E 
0125 79E6 1D4F                   byte   pane.botrow,79
0126 79E8 32BA                   data   txt.alpha.down
0127                       ;------------------------------------------------------
0128                       ; Command buffer content
0129                       ;------------------------------------------------------
0130               pane.cmdb.draw.promptcmd:
0131 79EA C120  34         mov   @waux1,tmp0           ; Flag set?
     79EC 833C 
0132 79EE 1602  14         jne   pane.cmdb.draw.exit   ; Yes, so exit early
0133 79F0 06A0  32         bl    @cmdb.refresh         ; Refresh command buffer content
     79F2 6E8E 
0134                       ;------------------------------------------------------
0135                       ; Exit
0136                       ;------------------------------------------------------
0137               pane.cmdb.draw.exit:
0138 79F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0139 79F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0140 79F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0141 79FA C2F9  30         mov   *stack+,r11           ; Pop r11
0142 79FC 045B  20         b     *r11                  ; Return
0143               
0144               
0145               ***************************************************************
0146               * pane.cmdb.show
0147               * Show command buffer pane
0148               ***************************************************************
0149               * bl @pane.cmdb.show
0150               *--------------------------------------------------------------
0151               * INPUT
0152               * none
0153               *--------------------------------------------------------------
0154               * OUTPUT
0155               * none
0156               *--------------------------------------------------------------
0157               * Register usage
0158               * none
0159               *--------------------------------------------------------------
0160               * Notes
0161               ********|*****|*********************|**************************
0162               pane.cmdb.show:
0163 79FE 0649  14         dect  stack
0164 7A00 C64B  30         mov   r11,*stack            ; Save return address
0165 7A02 0649  14         dect  stack
0166 7A04 C644  30         mov   tmp0,*stack           ; Push tmp0
0167                       ;------------------------------------------------------
0168                       ; Show command buffer pane
0169                       ;------------------------------------------------------
0170 7A06 C820  54         mov   @wyx,@cmdb.fb.yxsave
     7A08 832A 
     7A0A A304 
0171                                                   ; Save YX position in frame buffer
0172               
0173 7A0C C120  34         mov   @fb.scrrows.max,tmp0
     7A0E A11A 
0174 7A10 6120  34         s     @cmdb.scrrows,tmp0
     7A12 A306 
0175 7A14 C804  38         mov   tmp0,@fb.scrrows      ; Resize framebuffer
     7A16 A118 
0176               
0177 7A18 0A84  56         sla   tmp0,8                ; LSB to MSB (Y), X=0
0178 7A1A C804  38         mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line
     7A1C A30E 
0179               
0180 7A1E 0224  22         ai    tmp0,>0100
     7A20 0100 
0181 7A22 C804  38         mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
     7A24 A310 
0182 7A26 0584  14         inc   tmp0
0183 7A28 C804  38         mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane
     7A2A A30A 
0184               
0185 7A2C 0720  34         seto  @cmdb.visible         ; Show pane
     7A2E A302 
0186 7A30 0720  34         seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
     7A32 A318 
0187               
0188 7A34 0204  20         li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
     7A36 0001 
0189 7A38 C804  38         mov   tmp0,@tv.pane.focus   ; /
     7A3A A01A 
0190               
0191 7A3C 06A0  32         bl    @pane.errline.hide    ; Hide error pane
     7A3E 7AC6 
0192               
0193 7A40 0720  34         seto  @parm1                ; Do not turn screen off while
     7A42 2F20 
0194                                                   ; reloading color scheme
0195               
0196 7A44 06A0  32         bl    @pane.action.colorscheme.load
     7A46 7852 
0197                                                   ; Reload color scheme
0198                                                   ; i  parm1 = Skip screen off if >FFFF
0199               
0200               pane.cmdb.show.exit:
0201                       ;------------------------------------------------------
0202                       ; Exit
0203                       ;------------------------------------------------------
0204 7A48 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0205 7A4A C2F9  30         mov   *stack+,r11           ; Pop r11
0206 7A4C 045B  20         b     *r11                  ; Return to caller
0207               
0208               
0209               
0210               ***************************************************************
0211               * pane.cmdb.hide
0212               * Hide command buffer pane
0213               ***************************************************************
0214               * bl @pane.cmdb.hide
0215               *--------------------------------------------------------------
0216               * INPUT
0217               * none
0218               *--------------------------------------------------------------
0219               * OUTPUT
0220               * none
0221               *--------------------------------------------------------------
0222               * Register usage
0223               * none
0224               *--------------------------------------------------------------
0225               * Hiding the command buffer automatically passes pane focus
0226               * to frame buffer.
0227               ********|*****|*********************|**************************
0228               pane.cmdb.hide:
0229 7A4E 0649  14         dect  stack
0230 7A50 C64B  30         mov   r11,*stack            ; Save return address
0231                       ;------------------------------------------------------
0232                       ; Hide command buffer pane
0233                       ;------------------------------------------------------
0234 7A52 C820  54         mov   @fb.scrrows.max,@fb.scrrows
     7A54 A11A 
     7A56 A118 
0235                       ;------------------------------------------------------
0236                       ; Adjust frame buffer size if error pane visible
0237                       ;------------------------------------------------------
0238 7A58 C820  54         mov   @tv.error.visible,@tv.error.visible
     7A5A A01E 
     7A5C A01E 
0239 7A5E 1302  14         jeq   !
0240 7A60 0620  34         dec   @fb.scrrows
     7A62 A118 
0241                       ;------------------------------------------------------
0242                       ; Clear error/hint & status line
0243                       ;------------------------------------------------------
0244 7A64 06A0  32 !       bl    @hchar
     7A66 2792 
0245 7A68 1C00                   byte pane.botrow-1,0,32,80*2
     7A6A 20A0 
0246 7A6C FFFF                   data EOL
0247                       ;------------------------------------------------------
0248                       ; Hide command buffer pane (rest)
0249                       ;------------------------------------------------------
0250 7A6E C820  54         mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
     7A70 A304 
     7A72 832A 
0251 7A74 04E0  34         clr   @cmdb.visible         ; Hide command buffer pane
     7A76 A302 
0252 7A78 0720  34         seto  @fb.dirty             ; Redraw framebuffer
     7A7A A116 
0253 7A7C 04E0  34         clr   @tv.pane.focus        ; Framebuffer has focus!
     7A7E A01A 
0254                       ;------------------------------------------------------
0255                       ; Reload current color scheme
0256                       ;------------------------------------------------------
0257 7A80 0720  34         seto  @parm1                ; Do not turn screen off while
     7A82 2F20 
0258                                                   ; reloading color scheme
0259               
0260 7A84 06A0  32         bl    @pane.action.colorscheme.load
     7A86 7852 
0261                                                   ; Reload color scheme
0262                                                   ; i  parm1 = Skip screen off if >FFFF
0263                       ;------------------------------------------------------
0264                       ; Show cursor again
0265                       ;------------------------------------------------------
0266 7A88 06A0  32         bl    @pane.cursor.blink
     7A8A 77AA 
0267                       ;------------------------------------------------------
0268                       ; Exit
0269                       ;------------------------------------------------------
0270               pane.cmdb.hide.exit:
0271 7A8C C2F9  30         mov   *stack+,r11           ; Pop r11
0272 7A8E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0161                       copy  "pane.errline.asm"    ; Error line
**** **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Stevie Editor - Error line pane
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Error line pane
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.errline.show
0010               * Show command buffer pane
0011               ***************************************************************
0012               * bl @pane.errline.show
0013               *--------------------------------------------------------------
0014               * INPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0,tmp1
0022               *--------------------------------------------------------------
0023               * Notes
0024               ********|*****|*********************|**************************
0025               pane.errline.show:
0026 7A90 0649  14         dect  stack
0027 7A92 C64B  30         mov   r11,*stack            ; Save return address
0028 7A94 0649  14         dect  stack
0029 7A96 C644  30         mov   tmp0,*stack           ; Push tmp0
0030 7A98 0649  14         dect  stack
0031 7A9A C645  30         mov   tmp1,*stack           ; Push tmp1
0032               
0033 7A9C 0205  20         li    tmp1,>00f6            ; White on dark red
     7A9E 00F6 
0034 7AA0 C805  38         mov   tmp1,@parm1
     7AA2 2F20 
0035               
0036 7AA4 06A0  32         bl    @pane.action.colorscheme.errline
     7AA6 790C 
0037                                                   ; \ Set colors for error line
0038                                                   ; / i  parm1 = FG/BG color
0039               
0040                       ;------------------------------------------------------
0041                       ; Show error line content
0042                       ;------------------------------------------------------
0043 7AA8 06A0  32         bl    @putat                ; Display error message
     7AAA 244E 
0044 7AAC 1C00                   byte pane.botrow-1,0
0045 7AAE A020                   data tv.error.msg
0046               
0047 7AB0 C120  34         mov   @fb.scrrows.max,tmp0
     7AB2 A11A 
0048 7AB4 0604  14         dec   tmp0
0049 7AB6 C804  38         mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer
     7AB8 A118 
0050               
0051 7ABA 0720  34         seto  @tv.error.visible     ; Error line is visible
     7ABC A01E 
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               pane.errline.show.exit:
0056 7ABE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7AC0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7AC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0059 7AC4 045B  20         b     *r11                  ; Return to caller
0060               
0061               
0062               
0063               ***************************************************************
0064               * pane.errline.hide
0065               * Hide error line
0066               ***************************************************************
0067               * bl @pane.errline.hide
0068               *--------------------------------------------------------------
0069               * INPUT
0070               * none
0071               *--------------------------------------------------------------
0072               * OUTPUT
0073               * none
0074               *--------------------------------------------------------------
0075               * Register usage
0076               * none
0077               *--------------------------------------------------------------
0078               * Hiding the error line passes pane focus to frame buffer.
0079               ********|*****|*********************|**************************
0080               pane.errline.hide:
0081 7AC6 0649  14         dect  stack
0082 7AC8 C64B  30         mov   r11,*stack            ; Save return address
0083 7ACA 0649  14         dect  stack
0084 7ACC C644  30         mov   tmp0,*stack           ; Push tmp0
0085                       ;------------------------------------------------------
0086                       ; Hide command buffer pane
0087                       ;------------------------------------------------------
0088 7ACE 06A0  32 !       bl    @errline.init         ; Clear error line
     7AD0 6F40 
0089               
0090 7AD2 C120  34         mov   @tv.color,tmp0        ; Get colors
     7AD4 A018 
0091 7AD6 0984  56         srl   tmp0,8                ; Right aligns
0092 7AD8 C804  38         mov   tmp0,@parm1           ; set foreground/background color
     7ADA 2F20 
0093               
0094 7ADC 06A0  32         bl    @pane.action.colorscheme.errline
     7ADE 790C 
0095                                                   ; \ Set colors for error line
0096                                                   ; / i  parm1 LSB = FG/BG color
0097                       ;------------------------------------------------------
0098                       ; Exit
0099                       ;------------------------------------------------------
0100               pane.errline.hide.exit:
0101 7AE0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 7AE2 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 7AE4 045B  20         b     *r11                  ; Return to caller
**** **** ****     > stevie_b1.asm.2287273
0162                       copy  "pane.botline.asm"    ; Status line
**** **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Stevie Editor - Pane status bottom line
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Pane status bottom line
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * pane.botline.draw
0010               * Draw Stevie status bottom line
0011               ***************************************************************
0012               * bl  @pane.botline.draw
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               pane.botline.draw:
0021 7AE6 0649  14         dect  stack
0022 7AE8 C64B  30         mov   r11,*stack            ; Save return address
0023 7AEA 0649  14         dect  stack
0024 7AEC C644  30         mov   tmp0,*stack           ; Push tmp0
0025               
0026 7AEE C820  54         mov   @wyx,@fb.yxsave
     7AF0 832A 
     7AF2 A114 
0027                       ;------------------------------------------------------
0028                       ; Show separators
0029                       ;------------------------------------------------------
0030 7AF4 06A0  32         bl    @hchar
     7AF6 2792 
0031 7AF8 1D2C                   byte pane.botrow,44,14,1       ; Vertical line 1
     7AFA 0E01 
0032 7AFC 1D3C                   byte pane.botrow,60,14,1       ; Vertical line 2
     7AFE 0E01 
0033 7B00 1D47                   byte pane.botrow,71,14,1       ; Vertical line 3
     7B02 0E01 
0034 7B04 FFFF                   data eol
0035                       ;------------------------------------------------------
0036                       ; Show buffer number
0037                       ;------------------------------------------------------
0038               pane.botline.bufnum:
0039 7B06 06A0  32         bl    @putat
     7B08 244E 
0040 7B0A 1D00                   byte  pane.botrow,0
0041 7B0C 329C                   data  txt.bufnum
0042                       ;------------------------------------------------------
0043                       ; Show current file
0044                       ;------------------------------------------------------
0045               pane.botline.show_file:
0046 7B0E 06A0  32         bl    @at
     7B10 269E 
0047 7B12 1D03                   byte  pane.botrow,3   ; Position cursor
0048 7B14 C160  34         mov   @edb.filename.ptr,tmp1
     7B16 A20E 
0049                                                   ; Get string to display
0050 7B18 06A0  32         bl    @xutst0               ; Display string
     7B1A 242C 
0051                       ;------------------------------------------------------
0052                       ; Show text editing mode
0053                       ;------------------------------------------------------
0054               pane.botline.show_mode:
0055 7B1C C120  34         mov   @edb.insmode,tmp0
     7B1E A20A 
0056 7B20 1605  14         jne   pane.botline.show_mode.insert
0057                       ;------------------------------------------------------
0058                       ; Overwrite mode
0059                       ;------------------------------------------------------
0060               pane.botline.show_mode.overwrite:
0061 7B22 06A0  32         bl    @putat
     7B24 244E 
0062 7B26 1D2E                   byte  pane.botrow,46
0063 7B28 3268                   data  txt.ovrwrite
0064 7B2A 1004  14         jmp   pane.botline.show_changed
0065                       ;------------------------------------------------------
0066                       ; Insert  mode
0067                       ;------------------------------------------------------
0068               pane.botline.show_mode.insert:
0069 7B2C 06A0  32         bl    @putat
     7B2E 244E 
0070 7B30 1D2E                   byte  pane.botrow,46
0071 7B32 326C                   data  txt.insert
0072                       ;------------------------------------------------------
0073                       ; Show if text was changed in editor buffer
0074                       ;------------------------------------------------------
0075               pane.botline.show_changed:
0076 7B34 C120  34         mov   @edb.dirty,tmp0
     7B36 A206 
0077 7B38 1305  14         jeq   pane.botline.show_linecol
0078                       ;------------------------------------------------------
0079                       ; Show "*"
0080                       ;------------------------------------------------------
0081 7B3A 06A0  32         bl    @putat
     7B3C 244E 
0082 7B3E 1D32                   byte pane.botrow,50
0083 7B40 3270                   data txt.star
0084 7B42 1000  14         jmp   pane.botline.show_linecol
0085                       ;------------------------------------------------------
0086                       ; Show "line,column"
0087                       ;------------------------------------------------------
0088               pane.botline.show_linecol:
0089 7B44 C820  54         mov   @fb.row,@parm1
     7B46 A106 
     7B48 2F20 
0090 7B4A 06A0  32         bl    @fb.row2line
     7B4C 68E4 
0091 7B4E 05A0  34         inc   @outparm1
     7B50 2F30 
0092                       ;------------------------------------------------------
0093                       ; Show line
0094                       ;------------------------------------------------------
0095 7B52 06A0  32         bl    @putnum
     7B54 2A22 
0096 7B56 1D3E                   byte  pane.botrow,62  ; YX
0097 7B58 2F30                   data  outparm1,rambuf
     7B5A 2F64 
0098 7B5C 3020                   byte  48              ; ASCII offset
0099                             byte  32              ; Padding character
0100                       ;------------------------------------------------------
0101                       ; Show comma
0102                       ;------------------------------------------------------
0103 7B5E 06A0  32         bl    @putat
     7B60 244E 
0104 7B62 1D43                   byte  pane.botrow,67
0105 7B64 3259                   data  txt.delim
0106                       ;------------------------------------------------------
0107                       ; Show column
0108                       ;------------------------------------------------------
0109 7B66 06A0  32         bl    @film
     7B68 2242 
0110 7B6A 2F6A                   data rambuf+6,32,12   ; Clear work buffer with space character
     7B6C 0020 
     7B6E 000C 
0111               
0112 7B70 C820  54         mov   @fb.column,@waux1
     7B72 A10C 
     7B74 833C 
0113 7B76 05A0  34         inc   @waux1                ; Offset 1
     7B78 833C 
0114               
0115 7B7A 06A0  32         bl    @mknum                ; Convert unsigned number to string
     7B7C 29A4 
0116 7B7E 833C                   data  waux1,rambuf
     7B80 2F64 
0117 7B82 3020                   byte  48              ; ASCII offset
0118                             byte  32              ; Fill character
0119               
0120 7B84 06A0  32         bl    @trimnum              ; Trim number to the left
     7B86 29FC 
0121 7B88 2F64                   data  rambuf,rambuf+6,32
     7B8A 2F6A 
     7B8C 0020 
0122               
0123 7B8E 0204  20         li    tmp0,>0200
     7B90 0200 
0124 7B92 D804  38         movb  tmp0,@rambuf+6        ; "Fix" number length to clear junk chars
     7B94 2F6A 
0125               
0126 7B96 06A0  32         bl    @putat
     7B98 244E 
0127 7B9A 1D44                   byte pane.botrow,68
0128 7B9C 2F6A                   data rambuf+6         ; Show column
0129                       ;------------------------------------------------------
0130                       ; Show lines in buffer unless on last line in file
0131                       ;------------------------------------------------------
0132 7B9E C820  54         mov   @fb.row,@parm1
     7BA0 A106 
     7BA2 2F20 
0133 7BA4 06A0  32         bl    @fb.row2line
     7BA6 68E4 
0134 7BA8 8820  54         c     @edb.lines,@outparm1
     7BAA A204 
     7BAC 2F30 
0135 7BAE 1605  14         jne   pane.botline.show_lines_in_buffer
0136               
0137 7BB0 06A0  32         bl    @putat
     7BB2 244E 
0138 7BB4 1D49                   byte pane.botrow,73
0139 7BB6 3262                   data txt.bottom
0140               
0141 7BB8 100B  14         jmp   pane.botline.exit
0142                       ;------------------------------------------------------
0143                       ; Show lines in buffer
0144                       ;------------------------------------------------------
0145               pane.botline.show_lines_in_buffer:
0146 7BBA C820  54         mov   @edb.lines,@waux1
     7BBC A204 
     7BBE 833C 
0147 7BC0 05A0  34         inc   @waux1                ; Offset 1
     7BC2 833C 
0148               
0149 7BC4 06A0  32         bl    @putnum
     7BC6 2A22 
0150 7BC8 1D49                   byte pane.botrow,73   ; YX
0151 7BCA 833C                   data waux1,rambuf
     7BCC 2F64 
0152 7BCE 3020                   byte 48
0153                             byte 32
0154                       ;------------------------------------------------------
0155                       ; Exit
0156                       ;------------------------------------------------------
0157               pane.botline.exit:
0158 7BD0 C820  54         mov   @fb.yxsave,@wyx
     7BD2 A114 
     7BD4 832A 
0159 7BD6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0160 7BD8 C2F9  30         mov   *stack+,r11           ; Pop r11
0161 7BDA 045B  20         b     *r11                  ; Return
**** **** ****     > stevie_b1.asm.2287273
0163                       ;-----------------------------------------------------------------------
0164                       ; Dialogs
0165                       ;-----------------------------------------------------------------------
0166                       copy  "dialog.about.asm"    ; Dialog "About"
**** **** ****     > dialog.about.asm
0001               * FILE......: dialog.about.asm
0002               * Purpose...: Stevie Editor - About dialog
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - About dialog
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *---------------------------------------------------------------
0009               * Show Stevie welcome/about dialog
0010               *---------------------------------------------------------------
0011               edkey.action.about:
0012                       ;-------------------------------------------------------
0013                       ; Setup dialog
0014                       ;-------------------------------------------------------
0015 7BDC 0204  20         li    tmp0,id.dialog.about
     7BDE 0066 
0016 7BE0 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7BE2 A31A 
0017               
0018 7BE4 06A0  32         bl    @dialog.about.content ; display content in modal dialog
     7BE6 7C04 
0019               
0020 7BE8 0204  20         li    tmp0,txt.head.about
     7BEA 34B6 
0021 7BEC C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7BEE A31C 
0022               
0023 7BF0 0204  20         li    tmp0,txt.hint.about
     7BF2 34C4 
0024 7BF4 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7BF6 A31E 
0025               
0026 7BF8 0204  20         li    tmp0,txt.keys.about
     7BFA 34F2 
0027 7BFC C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7BFE A320 
0028               
0029 7C00 0460  28         b     @edkey.action.cmdb.show
     7C02 6766 
0030                                                   ; Show dialog in CMDB pane
0031               
0032               
0033               
0034               
0035               
0036               ***************************************************************
0037               * dialog.about.content
0038               * Show content in modal dialog
0039               ***************************************************************
0040               * bl  @dialog.about.content
0041               *--------------------------------------------------------------
0042               * OUTPUT
0043               * none
0044               *--------------------------------------------------------------
0045               * Register usage
0046               * tmp0
0047               ********|*****|*********************|**************************
0048               dialog.about.content:
0049 7C04 0649  14         dect  stack
0050 7C06 C64B  30         mov   r11,*stack            ; Save return address
0051 7C08 0649  14         dect  stack
0052 7C0A C644  30         mov   tmp0,*stack           ; Push tmp0
0053 7C0C 0649  14         dect  stack
0054 7C0E C645  30         mov   tmp1,*stack           ; Push tmp1
0055 7C10 0649  14         dect  stack
0056 7C12 C646  30         mov   tmp2,*stack           ; Push tmp2
0057               
0058 7C14 C820  54         mov   @wyx,@fb.yxsave       ; Save cursor
     7C16 832A 
     7C18 A114 
0059                       ;-------------------------------------------------------
0060                       ; Clear VDP screen buffer
0061                       ;-------------------------------------------------------
0062 7C1A 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7C1C 778C 
0063               
0064 7C1E C160  34         mov   @fb.scrrows,tmp1
     7C20 A118 
0065 7C22 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7C24 A10E 
0066                                                   ; 16 bit part is in tmp2!
0067               
0068 7C26 04C4  14         clr   tmp0                  ; VDP target address (1nd row on screen!)
0069 7C28 0205  20         li    tmp1,32               ; Character to fill
     7C2A 0020 
0070               
0071 7C2C 06A0  32         bl    @xfilv                ; Fill VDP memory
     7C2E 22A0 
0072                                                   ; \ i  tmp0 = VDP target address
0073                                                   ; | i  tmp1 = Byte to fill
0074                                                   ; / i  tmp2 = Bytes to copy
0075                       ;------------------------------------------------------
0076                       ; Show About dialog
0077                       ;------------------------------------------------------
0078 7C30 06A0  32 !       bl    @hchar
     7C32 2792 
0079 7C34 0214                   byte 2,20,3,40
     7C36 0328 
0080 7C38 0C14                   byte 12,20,3,40
     7C3A 0328 
0081 7C3C FFFF                   data EOL
0082               
0083 7C3E 06A0  32         bl    @putat
     7C40 244E 
0084 7C42 0421                   byte   4,33
0085 7C44 30E2                   data   txt.about.program
0086 7C46 06A0  32         bl    @putat
     7C48 244E 
0087 7C4A 0616                   byte   6,22
0088 7C4C 30F0                   data   txt.about.purpose
0089 7C4E 06A0  32         bl    @putat
     7C50 244E 
0090 7C52 0719                   byte   7,25
0091 7C54 3114                   data   txt.about.author
0092 7C56 06A0  32         bl    @putat
     7C58 244E 
0093 7C5A 091A                   byte   9,26
0094 7C5C 3132                   data   txt.about.website
0095 7C5E 06A0  32         bl    @putat
     7C60 244E 
0096 7C62 0A1E                   byte   10,30
0097 7C64 314E                   data   txt.about.build
0098               
0099 7C66 06A0  32         bl    @putat
     7C68 244E 
0100 7C6A 0E03                   byte   14,3
0101 7C6C 3164                   data   txt.about.msg1
0102 7C6E 06A0  32         bl    @putat
     7C70 244E 
0103 7C72 0F03                   byte   15,3
0104 7C74 318A                   data   txt.about.msg2
0105 7C76 06A0  32         bl    @putat
     7C78 244E 
0106 7C7A 1003                   byte   16,3
0107 7C7C 31AE                   data   txt.about.msg3
0108 7C7E 06A0  32         bl    @putat
     7C80 244E 
0109 7C82 0E32                   byte   14,50
0110 7C84 31C8                   data   txt.about.msg4
0111 7C86 06A0  32         bl    @putat
     7C88 244E 
0112 7C8A 0F32                   byte   15,50
0113 7C8C 31E6                   data   txt.about.msg5
0114 7C8E 06A0  32         bl    @putat
     7C90 244E 
0115 7C92 1032                   byte   16,50
0116 7C94 3204                   data   txt.about.msg6
0117               
0118 7C96 06A0  32         bl    @putat
     7C98 244E 
0119 7C9A 120A                   byte   18,10
0120 7C9C 3220                   data   txt.about.msg7
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               _dialog.about.content.exit:
0125 7C9E C820  54         mov   @fb.yxsave,@wyx
     7CA0 A114 
     7CA2 832A 
0126 7CA4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0127 7CA6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0128 7CA8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0129 7CAA C2F9  30         mov   *stack+,r11           ; Pop r11
0130 7CAC 045B  20         b     *r11                  ; Return
0131               
**** **** ****     > stevie_b1.asm.2287273
0167                       copy  "dialog.load.asm"     ; Dialog "Load DV80 file"
**** **** ****     > dialog.load.asm
0001               * FILE......: dialog.load.asm
0002               * Purpose...: Dialog "Load file"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Open DV80 file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.load
0011               * Open Dialog for loading DV 80 file
0012               ***************************************************************
0013               * b @dialog.load
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               dialog.load:
0027                       ;-------------------------------------------------------
0028                       ; Show dialog "unsaved changes" if editor buffer dirty
0029                       ;-------------------------------------------------------
0030 7CAE C120  34         mov   @edb.dirty,tmp0
     7CB0 A206 
0031 7CB2 1302  14         jeq   dialog.load.setup
0032 7CB4 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     7CB6 7D24 
0033                       ;-------------------------------------------------------
0034                       ; Setup dialog
0035                       ;-------------------------------------------------------
0036               dialog.load.setup:
0037 7CB8 0204  20         li    tmp0,id.dialog.load
     7CBA 000A 
0038 7CBC C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7CBE A31A 
0039               
0040 7CC0 0204  20         li    tmp0,txt.head.load
     7CC2 32BE 
0041 7CC4 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7CC6 A31C 
0042               
0043 7CC8 0204  20         li    tmp0,txt.hint.load
     7CCA 32CE 
0044 7CCC C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7CCE A31E 
0045               
0046 7CD0 0760  38         abs   @fh.offsetopcode      ; FastMode is off ?
     7CD2 A44E 
0047 7CD4 1303  14         jeq   !
0048                       ;-------------------------------------------------------
0049                       ; Show that FastMode is on
0050                       ;-------------------------------------------------------
0051 7CD6 0204  20         li    tmp0,txt.keys.load2   ; Highlight FastMode
     7CD8 3354 
0052 7CDA 1002  14         jmp   dialog.load.keylist
0053                       ;-------------------------------------------------------
0054                       ; Show that FastMode is off
0055                       ;-------------------------------------------------------
0056 7CDC 0204  20 !       li    tmp0,txt.keys.load
     7CDE 331C 
0057                       ;-------------------------------------------------------
0058                       ; Show dialog
0059                       ;-------------------------------------------------------
0060               dialog.load.keylist:
0061 7CE0 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7CE2 A320 
0062               
0063 7CE4 0460  28         b     @edkey.action.cmdb.show
     7CE6 6766 
0064                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.2287273
0168                       copy  "dialog.save.asm"     ; Dialog "Save DV80 file"
**** **** ****     > dialog.save.asm
0001               * FILE......: dialog.save.asm
0002               * Purpose...: Dialog "Save file"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *              Stevie Editor - Save DV80 file
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.save
0011               * Open Dialog for saving file
0012               ***************************************************************
0013               * b @dialog.save
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               dialog.save:
0027                       ;-------------------------------------------------------
0028                       ; Crunch current row if dirty
0029                       ;-------------------------------------------------------
0030 7CE8 8820  54         c     @fb.row.dirty,@w$ffff
     7CEA A10A 
     7CEC 202C 
0031 7CEE 1604  14         jne   !                     ; Skip crunching if clean
0032 7CF0 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7CF2 6C94 
0033 7CF4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7CF6 A10A 
0034                       ;-------------------------------------------------------
0035                       ; Setup dialog
0036                       ;-------------------------------------------------------
0037 7CF8 0204  20 !       li    tmp0,id.dialog.save
     7CFA 000B 
0038 7CFC C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7CFE A31A 
0039               
0040 7D00 0204  20         li    tmp0,txt.head.save
     7D02 338C 
0041 7D04 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7D06 A31C 
0042               
0043 7D08 0204  20         li    tmp0,txt.hint.save
     7D0A 339C 
0044 7D0C C804  38         mov   tmp0,@cmdb.panhint    ; Hint line in dialog
     7D0E A31E 
0045               
0046 7D10 0204  20         li    tmp0,txt.keys.save
     7D12 33DC 
0047 7D14 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7D16 A320 
0048               
0049 7D18 04E0  34         clr   @fh.offsetopcode      ; Data buffer in VDP RAM
     7D1A A44E 
0050               
0051 7D1C 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     7D1E 77AA 
0052               
0053 7D20 0460  28         b     @edkey.action.cmdb.show
     7D22 6766 
0054                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.2287273
0169                       copy  "dialog.unsaved.asm"  ; Dialog "Unsaved changes"
**** **** ****     > dialog.unsaved.asm
0001               * FILE......: dialog.unsaved.asm
0002               * Purpose...: Dialog "Unsaved changes"
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *      Stevie Editor - Unsaved changes in editor buffer
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dialog.unsaved
0011               * Open Dialog "Unsaved changes"
0012               ***************************************************************
0013               * b @dialog.unsaved
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * OUTPUT
0019               * none
0020               *--------------------------------------------------------------
0021               * Register usage
0022               * tmp0
0023               *--------------------------------------------------------------
0024               * Notes
0025               ********|*****|*********************|**************************
0026               dialog.unsaved:
0027 7D24 0204  20         li    tmp0,id.dialog.unsaved
     7D26 0065 
0028 7D28 C804  38         mov   tmp0,@cmdb.dialog     ; Set dialog ID
     7D2A A31A 
0029               
0030 7D2C 0204  20         li    tmp0,txt.head.unsaved
     7D2E 3406 
0031 7D30 C804  38         mov   tmp0,@cmdb.panhead    ; Header for dialog
     7D32 A31C 
0032               
0033 7D34 0204  20         li    tmp0,txt.hint.unsaved
     7D36 3418 
0034 7D38 C804  38         mov   tmp0,@cmdb.panhint    ; Hint in bottom line
     7D3A A31E 
0035               
0036 7D3C 0204  20         li    tmp0,txt.keys.unsaved
     7D3E 3458 
0037 7D40 C804  38         mov   tmp0,@cmdb.pankeys    ; Keylist in status line
     7D42 A320 
0038               
0039 7D44 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7D46 778C 
0040               
0041 7D48 0460  28         b     @edkey.action.cmdb.show
     7D4A 6766 
0042                                                   ; Show dialog in CMDB pane
**** **** ****     > stevie_b1.asm.2287273
0170                       ;-----------------------------------------------------------------------
0171                       ; Program data
0172                       ;-----------------------------------------------------------------------
0173                       copy  "data.keymap.actions.asm"
**** **** ****     > data.keymap.actions.asm
0001               * FILE......: data.keymap.actions.asm
0002               * Purpose...: Stevie Editor - data segment (keyboard actions)
0003               
0004               *---------------------------------------------------------------
0005               * Action keys mapping table: Editor
0006               *---------------------------------------------------------------
0007               keymap_actions.editor:
0008                       ;-------------------------------------------------------
0009                       ; Movement keys
0010                       ;-------------------------------------------------------
0011 7D4C 0D00             data  key.enter, pane.focus.fb, edkey.action.enter
     7D4E 0000 
     7D50 659A 
0012 7D52 0800             data  key.fctn.s, pane.focus.fb, edkey.action.left
     7D54 0000 
     7D56 6172 
0013 7D58 0900             data  key.fctn.d, pane.focus.fb, edkey.action.right
     7D5A 0000 
     7D5C 6188 
0014 7D5E 0B00             data  key.fctn.e, pane.focus.fb, edkey.action.up
     7D60 0000 
     7D62 61A0 
0015 7D64 0A00             data  key.fctn.x, pane.focus.fb, edkey.action.down
     7D66 0000 
     7D68 61F2 
0016 7D6A 8100             data  key.ctrl.a, pane.focus.fb, edkey.action.home
     7D6C 0000 
     7D6E 625E 
0017 7D70 8600             data  key.ctrl.f, pane.focus.fb, edkey.action.end
     7D72 0000 
     7D74 6276 
0018 7D76 9300             data  key.ctrl.s, pane.focus.fb, edkey.action.pword
     7D78 0000 
     7D7A 6294 
0019 7D7C 8400             data  key.ctrl.d, pane.focus.fb, edkey.action.nword
     7D7E 0000 
     7D80 62E6 
0020 7D82 8500             data  key.ctrl.e, pane.focus.fb, edkey.action.ppage
     7D84 0000 
     7D86 6346 
0021 7D88 9800             data  key.ctrl.x, pane.focus.fb, edkey.action.npage
     7D8A 0000 
     7D8C 637A 
0022 7D8E 9400             data  key.ctrl.t, pane.focus.fb, edkey.action.top
     7D90 0000 
     7D92 63C6 
0023 7D94 8200             data  key.ctrl.b, pane.focus.fb, edkey.action.bot
     7D96 0000 
     7D98 63DC 
0024                       ;-------------------------------------------------------
0025                       ; Modifier keys - Delete
0026                       ;-------------------------------------------------------
0027 7D9A 0300             data  key.fctn.1, pane.focus.fb, edkey.action.del_char
     7D9C 0000 
     7D9E 6406 
0028 7DA0 0700             data  key.fctn.3, pane.focus.fb, edkey.action.del_line
     7DA2 0000 
     7DA4 6482 
0029 7DA6 0200             data  key.fctn.4, pane.focus.fb, edkey.action.del_eol
     7DA8 0000 
     7DAA 644E 
0030               
0031                       ;-------------------------------------------------------
0032                       ; Modifier keys - Insert
0033                       ;-------------------------------------------------------
0034 7DAC 0400             data  key.fctn.2, pane.focus.fb, edkey.action.ins_char.ws
     7DAE 0000 
     7DB0 64DE 
0035 7DB2 B900             data  key.fctn.dot, pane.focus.fb, edkey.action.ins_onoff
     7DB4 0000 
     7DB6 6608 
0036 7DB8 0E00             data  key.fctn.5, pane.focus.fb, edkey.action.ins_line
     7DBA 0000 
     7DBC 6556 
0037                       ;-------------------------------------------------------
0038                       ; Other action keys
0039                       ;-------------------------------------------------------
0040 7DBE 0500             data  key.fctn.plus, pane.focus.fb, edkey.action.quit
     7DC0 0000 
     7DC2 6672 
0041 7DC4 9A00             data  key.ctrl.z, pane.focus.fb, pane.action.colorscheme.cycle
     7DC6 0000 
     7DC8 77CA 
0042                       ;-------------------------------------------------------
0043                       ; Dialog keys
0044                       ;-------------------------------------------------------
0045 7DCA 8000             data  key.ctrl.comma, pane.focus.fb, edkey.action.fb.fname.dec.load
     7DCC 0000 
     7DCE 6688 
0046 7DD0 9B00             data  key.ctrl.dot, pane.focus.fb, edkey.action.fb.fname.inc.load
     7DD2 0000 
     7DD4 6694 
0047 7DD6 0100             data  key.fctn.7, pane.focus.fb, edkey.action.about
     7DD8 0000 
     7DDA 7BDC 
0048 7DDC 8B00             data  key.ctrl.k, pane.focus.fb, dialog.save
     7DDE 0000 
     7DE0 7CE8 
0049 7DE2 8C00             data  key.ctrl.l, pane.focus.fb, dialog.load
     7DE4 0000 
     7DE6 7CAE 
0050                       ;-------------------------------------------------------
0051                       ; End of list
0052                       ;-------------------------------------------------------
0053 7DE8 FFFF             data  EOL                           ; EOL
0054               
0055               
0056               
0057               
0058               *---------------------------------------------------------------
0059               * Action keys mapping table: Command Buffer (CMDB)
0060               *---------------------------------------------------------------
0061               keymap_actions.cmdb:
0062                       ;-------------------------------------------------------
0063                       ; Dialog specific: File load / save
0064                       ;-------------------------------------------------------
0065 7DEA 0E00             data  key.fctn.5, id.dialog.load, edkey.action.cmdb.fastmode.toggle
     7DEC 000A 
     7DEE 67F4 
0066                       ;-------------------------------------------------------
0067                       ; Dialog specific: Unsaved changes
0068                       ;-------------------------------------------------------
0069 7DF0 0C00             data  key.fctn.6, id.dialog.unsaved, edkey.action.cmdb.proceed
     7DF2 0065 
     7DF4 67CA 
0070 7DF6 0D00             data  key.enter, id.dialog.unsaved, dialog.save
     7DF8 0065 
     7DFA 7CE8 
0071                       ;-------------------------------------------------------
0072                       ; Dialog specific: About
0073                       ;-------------------------------------------------------
0074 7DFC 0D00             data  key.enter, id.dialog.about, edkey.action.cmdb.close.dialog
     7DFE 0066 
     7E00 6800 
0075                       ;-------------------------------------------------------
0076                       ; Movement keys
0077                       ;-------------------------------------------------------
0078 7E02 0800             data  key.fctn.s, pane.focus.cmdb, edkey.action.cmdb.left
     7E04 0001 
     7E06 66BE 
0079 7E08 0900             data  key.fctn.d, pane.focus.cmdb, edkey.action.cmdb.right
     7E0A 0001 
     7E0C 66D0 
0080 7E0E 8100             data  key.ctrl.a, pane.focus.cmdb, edkey.action.cmdb.home
     7E10 0001 
     7E12 66E8 
0081 7E14 8600             data  key.ctrl.f, pane.focus.cmdb, edkey.action.cmdb.end
     7E16 0001 
     7E18 66FC 
0082                       ;-------------------------------------------------------
0083                       ; Modifier keys
0084                       ;-------------------------------------------------------
0085 7E1A 0700             data  key.fctn.3, pane.focus.cmdb, edkey.action.cmdb.clear
     7E1C 0001 
     7E1E 6714 
0086 7E20 0D00             data  key.enter, pane.focus.cmdb, edkey.action.cmdb.enter
     7E22 0001 
     7E24 6758 
0087                       ;-------------------------------------------------------
0088                       ; Other action keys
0089                       ;-------------------------------------------------------
0090 7E26 0F00             data  key.fctn.9, pane.focus.cmdb, edkey.action.cmdb.close.dialog
     7E28 0001 
     7E2A 6800 
0091 7E2C 0500             data  key.fctn.plus, pane.focus.cmdb, edkey.action.quit
     7E2E 0001 
     7E30 6672 
0092 7E32 9A00             data  key.ctrl.z, pane.focus.cmdb, pane.action.colorscheme.cycle
     7E34 0001 
     7E36 77CA 
0093                       ;------------------------------------------------------
0094                       ; End of list
0095                       ;-------------------------------------------------------
0096 7E38 FFFF             data  EOL                           ; EOL
**** **** ****     > stevie_b1.asm.2287273
0174                                                   ; Data segment - Keyboard actions
0178 7E3A 7E3A                   data $                ; Bank 1 ROM size OK.
0180               
0181               *--------------------------------------------------------------
0182               * Video mode configuration
0183               *--------------------------------------------------------------
0184      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0185      0004     spfbck  equ   >04                   ; Screen background color.
0186      3008     spvmod  equ   stevie.tx8030         ; Video mode.   See VIDTAB for details.
0187      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0188      0050     colrow  equ   80                    ; Columns per row
0189      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0190      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0191      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0192      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table
