
; 8025 to read text vram
;
; 8025 >xtal.bin
; 8025 -text >xtal.txt

PSP     Equ     0x0080

Mode    equ     2
BPSP    equ     2

        Org     0x100

        Section .text

        Mov     Bp,Sp
        Lea     Sp,[Bp-BPSP]

        Lds     Si,[TextMemory]
        Push    Cs
        Pop     Es
        Mov     Di,Memory
        Mov     Cx,80*25
        Cld
Reader:
        Lodsw
        Stosb
        Loop    Reader

        Push    Cs
        Pop     Ds

        Mov     [Bp-Mode],word 0
        Mov     Si,PSP
        Xor     Ax,Ax
        Lodsb
        Mov     Cx,Ax
        Or      Cx,Cx
        Jz      Enter
isMode:
        Lodsb
        Cmp     Al,'-'
        Jz      Option
        Cmp     Al,' '
        Jz      DDD
        Jmp     ErrorUsage
Option:
        Dec     Cx
        Jz      ErrorUsage
        Lodsb
        Cmp     Al,'t'
        Jnz     ErrorUsage
        Mov     [Bp-Mode],word 1
        Dec     Cx
        Jz      Enter
        Lodsb
        Cmp     Al,' '
        Jz      DDD
ErrorUsage:
        Mov     Dx,ErrorWrongUsage
        Mov     Al,1
        Jmp     Fatal
DDD:
        Loop    isMode
Enter:

        Mov     Si,Memory
        Mov     Cx,25
Writer:
        Push    Cx
        Mov     Bx,80
        Cmp     [BP-Mode],word 0
        Jz      Skip

        Push    Si
        Mov     Cx,Bx
        Xor     Bx,Bx
Scan:
        Lodsb
        Cmp     Al,0x21
        Jc      Next
        Mov     Bx,81
        Sub     Bx,Cx
Next:
        Loop    Scan
        Pop     Si
        Or      Bx,Bx
        Jz      Writer0
Skip:
        Mov     Cx,Bx
Writer1:
        Lodsb
        Mov     Ah,0x02
        Mov     Dl,Al
        Int     0x21
        Loop    Writer1
Writer0:
        Mov     Ax,80
        Sub     Ax,Bx
        Add     Si,Ax
        Mov     Ah,0x02
        Mov     Dl,0x0d
        Int     0x21
        Mov     Dl,0x0a
        Int     0x21
        Pop     Cx
        Loop    Writer

        Int     3

        Xor     Al,Al
        Jmp     Exit
Fatal:
        Mov     Ah,0x09
        Int     0x21
Exit:
        Mov     Ah,0x4c
        Int     0x21

        Section .data

TextMemory:
        Dw      0
        Dw      0xb800
ErrorWrongUsage:
        Db      "Wrong usage",0x0d,0x0a,'$'

        Section .bss

Memory:
        Resb    80*25

