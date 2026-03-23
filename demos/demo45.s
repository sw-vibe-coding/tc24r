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

        .globl  _make_nil
_make_nil:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,15
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lc      r0,3
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,-3(fp)
        la      r2,L221
        jmp     (r2)
L221:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _make_num
_make_num:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,15
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lc      r0,0
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,-3(fp)
        la      r2,L222
        jmp     (r2)
L222:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _make_sym
_make_sym:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,15
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lc      r0,1
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,-3(fp)
        la      r2,L223
        jmp     (r2)
L223:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _cons
_cons:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lc      r0,15
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lc      r0,2
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,9
        pop     r1
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,12(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,12
        pop     r1
        add     r0,r1
        mov     r1,r0
        pop     r0
        sw      r0,0(r1)
        lw      r0,-3(fp)
        la      r2,L224
        jmp     (r2)
L224:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _car
_car:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        lc      r0,9
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L225
        jmp     (r2)
L225:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _cdr
_cdr:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        lc      r0,12
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L226
        jmp     (r2)
L226:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _atom
_atom:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,2
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        la      r2,L227
        jmp     (r2)
L227:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _null
_null:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        la      r2,L228
        jmp     (r2)
L228:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _print_val
_print_val:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L232
        la      r2,L230
        jmp     (r2)
L232:
        lw      r0,9(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S0
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r2,L231
        jmp     (r2)
L230:
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L235
        la      r2,L233
        jmp     (r2)
L235:
        lw      r0,9(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_S1
        push    r0
        la      r0,___tc24r_printf1
        jal     r1,(r0)
        add     sp,6
        la      r2,L234
        jmp     (r2)
L233:
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L238
        la      r2,L236
        jmp     (r2)
L238:
        la      r0,_S2
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r2,L237
        jmp     (r2)
L236:
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,2
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L241
        la      r2,L240
        jmp     (r2)
L241:
        la      r0,_S3
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        lc      r0,9
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_print_val
        jal     r1,(r0)
        add     sp,3
        lw      r0,9(fp)
        push    r0
        lc      r0,12
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-3(fp)
L242:
        lw      r0,-3(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,2
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L244
        la      r2,L243
        jmp     (r2)
L244:
        la      r0,_S4
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        push    r0
        lc      r0,9
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        la      r0,_print_val
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        push    r0
        lc      r0,12
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-3(fp)
        la      r2,L242
        jmp     (r2)
L243:
        lw      r0,-3(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L247
        la      r2,L246
        jmp     (r2)
L247:
        la      r0,_S5
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-3(fp)
        push    r0
        la      r0,_print_val
        jal     r1,(r0)
        add     sp,3
L246:
        la      r0,_S6
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
L240:
L237:
L234:
L231:
L229:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _peek
_peek:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        la      r1,__input
        lw      r0,0(r1)
        push    r0
        la      r1,__pos
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        la      r2,L248
        jmp     (r2)
L248:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _next
_next:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
        la      r1,__input
        lw      r0,0(r1)
        push    r0
        la      r1,__pos
        lw      r0,0(r1)
        mov     r1,r0
        pop     r0
        add     r0,r1
        lbu     r0,0(r0)
        sw      r0,-3(fp)
        la      r1,__pos
        lw      r0,0(r1)
        push    r0
        add     r0,1
        la      r1,__pos
        sw      r0,0(r1)
        pop     r0
        lw      r0,-3(fp)
        la      r2,L249
        jmp     (r2)
L249:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _skip_ws
_skip_ws:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
L251:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,32
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L257
        la      r2,L255
        jmp     (r2)
L257:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L258
        la      r2,L255
        jmp     (r2)
L258:
        lc      r0,0
        la      r2,L256
        jmp     (r2)
L255:
        lc      r0,1
L256:
        ceq     r0,z
        brt     L259
        la      r2,L253
        jmp     (r2)
L259:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,9
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brt     L260
        la      r2,L253
        jmp     (r2)
L260:
        lc      r0,0
        la      r2,L254
        jmp     (r2)
L253:
        lc      r0,1
L254:
        ceq     r0,z
        brf     L261
        la      r2,L252
        jmp     (r2)
L261:
        la      r0,_next
        jal     r1,(r0)
        la      r2,L251
        jmp     (r2)
L252:
L250:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _read_list
_read_list:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-6
        la      r0,_skip_ws
        jal     r1,(r0)
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,41
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L265
        la      r2,L264
        jmp     (r2)
L265:
        la      r0,_next
        jal     r1,(r0)
        la      r1,_NIL
        lw      r0,0(r1)
        la      r2,L262
        jmp     (r2)
L264:
        la      r0,_read_val
        jal     r1,(r0)
        sw      r0,-3(fp)
        la      r0,_read_list
        jal     r1,(r0)
        sw      r0,-6(fp)
        lw      r0,-6(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r0,_cons
        jal     r1,(r0)
        add     sp,6
        la      r2,L262
        jmp     (r2)
L262:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _read_val
_read_val:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-31
        la      r0,_skip_ws
        jal     r1,(r0)
        la      r0,_peek
        jal     r1,(r0)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        push    r0
        lc      r0,48
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L273
        la      r2,L271
        jmp     (r2)
L273:
        lw      r0,-3(fp)
        push    r0
        lc      r0,57
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L274
        la      r2,L271
        jmp     (r2)
L274:
        lc      r0,1
        la      r2,L272
        jmp     (r2)
L271:
        lc      r0,0
L272:
        ceq     r0,z
        brt     L275
        la      r2,L269
        jmp     (r2)
L275:
        lw      r0,-3(fp)
        push    r0
        lc      r0,45
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L280
        la      r2,L278
        jmp     (r2)
L280:
        la      r1,__input
        lw      r0,0(r1)
        push    r0
        la      r1,__pos
        lw      r0,0(r1)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
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
        brf     L281
        la      r2,L278
        jmp     (r2)
L281:
        lc      r0,1
        la      r2,L279
        jmp     (r2)
L278:
        lc      r0,0
L279:
        ceq     r0,z
        brf     L282
        la      r2,L276
        jmp     (r2)
L282:
        la      r1,__input
        lw      r0,0(r1)
        push    r0
        la      r1,__pos
        lw      r0,0(r1)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
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
        brf     L283
        la      r2,L276
        jmp     (r2)
L283:
        lc      r0,1
        la      r2,L277
        jmp     (r2)
L276:
        lc      r0,0
L277:
        ceq     r0,z
        brt     L284
        la      r2,L269
        jmp     (r2)
L284:
        lc      r0,0
        la      r2,L270
        jmp     (r2)
L269:
        lc      r0,1
L270:
        ceq     r0,z
        brf     L285
        la      r2,L268
        jmp     (r2)
L285:
        lc      r0,1
        sw      r0,-6(fp)
        lw      r0,-3(fp)
        push    r0
        lc      r0,45
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L288
        la      r2,L287
        jmp     (r2)
L288:
        lc      r0,1
        push    r0
        lc      r0,0
        pop     r1
        sub     r0,r1
        sw      r0,-6(fp)
        la      r0,_next
        jal     r1,(r0)
L287:
        lc      r0,0
        sw      r0,-9(fp)
L289:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,48
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L293
        la      r2,L291
        jmp     (r2)
L293:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,57
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L294
        la      r2,L291
        jmp     (r2)
L294:
        lc      r0,1
        la      r2,L292
        jmp     (r2)
L291:
        lc      r0,0
L292:
        ceq     r0,z
        brf     L295
        la      r2,L290
        jmp     (r2)
L295:
        lw      r0,-9(fp)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        mul     r0,r1
        push    r0
        la      r0,_next
        jal     r1,(r0)
        push    r0
        lc      r0,48
        mov     r1,r0
        pop     r0
        sub     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,-9(fp)
        la      r2,L289
        jmp     (r2)
L290:
        lw      r0,-9(fp)
        push    r0
        lw      r0,-6(fp)
        mov     r1,r0
        pop     r0
        mul     r0,r1
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L266
        jmp     (r2)
L268:
        lw      r0,-3(fp)
        push    r0
        lc      r0,40
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L298
        la      r2,L297
        jmp     (r2)
L298:
        la      r0,_next
        jal     r1,(r0)
        la      r0,_read_list
        jal     r1,(r0)
        la      r2,L266
        jmp     (r2)
L297:
        lc      r0,0
        sw      r0,-28(fp)
L299:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L311
        la      r2,L309
        jmp     (r2)
L311:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,32
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L312
        la      r2,L309
        jmp     (r2)
L312:
        lc      r0,1
        la      r2,L310
        jmp     (r2)
L309:
        lc      r0,0
L310:
        ceq     r0,z
        brf     L313
        la      r2,L307
        jmp     (r2)
L313:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,41
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L314
        la      r2,L307
        jmp     (r2)
L314:
        lc      r0,1
        la      r2,L308
        jmp     (r2)
L307:
        lc      r0,0
L308:
        ceq     r0,z
        brf     L315
        la      r2,L305
        jmp     (r2)
L315:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,40
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L316
        la      r2,L305
        jmp     (r2)
L316:
        lc      r0,1
        la      r2,L306
        jmp     (r2)
L305:
        lc      r0,0
L306:
        ceq     r0,z
        brf     L317
        la      r2,L303
        jmp     (r2)
L317:
        la      r0,_peek
        jal     r1,(r0)
        push    r0
        lc      r0,10
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L318
        la      r2,L303
        jmp     (r2)
L318:
        lc      r0,1
        la      r2,L304
        jmp     (r2)
L303:
        lc      r0,0
L304:
        ceq     r0,z
        brf     L319
        la      r2,L301
        jmp     (r2)
L319:
        lw      r0,-28(fp)
        push    r0
        lc      r0,15
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L320
        la      r2,L301
        jmp     (r2)
L320:
        lc      r0,1
        la      r2,L302
        jmp     (r2)
L301:
        lc      r0,0
L302:
        ceq     r0,z
        brf     L321
        la      r2,L300
        jmp     (r2)
L321:
        la      r0,_next
        jal     r1,(r0)
        push    r0
        lc      r0,-25
        add     r0,fp
        push    r0
        lw      r0,-28(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-28(fp)
        push    r0
        add     r0,1
        sw      r0,-28(fp)
        pop     r0
        la      r2,L299
        jmp     (r2)
L300:
        lc      r0,0
        push    r0
        lc      r0,-25
        add     r0,fp
        push    r0
        lw      r0,-28(fp)
        mov     r1,r0
        pop     r0
        add     r0,r1
        mov     r1,r0
        pop     r0
        sb      r0,0(r1)
        lw      r0,-28(fp)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        la      r0,_malloc
        jal     r1,(r0)
        add     sp,3
        sw      r0,-31(fp)
        lc      r0,-25
        add     r0,fp
        push    r0
        lw      r0,-31(fp)
        push    r0
        la      r0,_strcpy
        jal     r1,(r0)
        add     sp,6
        lw      r0,-31(fp)
        push    r0
        la      r0,_make_sym
        jal     r1,(r0)
        add     sp,3
        la      r2,L266
        jmp     (r2)
L266:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _read_str
_read_str:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        la      r1,__input
        sw      r0,0(r1)
        lc      r0,0
        la      r1,__pos
        sw      r0,0(r1)
        la      r0,_read_val
        jal     r1,(r0)
        la      r2,L322
        jmp     (r2)
L322:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _env_lookup
_env_lookup:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-3
L324:
        lw      r0,12(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,2
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L326
        la      r2,L325
        jmp     (r2)
L326:
        lw      r0,12(fp)
        push    r0
        lc      r0,9
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,-3(fp)
        lw      r0,9(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,9
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L329
        la      r2,L328
        jmp     (r2)
L329:
        lw      r0,-3(fp)
        push    r0
        lc      r0,12
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        la      r2,L323
        jmp     (r2)
L328:
        lw      r0,12(fp)
        push    r0
        lc      r0,12
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        sw      r0,12(fp)
        la      r2,L324
        jmp     (r2)
L325:
        la      r1,_NIL
        lw      r0,0(r1)
        la      r2,L323
        jmp     (r2)
L323:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _env_bind
_env_bind:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,15(fp)
        push    r0
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_cons
        jal     r1,(r0)
        add     sp,6
        push    r0
        la      r0,_cons
        jal     r1,(r0)
        add     sp,6
        la      r2,L330
        jmp     (r2)
L330:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _evlis
_evlis:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r0,9(fp)
        push    r0
        la      r0,_null
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        brf     L334
        la      r2,L333
        jmp     (r2)
L334:
        la      r1,_NIL
        lw      r0,0(r1)
        la      r2,L331
        jmp     (r2)
L333:
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_evlis
        jal     r1,(r0)
        add     sp,6
        push    r0
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        push    r0
        la      r0,_cons
        jal     r1,(r0)
        add     sp,6
        la      r2,L331
        jmp     (r2)
L331:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _eval
_eval:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        add     sp,-18
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L338
        la      r2,L337
        jmp     (r2)
L338:
        lw      r0,9(fp)
        la      r2,L335
        jmp     (r2)
L337:
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,3
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L341
        la      r2,L340
        jmp     (r2)
L341:
        lw      r0,9(fp)
        la      r2,L335
        jmp     (r2)
L340:
        lw      r0,9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L344
        la      r2,L343
        jmp     (r2)
L344:
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r0,_env_lookup
        jal     r1,(r0)
        add     sp,6
        la      r2,L335
        jmp     (r2)
L343:
        lw      r0,9(fp)
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        sw      r0,-3(fp)
        lw      r0,9(fp)
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        sw      r0,-6(fp)
        lw      r0,-3(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L347
        la      r2,L346
        jmp     (r2)
L347:
        la      r0,_S7
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L350
        la      r2,L349
        jmp     (r2)
L350:
        lw      r0,-6(fp)
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L349:
        la      r0,_S8
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L353
        la      r2,L352
        jmp     (r2)
L353:
        lw      r0,12(fp)
        push    r0
        lw      r0,-6(fp)
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-9(fp)
        lw      r0,-9(fp)
        push    r0
        la      r0,_null
        jal     r1,(r0)
        add     sp,3
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L358
        la      r2,L356
        jmp     (r2)
L358:
        lw      r0,-9(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L361
        la      r2,L359
        jmp     (r2)
L361:
        lw      r0,-9(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L362
        la      r2,L359
        jmp     (r2)
L362:
        lc      r0,1
        la      r2,L360
        jmp     (r2)
L359:
        lc      r0,0
L360:
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L363
        la      r2,L356
        jmp     (r2)
L363:
        lc      r0,1
        la      r2,L357
        jmp     (r2)
L356:
        lc      r0,0
L357:
        ceq     r0,z
        brf     L364
        la      r2,L354
        jmp     (r2)
L364:
        lw      r0,12(fp)
        push    r0
        lw      r0,-6(fp)
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        la      r2,L335
        jmp     (r2)
        la      r2,L355
        jmp     (r2)
L354:
        lw      r0,12(fp)
        push    r0
        lw      r0,-6(fp)
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        la      r2,L335
        jmp     (r2)
L355:
L352:
L346:
        lw      r0,12(fp)
        push    r0
        lw      r0,-6(fp)
        push    r0
        la      r0,_evlis
        jal     r1,(r0)
        add     sp,6
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        sw      r0,-15(fp)
        lw      r0,-12(fp)
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        sw      r0,-18(fp)
        lw      r0,-3(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,1
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L367
        la      r2,L366
        jmp     (r2)
L367:
        la      r0,_S9
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L370
        la      r2,L369
        jmp     (r2)
L370:
        lw      r0,-15(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-18(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        add     r0,r1
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L369:
        la      r0,_S10
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L373
        la      r2,L372
        jmp     (r2)
L373:
        lw      r0,-15(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-18(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        sub     r0,r1
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L372:
        la      r0,_S11
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L376
        la      r2,L375
        jmp     (r2)
L376:
        lw      r0,-15(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-18(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        mul     r0,r1
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L375:
        la      r0,_S12
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L379
        la      r2,L378
        jmp     (r2)
L379:
        lw      r0,-15(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-18(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        push    r1
        push    r0
        la      r0,__tc24r_div
        jal     r1,(r0)
        add     sp,6
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L378:
        la      r0,_S13
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L382
        la      r2,L381
        jmp     (r2)
L382:
        lw      r0,-18(fp)
        push    r0
        lw      r0,-15(fp)
        push    r0
        la      r0,_cons
        jal     r1,(r0)
        add     sp,6
        la      r2,L335
        jmp     (r2)
L381:
        la      r0,_S14
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L385
        la      r2,L384
        jmp     (r2)
L385:
        lw      r0,-15(fp)
        push    r0
        la      r0,_car
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L384:
        la      r0,_S15
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L388
        la      r2,L387
        jmp     (r2)
L388:
        lw      r0,-15(fp)
        push    r0
        la      r0,_cdr
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L387:
        la      r0,_S16
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L391
        la      r2,L390
        jmp     (r2)
L391:
        lw      r0,-15(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L396
        la      r2,L394
        jmp     (r2)
L396:
        lw      r0,-18(fp)
        lw      r0,0(r0)
        push    r0
        lc      r0,0
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L397
        la      r2,L394
        jmp     (r2)
L397:
        lc      r0,1
        la      r2,L395
        jmp     (r2)
L394:
        lc      r0,0
L395:
        ceq     r0,z
        brf     L398
        la      r2,L393
        jmp     (r2)
L398:
        lw      r0,-15(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lw      r0,-18(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L393:
        la      r1,_NIL
        lw      r0,0(r1)
        la      r2,L335
        jmp     (r2)
L390:
        la      r0,_S17
        push    r0
        lw      r0,-3(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L401
        la      r2,L400
        jmp     (r2)
L401:
        lw      r0,-15(fp)
        push    r0
        la      r0,_atom
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_make_num
        jal     r1,(r0)
        add     sp,3
        la      r2,L335
        jmp     (r2)
L400:
L366:
        la      r1,_NIL
        lw      r0,0(r1)
        la      r2,L335
        jmp     (r2)
L335:
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
        add     sp,-30
        lc      r0,1
        sw      r0,-3(fp)
        la      r0,_make_nil
        jal     r1,(r0)
        la      r1,_NIL
        sw      r0,0(r1)
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S18
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-6(fp)
        lw      r0,-6(fp)
        push    r0
        la      r0,_print_val
        jal     r1,(r0)
        add     sp,3
        la      r0,_S19
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-6(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L405
        la      r2,L404
        jmp     (r2)
L405:
        lc      r0,0
        sw      r0,-3(fp)
L404:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S20
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-9(fp)
        lw      r0,-9(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L408
        la      r2,L407
        jmp     (r2)
L408:
        lc      r0,0
        sw      r0,-3(fp)
L407:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S21
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-12(fp)
        lw      r0,-12(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L411
        la      r2,L410
        jmp     (r2)
L411:
        lc      r0,0
        sw      r0,-3(fp)
L410:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S22
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-15(fp)
        lw      r0,-15(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L414
        la      r2,L413
        jmp     (r2)
L414:
        lc      r0,0
        sw      r0,-3(fp)
L413:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S23
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-18(fp)
        lw      r0,-18(fp)
        push    r0
        la      r0,_print_val
        jal     r1,(r0)
        add     sp,3
        la      r0,_S24
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        la      r0,_S25
        push    r0
        lw      r0,-18(fp)
        push    r0
        lc      r0,6
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
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
        brf     L417
        la      r2,L416
        jmp     (r2)
L417:
        lc      r0,0
        sw      r0,-3(fp)
L416:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S26
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-21(fp)
        lw      r0,-21(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L420
        la      r2,L419
        jmp     (r2)
L420:
        lc      r0,0
        sw      r0,-3(fp)
L419:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S27
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-24(fp)
        lw      r0,-24(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L423
        la      r2,L422
        jmp     (r2)
L423:
        lc      r0,0
        sw      r0,-3(fp)
L422:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S28
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-27(fp)
        lw      r0,-27(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L426
        la      r2,L425
        jmp     (r2)
L426:
        lc      r0,0
        sw      r0,-3(fp)
L425:
        la      r1,_NIL
        lw      r0,0(r1)
        push    r0
        la      r0,_S29
        push    r0
        la      r0,_read_str
        jal     r1,(r0)
        add     sp,3
        push    r0
        la      r0,_eval
        jal     r1,(r0)
        add     sp,6
        sw      r0,-30(fp)
        lw      r0,-30(fp)
        push    r0
        la      r0,_print_val
        jal     r1,(r0)
        add     sp,3
        la      r0,_S30
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lw      r0,-30(fp)
        push    r0
        lc      r0,3
        pop     r1
        add     r0,r1
        lw      r0,0(r0)
        push    r0
        lc      r0,42
        mov     r1,r0
        pop     r0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L429
        la      r2,L428
        jmp     (r2)
L429:
        lc      r0,0
        sw      r0,-3(fp)
L428:
        lw      r0,-3(fp)
        ceq     r0,z
        brf     L432
        la      r2,L431
        jmp     (r2)
L432:
        la      r0,_S31
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,42
        la      r2,L402
        jmp     (r2)
L431:
        la      r0,_S32
        push    r0
        la      r0,___tc24r_printf0
        jal     r1,(r0)
        add     sp,3
        lc      r0,0
        la      r2,L402
        jmp     (r2)
L402:
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
_NIL:
        .word   0
__input:
        .word   0
__pos:
        .word   0
_S0:
        .byte   37,100,0
_S1:
        .byte   37,115,0
_S2:
        .byte   110,105,108,0
_S3:
        .byte   40,0
_S4:
        .byte   32,0
_S5:
        .byte   32,46,32,0
_S6:
        .byte   41,0
_S7:
        .byte   113,117,111,116,101,0
_S8:
        .byte   105,102,0
_S9:
        .byte   43,0
_S10:
        .byte   45,0
_S11:
        .byte   42,0
_S12:
        .byte   47,0
_S13:
        .byte   99,111,110,115,0
_S14:
        .byte   99,97,114,0
_S15:
        .byte   99,100,114,0
_S16:
        .byte   101,113,0
_S17:
        .byte   97,116,111,109,0
_S18:
        .byte   40,43,32,52,48,32,50,41,0
_S19:
        .byte   10,0
_S20:
        .byte   40,45,32,53,48,32,56,41,0
_S21:
        .byte   40,42,32,54,32,55,41,0
_S22:
        .byte   40,43,32,40,42,32,53,32,56,41,32,50,41,0
_S23:
        .byte   40,113,117,111,116,101,32,104,101,108,108,111,41,0
_S24:
        .byte   10,0
_S25:
        .byte   104,101,108,108,111,0
_S26:
        .byte   40,105,102,32,49,32,52,50,32,48,41,0
_S27:
        .byte   40,105,102,32,48,32,57,57,32,52,50,41,0
_S28:
        .byte   40,99,97,114,32,40,99,111,110,115,32,52,50,32,57,57,41,41,0
_S29:
        .byte   40,43,32,40,43,32,49,48,32,50,48,41,32,40,43,32,53,32,55,41,41,0
_S30:
        .byte   10,0
_S31:
        .byte   68,52,53,79,75,10,0
_S32:
        .byte   70,65,73,76,10,0
