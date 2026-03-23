        .text

        .globl  _start
_start:
        la      r0,_main
        jal     r1,(r0)
_halt:
        bra     _halt

        .globl  _putc
_putc:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L1:
        la      r0,16711937
        lbu     r0,0(r0)
        push    r0
        la      r0,128
        mov     r1,r0
        pop     r0
        and     r0,r1
        ceq     r0,z
        brt     L2
        bra     L1
L2:
        lw      r0,9(fp)
        push    r0
        la      r0,16711936
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
L0:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _puts
_puts:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L4:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brt     L5
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,_putc
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        bra     L4
L5:
L3:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _is_even
_is_even:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L8
        lc      r0,1
        bra     L6
L8:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        sub     r0,r1
        push    r0
        la      r0,_is_odd
        jal     r1,(r0)
        add     sp,3
        bra     L6
L6:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _is_odd
_is_odd:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L11
        lc      r0,0
        bra     L9
L11:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        sub     r0,r1
        push    r0
        la      r0,_is_even
        jal     r1,(r0)
        add     sp,3
        bra     L9
L9:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _main
_main:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,1
        sw      r0,-3(fp)
        lc      r0,0
        push    r0
        la      r0,_is_even
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L14
        lc      r0,0
        sw      r0,-3(fp)
L14:
        lc      r0,4
        push    r0
        la      r0,_is_even
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L16
        lc      r0,0
        sw      r0,-3(fp)
L16:
        lc      r0,3
        push    r0
        la      r0,_is_even
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L18
        lc      r0,0
        sw      r0,-3(fp)
L18:
        lc      r0,3
        push    r0
        la      r0,_is_odd
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L20
        lc      r0,0
        sw      r0,-3(fp)
L20:
        lc      r0,4
        push    r0
        la      r0,_is_odd
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L22
        lc      r0,0
        sw      r0,-3(fp)
L22:
        lw      r0,-3(fp)
        ceq     r0,z
        brt     L24
        la      r0,_S0
        push    r0
        la      r0,_puts
        jal     r1,(r0)
        add     sp,3
        lc      r0,42
        bra     L12
L24:
        lc      r0,0
        bra     L12
L12:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .data
_S0:
        .byte   68,50,55,79,75,10,0
