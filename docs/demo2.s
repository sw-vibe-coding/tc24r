	.text

	.globl	_led_on
_led_on:
	push	fp
	push	r2
	push	r1
	mov	fp,sp
; line 21, file "demo2.c"
	la	r0,-65536
	lc	r1,0
	sb	r1,(r0)
	mov	sp,fp
	pop	r1
	pop	r2
	pop	fp
	jmp	(r1)

	.globl	_led_off
_led_off:
	push	fp
	push	r2
	push	r1
	mov	fp,sp
; line 25, file "demo2.c"
	la	r0,-65536
	lc	r1,1
	sb	r1,(r0)
	mov	sp,fp
	pop	r1
	pop	r2
	pop	fp
	jmp	(r1)

	.globl	_uart_putc
_uart_putc:
	push	fp
	push	r2
	push	r1
	mov	fp,sp
L17:
; line 31, file "demo2.c"
	la	r0,-65279
	lb	r0,(r0)
	lcu	r1,128
	and	r0,r1
	clu	z,r0
	brt	L17
; line 32, file "demo2.c"
	la	r0,-65280
	lw	r1,9(fp)
	sb	r1,(r0)
	mov	sp,fp
	pop	r1
	pop	r2
	pop	fp
	jmp	(r1)

	.globl	_main
_main:
	push	fp
	push	r2
	push	r1
	mov	fp,sp
	add	sp,-15
; line 37, file "demo2.c"
	lc	r0,1
	sw	r0,-7(fp)
; line 41, file "demo2.c"
	lc	r0,65
	sb	r0,-14(fp)
; line 42, file "demo2.c"
	lc	r0,66
	sb	r0,-15(fp)
; line 43, file "demo2.c"
	lb	r0,-14(fp)
	lc	r1,65
	ceq	r0,r1
	brt	L21
; line 43, file "demo2.c"
	lc	r0,0
	sw	r0,-7(fp)
L21:
; line 44, file "demo2.c"
	lb	r0,-15(fp)
	lc	r1,66
	ceq	r0,r1
	brt	L22
; line 44, file "demo2.c"
	lc	r0,0
	sw	r0,-7(fp)
L22:
; line 47, file "demo2.c"
	lc	r0,123
	sw	r0,-13(fp)
; line 48, file "demo2.c"
	lc	r0,-13
	add	r0,fp
	sw	r0,-10(fp)
; line 49, file "demo2.c"
	lw	r0,-10(fp)
	lw	r0,(r0)
	lc	r1,123
	ceq	r0,r1
	brt	L23
; line 49, file "demo2.c"
	lc	r0,0
	sw	r0,-7(fp)
L23:
; line 52, file "demo2.c"
	lw	r0,-10(fp)
	la	r1,456
	sw	r1,(r0)
; line 53, file "demo2.c"
	lw	r0,-13(fp)
	la	r1,456
	ceq	r0,r1
	brt	L24
; line 53, file "demo2.c"
	lc	r0,0
	sw	r0,-7(fp)
L24:
; line 56, file "demo2.c"
	lc	r0,77
	sb	r0,-1(fp)
; line 57, file "demo2.c"
	lc	r0,-1
	add	r0,fp
	sw	r0,-4(fp)
; line 58, file "demo2.c"
	lw	r0,-4(fp)
	lb	r0,(r0)
	lc	r1,77
	ceq	r0,r1
	brt	L25
; line 58, file "demo2.c"
	lc	r0,0
	sw	r0,-7(fp)
L25:
; line 61, file "demo2.c"
	la	r0,_led_on
	jal	r1,(r0)
; line 64, file "demo2.c"
	lw	r0,-7(fp)
	lc	r1,1
	ceq	r0,r1
	brf	L26
; line 65, file "demo2.c"
	lc	r0,79
	push	r0
	la	r0,_uart_putc
	jal	r1,(r0)
	add	sp,3
; line 66, file "demo2.c"
	lc	r0,75
	push	r0
	la	r0,_uart_putc
	jal	r1,(r0)
	add	sp,3
; line 67, file "demo2.c"
	lc	r0,10
	push	r0
	la	r0,_uart_putc
	jal	r1,(r0)
	add	sp,3
L26:
; line 70, file "demo2.c"
	lw	r0,-7(fp)
	lc	r1,1
	ceq	r0,r1
	brf	L27
; line 71, file "demo2.c"
	lc	r0,42
	bra	L20
L27:
; line 73, file "demo2.c"
	lc	r0,0
L20:
	mov	sp,fp
	pop	r1
	pop	r2
	pop	fp
	jmp	(r1)
