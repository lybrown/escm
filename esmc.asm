ZP equ $0		; Access: BC47 BC13 BB7F B8BA B851
outchar equ $80		; Access: BAB3 BAC1 BAC6 BB77 BBBE BACC BAE2
answer equ $81		; Access: B960 B964 BB40 BB37
curptr equ $82		; Access: BBFE BC4E B913 BB84 BBEB BB9D BBAE BB1B BB25
nextlineptr equ $84		; Access: BC53 BC65 BBED BB1F BB23
ptr1 equ $86		; Access: BC0F BB8B BB8F BB97 BBAA BBAC BBD1 BBD5 BBC2 BBC6 B842
ptr2 equ $88		; Access: B8B2 B8C4 B853 B858 B844
timeremains equ $8A		; Access: B94D B921 BC3D
lastkey equ $8B		; Access: B95C BBFA B96A B998 B9B4 B9D4 B9DA
bitmask equ $8E		; Access: BBBA BBCF BBD3 BBC4
bufwriteindex equ $90		; Access: BAA8 BAAE B93E B8D5
bufreadindex equ $91		; Access: B93C B946 B8D7
colorcount2 equ $94		; Access: BC89 B953 B902 B975 B932 B8DB
colpf2shadow equ $96		; Access: BC8F BC94 BAFA
colbakshadow equ $97		; Access: BCB7 BCBC BB0E
colpmshadow equ $98		; Access: BCA2 BCA7 BAF2
colpf2shadow2 equ $99		; Access: BCC7 BAFC
colbakshadow2 equ $9A		; Access: BCCC BB10
colpmshadow2 equ $9B		; Access: BCD1 BAF4
lastvcount equ $9C		; Access: BA89 BA0C
timer equ $9D		; Access: BA07 BA8B BA91 BA96 BA9C BAA2 BAA0 BA9A B925 BC32 BC44
period equ $9E		; Access: BA33 BA3D BA41 BC69 BA48 BA4F BA53 BA5A BA61 BA65 BA6E BA70 BA74 BA78 BA84
periodacc equ $A0		; Access: BA35 BC6B BC6D
accum equ $A2		; Access: BA2D BA30
startflag equ $A3		; Access: B8E1 B802
VIMIRQ equ $216		; Access: B838
GLBABS equ $2E0		; Access: BCE9
buf equ $600		; Access: BAAA B942
charset equ $C00
HPOSP0 equ $D000		; Access: B814
COLPM0 equ $D012		; Access: BCAB BCD3 BAE6 B81A
COLPM1 equ $D013		; Access: BCAE BCD6 BAE9
COLPM2 equ $D014		; Access: BCB1 BCD9 BAEC
COLPM3 equ $D015		; Access: BCB4 BCDC BAEF
COLPF1 equ $D017		; Access: BC9F BCE2
COLPF2 equ $D018		; Access: BC98 BCC9 BAF7
COLBK equ $D01A		; Access: BCC0 BCCE BB0B
GRACTL equ $D01D		; Access: BC2E
CONSOL equ $D01F		; Access: B927 B8F0 B8E8 B80C
AUDF1 equ $D200		; Access: B820
AUDC1 equ $D201		; Access: BBF4 B983 B992
AUDC2 equ $D203		; Access: BBF7 B986 B995
AUDF3 equ $D204		; Access: BA7F
AUDF4 equ $D206		; Access: BA86
KBCODE equ $D209		; Access: B9B1
SKREST equ $D20A		; Access: B9F2
SERIN equ $D20D		; Access: B9F7
IRQEN equ $D20E		; Access: B9E7 B9EC B90B B9A1 B9A9 B9AE BC41 B8D2
SKSTAT equ $D20F		; Access: B9EF B98B B833
PACTL equ $D302		; Access: B91E BC38 B82E
DMACTL equ $D400		; Access: BC2B B826
CHACTL equ $D401		; Access: BC21 B97E BB6C BB4F
WSYNC equ $D40A		; Access: BC1E BC28 B97B BB69 BB4C
VCOUNT equ $D40B		; Access: BA03
NMIEN equ $D40E		; Access: B807
    opt h-f+
    org $A000
    dta $FF
    org $B800
cartstart		; Callers: -c B800 -v BFFA
    lda #$FF		; B800: A9 FF
    sta startflag		; B802: 85 A3
    sei    		; B804: 78
    lda #$00		; B805: A9 00
    sta NMIEN		; B807: 8D 0E D4
    lda #$08		; B80A: A9 08
    sta CONSOL		; B80C: 8D 1F D0
    ldx #$0B		; B80F: A2 0B
chipinitloop		; Callers: B82A -c B811
    lda pmtbl,x		; B811: BD 8C BD
    sta HPOSP0,x		; B814: 9D 00 D0
    lda colortbl+1,x		; B817: BD 6D BD
    sta COLPM0,x		; B81A: 9D 12 D0
    lda pokeytbl,x		; B81D: BD 79 BD
    sta AUDF1,x		; B820: 9D 00 D2
    lda antictbl,x		; B823: BD 82 BD
    sta DMACTL,x		; B826: 9D 00 D4
    dex    		; B829: CA
    bpl chipinitloop		; B82A: 10 E5
    lda #$38		; B82C: A9 38
    sta PACTL		; B82E: 8D 02 D3
    lda #$13		; B831: A9 13
    sta SKSTAT		; B833: 8D 0F D2
    lda #$9C		; B836: A9 9C
    sta VIMIRQ		; B838: 8D 16 02
    lda #$B9		; B83B: A9 B9
    sta VIMIRQ+1		; B83D: 8D 17 02
    lda #$00		; B840: A9 00
    sta ptr1		; B842: 85 86
    sta ptr2		; B844: 85 88
    tay    		; B846: A8
    lda #$E0		; B847: A9 E0
    sta ptr1+1		; B849: 85 87
    lda #$0C		; B84B: A9 0C
    sta ptr2+1		; B84D: 85 89
    ldx #$86		; B84F: A2 86
copycharsetloop		; Callers: -c B851 B85A B862
    lda (ZP,x)		; B851: A1 00
    sta (ptr2),y		; B853: 91 88
    jsr incword_at_x		; B855: 20 47 BC
    inc ptr2		; B858: E6 88
    bne copycharsetloop		; B85A: D0 F5
    inc ptr2+1		; B85C: E6 89
    lda #$10		; B85E: A9 10
    cmp ptr2+1		; B860: C5 89
    bne copycharsetloop		; B862: D0 ED
    ldy #$27		; B864: A0 27
customcharsetloop1	; Callers: B873 -c B866
    lda customchars,y		; B866: B9 98 BD
    sta charset+$3D8,y		; B869: 99 D8 0F
    lda customchars+$28,y		; B86C: B9 C0 BD
    sta charset+$1D8,y		; B86F: 99 D8 0D
    dey    		; B872: 88
    bpl customcharsetloop1		; B873: 10 F1
    ldy #$07		; B875: A0 07
customcharsetloop2	; Callers: -c B877 B8AE
    lda customchars+$50,y		; B877: B9 E8 BD
    sta charset+$18,y		; B87A: 99 18 0C
    lda customchars+$58,y		; B87D: B9 F0 BD
    sta charset+$30,y		; B880: 99 30 0C
    lda customchars+$60,y		; B883: B9 F8 BD
    sta charset+$50,y		; B886: 99 50 0C
    lda customchars+$68,y		; B889: B9 00 BE
    sta charset+$80,y		; B88C: 99 80 0C
    lda customchars+$70,y		; B88F: B9 08 BE
    sta charset+$100,y		; B892: 99 00 0D
    lda customchars+$78,y		; B895: B9 10 BE
    sta charset+$300,y		; B898: 99 00 0F
    lda customchars+$80,y		; B89B: B9 18 BE
    sta charset+$E0,y		; B89E: 99 E0 0C
    lda customchars+$88,y		; B8A1: B9 20 BE
    sta charset+$F0,y		; B8A4: 99 F0 0C
    lda customchars+$90,y		; B8A7: B9 28 BE
    sta charset+$38,y		; B8AA: 99 38 0C
    dey    		; B8AD: 88
    bpl customcharsetloop2		; B8AE: 10 C7
    lda #$30		; B8B0: A9 30
    sta ptr2		; B8B2: 85 88
    lda #$BE		; B8B4: A9 BE
    sta ptr2+1		; B8B6: 85 89
    ldx #$88		; B8B8: A2 88
readstream		; Callers: B8C8 B8CE -c B8BA
    lda (ZP,x)		; B8BA: A1 00
    jsr writechar1		; B8BC: 20 B3 BA
    ldx #$88		; B8BF: A2 88
    jsr incword_at_x		; B8C1: 20 47 BC
    lda ptr2		; B8C4: A5 88
    cmp #$5C		; B8C6: C9 5C
    bne readstream		; B8C8: D0 F0
    lda ptr2+1		; B8CA: A5 89
    cmp #$BF		; B8CC: C9 BF
    bne readstream		; B8CE: D0 EA
enableserial		; Callers: -c B8D0
    lda #$20		; B8D0: A9 20
    sta IRQEN		; B8D2: 8D 0E D2
    sta bufwriteindex		; B8D5: 85 90
    sta bufreadindex		; B8D7: 85 91
    lda #$FE		; B8D9: A9 FE
    sta colorcount2		; B8DB: 85 94
    sta colorcount2+1		; B8DD: 85 95
    lda #$01		; B8DF: A9 01
    bit startflag		; B8E1: 24 A3
    bpl waitstartkeyup		; B8E3: 10 08
