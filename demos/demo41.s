        .text

        .globl  _start
_start:
        la      r0,_main
        jal     r1,(r0)
_halt:
        bra     _halt

        .globl  __putc_uart
__putc_uart:
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
        brf     L3
        la      r2,L2
        jmp     (r2)
L3:
        la      r2,L1
        jmp     (r2)
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

        .globl  _putchar
_putchar:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        la      r2,L4
        jmp     (r2)
L4:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _getchar
_getchar:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L6:
        la      r0,16711937
        lbu     r0,0(r0)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        and     r0,r1
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r2,L7
        jmp     (r2)
L8:
        la      r2,L6
        jmp     (r2)
L7:
        la      r0,16711936
        lbu     r0,0(r0)
        la      r2,L5
        jmp     (r2)
L5:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _getc
_getc:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r0,_getchar
        jal     r1,(r0)
        la      r2,L9
        jmp     (r2)
L9:
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
L11:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L13
        la      r2,L12
        jmp     (r2)
L13:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L11
        jmp     (r2)
L12:
        lc      r0,10
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L10
        jmp     (r2)
L10:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __print_int
__print_int:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-11
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L17
        la      r2,L16
        jmp     (r2)
L17:
        lc      r0,45
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        sw      r0,9(fp)
L16:
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L20
        la      r2,L19
        jmp     (r2)
L20:
        lc      r0,48
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L14
        jmp     (r2)
L19:
        lc      r0,0
        sw      r0,-11(fp)
L21:
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L23
        la      r2,L22
        jmp     (r2)
