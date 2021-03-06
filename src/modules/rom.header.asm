* FILE......: rom.header.asm
* Purpose...: Cartridge header

*--------------------------------------------------------------
* Cartridge header
********|*****|*********************|**************************
        byte  >aa                   ; 0  Standard header                   >6000
        byte  >01                   ; 1  Version number
        byte  >01                   ; 2  Number of programs (optional)     >6002
        byte  0                     ; 3  Reserved ('R' = adv. mode FG99)

        data  >0000                 ; 4  \ Pointer to power-up list        >6004
                                    ; 5  / 

        data  rom.program1          ; 6  \ Pointer to program list         >6006
                                    ; 7  / 

        data  >0000                 ; 8  \ Pointer to DSR list             >6008
                                    ; 9  / 

        data  >0000                 ; 10 \ Pointer to subprogram list      >600a
                                    ; 11 / 

        ;-----------------------------------------------------------------------
        ; Program list entry
        ;-----------------------------------------------------------------------
rom.program1:        
        data  >0000                 ; 12 \ Next program list entry         >600c
                                    ; 13 / (no more items following)

        data  kickstart.code1       ; 14 \ Program address                 >600e
                                    ; 15 /

        .ifeq device.f18a,1

           .ifeq device.fg99.mode.adv,1
              #string 'STEVIE 1.1N (F18A+FG99)'
           .else
              #string 'STEVIE 1.1N (F18A)'
           .endif

        .else

           .ifeq device.fg99.mode.adv,1
              #string 'STEVIE 1.1N (9938+FG99)'
           .else
              #string 'STEVIE 1.1N (9938)'
           .endif

        .endif