waitstartkeydown	; Callers: B8EB -c B8E5
    jsr changecolors		; B8E5: 20 76 BC
    bit CONSOL		; B8E8: 2C 1F D0
    bne waitstartkeydown		; B8EB: D0 F8
waitstartkeyup		; Callers: B8E3 B8F5 -c B8ED
    jsr changecolors		; B8ED: 20 76 BC
    bit CONSOL		; B8F0: 2C 1F D0
    bne start		; B8F3: D0 02
    beq waitstartkeyup		; B8F5: F0 F6
start			; Callers: -c B8F7 B8F3
    lda #$9E		; B8F7: A9 9E
    jsr writechar1		; B8F9: 20 B3 BA
    jmp correct		; B8FC: 4C FF B8
correct			; Callers: B962 B968 B8FC -c B8FF
    cli    		; B8FF: 58
    lda #$FB		; B900: A9 FB
    sta colorcount2		; B902: 85 94
    sta colorcount2+1		; B904: 85 95
    jsr restorecolors		; B906: 20 C7 BC
    lda #$20		; B909: A9 20
    sta IRQEN		; B90B: 8D 0E D2
    jsr homeinit		; B90E: 20 F2 BB
    lda #$C0		; B911: A9 C0
    sta curptr		; B913: 85 82
    lda #$09		; B915: A9 09
    sta curptr+1		; B917: 85 83
    jsr computenextlineptr		; B919: 20 4E BC
    lda #$30		; B91C: A9 30
    sta PACTL		; B91E: 8D 02 D3
    sta timeremains		; B921: 85 8A
    lda #$14		; B923: A9 14
    sta timer		; B925: 85 9D
checksso		; Callers: -c B927 B94F
    lda CONSOL		; B927: AD 1F D0
    and #$07		; B92A: 29 07
    eor #$07		; B92C: 49 07
    beq donesso		; B92E: F0 09
    lda #$FB		; B930: A9 FB
    sta colorcount2		; B932: 85 94
    sta colorcount2+1		; B934: 85 95
    jsr restorecolors		; B936: 20 C7 BC
donesso			; Callers: B92E -c B939
    jsr changecolors		; B939: 20 76 BC
read_from_ring_buffer	; Callers: -c B93C
    ldx bufreadindex		; B93C: A6 91
    cpx bufwriteindex		; B93E: E4 90
    beq readdone		; B940: F0 09
    lda buf,x		; B942: BD 00 06
    inx    		; B945: E8
    stx bufreadindex		; B946: 86 91
    jsr writechar1		; B948: 20 B3 BA
readdone		; Callers: B940 -c B94B
    lda #$00		; B94B: A9 00
    cmp timeremains		; B94D: C5 8A
    bne checksso		; B94F: D0 D6
    lda #$FE		; B951: A9 FE
    sta colorcount2		; B953: 85 94
    sta colorcount2+1		; B955: 85 95
waitkey			; Callers: B95E B96E B98E B99A -c B957
    cli    		; B957: 58
    jsr changecolors		; B958: 20 76 BC
    sei    		; B95B: 78
    lda lastkey		; B95C: A5 8B
    bmi waitkey		; B95E: 30 F7
    cmp answer		; B960: C5 81
    beq correct		; B962: F0 9B
    lda answer		; B964: A5 81
    cmp #$03		; B966: C9 03
    beq correct		; B968: F0 95
    lda lastkey		; B96A: A5 8B
    cmp #$03		; B96C: C9 03
    beq waitkey		; B96E: F0 E7
    jsr restorecolors		; B970: 20 C7 BC
    lda #$FE		; B973: A9 FE
    sta colorcount2		; B975: 85 94
    sta colorcount2+1		; B977: 85 95
    lda #$00		; B979: A9 00
    sta WSYNC		; B97B: 8D 0A D4
    sta CHACTL		; B97E: 8D 01 D4
    lda #$A8		; B981: A9 A8
    sta AUDC1		; B983: 8D 01 D2
    sta AUDC2		; B986: 8D 03 D2
    lda #$04		; B989: A9 04
    bit SKSTAT		; B98B: 2C 0F D2
    beq waitkey		; B98E: F0 C7
    lda #$A0		; B990: A9 A0
    sta AUDC1		; B992: 8D 01 D2
    sta AUDC2		; B995: 8D 03 D2
    sta lastkey		; B998: 85 8B
    bne waitkey		; B99A: D0 BB
irqhandler		; Callers: -c B99C
    pha    		; B99C: 48
    txa    		; B99D: 8A
    pha    		; B99E: 48
    tya    		; B99F: 98
    pha    		; B9A0: 48
    lda IRQEN		; B9A1: AD 0E D2
    rol @		; B9A4: 2A
    bmi serialhandler		; B9A5: 30 3B
    lda #$00		; B9A7: A9 00
    sta IRQEN		; B9A9: 8D 0E D2
    lda #$40		; B9AC: A9 40
    sta IRQEN		; B9AE: 8D 0E D2
    lda KBCODE		; B9B1: AD 09 D2
    sta lastkey		; B9B4: 85 8B
    cmp #$1F		; B9B6: C9 1F
    bne not1		; B9B8: D0 02
    lda #$00		; B9BA: A9 00
not1			; Callers: B9B8 -c B9BC
    cmp #$1E		; B9BC: C9 1E
    bne not2		; B9BE: D0 02
    lda #$01		; B9C0: A9 01
not2			; Callers: B9BE -c B9C2
    cmp #$1A		; B9C2: C9 1A
    bne not3		; B9C4: D0 02
    lda #$02		; B9C6: A9 02
not3			; Callers: B9C4 -c B9C8
    cmp #$21		; B9C8: C9 21
    bne notspace		; B9CA: D0 02
    lda #$03		; B9CC: A9 03
notspace		; Callers: B9CA -c B9CE
    cmp #$0C		; B9CE: C9 0C
    bne notreturn		; B9D0: D0 02
    lda #$03		; B9D2: A9 03
notreturn		; Callers: B9D0 -c B9D4
    cmp lastkey		; B9D4: C5 8B
    bne notsame		; B9D6: D0 02
    lda #$FF		; B9D8: A9 FF
notsame			; Callers: B9D6 -c B9DA
    sta lastkey		; B9DA: 85 8B
exitirq			; Callers: B9E3 B9F5 lBA93 lBAB0 -c B9DC
    pla    		; B9DC: 68
    tay    		; B9DD: A8
    pla    		; B9DE: 68
    tax    		; B9DF: AA
    pla    		; B9E0: 68
    rti    		; B9E1: 40
serialhandler		; Callers: -c B9E2 B9A5
    rol @		; B9E2: 2A
    bmi exitirq		; B9E3: 30 F7
    lda #$00		; B9E5: A9 00
    sta IRQEN		; B9E7: 8D 0E D2
    lda #$20		; B9EA: A9 20
    sta IRQEN		; B9EC: 8D 0E D2
    bit SKSTAT		; B9EF: 2C 0F D2
    sta SKREST		; B9F2: 8D 0A D2
    bpl exitirq		; B9F5: 10 E5
    lda SERIN		; B9F7: AD 0D D2
    eor #$FF		; B9FA: 49 FF
    cmp #$00		; B9FC: C9 00
    beq receivezero		; B9FE: F0 03
    jmp receivebyte		; BA00: 4C 96 BA
receivezero		; Callers: B9FE -c BA03
    lda VCOUNT		; BA03: AD 0B D4
    tax    		; BA06: AA
    bit timer		; BA07: 24 9D
    bpl lBA89		; BA09: 10 7E
    sec    		; BA0B: 38
    sbc lastvcount		; BA0C: E5 9C
    bmi lBA18		; BA0E: 30 08
    cmp #$42		; BA10: C9 42
    bmi lBA1E		; BA12: 30 0A
    sbc #$83		; BA14: E9 83
    bmi lBA1E		; BA16: 30 06
lBA18			; Callers: BA0E
    cmp #$BE		; BA18: C9 BE
    bpl lBA1E		; BA1A: 10 02
    adc #$83		; BA1C: 69 83
lBA1E			; Callers: BA1A BA12 BA16
    clc    		; BA1E: 18
    adc #$41		; BA1F: 69 41
    cmp #$2D		; BA21: C9 2D
    bpl lBA27		; BA23: 10 02
    lda #$2D		; BA25: A9 2D
lBA27			; Callers: BA23
    cmp #$55		; BA27: C9 55
    bmi lBA2D		; BA29: 30 02
    lda #$55		; BA2B: A9 55
lBA2D			; Callers: BA29
    adc accum		; BA2D: 65 A2
    ror @		; BA2F: 6A
    sta accum		; BA30: 85 A2
