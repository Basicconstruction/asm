DATA1 SEGMENT
    str1 db "123456711890",0
data1 ends
code1 segment
assume cs:code1,ds:data1
printString proc
    ;入口参数bx 字符串首地址，结束标识 0 (00)
    ;输出字符串,字符串以0结束，或者如果cl!=0，则输出cl长度
    push ax
    push bx
    push cx
    push dx
    mov ah,02h
    mov ch,0h
    cmp cx,0h
    jne printString_with_cx
    printString_without_cx:
        mov dl,[bx]
        cmp dl,0h
        je printbreak
        int 21h
        inc bx
        jmp printString_without_cx
    printString_with_cx:
        mov dl,[bx]
        inc bx
        int 21H
        loop printString_with_cx
    printbreak:
        pop dx
        pop cx
        pop bx
        pop ax
    ret
printString endp
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
print8 proc
        ;输入参数 al 
        ;功能 输出al数字代表的字符,例如 al = 31,输出 '3''1' as  31
        push bx         
        push cx    
        push dx
        mov cl,0   ;存储 存储在栈上的长度
        pnloop:
            cmp al,0ah
            jb pushLastOne
            jmp loopPush
            pushLastOne:
                add cl,01h
                mov bl,al
                xor bh,bh
                push bx     ;将单个数字推入到栈
                jmp outofpushnumbers
            loopPush:
                add cl,01h      
                mov dl,al
                cmp dl,100
                jae sub100
                jmp sub10judge
                sub100:
                    sub dl,100
                    jae sub100
                sub10judge:
                    cmp dl,0ah
                    jae sub10
                    jmp readygo
                sub10:
                    sub dl,0ah
                    cmp dl,0ah
                    jae sub10
                readygo:
                    mov bl,dl
                    xor bh,bh
                    push bx     ;将单个数字推入到栈
                    mov ah,0
                    mov dh,10
                    div dh
                    jmp pnloop
        outofpushnumbers:
            xor ch,ch
            mov ah,02h
            printChar:
                pop bx
                mov dl,bl
                add dl,30h
                int 21H
                loop printChar
            pop dx
            pop cx
            pop bx
    ret
print8 endp
print16 proc
        ;输入参数 ax
        ;功能 输出ax数字代表的字符,例如 ax = 31,输出 '3''1' as  31
        push bx         
        push cx    
        push dx
        mov cl,0   ;存储 存储在栈上的长度
        pnloop16:
            cmp ax,0ah
            jb pushLastOne16
            jmp loopPush16
            pushLastOne16:
                add cl,01h
                mov bx,ax
                push bx     ;将单个数字推入到栈
                jmp outofpushnumbers16
            loopPush16:
                add cl,01h      
                mov dx,ax
                cmp dx,10000
                jae sub10000_16
                jmp sub1000judge16
                sub10000_16:
                    sub dx,10000
                    cmp dx,10000
                    jae sub10000_16
                sub1000judge16:
                    cmp dx,1000
                    jae sub1000_16
                    jmp sub100judge16
                sub1000_16:
                    sub dx,1000
                    cmp dx,1000
                    jae sub1000_16
                sub100judge16:
                    cmp dx,100
                    jae sub100_16
                    jmp sub10judge16
                sub100_16:
                    sub dx,100
                    cmp dx,100
                    jae sub100_16
                sub10judge16:
                    cmp dx,0ah
                    jae sub10_16
                    jmp readygo16
                sub10_16:
                    sub dx,0ah
                    cmp dx,0ah
                    jae sub10_16
                readygo16:
                    mov bx,dx
                    push bx     ;将单个数字推入到栈
                    mov bx,10
                    mov dx,0
                    div bx
                    jmp pnloop16
        outofpushnumbers16:
            xor ch,ch
            mov ah,02h
            printChar16:
                pop bx
                mov dl,bl
                add dl,30h
                int 21H
                loop printChar16
            pop dx
            pop cx
            pop bx
    ret
print16 endp
getLengthOfString proc
    ;输入参数bx 字符串初始地址
    ;输出参数al字符串长度
    push cx
    push bx
    mov al,0h
    getLengthOfString_loop:
        mov cl,[bx]
        cmp cl,0h
        je getLengthOfString_break
        inc al
        inc bx
        jmp getLengthOfString_loop
    getLengthOfString_break:
        pop bx
        pop cx

    ret
getLengthOfString endp
counterByte proc
    ;输入参数查找字符 dl,字符串首地址bx
    ;输出参数 字符数目al
    ;如果cl!=0 就按照cl长度来查找，否则按照字符串以0结束,该方法也可以快速改为以某一可变字符结束
    ;实际也是按照cl的长度，本子程序的设计均不太严谨，需要使用者多加小心
    push cx
    push bx
    mov ch,0
    cmp cx,0h
    jne counterByte_with_cx
    ; jmp counterByte_without_cx
    counterByte_without_cx:
        call getLengthOfString
        mov cl,al
        counterByteloop:
            cmp cl,0h
            je counterByte_break
            mov ch,[bx]
            inc bx
            dec cl
            cmp ch,dl
            je counterByteloop
            dec al
            jmp counterByteloop
    counterByte_with_cx:
        mov al,cl
        counterByte_with_loop:
            mov ah,[bx]
            inc bx
            cmp ah,dl
            je counterByte_with_notdec_al
            counterByte_with_dec_al:
                dec al
                loop counterByte_with_loop
            counterByte_with_notdec_al:
                loop counterByte_with_loop
    counterByte_break:
        pop bx
        pop cx
    ret
counterByte endp
start:
    mov ax,seg str1
    mov ds,ax
    lea bx,str1
    call getLengthOfString
    call print8
    call println
    mov dl,31h
    mov cx,8
    call counterByte
    call print8
    mov ax,4c00h
    int 21h;调用dos退出函数
            
CODE1 ENDS
END START
