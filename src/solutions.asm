DATA1 SEGMENT
    X dw 125
    ddarr dw 5,134,256,347,890,1123,0
    message db "please input a number: ",0
    message_sum db "the sum is: ",0
data1 ends
code1 segment
assume cs:code1,ds:data1

printWordArray proc
;输出一个双字数组,
;bx提供数组首地址
;如果cx!=0那么直接输出cx个元素
;如果cx==0那么一直输出直到遇到第一个0
push ax
push cx
push bx
    mov ah,0
    cmp cx,0h
    jne printWordArray_with_cx
    jmp printWordArray_without_cx
    printWordArray_with_cx:
        printWordArray_with_cx_loop:
            mov ax,[bx]
            push bx
            mov bx,10
            call print16as
            pop bx
            call printBlank
            add bx,02h
            loop printWordArray_with_cx_loop
        jmp printWordArray_end
    printWordArray_without_cx:
        sub bx,02h
        printWordArray_without_cx_loop:
            add bx,02h
            mov ax,[bx]
            cmp ax,0h
            jne printWordArray_without_cx_not_end
            jmp printWordArray_end
        printWordArray_without_cx_not_end:
            push bx
            mov bx,10
            call print16as
            pop bx
            call printBlank
            jmp printWordArray_without_cx_loop
    printWordArray_end:
        pop bx
        pop cx
        pop ax
ret
printWordArray endp
println proc
    ;换行
    push ax
    push dx
    mov dl,0ah
    mov ah,02h
    int 21h
    pop dx
    pop ax
    ret
println endp
printBlank proc
    ;输出空格
    push ax
    push dx
    mov dl,20h
    mov ah,02h
    int 21h
    pop dx
    pop ax
    ret
printBlank endp
print16as proc
push ax
push bx
push dx
push cx
    mov cx,0h
    cmp bx,10
    je print16as_loop
    cmp bx,2
    je print16as_loop
    cmp bx,16
    je print16as_loop
    mov bx,10
    print16as_loop:
        cmp ax,0
        jbe print16as_break
        mov dx,0
        div bx
        push dx
        inc cx
        jmp print16as_loop
    print16as_break:
        pop dx
        add dl,30h
        cmp dl,39h
        jbe print16as_break_noneed
        add dl,39
    print16as_break_noneed:
        mov ah,02h
        int 21h
        loop print16as_break
pop cx
pop dx
pop bx
pop ax
ret
print16as endp
inputSignalNumber proc
    mov ah,01h
    int 21h
ret
inputSignalNumber endp
input16 proc
push bx
push cx
push dx
    mov ax,0
    mov cx,0
    input16_loop:
        call inputSignalNumber
        cmp al,0dh
        je input16_end
        inc cx
        sub al,30h
        push ax
        jmp input16_loop
    input16_end:
        mov ax,0h
        mov ch,0
        input16_getout:
            cmp cl,0h
            jbe input16_return0
            pop dx
            push ax
            push cx
            mov cl,ch
            xor ch,ch
            mov dh,0
            mov ax,dx
            call multiply_help
            pop cx
            mov dx,ax
            pop ax
            add ax,dx
            dec cx
            inc ch
            cmp cl,0h
            ja input16_getout
    input16_return0:

pop dx
pop cx
pop bx
ret
input16 endp

multiply_help proc
push cx
push bx
push dx
    mov bx,10
    multiply_help_loop:
        cmp cl,0
        je multiply_help_break
        mul bx
        loop multiply_help_loop
    multiply_help_break:
pop dx
pop bx
pop cx
ret
multiply_help endp
printString proc
    ;入口参数bx 字符串首地址，结束标识 0 (00)
    push ax
    push bx
    push cx
    push dx
    mov ah,02h
    printString_without_cx:
        mov dl,[bx]
        cmp dl,0h
        je printbreak
        int 21h
        inc bx
        jmp printString_without_cx
    printbreak:
        pop dx
        pop cx
        pop bx
        pop ax
    ret
printString endp
start:
    mov ax,data1
    mov ds,ax
    mov es,ax



    ; first question
    lea bx,ddarr
    mov cx,[bx]
    inc cx
    call printWordArray
    dec cx
    call println

    mov ax,X
    push cx
    add bx,02h
    xchg_loop:
        cmp ax,[bx]
        jbe xchg_sign
        add bx,02h
        dec cx
        cmp cx,0
        ja xchg_loop
        jmp xchg_end
    xchg_sign:
        xchg ax,[bx]
        add bx,02h
        loop xchg_loop
    xchg_end:
    xchg ax,[bx]
    pop cx
    
    inc cx
    lea bx,ddarr
    mov [bx],cx
    inc cx
    call printWordArray

    ;2,3
    ; mov cx,0h
    ; lea bx,message
    ; message_loop:
    ;     call printString
    ;     CALL input16
    ;     cmp ax,0
    ;     je message_break
    ;     add cx,ax
    ;     jmp message_loop
    ; message_break:
    ;     mov ax,cx
    ;     lea bx,message_sum
    ;     call printString
    ;     mov bx,2
    ;     call print16as
    ;     call println
    ;     mov bx,10
    ;     call print16as
    ;     call println
    ;     mov bx,16
    ;     call print16as
    ;     call println
    mov ax,4c00h
    int 21h;调用dos退出函数

CODE1 ENDS
END START