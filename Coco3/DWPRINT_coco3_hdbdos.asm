f9dasm: M6800/1/2/3/8/9 / H6309 Binary/OS9/FLEX9 Disassembler V1.78
Loaded binary file out.dmp

*****************************************************
** Used Labels                                      *
*****************************************************

DevNum  EQU     $006F
LptWid  EQU     $009B
LptPos  EQU     $009C
PATCH22A EQU     $8C37
BrkChk  EQU     $A549
DwWrite EQU     $D941

*****************************************************
** Program Code / Data Areas                        *
*****************************************************

        ORG     $A2BF

* Patch basic - replace Bit-Banger print with DwPrnt
DwpPch1 JMP     DwPrnt                   *A2BF: 7E FA 0C       '~..'

        ORG     $A30A 

* Patch basic - Add flush check to screen print rtn
DwpPch2 JMP     FlshCk                   *A30A: 7E FA 58       '~.X'

        ORG     $FA0C 

* DwPrnt - Entry from basic, char is in A
DwPrnt  PSHS    Y,X,D                    *FA0C: 34 36          '46'
        LDB     #$FF                     *FA0E: C6 FF          '..'
        STB     <FlshFlg,PCR             *FA10: E7 8C 54       '..T'
        LDY     #$0002                   *FA13: 10 8E 00 02    '....'
        LEAX    <Buf0,PCR                *FA17: 30 8C 4E       '0.N'
        TFR     A,B                      *FA1A: 1F 89          '..'
        CMPA    #$0D                     *FA1C: 81 0D          '..'
        BNE     DoPrnt                   *FA1E: 26 0C          '&.'
        CLR     LptPos                   *FA20: 0F 9C          '..'
        DEC     LptPos                   *FA22: 0A 9C          '..'
        LDA     #$0A                     *FA24: 86 0A          '..'
        STA     $03,X                    *FA26: A7 03          '..'
        LDY     #$0004                   *FA28: 10 8E 00 04    '....'
DoPrnt  LDA     #$50                     *FA2C: 86 50          '.P'
        STD     ,X                       *FA2E: ED 84          '..'
        STA     $02,X                    *FA30: A7 02          '..'
        JSR     [DwWrite]                *FA32: AD 9F D9 41    '...A'
        INC     LptPos                   *FA36: 0C 9C          '..'
        LDB     LptPos                   *FA38: D6 9C          '..'
        CMPB    LptWid                   *FA3A: D1 9B          '..'
        BNE     RtnBas1                  *FA3C: 26 02          '&.'
        CLR     LptPos                   *FA3E: 0F 9C          '..'
RtnBas1 PULS    PC,Y,X,D                 *FA40: 35 B6          '5.'

Flush   PSHS    Y,X,D                    *FA42: 34 36          '46'
        LDY     #$0001                   *FA44: 10 8E 00 01    '....'
        LDA     #$46                     *FA48: 86 46          '.F'
        LEAX    <Buf0,PCR                *FA4A: 30 8C 1B       '0..'
        STA     ,X                       *FA4D: A7 84          '..'
        CLR     <FlshFlg,PCR             *FA4F: 6F 8C 15       'o..'
        JSR     [DwWrite]                *FA52: AD 9F D9 41    '...A'
        PULS    PC,Y,X,D                 *FA56: 35 B6          '5.'

* FlshCk - Flush Check - Send OP_PRINTFLUSH if necessary
FlshCk  PSHS    CC                       *FA58: 34 01          '4.'
        TST     <FlshFlg,PCR             *FA5A: 6D 8C 0A       'm..'
        BEQ     RtnBas2                  *FA5D: 27 03          ''.'
        JSR     Flush                    *FA5F: BD FA 42       '..B'
RtnBas2 PULS    CC                       *FA62: 35 01          '5.'
        JMP     PATCH22A                 *FA64: 7E 8C 37       '~.7'

* Data/Vars

* Flag to track when to send OP_FLUSH
FlshFlg FCB     $00                      *FA67: 00             '.'
* Data buffer
Buf0    FCC     "P"                      *FA68: 50             'P'
Buf1    FCB     $00                      *FA69: 00             '.'
Buf2    FCC     "P"                      *FA6A: 50             'P'
Buf3    FCB     $00                      *FA6B: 00             '.'

* Unused Code
        PSHB                             *FA6C: 34 04          '4.'

        LDB     DevNum                   *FA6E: D6 6F          '.o'
        BEQ     ZFA78                    *FA70: 27 06          ''.'
ZFA72   PULB                             *FA72: 35 04          '5.'
        JSR     BrkChk                   *FA74: BD A5 49       '..I'
        RTS                              *FA77: 39             '9'
ZFA78   LDB     #$FE                     *FA78: C6 FE          '..'
        STB     DevNum                   *FA7A: D7 6F          '.o'
        BRA     ZFA72                    *FA7C: 20 F4          ' .'
* Unused Data/Vars
        FCC     "P"                      *FA7E: 50             'P'
        FCB     $00                      *FA7F: 00             '.'
        FCC     "P"                      *FA80: 50             'P'
        FCB     $00                      *FA81: 00             '.'

        END