multiplyby365		; Callers: -c BA32
    clc    		; BA32: 18
    sta period		; BA33: 85 9E
    sta periodacc		; BA35: 85 A0
    lda #$00		; BA37: A9 00
    sta period+1		; BA39: 85 9F
    sta periodacc+1		; BA3B: 85 A1
    asl period		; BA3D: 06 9E
    rol period+1		; BA3F: 26 9F
    asl period		; BA41: 06 9E
    rol period+1		; BA43: 26 9F
    jsr accumulate		; BA45: 20 68 BC
    asl period		; BA48: 06 9E
    rol period+1		; BA4A: 26 9F
    jsr accumulate		; BA4C: 20 68 BC
    asl period		; BA4F: 06 9E
    rol period+1		; BA51: 26 9F
    asl period		; BA53: 06 9E
    rol period+1		; BA55: 26 9F
    jsr accumulate		; BA57: 20 68 BC
    asl period		; BA5A: 06 9E
    rol period+1		; BA5C: 26 9F
    jsr accumulate		; BA5E: 20 68 BC
    asl period		; BA61: 06 9E
    rol period+1		; BA63: 26 9F
    asl period		; BA65: 06 9E
    rol period+1		; BA67: 26 9F
    jsr accumulate		; BA69: 20 68 BC
    lda #$00		; BA6C: A9 00
    sta period		; BA6E: 85 9E
    rol period		; BA70: 26 9E
    asl periodacc+1		; BA72: 06 A1
    rol period		; BA74: 26 9E
    asl periodacc+1		; BA76: 06 A1
    rol period		; BA78: 26 9E
    clc    		; BA7A: 18
    lda #$5B		; BA7B: A9 5B
    adc periodacc+1		; BA7D: 65 A1
    sta AUDF3		; BA7F: 8D 04 D2
    lda #$04		; BA82: A9 04
    adc period		; BA84: 65 9E
    sta AUDF4		; BA86: 8D 06 D2
lBA89			; Callers: BA09
    stx lastvcount		; BA89: 86 9C
    dec timer		; BA8B: C6 9D
    bpl lBA93		; BA8D: 10 04
    lda #$FF		; BA8F: A9 FF
    sta timer		; BA91: 85 9D
lBA93			; Callers: BA8D
    jmp exitirq		; BA93: 4C DC B9
receivebyte		; Callers: BA00 -c BA96
    bit timer		; BA96: 24 9D
    bpl lBA9C		; BA98: 10 02
    inc timer		; BA9A: E6 9D
lBA9C			; Callers: BA98
    dec timer		; BA9C: C6 9D
    bpl lBAA2		; BA9E: 10 02
    inc timer		; BAA0: E6 9D
lBAA2			; Callers: BA9E
    ldx timer		; BAA2: A6 9D
    cpx #$0F		; BAA4: E0 0F
    bpl lBAB0		; BAA6: 10 08
write_to_ring_buffer	; Callers: -c BAA8
    ldx bufwriteindex		; BAA8: A6 90
    sta buf,x		; BAAA: 9D 00 06
    inx    		; BAAD: E8
    stx bufwriteindex		; BAAE: 86 90
lBAB0			; Callers: BAA6
    jmp exitirq		; BAB0: 4C DC B9
writechar1		; Callers: B948 B8F9 B8BC -c BAB3
    sta outchar		; BAB3: 85 80
    and #$7F		; BAB5: 29 7F
    sec    		; BAB7: 38
    sbc #$20		; BAB8: E9 20
    bmi lBAC0		; BABA: 30 04
    jsr writechar2		; BABC: 20 70 BB
lBABF			; Callers: BAD2
    rts    		; BABF: 60
lBAC0			; Callers: BABA
    pha    		; BAC0: 48
    lda outchar		; BAC1: A5 80
    pha    		; BAC3: 48
    lda #$00		; BAC4: A9 00
    sta outchar		; BAC6: 85 80
    jsr writechar2		; BAC8: 20 70 BB
    pla    		; BACB: 68
    sta outchar		; BACC: 85 80
    pla    		; BACE: 68
    jsr checkforsetcolor		; BACF: 20 D5 BA
    jmp lBABF		; BAD2: 4C BF BA
checkforsetcolor	; Callers: BACF -c BAD5
    clc    		; BAD5: 18
    adc #$01		; BAD6: 69 01
    bpl lBAF6		; BAD8: 10 1C
    adc #$06		; BADA: 69 06
    bmi checkforcolbak		; BADC: 30 21
    tax    		; BADE: AA
    lda colortbl,x		; BADF: BD 6C BD
    bit outchar		; BAE2: 24 80
    bpl setcolpf2		; BAE4: 10 11
setcolpm		; Callers: -c BAE6
    sta COLPM0		; BAE6: 8D 12 D0
    sta COLPM1		; BAE9: 8D 13 D0
    sta COLPM2		; BAEC: 8D 14 D0
    sta COLPM3		; BAEF: 8D 15 D0
    sta colpmshadow		; BAF2: 85 98
    sta colpmshadow2		; BAF4: 85 9B
lBAF6			; Callers: BAD8
    rts    		; BAF6: 60
setcolpf2		; Callers: BAE4 -c BAF7
    sta COLPF2		; BAF7: 8D 18 D0
    sta colpf2shadow		; BAFA: 85 96
    sta colpf2shadow2		; BAFC: 85 99
    rts    		; BAFE: 60
checkforcolbak		; Callers: BADC -c BAFF
    adc #$02		; BAFF: 69 02
    bpl lBB12		; BB01: 10 0F
    adc #$06		; BB03: 69 06
    bmi checkforlinefeed		; BB05: 30 0C
setcolbak		; Callers: -c BB07
    tax    		; BB07: AA
    lda colortbl,x		; BB08: BD 6C BD
    sta COLBK		; BB0B: 8D 1A D0
    sta colbakshadow		; BB0E: 85 97
    sta colbakshadow2		; BB10: 85 9A
lBB12			; Callers: BB01
    rts    		; BB12: 60
checkforlinefeed	; Callers: BB05 -c BB13
    adc #$03		; BB13: 69 03
    bpl lBB2E		; BB15: 10 17
    adc #$01		; BB17: 69 01
    bmi checkforanswer		; BB19: 30 14
linefeed		; Callers: -c BB1B
    lda curptr		; BB1B: A5 82
    adc #$1F		; BB1D: 69 1F
    cmp nextlineptr		; BB1F: C5 84
    beq lBB2E		; BB21: F0 0B
    lda nextlineptr		; BB23: A5 84
    sta curptr		; BB25: 85 82
    lda nextlineptr+1		; BB27: A5 85
    sta curptr+1		; BB29: 85 83
    jsr computenextlineptr		; BB2B: 20 4E BC
lBB2E			; Callers: BB15 BB21
    rts    		; BB2E: 60
checkforanswer		; Callers: BB19 -c BB2F
    adc #$01		; BB2F: 69 01
    bpl lBB39		; BB31: 10 06
    adc #$04		; BB33: 69 04
    bmi checkforcontinue		; BB35: 30 03
setanswer		; Callers: -c BB37
    sta answer		; BB37: 85 81
lBB39			; Callers: BB31
    rts    		; BB39: 60
checkforcontinue	; Callers: BB35 -c BB3A
    adc #$01		; BB3A: 69 01
    bmi checkforchactl		; BB3C: 30 06
setcontinue		; Callers: -c BB3E
    lda #$03		; BB3E: A9 03
    sta answer		; BB40: 85 81
    bne lBB57		; BB42: D0 13
checkforchactl		; Callers: BB3C -c BB44
    adc #$01		; BB44: 69 01
    bpl lBB52		; BB46: 10 0A
setchactl		; Callers: -c BB48
    adc #$01		; BB48: 69 01
    bmi lBB53		; BB4A: 30 07
    sta WSYNC		; BB4C: 8D 0A D4
    sta CHACTL		; BB4F: 8D 01 D4
lBB52			; Callers: BB46
    rts    		; BB52: 60
lBB53			; Callers: BB4A
    adc #$01		; BB53: 69 01
    bmi lBB5B		; BB55: 30 04
lBB57			; Callers: BB42
    jsr checktimer		; BB57: 20 32 BC
    rts    		; BB5A: 60
lBB5B			; Callers: BB55
    adc #$01		; BB5B: 69 01
    bmi checkforchactl2		; BB5D: 30 04
    jsr homeinit		; BB5F: 20 F2 BB
    rts    		; BB62: 60
checkforchactl2		; Callers: BB5D -c BB63
    adc #$01		; BB63: 69 01
    bmi lBB6F		; BB65: 30 08
setchactl2		; Callers: -c BB67
    lda #$01		; BB67: A9 01
    sta WSYNC		; BB69: 8D 0A D4
    sta CHACTL		; BB6C: 8D 01 D4
lBB6F			; Callers: BB65
    rts    		; BB6F: 60
writechar2		; Callers: BAC8 BABC -c BB70
    cmp #$40		; BB70: C9 40
    bmi lessthan40		; BB72: 30 03
    clc    		; BB74: 18
    adc #$20		; BB75: 69 20
lessthan40		; Callers: BB72 -c BB77
    bit outchar		; BB77: 24 80
    bpl notinverse		; BB79: 10 02
    ora #$80		; BB7B: 09 80
notinverse		; Callers: BB79 -c BB7D
    ldx #$82		; BB7D: A2 82
    sta (ZP,x)		; BB7F: 81 00
    lda curptr+1		; BB81: A5 83
    ror @		; BB83: 6A
    lda curptr		; BB84: A5 82
    and #$E0		; BB86: 29 E0
    ror @		; BB88: 6A
    ror @		; BB89: 6A
    ror @		; BB8A: 6A
    sta ptr1		; BB8B: 85 86
    ror @		; BB8D: 6A
    ror @		; BB8E: 6A
    adc ptr1		; BB8F: 65 86
    cmp #$46		; BB91: C9 46
    bpl advancecursor		; BB93: 10 45
    adc #$18		; BB95: 69 18
    sta ptr1		; BB97: 85 86
    lda #$0A		; BB99: A9 0A
    sta ptr1+1		; BB9B: 85 87
    lda curptr		; BB9D: A5 82
    rol @		; BB9F: 2A
    rol @		; BBA0: 2A
    rol @		; BBA1: 2A
    rol @		; BBA2: 2A
    bcc lBBA7		; BBA3: 90 02
    inc ptr1+1		; BBA5: E6 87