L23:
        lc      r0,48
        push    r0
        lw      r0,9(fp)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        push    r1
        push    r0
        la      r0,__tc24r_mod
        jal     r1,(r0)
        add     sp,6
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        lc      r0,-8
        add     r0,fp
        push    r0
        lw      r0,-11(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        push    r1
        push    r0
        la      r0,__tc24r_div
        jal     r1,(r0)
        add     sp,6
        sw      r0,9(fp)
        lw      r0,-11(fp)
        push    r0
        add     r0,1
        sw      r0,-11(fp)
        pop     r0
        la      r2,L21
        jmp     (r2)
L22:
L24:
        lw      r0,-11(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L26
        la      r2,L25
        jmp     (r2)
L26:
        lw      r0,-11(fp)
        push    r0
        add     r0,-1
        sw      r0,-11(fp)
        pop     r0
        lc      r0,-8
        add     r0,fp
        push    r0
        lw      r0,-11(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L24
        jmp     (r2)
L25:
L14:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __print_hex
__print_hex:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-12
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L30
        la      r2,L29
        jmp     (r2)
L30:
        lc      r0,48
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L27
        jmp     (r2)
L29:
        lc      r0,0
        sw      r0,-9(fp)
L31:
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L33
        la      r2,L32
        jmp     (r2)
L33:
        lw      r0,9(fp)
        push    r0
        lc      r0,15
        mov     r1,r0
        pop     r0
        and     r0,r1
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L36
        la      r2,L34
        jmp     (r2)
L36:
        lc      r0,48
        push    r0
        lw      r0,-12(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        lc      r0,-6
        add     r0,fp
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        la      r2,L35
        jmp     (r2)
L34:
        lc      r0,87
        push    r0
        lw      r0,-12(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        lc      r0,-6
        add     r0,fp
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
L35:
        lw      r0,9(fp)
        push    r0
        lc      r0,4
        mov     r1,r0
        pop     r0
        srl     r0,r1
        sw      r0,9(fp)
        lw      r0,-9(fp)
        push    r0
        add     r0,1
        sw      r0,-9(fp)
        pop     r0
        la      r2,L31
        jmp     (r2)
L32:
L37:
        lw      r0,-9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L39
        la      r2,L38
        jmp     (r2)
L39:
        lw      r0,-9(fp)
        push    r0
        add     r0,-1
        sw      r0,-9(fp)
        pop     r0
        lc      r0,-6
        add     r0,fp
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L37
        jmp     (r2)
L38:
L27:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __print_str
__print_str:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L41:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L43
        la      r2,L42
        jmp     (r2)
L43:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L41
        jmp     (r2)
L42:
L40:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  __fmt_one
__fmt_one:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        lc      r0,100
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L47
        la      r2,L45
        jmp     (r2)
L47:
        lw      r0,12(fp)
        push    r0
        la      r0,__print_int
        jal     r1,(r0)
        add     sp,3
        la      r2,L46
        jmp     (r2)
L45:
        lw      r0,9(fp)
        push    r0
        lc      r0,120
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L50
        la      r2,L48
        jmp     (r2)
L50:
        lw      r0,12(fp)
        push    r0
        la      r0,__print_hex
        jal     r1,(r0)
        add     sp,3
        la      r2,L49
        jmp     (r2)
L48:
        lw      r0,9(fp)
        push    r0
        lc      r0,99
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L53
        la      r2,L51
        jmp     (r2)
L53:
        lw      r0,12(fp)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L52
        jmp     (r2)
L51:
        lw      r0,9(fp)
        push    r0
        lc      r0,115
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L56
        la      r2,L54
        jmp     (r2)
L56:
        lw      r0,12(fp)
        push    r0
        la      r0,__print_str
        jal     r1,(r0)
        add     sp,3
        la      r2,L55
        jmp     (r2)
L54:
        lw      r0,9(fp)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L59
        la      r2,L57
        jmp     (r2)
L59:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L58
        jmp     (r2)
L57:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L58:
L55:
L52:
L49:
L46:
L44:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf0
___tc24r_printf0:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L61:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L63
        la      r2,L62
        jmp     (r2)
L63:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L66
        la      r2,L64
        jmp     (r2)
L66:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L69
        la      r2,L67
        jmp     (r2)
L69:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L68
        jmp     (r2)
L67:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L68:
        la      r2,L65
        jmp     (r2)
L64:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L65:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L61
        jmp     (r2)
L62:
        lc      r0,0
        la      r2,L60
        jmp     (r2)
L60:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf1
___tc24r_printf1:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L71:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L73
        la      r2,L72
        jmp     (r2)
L73:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L76
        la      r2,L74
        jmp     (r2)
L76:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L79
        la      r2,L77
        jmp     (r2)
L79:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L78
        jmp     (r2)
L77:
        lw      r0,-3(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L82
        la      r2,L80
        jmp     (r2)
L82:
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L81
        jmp     (r2)
L80:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L81:
L78:
        la      r2,L75
        jmp     (r2)
L74:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L75:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L71
        jmp     (r2)
L72:
        lc      r0,0
        la      r2,L70
        jmp     (r2)
L70:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf2
___tc24r_printf2:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L84:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L86
        la      r2,L85
        jmp     (r2)
L86:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L89
        la      r2,L87
        jmp     (r2)
L89:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L92
        la      r2,L90
        jmp     (r2)
L92:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L91
        jmp     (r2)
L90:
        lw      r0,-3(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L95
        la      r2,L93
        jmp     (r2)
L95:
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L94
        jmp     (r2)
L93:
        lw      r0,-3(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L98
        la      r2,L96
        jmp     (r2)
L98:
        lw      r0,15(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L97
        jmp     (r2)
L96:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L97:
L94:
L91:
        la      r2,L88
        jmp     (r2)
L87:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L88:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L84
        jmp     (r2)
L85:
        lc      r0,0
        la      r2,L83
        jmp     (r2)
L83:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  ___tc24r_printf3
___tc24r_printf3:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L100:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L102
        la      r2,L101
        jmp     (r2)
L102:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L105
        la      r2,L103
        jmp     (r2)
L105:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,37
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L108
        la      r2,L106
        jmp     (r2)
L108:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        la      r2,L107
        jmp     (r2)
L106:
        lw      r0,-3(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L111
        la      r2,L109
        jmp     (r2)
L111:
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L110
        jmp     (r2)
L109:
        lw      r0,-3(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L114
        la      r2,L112
        jmp     (r2)
L114:
        lw      r0,15(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L113
        jmp     (r2)
L112:
        lw      r0,-3(fp)
        push    r0
        lc      r0,2
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L117
        la      r2,L115
        jmp     (r2)
L117:
        lw      r0,18(fp)
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__fmt_one
        jal     r1,(r0)
        add     sp,6
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L116
        jmp     (r2)
L115:
        lc      r0,37
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L116:
L113:
L110:
L107:
        la      r2,L104
        jmp     (r2)
L103:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        la      r0,__putc_uart
        jal     r1,(r0)
        add     sp,3
L104:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L100
        jmp     (r2)
L101:
        lc      r0,0
        la      r2,L99
        jmp     (r2)
L99:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _malloc
_malloc:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        lw      r0,9(fp)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L121
        la      r2,L120
        jmp     (r2)
L121:
        lc      r0,3
        sw      r0,9(fp)
L120:
        lw      r0,9(fp)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        push    r1
        push    r0
        la      r0,__tc24r_mod
        jal     r1,(r0)
        add     sp,6
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L124
        la      r2,L123
        jmp     (r2)
L124:
        lw      r0,9(fp)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        sw      r0,9(fp)
L123:
        la      r1,__heap_ptr
        lw      r0,0(r1)
        sw      r0,-6(fp)
        la      r1,__heap_ptr
        lw      r0,0(r1)
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        la      r1,__heap_ptr
        sw      r0,0(r1)
        lw      r0,-6(fp)
        la      r2,L118
        jmp     (r2)
L118:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _free
_free:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L125:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _calloc
_calloc:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        lw      r0,9(fp)
        push    r0
        lw      r0,12(fp)
        mov     r1,r0
        pop     r0
        mul     r0,r1
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        sw      r0,-6(fp)
        lc      r0,0
        sw      r0,-9(fp)
L127:
        lw      r0,-9(fp)
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L129
        la      r2,L128
        jmp     (r2)
L129:
        lc      r0,0
        push    r0
        lw      r0,-6(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-9(fp)
        push    r0
        add     r0,1
        sw      r0,-9(fp)
        pop     r0
        la      r2,L127
        jmp     (r2)
L128:
        lw      r0,-6(fp)
        la      r2,L126
        jmp     (r2)
L126:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _realloc
_realloc:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,12(fp)
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        la      r2,L130
        jmp     (r2)
L130:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _exit
_exit:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        _exit_halt:
        bra _exit_halt
L131:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _abs
_abs:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L135
        la      r2,L134
        jmp     (r2)
L135:
        lc      r0,0
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        la      r2,L132
        jmp     (r2)
L134:
        lw      r0,9(fp)
        la      r2,L132
        jmp     (r2)
L132:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _atoi
_atoi:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        lc      r0,0
        sw      r0,-3(fp)
        lc      r0,0
        sw      r0,-6(fp)
L137:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,32
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L139
        la      r2,L138
        jmp     (r2)
L139:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L137
        jmp     (r2)
L138:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,45
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L142
        la      r2,L140
        jmp     (r2)
L142:
        lc      r0,1
        sw      r0,-6(fp)
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L141
        jmp     (r2)
L140:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,43
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L145
        la      r2,L144
        jmp     (r2)
L145:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
L144:
L141:
L146:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,48
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L150
        la      r2,L148
        jmp     (r2)
L150:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,57
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L151
        la      r2,L148
        jmp     (r2)
L151:
        lc      r0,1
        la      r2,L149
        jmp     (r2)
L148:
        lc      r0,0
L149:
        ceq     r0,z
        brf     L152
        la      r2,L147
        jmp     (r2)
L152:
        lw      r0,-3(fp)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        mul     r0,r1
        push    r0
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lc      r0,48
        mov     r1,r0
        pop     r0
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,-3(fp)
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L146
        jmp     (r2)
L147:
        lw      r0,-6(fp)
        ceq     r0,z
        brf     L155
        la      r2,L154
        jmp     (r2)
L155:
        lc      r0,0
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        la      r2,L136
        jmp     (r2)
L154:
        lw      r0,-3(fp)
        la      r2,L136
        jmp     (r2)
L136:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _strlen
_strlen:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L157:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L159
        la      r2,L158
        jmp     (r2)
L159:
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        la      r2,L157
        jmp     (r2)
L158:
        lw      r0,-3(fp)
        la      r2,L156
        jmp     (r2)
L156:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _strcmp
_strcmp:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L161:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L167
        la      r2,L165
        jmp     (r2)
L167:
        lw      r0,12(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L168
        la      r2,L165
        jmp     (r2)
L168:
        lc      r0,1
        la      r2,L166
        jmp     (r2)
L165:
        lc      r0,0
L166:
        ceq     r0,z
        brf     L169
        la      r2,L163
        jmp     (r2)
L169:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,12(fp)
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L170
        la      r2,L163
        jmp     (r2)
L170:
        lc      r0,1
        la      r2,L164
        jmp     (r2)
L163:
        lc      r0,0
L164:
        ceq     r0,z
        brf     L171
        la      r2,L162
        jmp     (r2)
L171:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,12(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,12(fp)
        la      r2,L161
        jmp     (r2)
L162:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,12(fp)
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        la      r2,L160
        jmp     (r2)
L160:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _strncmp
_strncmp:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,0
        sw      r0,-3(fp)
L173:
        lw      r0,-3(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L181
        la      r2,L179
        jmp     (r2)
L181:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L182
        la      r2,L179
        jmp     (r2)
L182:
        lc      r0,1
        la      r2,L180
        jmp     (r2)
L179:
        lc      r0,0
L180:
        ceq     r0,z
        brf     L183
        la      r2,L177
        jmp     (r2)
L183:
        lw      r0,12(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L184
        la      r2,L177
        jmp     (r2)
L184:
        lc      r0,1
        la      r2,L178
        jmp     (r2)
L177:
        lc      r0,0
L178:
        ceq     r0,z
        brf     L185
        la      r2,L175
        jmp     (r2)
L185:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,12(fp)
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L186
        la      r2,L175
        jmp     (r2)
L186:
        lc      r0,1
        la      r2,L176
        jmp     (r2)
L175:
        lc      r0,0
L176:
        ceq     r0,z
        brf     L187
        la      r2,L174
        jmp     (r2)
L187:
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,12(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,12(fp)
        lw      r0,-3(fp)
        push    r0
        add     r0,1
        sw      r0,-3(fp)
        pop     r0
        la      r2,L173
        jmp     (r2)
L174:
        lw      r0,-3(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L190
        la      r2,L189
        jmp     (r2)
L190:
        lc      r0,0
        la      r2,L172
        jmp     (r2)
L189:
        lw      r0,9(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,12(fp)
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        la      r2,L172
        jmp     (r2)
L172:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _strcpy
_strcpy:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        sw      r0,-3(fp)
L192:
        lw      r0,12(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L194
        la      r2,L193
        jmp     (r2)
L194:
        lw      r0,12(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,12(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,12(fp)
        la      r2,L192
        jmp     (r2)
L193:
        lc      r0,0
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-3(fp)
        la      r2,L191
        jmp     (r2)
L191:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _strncpy
_strncpy:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        lw      r0,9(fp)
        sw      r0,-3(fp)
        lc      r0,0
        sw      r0,-6(fp)
L196:
        lw      r0,-6(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L200
        la      r2,L198
        jmp     (r2)
L200:
        lw      r0,12(fp)
        lbu     r0,0(r0)
        ceq     r0,z
        brf     L201
        la      r2,L198
        jmp     (r2)
L201:
        lc      r0,1
        la      r2,L199
        jmp     (r2)
L198:
        lc      r0,0
L199:
        ceq     r0,z
        brf     L202
        la      r2,L197
        jmp     (r2)
L202:
        lw      r0,12(fp)
        lbu     r0,0(r0)
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,12(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,12(fp)
        lw      r0,-6(fp)
        push    r0
        add     r0,1
        sw      r0,-6(fp)
        pop     r0
        la      r2,L196
        jmp     (r2)
L197:
L203:
        lw      r0,-6(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L205
        la      r2,L204
        jmp     (r2)
L205:
        lc      r0,0
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,9(fp)
        lw      r0,-6(fp)
        push    r0
        add     r0,1
        sw      r0,-6(fp)
        pop     r0
        la      r2,L203
        jmp     (r2)
L204:
        lw      r0,-3(fp)
        la      r2,L195
        jmp     (r2)
L195:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _memcpy
_memcpy:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        lw      r0,9(fp)
        sw      r0,-3(fp)
        lw      r0,12(fp)
        sw      r0,-6(fp)
        lc      r0,0
        sw      r0,-9(fp)
L207:
        lw      r0,-9(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L209
        la      r2,L208
        jmp     (r2)
L209:
        lw      r0,-6(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-9(fp)
        push    r0
        add     r0,1
        sw      r0,-9(fp)
        pop     r0
        la      r2,L207
        jmp     (r2)
L208:
        lw      r0,9(fp)
        la      r2,L206
        jmp     (r2)
L206:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _memset
_memset:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        lw      r0,9(fp)
        sw      r0,-3(fp)
        lc      r0,0
        sw      r0,-6(fp)
L211:
        lw      r0,-6(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L213
        la      r2,L212
        jmp     (r2)
L213:
        lw      r0,12(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lw      r0,-6(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-6(fp)
        push    r0
        add     r0,1
        sw      r0,-6(fp)
        pop     r0
        la      r2,L211
        jmp     (r2)
L212:
        lw      r0,9(fp)
        la      r2,L210
        jmp     (r2)
L210:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _memcmp
_memcmp:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-9
        lw      r0,9(fp)
        sw      r0,-3(fp)
        lw      r0,12(fp)
        sw      r0,-6(fp)
        lc      r0,0
        sw      r0,-9(fp)
L215:
        lw      r0,-9(fp)
        push    r0
        lw      r0,15(fp)
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L217
        la      r2,L216
        jmp     (r2)
L217:
        lw      r0,-3(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        lw      r0,-6(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L220
        la      r2,L219
        jmp     (r2)
L220:
        lw      r0,-3(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        push    r0
        lw      r0,-6(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        la      r2,L214
        jmp     (r2)
L219:
        lw      r0,-9(fp)
        push    r0
        add     r0,1
        sw      r0,-9(fp)
        pop     r0
        la      r2,L215
        jmp     (r2)
L216:
        lc      r0,0
        la      r2,L214
        jmp     (r2)
L214:
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
        add     sp,-11
        lc      r0,1
        sw      r0,-3(fp)
        la      r0,_S0
        push    r0
        la      r0,_atoi
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L224
        la      r2,L223
        jmp     (r2)
L224:
        lc      r0,0
        sw      r0,-3(fp)
L223:
        la      r0,_S1
        push    r0
        la      r0,_atoi
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,7
        push    r0
        lc      r0,0
        pop     r1
        sub     r0,r1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L227
        la      r2,L226
        jmp     (r2)
L227:
        lc      r0,0
        sw      r0,-3(fp)
L226:
        la      r0,_S2
        push    r0
        la      r0,_atoi
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,100
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L230
        la      r2,L229
        jmp     (r2)
L230:
        lc      r0,0
        sw      r0,-3(fp)
L229:
        la      r0,_S3
        push    r0
        la      r0,_strlen
        jal     r1,(r0)
        add     sp,3
        push    r0
        lc      r0,5
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L233
        la      r2,L232
        jmp     (r2)
L233:
        lc      r0,0
        sw      r0,-3(fp)
L232:
        la      r0,_S4
        push    r0
        la      r0,_strlen
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
        brf     L236
        la      r2,L235
        jmp     (r2)
L236:
        lc      r0,0
        sw      r0,-3(fp)
L235:
        la      r0,_S5
        push    r0
        la      r0,_S6
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L239
        la      r2,L238
        jmp     (r2)
L239:
        lc      r0,0
        sw      r0,-3(fp)
L238:
        la      r0,_S7
        push    r0
        la      r0,_S8
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L242
        la      r2,L241
        jmp     (r2)
L242:
        lc      r0,0
        sw      r0,-3(fp)
L241:
        la      r0,_S9
        push    r0
        la      r0,_S10
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L245
        la      r2,L244
        jmp     (r2)
L245:
        lc      r0,0
        sw      r0,-3(fp)
L244:
        la      r0,_S11
        push    r0
        lc      r0,-11
        add     r0,fp
        push    r0
        la      r0,_strcpy
        jal     r1,(r0)
        add     sp,6
        la      r0,_S12
        push    r0
        lc      r0,-11
        add     r0,fp
        push    r0
        la      r0,_strcmp
        jal     r1,(r0)
        add     sp,6
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L248
        la      r2,L247
        jmp     (r2)
L248:
        lc      r0,0
        sw      r0,-3(fp)
L247:
        lw      r0,-3(fp)
        ceq     r0,z
        brf     L251
        la      r2,L250
        jmp     (r2)
L251:
        la      r0,_S13
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,42
        la      r2,L221
        jmp     (r2)
L250:
        lc      r0,0
        la      r2,L221
        jmp     (r2)
L221:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

__tc24r_div:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        lc      r2,0
__tc24r_div_lp:
        cls     r0,r1
        brt     __tc24r_div_dn
        sub     r0,r1
        add     r2,1
        bra     __tc24r_div_lp
__tc24r_div_dn:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
__tc24r_mod:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
__tc24r_mod_lp:
        cls     r0,r1
        brt     __tc24r_mod_dn
        sub     r0,r1
        bra     __tc24r_mod_lp
__tc24r_mod_dn:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .data
__heap_ptr:
        .word   524288
_S0:
        .byte   52,50,0
_S1:
        .byte   45,55,0
_S2:
        .byte   32,32,49,48,48,0
_S3:
        .byte   104,101,108,108,111,0
_S4:
        .byte   0
_S5:
        .byte   97,98,99,0
_S6:
        .byte   97,98,99,0
_S7:
        .byte   97,98,100,0
_S8:
        .byte   97,98,99,0
_S9:
        .byte   97,98,99,0
_S10:
        .byte   97,98,100,0
_S11:
        .byte   79,75,0
_S12:
        .byte   79,75,0
_S13:
        .byte   68,52,49,79,75,10,0
