        .text

        .globl  _start
_start:
        la      r0,_main
        jal     r1,(r0)
_halt:
        bra     _halt

        .globl  _led_write
_led_write:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        la      r0,16711680
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
L0:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _uart_putc
_uart_putc:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        la      r0,16711936
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
L1:
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
        add     sp,-21
        lc      r0,1
        sw      r0,-3(fp)
        lc      r0,65
        sw      r0,-6(fp)
        lc      r0,66
        sw      r0,-9(fp)
        lw      r0,-6(fp)
        push    r0
        lc      r0,65
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L4
        lc      r0,0
        sw      r0,-3(fp)
L4:
        lw      r0,-9(fp)
        push    r0
        lc      r0,66
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L6
        lc      r0,0
        sw      r0,-3(fp)
L6:
        lc      r0,123
        sw      r0,-12(fp)
        lc      r0,-12
        add     r0,fp
        sw      r0,-15(fp)
        lw      r0,-15(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,123
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L8
        lc      r0,0
        sw      r0,-3(fp)
L8:
        la      r0,456
        push    r0
        lw      r0,-15(fp)
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,-12(fp)
        push    r0
        la      r0,456
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L10
        lc      r0,0
        sw      r0,-3(fp)
L10:
        lc      r0,77
        sw      r0,-18(fp)
        lc      r0,-18
        add     r0,fp
        sw      r0,-21(fp)
        lw      r0,-21(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,77
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brt     L12
        lc      r0,0
        sw      r0,-3(fp)
L12:
        la      r0,170
        push    r0
        la      r0,_led_write
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L14
        lc      r0,79
        push    r0
        la      r0,_uart_putc
        jal     r1,(r0)
        add     sp,3
        lc      r0,75
        push    r0
        la      r0,_uart_putc
        jal     r1,(r0)
        add     sp,3
        lc      r0,10
        push    r0
        la      r0,_uart_putc
        jal     r1,(r0)
        add     sp,3
L14:
        lw      r0,-3(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L16
        lc      r0,42
        bra     L2
L16:
        lc      r0,0
        bra     L2
L2:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .data
_LED_ADDR:
        .word   16711680
_UART_ADDR:
        .word   16711936