lBBA7			; Callers: BBA3
    and #$80		; BBA7: 29 80
    clc    		; BBA9: 18
    adc ptr1		; BBAA: 65 86
    sta ptr1		; BBAC: 85 86
    lda curptr		; BBAE: A5 82
    and #$07		; BBB0: 29 07
    tay    		; BBB2: A8
    lda #$80		; BBB3: A9 80
    asl @		; BBB5: 0A
lBBB6			; Callers: BBB8
    ror @		; BBB6: 6A
    dey    		; BBB7: 88
    bpl lBBB6		; BBB8: 10 FC
    sta bitmask		; BBBA: 85 8E
    ldy #$04		; BBBC: A0 04
    bit outchar		; BBBE: 24 80
    bpl lBBCD		; BBC0: 10 0B
setpmbits		; Callers: BBC9 -c BBC2
    lda (ptr1),y		; BBC2: B1 86
    ora bitmask		; BBC4: 05 8E
    sta (ptr1),y		; BBC6: 91 86
    dey    		; BBC8: 88
    bpl setpmbits		; BBC9: 10 F7
    bmi advancecursor		; BBCB: 30 0D
lBBCD			; Callers: BBC0
    eor #$FF		; BBCD: 49 FF
    sta bitmask		; BBCF: 85 8E
clearpmbits		; Callers: BBD8 -c BBD1
    lda (ptr1),y		; BBD1: B1 86
    and bitmask		; BBD3: 25 8E
    sta (ptr1),y		; BBD5: 91 86
    dey    		; BBD7: 88
    bpl clearpmbits		; BBD8: 10 F7
advancecursor		; Callers: BB93 BBCB -c BBDA
    jsr incword_at_x		; BBDA: 20 47 BC
    lda #$0A		; BBDD: A9 0A
    cmp curptr+1		; BBDF: C5 83
    bne lBBEB		; BBE1: D0 08
    lda #$08		; BBE3: A9 08
    sta curptr+1		; BBE5: 85 83
lBBE7			; Callers: BBEF
    jsr computenextlineptr		; BBE7: 20 4E BC
    rts    		; BBEA: 60
lBBEB			; Callers: BBE1
    lda curptr		; BBEB: A5 82
    cmp nextlineptr		; BBED: C5 84
    beq lBBE7		; BBEF: F0 F6
    rts    		; BBF1: 60
homeinit		; Callers: B90E BB5F -c BBF2
    lda #$A0		; BBF2: A9 A0
    sta AUDC1		; BBF4: 8D 01 D2
    sta AUDC2		; BBF7: 8D 03 D2
    sta lastkey		; BBFA: 85 8B
    lda #$00		; BBFC: A9 00
    sta curptr		; BBFE: 85 82
    lda #$08		; BC00: A9 08
    sta curptr+1		; BC02: 85 83
    jsr computenextlineptr		; BC04: 20 4E BC
    ldx #$86		; BC07: A2 86
    lda #$07		; BC09: A9 07
    sta ptr1+1		; BC0B: 85 87
    lda #$00		; BC0D: A9 00
    sta ptr1		; BC0F: 85 86
    ldy #$0C		; BC11: A0 0C
writefiller		; Callers: BC1A -c BC13
    sta (ZP,x)		; BC13: 81 00
    jsr incword_at_x		; BC15: 20 47 BC
    cpy ptr1+1		; BC18: C4 87
    bne writefiller		; BC1A: D0 F7
    lda #$00		; BC1C: A9 00
    sta WSYNC		; BC1E: 8D 0A D4
    sta CHACTL		; BC21: 8D 01 D4
    lda #$2D		; BC24: A9 2D
    ldx #$03		; BC26: A2 03
    sta WSYNC		; BC28: 8D 0A D4
    sta DMACTL		; BC2B: 8D 00 D4
    stx GRACTL		; BC2E: 8E 1D D0
    rts    		; BC31: 60
checktimer		; Callers: BB57 -c BC32
    dec timer		; BC32: C6 9D
    bpl donechecktimer		; BC34: 10 0E
    lda #$38		; BC36: A9 38
    sta PACTL		; BC38: 8D 02 D3
    lda #$00		; BC3B: A9 00
    sta timeremains		; BC3D: 85 8A
    lda #$40		; BC3F: A9 40
    sta IRQEN		; BC41: 8D 0E D2
donechecktimer		; Callers: BC34 -c BC44
    inc timer		; BC44: E6 9D
    rts    		; BC46: 60
incword_at_x		; Callers: BC7B BC82 BC15 advancecursor B8C1 B855 -c BC47
    inc ZP,x		; BC47: F6 00
    bne incword_at_xskip		; BC49: D0 02
    inc ZP+1,x		; BC4B: F6 01
incword_at_xskip	; Callers: BC49 -c BC4D
    rts    		; BC4D: 60
computenextlineptr	; Callers: BC04 B919 lBBE7 BB2B -c BC4E
    lda curptr		; BC4E: A5 82
    clc    		; BC50: 18
    adc #$20		; BC51: 69 20
    sta nextlineptr		; BC53: 85 84
    lda curptr+1		; BC55: A5 83
    adc #$00		; BC57: 69 00
    sta nextlineptr+1		; BC59: 85 85
    cmp #$0A		; BC5B: C9 0A
    bne lBC67		; BC5D: D0 08
    lda #$08		; BC5F: A9 08
    sta nextlineptr+1		; BC61: 85 85
    lda #$00		; BC63: A9 00
    sta nextlineptr		; BC65: 85 84
lBC67			; Callers: BC5D
    rts    		; BC67: 60
accumulate		; Callers: BA45 BA4C BA57 BA5E BA69 -c BC68
    clc    		; BC68: 18
    lda period		; BC69: A5 9E
    adc periodacc		; BC6B: 65 A0
    sta periodacc		; BC6D: 85 A0
    lda period+1		; BC6F: A5 9F
    adc periodacc+1		; BC71: 65 A1
    sta periodacc+1		; BC73: 85 A1
    rts    		; BC75: 60
changecolors		; Callers: donesso B958 waitstartkeyup waitstartkeydown -c BC76
    pha    		; BC76: 48
    txa    		; BC77: 8A
    pha    		; BC78: 48
    ldx #$92		; BC79: A2 92
    jsr incword_at_x		; BC7B: 20 47 BC
    bne changecolorsdone		; BC7E: D0 43
    ldx #$94		; BC80: A2 94
    jsr incword_at_x		; BC82: 20 47 BC
    bne changecolorsdone		; BC85: D0 3C
    lda #$FE		; BC87: A9 FE
    sta colorcount2		; BC89: 85 94
    lda #$FF		; BC8B: A9 FF
    sta colorcount2+1		; BC8D: 85 95
    lda colpf2shadow		; BC8F: A5 96
    clc    		; BC91: 18
    adc #$33		; BC92: 69 33
    sta colpf2shadow		; BC94: 85 96
    and #$F7		; BC96: 29 F7
    sta COLPF2		; BC98: 8D 18 D0
    adc #$04		; BC9B: 69 04
    and #$F7		; BC9D: 29 F7
    sta COLPF1		; BC9F: 8D 17 D0
    lda colpmshadow		; BCA2: A5 98
    clc    		; BCA4: 18
    adc #$33		; BCA5: 69 33
    sta colpmshadow		; BCA7: 85 98
    and #$F7		; BCA9: 29 F7
    sta COLPM0		; BCAB: 8D 12 D0
    sta COLPM1		; BCAE: 8D 13 D0
    sta COLPM2		; BCB1: 8D 14 D0
    sta COLPM3		; BCB4: 8D 15 D0
    lda colbakshadow		; BCB7: A5 97
    clc    		; BCB9: 18
    adc #$55		; BCBA: 69 55
    sta colbakshadow		; BCBC: 85 97
    and #$F7		; BCBE: 29 F7
    sta COLBK		; BCC0: 8D 1A D0
changecolorsdone	; Callers: BC7E BC85 -c BCC3
    pla    		; BCC3: 68
    tax    		; BCC4: AA
    pla    		; BCC5: 68
    rts    		; BCC6: 60
restorecolors		; Callers: B906 B970 B936 -c BCC7
    lda colpf2shadow2		; BCC7: A5 99
    sta COLPF2		; BCC9: 8D 18 D0
    lda colbakshadow2		; BCCC: A5 9A
    sta COLBK		; BCCE: 8D 1A D0
    lda colpmshadow2		; BCD1: A5 9B
    sta COLPM0		; BCD3: 8D 12 D0
    sta COLPM1		; BCD6: 8D 13 D0
    sta COLPM2		; BCD9: 8D 14 D0
    sta COLPM3		; BCDC: 8D 15 D0
    lda colortbl+6		; BCDF: AD 72 BD
    sta COLPF1		; BCE2: 8D 17 D0
    rts    		; BCE5: 60
unknown			; Callers: -c BCE6
    pha    		; BCE6: 48
    lda #$00		; BCE7: A9 00
    sta GLBABS		; BCE9: 8D E0 02
    lda #$B8		; BCEC: A9 B8
    sta GLBABS+1		; BCEE: 8D E1 02
    pla    		; BCF1: 68
cartinit		; Callers: -c BCF2 -v BFFE
    rts    		; BCF2: 60
    dta $0		; BCF3: 00
    dta $0		; BCF4: 00
    dta $0		; BCF5: 00
    dta $0		; BCF6: 00
    dta $0		; BCF7: 00
    dta $0		; BCF8: 00
    dta $0		; BCF9: 00
    dta $0		; BCFA: 00
    dta $0		; BCFB: 00
    dta $0		; BCFC: 00
    dta $0		; BCFD: 00
    dta $0		; BCFE: 00
    dta $0		; BCFF: 00
dlist			
    dta $70		; BD00: 70 <--- Data
    dta $70		; BD01: 70 <--- Data
    dta $70		; BD02: 70 <--- Data
    dta $70		; BD03: 70 <--- Data
    dta $70		; BD04: 70 <--- Data
    dta $4F		; BD05: 4F <--- Data
    dta $0		; BD06: 00 <--- Data
    dta $7		; BD07: 07 <--- Data
    dta $42		; BD08: 42 <--- Data
    dta $0		; BD09: 00 <--- Data
    dta $8		; BD0A: 08 <--- Data
    dta $4F		; BD0B: 4F <--- Data
    dta $0		; BD0C: 00 <--- Data
    dta $7		; BD0D: 07 <--- Data
    dta $F		; BD0E: 0F <--- Data
    dta $42		; BD0F: 42 <--- Data
    dta $20		; BD10: 20 <--- Data
    dta $8		; BD11: 08 <--- Data
    dta $4F		; BD12: 4F <--- Data
    dta $0		; BD13: 00 <--- Data
    dta $7		; BD14: 07 <--- Data
    dta $F		; BD15: 0F <--- Data
    dta $42		; BD16: 42 <--- Data
    dta $40		; BD17: 40 <--- Data
    dta $8		; BD18: 08 <--- Data
    dta $4F		; BD19: 4F <--- Data
    dta $0		; BD1A: 00 <--- Data
    dta $7		; BD1B: 07 <--- Data
    dta $F		; BD1C: 0F <--- Data
    dta $42		; BD1D: 42 <--- Data
    dta $60		; BD1E: 60 <--- Data
    dta $8		; BD1F: 08 <--- Data
    dta $4F		; BD20: 4F <--- Data
    dta $0		; BD21: 00 <--- Data
    dta $7		; BD22: 07 <--- Data
    dta $F		; BD23: 0F <--- Data
    dta $42		; BD24: 42 <--- Data
    dta $80		; BD25: 80 <--- Data
    dta $8		; BD26: 08 <--- Data
    dta $4F		; BD27: 4F <--- Data
    dta $0		; BD28: 00 <--- Data
    dta $7		; BD29: 07 <--- Data
    dta $F		; BD2A: 0F <--- Data
    dta $42		; BD2B: 42 <--- Data
    dta $A0		; BD2C: A0 <--- Data
    dta $8		; BD2D: 08 <--- Data
    dta $4F		; BD2E: 4F <--- Data
    dta $0		; BD2F: 00 <--- Data
    dta $7		; BD30: 07 <--- Data
    dta $F		; BD31: 0F <--- Data
    dta $42		; BD32: 42 <--- Data
    dta $C0		; BD33: C0 <--- Data
    dta $8		; BD34: 08 <--- Data
    dta $4F		; BD35: 4F <--- Data
    dta $0		; BD36: 00 <--- Data
    dta $7		; BD37: 07 <--- Data
    dta $F		; BD38: 0F <--- Data
    dta $42		; BD39: 42 <--- Data
    dta $E0		; BD3A: E0 <--- Data
    dta $8		; BD3B: 08 <--- Data
    dta $4F		; BD3C: 4F <--- Data
    dta $0		; BD3D: 00 <--- Data
    dta $7		; BD3E: 07 <--- Data
    dta $F		; BD3F: 0F <--- Data
    dta $42		; BD40: 42 <--- Data
    dta $0		; BD41: 00 <--- Data
    dta $9		; BD42: 09 <--- Data
    dta $4F		; BD43: 4F <--- Data
    dta $0		; BD44: 00 <--- Data
    dta $7		; BD45: 07 <--- Data
    dta $F		; BD46: 0F <--- Data
    dta $42		; BD47: 42 <--- Data
    dta $20		; BD48: 20 <--- Data
    dta $9		; BD49: 09 <--- Data
    dta $4F		; BD4A: 4F <--- Data
    dta $0		; BD4B: 00 <--- Data
    dta $7		; BD4C: 07 <--- Data
    dta $F		; BD4D: 0F <--- Data
    dta $42		; BD4E: 42 <--- Data
    dta $40		; BD4F: 40 <--- Data
    dta $9		; BD50: 09 <--- Data
    dta $4F		; BD51: 4F <--- Data
    dta $0		; BD52: 00 <--- Data
    dta $7		; BD53: 07 <--- Data
    dta $F		; BD54: 0F <--- Data
    dta $42		; BD55: 42 <--- Data
    dta $60		; BD56: 60 <--- Data
    dta $9		; BD57: 09 <--- Data
    dta $4F		; BD58: 4F <--- Data
    dta $0		; BD59: 00 <--- Data
    dta $7		; BD5A: 07 <--- Data
    dta $F		; BD5B: 0F <--- Data
    dta $42		; BD5C: 42 <--- Data
    dta $80		; BD5D: 80 <--- Data
    dta $9		; BD5E: 09 <--- Data
    dta $4F		; BD5F: 4F <--- Data
    dta $0		; BD60: 00 <--- Data
    dta $7		; BD61: 07 <--- Data
    dta $F		; BD62: 0F <--- Data
    dta $42		; BD63: 42 <--- Data
    dta $A0		; BD64: A0 <--- Data
    dta $9		; BD65: 09 <--- Data
    dta $4F		; BD66: 4F <--- Data
    dta $0		; BD67: 00 <--- Data
    dta $7		; BD68: 07 <--- Data
dlistjvb		
    dta $41		; BD69: 41 <--- Data
    dta $0		; BD6A: 00 <--- Data
    dta $BD		; BD6B: BD <--- Data
colortbl		
    dta $22		; BD6C: 22 Access: BB08 BADF <--- Data
    dta $44		; BD6D: 44 Access: B817 <--- Data
    dta $34		; BD6E: 34 <--- Data
    dta $24		; BD6F: 24 <--- Data
    dta $D4		; BD70: D4 <--- Data
    dta $84		; BD71: 84 <--- Data
    dta $A		; BD72: 0A Access: BCDF <--- Data
    dta $2		; BD73: 02 <--- Data
    dta $0		; BD74: 00 <--- Data
    dta $2		; BD75: 02 <--- Data
    dta $8		; BD76: 08 <--- Data
    dta $0		; BD77: 00 <--- Data
    dta $0		; BD78: 00
pokeytbl		
    dta $A0		; BD79: A0 Access: B81D <--- Data
    dta $A0		; BD7A: A0 <--- Data
    dta $B		; BD7B: 0B <--- Data
    dta $A0		; BD7C: A0 <--- Data
    dta $CE		; BD7D: CE <--- Data
    dta $A0		; BD7E: A0 <--- Data
    dta $5		; BD7F: 05 <--- Data
    dta $A0		; BD80: A0 <--- Data
    dta $78		; BD81: 78 <--- Data
antictbl		
    dta $0		; BD82: 00 Access: B823 <--- Data
    dta $0		; BD83: 00 <--- Data
dlistptr		
    dta $69		; BD84: 69 <--- Data
    dta $BD		; BD85: BD <--- Data
    dta $0		; BD86: 00 <--- Data
    dta $0		; BD87: 00 <--- Data
    dta $0		; BD88: 00 <--- Data
pmbaseptr		
    dta $8		; BD89: 08 <--- Data
    dta $0		; BD8A: 00 <--- Data
chbaseptr		
    dta $C		; BD8B: 0C <--- Data
pmtbl			
    dta $40		; BD8C: 40 Access: B811 <--- Data
    dta $60		; BD8D: 60 <--- Data
    dta $80		; BD8E: 80 <--- Data
    dta $A0		; BD8F: A0 <--- Data
    dta $0		; BD90: 00 <--- Data
    dta $0		; BD91: 00 <--- Data
    dta $0		; BD92: 00 <--- Data
    dta $0		; BD93: 00 <--- Data
    dta $3		; BD94: 03 <--- Data
    dta $3		; BD95: 03 <--- Data
    dta $3		; BD96: 03 <--- Data
    dta $3		; BD97: 03 <--- Data
customchars		
    dta $3		; BD98: 03 Access: B866 <--- Data
    dta $0		; BD99: 00 <--- Data
    dta $C		; BD9A: 0C <--- Data
    dta $0		; BD9B: 00 <--- Data
    dta $0		; BD9C: 00 <--- Data
    dta $30		; BD9D: 30 <--- Data
    dta $0		; BD9E: 00 <--- Data
    dta $C0		; BD9F: C0 <--- Data
    dta $C0		; BDA0: C0 <--- Data
    dta $0		; BDA1: 00 <--- Data
    dta $30		; BDA2: 30 <--- Data
    dta $0		; BDA3: 00 <--- Data
    dta $0		; BDA4: 00 <--- Data
    dta $C		; BDA5: 0C <--- Data
    dta $0		; BDA6: 00 <--- Data
    dta $3		; BDA7: 03 <--- Data
    dta $3		; BDA8: 03 <--- Data
    dta $3		; BDA9: 03 <--- Data
    dta $3		; BDAA: 03 <--- Data
    dta $0		; BDAB: 00 <--- Data
    dta $0		; BDAC: 00 <--- Data
    dta $3		; BDAD: 03 <--- Data
    dta $3		; BDAE: 03 <--- Data
    dta $3		; BDAF: 03 <--- Data
    dta $76		; BDB0: 76 <--- Data
    dta $DC		; BDB1: DC <--- Data
    dta $0		; BDB2: 00 <--- Data
    dta $7C		; BDB3: 7C <--- Data
    dta $66		; BDB4: 66 <--- Data
    dta $66		; BDB5: 66 <--- Data
    dta $66		; BDB6: 66 <--- Data
    dta $0		; BDB7: 00 <--- Data
    dta $FF		; BDB8: FF <--- Data
    dta $0		; BDB9: 00 <--- Data
    dta $0		; BDBA: 00 <--- Data
    dta $FF		; BDBB: FF <--- Data
    dta $0		; BDBC: 00 <--- Data
    dta $0		; BDBD: 00 <--- Data
    dta $FF		; BDBE: FF <--- Data
    dta $0		; BDBF: 00 <--- Data
    dta $0		; BDC0: 00 Access: B86C <--- Data
    dta $0		; BDC1: 00 <--- Data
    dta $0		; BDC2: 00 <--- Data
    dta $3C		; BDC3: 3C <--- Data
    dta $66		; BDC4: 66 <--- Data
    dta $66		; BDC5: 66 <--- Data
    dta $0		; BDC6: 00 <--- Data
    dta $18		; BDC7: 18 <--- Data
    dta $0		; BDC8: 00 <--- Data
    dta $40		; BDC9: 40 <--- Data
    dta $60		; BDCA: 60 <--- Data
    dta $30		; BDCB: 30 <--- Data
    dta $18		; BDCC: 18 <--- Data
    dta $C		; BDCD: 0C <--- Data
    dta $6		; BDCE: 06 <--- Data
    dta $0		; BDCF: 00 <--- Data
    dta $66		; BDD0: 66 <--- Data
    dta $DB		; BDD1: DB <--- Data
    dta $DB		; BDD2: DB <--- Data
    dta $DB		; BDD3: DB <--- Data
    dta $DB		; BDD4: DB <--- Data
    dta $0		; BDD5: 00 <--- Data
    dta $66		; BDD6: 66 <--- Data
    dta $66		; BDD7: 66 <--- Data
    dta $0		; BDD8: 00 <--- Data
    dta $0		; BDD9: 00 <--- Data
    dta $0		; BDDA: 00 <--- Data
    dta $10		; BDDB: 10 <--- Data
    dta $38		; BDDC: 38 <--- Data
    dta $6C		; BDDD: 6C <--- Data
    dta $C6		; BDDE: C6 <--- Data
    dta $0		; BDDF: 00 <--- Data
    dta $0		; BDE0: 00 <--- Data
    dta $0		; BDE1: 00 <--- Data
    dta $0		; BDE2: 00 <--- Data
    dta $0		; BDE3: 00 <--- Data
    dta $0		; BDE4: 00 <--- Data
    dta $0		; BDE5: 00 <--- Data
    dta $0		; BDE6: 00 <--- Data
    dta $7E		; BDE7: 7E <--- Data
    dta $0		; BDE8: 00 Access: B877 <--- Data
    dta $0		; BDE9: 00 <--- Data
    dta $76		; BDEA: 76 <--- Data
    dta $FC		; BDEB: FC <--- Data
    dta $6C		; BDEC: 6C <--- Data
    dta $6C		; BDED: 6C <--- Data
    dta $6C		; BDEE: 6C <--- Data
    dta $0		; BDEF: 00 <--- Data
    dta $7E		; BDF0: 7E Access: B87D <--- Data
    dta $0		; BDF1: 00 <--- Data
    dta $0		; BDF2: 00 <--- Data
    dta $0		; BDF3: 00 <--- Data
    dta $0		; BDF4: 00 <--- Data
    dta $0		; BDF5: 00 <--- Data
    dta $0		; BDF6: 00 <--- Data
    dta $0		; BDF7: 00 <--- Data
    dta $0		; BDF8: 00 Access: B883 <--- Data
    dta $3C		; BDF9: 3C <--- Data
    dta $66		; BDFA: 66 <--- Data
    dta $DB		; BDFB: DB <--- Data
    dta $DB		; BDFC: DB <--- Data
    dta $66		; BDFD: 66 <--- Data
    dta $3C		; BDFE: 3C <--- Data
    dta $0		; BDFF: 00 <--- Data
    dta $0		; BE00: 00 Access: B889 <--- Data
    dta $0		; BE01: 00 <--- Data
    dta $0		; BE02: 00 <--- Data
    dta $18		; BE03: 18 <--- Data
    dta $18		; BE04: 18 <--- Data
    dta $0		; BE05: 00 <--- Data
    dta $0		; BE06: 00 <--- Data
    dta $0		; BE07: 00 <--- Data
    dta $0		; BE08: 00 Access: B88F <--- Data
    dta $0		; BE09: 00 <--- Data
    dta $0		; BE0A: 00 <--- Data
    dta $0		; BE0B: 00 <--- Data
    dta $0		; BE0C: 00 <--- Data
    dta $3C		; BE0D: 3C <--- Data
    dta $66		; BE0E: 66 <--- Data
    dta $C3		; BE0F: C3 <--- Data
    dta $66		; BE10: 66 Access: B895 <--- Data
    dta $66		; BE11: 66 <--- Data
    dta $66		; BE12: 66 <--- Data
    dta $0		; BE13: 00 <--- Data
    dta $0		; BE14: 00 <--- Data
    dta $66		; BE15: 66 <--- Data
    dta $66		; BE16: 66 <--- Data
    dta $66		; BE17: 66 <--- Data
    dta $6		; BE18: 06 Access: B89B <--- Data
    dta $C		; BE19: 0C <--- Data
    dta $18		; BE1A: 18 <--- Data
    dta $36		; BE1B: 36 <--- Data
    dta $18		; BE1C: 18 <--- Data
    dta $C		; BE1D: 0C <--- Data
    dta $6		; BE1E: 06 <--- Data
    dta $0		; BE1F: 00 <--- Data
    dta $60		; BE20: 60 Access: B8A1 <--- Data
    dta $30		; BE21: 30 <--- Data
    dta $18		; BE22: 18 <--- Data
    dta $6C		; BE23: 6C <--- Data
    dta $18		; BE24: 18 <--- Data
    dta $30		; BE25: 30 <--- Data
    dta $60		; BE26: 60 <--- Data
    dta $0		; BE27: 00 <--- Data
    dta $0		; BE28: 00 Access: B8A7 <--- Data
    dta $18		; BE29: 18 <--- Data
    dta $18		; BE2A: 18 <--- Data
    dta $30		; BE2B: 30 <--- Data
    dta $0		; BE2C: 00 <--- Data
    dta $0		; BE2D: 00 <--- Data
    dta $0		; BE2E: 00 <--- Data
    dta $0		; BE2F: 00 <--- Data
stream			
    dta $16		; BE30: 16 <--- Data
    dta $1E		; BE31: 1E <--- Data
    dta $9D		; BE32: 9D <--- Data
    dta $B		; BE33: 0B <--- Data
    dta $83		; BE34: 83 <--- Data
    dta $A0		; BE35: A0 <--- Data
    dta $A0		; BE36: A0 <--- Data
    dta $A0		; BE37: A0 <--- Data
    dta $A0		; BE38: A0 <--- Data
    dta $A0		; BE39: A0 <--- Data
    dta $A0		; BE3A: A0 <--- Data
    dta $A0		; BE3B: A0 <--- Data
    dta $A0		; BE3C: A0 <--- Data
    dta $A0		; BE3D: A0 <--- Data
    dta $A0		; BE3E: A0 <--- Data
    dta $A0		; BE3F: A0 <--- Data
    dta $A0		; BE40: A0 <--- Data
    dta $A0		; BE41: A0 <--- Data
    dta $A0		; BE42: A0 <--- Data
    dta $A0		; BE43: A0 <--- Data
    dta $A0		; BE44: A0 <--- Data
    dta $A0		; BE45: A0 <--- Data
    dta $A0		; BE46: A0 <--- Data
    dta $A0		; BE47: A0 <--- Data
    dta $A0		; BE48: A0 <--- Data
    dta $A0		; BE49: A0 <--- Data
    dta $A0		; BE4A: A0 <--- Data
    dta $A0		; BE4B: A0 <--- Data
    dta $A0		; BE4C: A0 <--- Data
    dta $A0		; BE4D: A0 <--- Data
    dta $A0		; BE4E: A0 <--- Data
    dta $A0		; BE4F: A0 <--- Data
    dta $A0		; BE50: A0 <--- Data
    dta $A0		; BE51: A0 <--- Data
    dta $A0		; BE52: A0 <--- Data
    dta $A0		; BE53: A0 <--- Data
    dta $A0		; BE54: A0 <--- Data
    dta $A0		; BE55: A0 <--- Data
    dta $A0		; BE56: A0 <--- Data
    dta $20		; BE57: 20 <--- Data
    dta $20		; BE58: 20 <--- Data
    dta $41		; BE59: 41 <--- Data
    dta $54		; BE5A: 54 <--- Data
    dta $41		; BE5B: 41 <--- Data
    dta $52		; BE5C: 52 <--- Data
    dta $49		; BE5D: 49 <--- Data
    dta $20		; BE5E: 20 <--- Data
    dta $45		; BE5F: 45 <--- Data
    dta $44		; BE60: 44 <--- Data
    dta $55		; BE61: 55 <--- Data
    dta $43		; BE62: 43 <--- Data
    dta $41		; BE63: 41 <--- Data
    dta $54		; BE64: 54 <--- Data
    dta $49		; BE65: 49 <--- Data
    dta $4F		; BE66: 4F <--- Data
    dta $4E		; BE67: 4E <--- Data
    dta $41		; BE68: 41 <--- Data
    dta $4C		; BE69: 4C <--- Data
    dta $20		; BE6A: 20 <--- Data
    dta $53		; BE6B: 53 <--- Data
    dta $59		; BE6C: 59 <--- Data
    dta $53		; BE6D: 53 <--- Data
    dta $54		; BE6E: 54 <--- Data
    dta $45		; BE6F: 45 <--- Data
    dta $4D		; BE70: 4D <--- Data
    dta $20		; BE71: 20 <--- Data
    dta $20		; BE72: 20 <--- Data
    dta $A0		; BE73: A0 <--- Data
    dta $A0		; BE74: A0 <--- Data
    dta $A0		; BE75: A0 <--- Data
    dta $A0		; BE76: A0 <--- Data
    dta $A0		; BE77: A0 <--- Data
    dta $A0		; BE78: A0 <--- Data
    dta $A0		; BE79: A0 <--- Data
    dta $A0		; BE7A: A0 <--- Data
    dta $A0		; BE7B: A0 <--- Data
    dta $A0		; BE7C: A0 <--- Data
    dta $A0		; BE7D: A0 <--- Data
    dta $A0		; BE7E: A0 <--- Data
    dta $A0		; BE7F: A0 <--- Data
    dta $A0		; BE80: A0 <--- Data
    dta $A0		; BE81: A0 <--- Data
    dta $A0		; BE82: A0 <--- Data
    dta $A0		; BE83: A0 <--- Data
    dta $A0		; BE84: A0 <--- Data
    dta $A0		; BE85: A0 <--- Data
    dta $A0		; BE86: A0 <--- Data
    dta $A0		; BE87: A0 <--- Data
    dta $A0		; BE88: A0 <--- Data
    dta $A0		; BE89: A0 <--- Data
    dta $A0		; BE8A: A0 <--- Data
    dta $A0		; BE8B: A0 <--- Data
    dta $A0		; BE8C: A0 <--- Data
    dta $A0		; BE8D: A0 <--- Data
    dta $A0		; BE8E: A0 <--- Data
    dta $A0		; BE8F: A0 <--- Data
    dta $A0		; BE90: A0 <--- Data
    dta $A0		; BE91: A0 <--- Data
    dta $A0		; BE92: A0 <--- Data
    dta $A0		; BE93: A0 <--- Data
    dta $A0		; BE94: A0 <--- Data
    dta $D		; BE95: 0D <--- Data
    dta $50		; BE96: 50 <--- Data
    dta $75		; BE97: 75 <--- Data
    dta $74		; BE98: 74 <--- Data
    dta $20		; BE99: 20 <--- Data
    dta $6C		; BE9A: 6C <--- Data
    dta $65		; BE9B: 65 <--- Data
    dta $73		; BE9C: 73 <--- Data
    dta $73		; BE9D: 73 <--- Data
    dta $6F		; BE9E: 6F <--- Data
    dta $6E		; BE9F: 6E <--- Data
    dta $20		; BEA0: 20 <--- Data
    dta $69		; BEA1: 69 <--- Data
    dta $6E		; BEA2: 6E <--- Data
    dta $20		; BEA3: 20 <--- Data
    dta $74		; BEA4: 74 <--- Data
    dta $68		; BEA5: 68 <--- Data
    dta $65		; BEA6: 65 <--- Data
    dta $20		; BEA7: 20 <--- Data
    dta $74		; BEA8: 74 <--- Data
    dta $61		; BEA9: 61 <--- Data
    dta $70		; BEAA: 70 <--- Data
    dta $65		; BEAB: 65 <--- Data
    dta $20		; BEAC: 20 <--- Data
    dta $70		; BEAD: 70 <--- Data
    dta $6C		; BEAE: 6C <--- Data
    dta $61		; BEAF: 61 <--- Data
    dta $79		; BEB0: 79 <--- Data
    dta $65		; BEB1: 65 <--- Data
    dta $72		; BEB2: 72 <--- Data
    dta $2C		; BEB3: 2C <--- Data
    dta $D		; BEB4: 0D <--- Data
    dta $74		; BEB5: 74 <--- Data
    dta $68		; BEB6: 68 <--- Data
    dta $65		; BEB7: 65 <--- Data
    dta $6E		; BEB8: 6E <--- Data
    dta $20		; BEB9: 20 <--- Data
    dta $70		; BEBA: 70 <--- Data
    dta $75		; BEBB: 75 <--- Data
    dta $73		; BEBC: 73 <--- Data
    dta $68		; BEBD: 68 <--- Data
    dta $20		; BEBE: 20 <--- Data
    dta $50		; BEBF: 50 <--- Data
    dta $4C		; BEC0: 4C <--- Data
    dta $41		; BEC1: 41 <--- Data
    dta $59		; BEC2: 59 <--- Data
    dta $20		; BEC3: 20 <--- Data
    dta $61		; BEC4: 61 <--- Data
    dta $6E		; BEC5: 6E <--- Data
    dta $64		; BEC6: 64 <--- Data
    dta $20		; BEC7: 20 <--- Data
    dta $53		; BEC8: 53 <--- Data
    dta $54		; BEC9: 54 <--- Data
    dta $41		; BECA: 41 <--- Data
    dta $52		; BECB: 52 <--- Data
    dta $54		; BECC: 54 <--- Data
    dta $2E		; BECD: 2E <--- Data
    dta $D		; BECE: 0D <--- Data
    dta $D		; BECF: 0D <--- Data
    dta $54		; BED0: 54 <--- Data
    dta $6F		; BED1: 6F <--- Data
    dta $20		; BED2: 20 <--- Data
    dta $61		; BED3: 61 <--- Data
    dta $6E		; BED4: 6E <--- Data
    dta $73		; BED5: 73 <--- Data
    dta $77		; BED6: 77 <--- Data
    dta $65		; BED7: 65 <--- Data
    dta $72		; BED8: 72 <--- Data
    dta $20		; BED9: 20 <--- Data
    dta $71		; BEDA: 71 <--- Data
    dta $75		; BEDB: 75 <--- Data
    dta $65		; BEDC: 65 <--- Data
    dta $73		; BEDD: 73 <--- Data
    dta $74		; BEDE: 74 <--- Data
    dta $69		; BEDF: 69 <--- Data
    dta $6F		; BEE0: 6F <--- Data
    dta $6E		; BEE1: 6E <--- Data
    dta $73		; BEE2: 73 <--- Data
    dta $20		; BEE3: 20 <--- Data
    dta $74		; BEE4: 74 <--- Data
    dta $79		; BEE5: 79 <--- Data
    dta $70		; BEE6: 70 <--- Data
    dta $65		; BEE7: 65 <--- Data
    dta $3A		; BEE8: 3A <--- Data
    dta $D		; BEE9: 0D <--- Data
    dta $4C		; BEEA: 4C <--- Data
    dta $65		; BEEB: 65 <--- Data
    dta $66		; BEEC: 66 <--- Data
    dta $74		; BEED: 74 <--- Data
    dta $2D		; BEEE: 2D <--- Data
    dta $B1		; BEEF: B1 <--- Data
    dta $20		; BEF0: 20 <--- Data
    dta $20		; BEF1: 20 <--- Data
    dta $20		; BEF2: 20 <--- Data
    dta $20		; BEF3: 20 <--- Data
    dta $20		; BEF4: 20 <--- Data
    dta $4D		; BEF5: 4D <--- Data
    dta $69		; BEF6: 69 <--- Data
    dta $64		; BEF7: 64 <--- Data
    dta $64		; BEF8: 64 <--- Data
    dta $6C		; BEF9: 6C <--- Data
    dta $65		; BEFA: 65 <--- Data
    dta $2D		; BEFB: 2D <--- Data
    dta $B2		; BEFC: B2 <--- Data
    dta $20		; BEFD: 20 <--- Data
    dta $20		; BEFE: 20 <--- Data
    dta $20		; BEFF: 20 <--- Data
    dta $20		; BF00: 20 <--- Data
    dta $20		; BF01: 20 <--- Data
    dta $20		; BF02: 20 <--- Data
    dta $52		; BF03: 52 <--- Data
    dta $69		; BF04: 69 <--- Data
    dta $67		; BF05: 67 <--- Data
    dta $68		; BF06: 68 <--- Data
    dta $74		; BF07: 74 <--- Data
    dta $2D		; BF08: 2D <--- Data
    dta $B3		; BF09: B3 <--- Data
    dta $20		; BF0A: 20 <--- Data
    dta $20		; BF0B: 20 <--- Data
    dta $20		; BF0C: 20 <--- Data
    dta $20		; BF0D: 20 <--- Data
    dta $20		; BF0E: 20 <--- Data
    dta $20		; BF0F: 20 <--- Data
    dta $20		; BF10: 20 <--- Data
    dta $20		; BF11: 20 <--- Data
    dta $20		; BF12: 20 <--- Data
    dta $20		; BF13: 20 <--- Data
    dta $20		; BF14: 20 <--- Data
    dta $20		; BF15: 20 <--- Data
    dta $20		; BF16: 20 <--- Data
    dta $20		; BF17: 20 <--- Data
    dta $2D		; BF18: 2D <--- Data
    dta $6F		; BF19: 6F <--- Data
    dta $72		; BF1A: 72 <--- Data
    dta $2D		; BF1B: 2D <--- Data
    dta $D		; BF1C: 0D <--- Data
    dta $4C		; BF1D: 4C <--- Data
    dta $65		; BF1E: 65 <--- Data
    dta $66		; BF1F: 66 <--- Data
    dta $74		; BF20: 74 <--- Data
    dta $2D		; BF21: 2D <--- Data
    dta $B1		; BF22: B1 <--- Data
    dta $20		; BF23: 20 <--- Data
    dta $20		; BF24: 20 <--- Data
    dta $20		; BF25: 20 <--- Data
    dta $20		; BF26: 20 <--- Data
    dta $20		; BF27: 20 <--- Data
    dta $20		; BF28: 20 <--- Data
    dta $20		; BF29: 20 <--- Data
    dta $20		; BF2A: 20 <--- Data
    dta $20		; BF2B: 20 <--- Data
    dta $20		; BF2C: 20 <--- Data
    dta $20		; BF2D: 20 <--- Data
    dta $20		; BF2E: 20 <--- Data
    dta $20		; BF2F: 20 <--- Data
    dta $20		; BF30: 20 <--- Data
    dta $20		; BF31: 20 <--- Data
    dta $20		; BF32: 20 <--- Data
    dta $20		; BF33: 20 <--- Data
    dta $20		; BF34: 20 <--- Data
    dta $20		; BF35: 20 <--- Data
    dta $52		; BF36: 52 <--- Data
    dta $69		; BF37: 69 <--- Data
    dta $67		; BF38: 67 <--- Data
    dta $68		; BF39: 68 <--- Data
    dta $74		; BF3A: 74 <--- Data
    dta $2D		; BF3B: 2D <--- Data
    dta $B3		; BF3C: B3 <--- Data
    dta $D		; BF3D: 0D <--- Data
    dta $D		; BF3E: 0D <--- Data
    dta $20		; BF3F: 20 <--- Data
    dta $20		; BF40: 20 <--- Data
    dta $20		; BF41: 20 <--- Data
    dta $20		; BF42: 20 <--- Data
    dta $28		; BF43: 28 <--- Data
    dta $43		; BF44: 43 <--- Data
    dta $29		; BF45: 29 <--- Data
    dta $20		; BF46: 20 <--- Data
    dta $43		; BF47: 43 <--- Data
    dta $6F		; BF48: 6F <--- Data
    dta $70		; BF49: 70 <--- Data
    dta $79		; BF4A: 79 <--- Data
    dta $72		; BF4B: 72 <--- Data
    dta $69		; BF4C: 69 <--- Data
    dta $67		; BF4D: 67 <--- Data
    dta $68		; BF4E: 68 <--- Data
    dta $74		; BF4F: 74 <--- Data
    dta $20		; BF50: 20 <--- Data
    dta $41		; BF51: 41 <--- Data
    dta $74		; BF52: 74 <--- Data
    dta $61		; BF53: 61 <--- Data
    dta $72		; BF54: 72 <--- Data
    dta $69		; BF55: 69 <--- Data
    dta $20		; BF56: 20 <--- Data
    dta $31		; BF57: 31 <--- Data
    dta $39		; BF58: 39 <--- Data
    dta $37		; BF59: 37 <--- Data
    dta $39		; BF5A: 39 <--- Data
    dta $D		; BF5B: 0D <--- Data
    dta $0		; BF5C: 00
    dta $0		; BF5D: 00
    dta $0		; BF5E: 00
    dta $0		; BF5F: 00
    dta $0		; BF60: 00
    dta $0		; BF61: 00
    dta $0		; BF62: 00
    dta $0		; BF63: 00
    dta $0		; BF64: 00
    dta $0		; BF65: 00
    dta $0		; BF66: 00
    dta $0		; BF67: 00
    dta $0		; BF68: 00
    dta $0		; BF69: 00
    dta $0		; BF6A: 00
    dta $0		; BF6B: 00
    dta $0		; BF6C: 00
    dta $0		; BF6D: 00
    dta $0		; BF6E: 00
    dta $0		; BF6F: 00
    dta $0		; BF70: 00
    dta $0		; BF71: 00
    dta $0		; BF72: 00
    dta $0		; BF73: 00
    dta $0		; BF74: 00
    dta $0		; BF75: 00
    dta $0		; BF76: 00
    dta $0		; BF77: 00
    dta $0		; BF78: 00
    dta $0		; BF79: 00
    dta $0		; BF7A: 00
    dta $0		; BF7B: 00
    dta $0		; BF7C: 00
    dta $0		; BF7D: 00
    dta $0		; BF7E: 00
    dta $0		; BF7F: 00
    dta $0		; BF80: 00
    dta $0		; BF81: 00
    dta $0		; BF82: 00
    dta $0		; BF83: 00
    dta $0		; BF84: 00
    dta $0		; BF85: 00
    dta $0		; BF86: 00
    dta $0		; BF87: 00
    dta $0		; BF88: 00
    dta $0		; BF89: 00
    dta $0		; BF8A: 00
    dta $0		; BF8B: 00
    dta $0		; BF8C: 00
    dta $0		; BF8D: 00
    dta $0		; BF8E: 00
    dta $0		; BF8F: 00
    dta $0		; BF90: 00
    dta $0		; BF91: 00
    dta $0		; BF92: 00
    dta $0		; BF93: 00
    dta $0		; BF94: 00
    dta $0		; BF95: 00
    dta $0		; BF96: 00
    dta $0		; BF97: 00
    dta $0		; BF98: 00
    dta $0		; BF99: 00
    dta $0		; BF9A: 00
    dta $0		; BF9B: 00
    dta $0		; BF9C: 00
    dta $0		; BF9D: 00
    dta $0		; BF9E: 00
    dta $0		; BF9F: 00
    dta $0		; BFA0: 00
    dta $0		; BFA1: 00
    dta $0		; BFA2: 00
    dta $0		; BFA3: 00
    dta $0		; BFA4: 00
    dta $0		; BFA5: 00
    dta $0		; BFA6: 00
    dta $0		; BFA7: 00
    dta $0		; BFA8: 00
    dta $0		; BFA9: 00
    dta $0		; BFAA: 00
    dta $0		; BFAB: 00
    dta $0		; BFAC: 00
    dta $0		; BFAD: 00
    dta $0		; BFAE: 00
    dta $0		; BFAF: 00
    dta $0		; BFB0: 00
    dta $0		; BFB1: 00
    dta $0		; BFB2: 00
    dta $0		; BFB3: 00
    dta $0		; BFB4: 00
    dta $0		; BFB5: 00
    dta $0		; BFB6: 00
    dta $0		; BFB7: 00
    dta $0		; BFB8: 00
    dta $0		; BFB9: 00
    dta $0		; BFBA: 00
    dta $0		; BFBB: 00
    dta $0		; BFBC: 00
    dta $0		; BFBD: 00
    dta $0		; BFBE: 00
    dta $0		; BFBF: 00
    dta $0		; BFC0: 00
    dta $0		; BFC1: 00
    dta $0		; BFC2: 00
    dta $0		; BFC3: 00
    dta $0		; BFC4: 00
    dta $0		; BFC5: 00
    dta $0		; BFC6: 00
    dta $0		; BFC7: 00
    dta $0		; BFC8: 00
    dta $0		; BFC9: 00
    dta $0		; BFCA: 00
    dta $0		; BFCB: 00
    dta $0		; BFCC: 00
    dta $0		; BFCD: 00
    dta $0		; BFCE: 00
    dta $0		; BFCF: 00
    dta $0		; BFD0: 00
    dta $0		; BFD1: 00
    dta $0		; BFD2: 00
    dta $0		; BFD3: 00
    dta $0		; BFD4: 00
    dta $0		; BFD5: 00
    dta $0		; BFD6: 00
    dta $0		; BFD7: 00
    dta $0		; BFD8: 00
    dta $0		; BFD9: 00
    dta $0		; BFDA: 00
    dta $0		; BFDB: 00
    dta $0		; BFDC: 00
    dta $0		; BFDD: 00
    dta $0		; BFDE: 00
    dta $0		; BFDF: 00
    dta $0		; BFE0: 00
    dta $0		; BFE1: 00
    dta $0		; BFE2: 00
    dta $0		; BFE3: 00
    dta $0		; BFE4: 00
    dta $0		; BFE5: 00
    dta $0		; BFE6: 00
    dta $0		; BFE7: 00
    dta $0		; BFE8: 00
    dta $0		; BFE9: 00
    dta $0		; BFEA: 00
    dta $0		; BFEB: 00
    dta $0		; BFEC: 00
    dta $0		; BFED: 00
    dta $0		; BFEE: 00
    dta $0		; BFEF: 00
    dta $0		; BFF0: 00
    dta $0		; BFF1: 00
    dta $0		; BFF2: 00
    dta $0		; BFF3: 00
    dta $0		; BFF4: 00
    dta $0		; BFF5: 00
    dta $0		; BFF6: 00
    dta $0		; BFF7: 00
    dta $0		; BFF8: 00
    dta $0		; BFF9: 00
CARTSTARTVEC		
    dta $0		; BFFA: 00
    dta $B8		; BFFB: B8
    dta $0		; BFFC: 00
    dta $4		; BFFD: 04
CARTINITVEC		
    dta $F2		; BFFE: F2
    dta $BC		; BFFF: BC
