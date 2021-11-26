DATA1 SEGMENT
    barr1 db 5,1,2,3,5,6
    X dw 400
    ddarr dw 5,134,256,347,890,1123
data1 ends
code1 segment
assume cs:code1,ds:data1
getByteSortedAscending proc
;bx 数组首地址
;如果只有一个数据，则返回ch=0
;cl数组长度
;因为输出了ch所以cx被修改
push bx
push ax
    mov ch,0
    dec cl
    getByteSortedAscending_loop:
        mov al,[bx]
        inc bx
        cmp [bx],al
        ja getByteSortedAscending_right
        jb getByteSortedAscending_left
        loop getByteSortedAscending_loop
    getByteSortedAscending_right:
        mov ch,0
        jmp getByteSortedAscending_end
    getByteSortedAscending_left:
        mov ch,1
    getByteSortedAscending_end:

pop bx
pop ax
ret
getByteSortedAscending endp
getWordSortedAscending proc
;bx 数组首地址
;如果只有一个数据，则返回ch=0
;cl数组长度
;因为输出了ch所以cx被修改
push bx
push ax
    mov ch,0
    dec cl
    getWordSortedAscending_loop:
        mov ax,[bx]
        add bx,02h
        cmp [bx],ax
        ja getWordSortedAscending_right
        jb getWordSortedAscending_left
        loop getWordSortedAscending_loop
    getWordSortedAscending_right:
        mov ch,0
        jmp getWordSortedAscending_end
    getWordSortedAscending_left:
        mov ch,1
    getWordSortedAscending_end:

pop bx
pop ax
ret
getWordSortedAscending endp

getFitBytePlaceToInsertInto proc
;这个函数仅处理cx,数组长度已知的数组
;bx数组首地址,al传入的值
;dl 插入位置          --dx将会被改变
push ax
push cx
push bx
    mov ch,0
    cmp cx,0
    je getFitBytePlaceToInsertInto_end_unual
    mov dx,0

    push bx
    add bx,cx
    dec bx
    cmp al,[bx]
    jae getFitBytePlaceToInsertInto_end_pre
    pop bx
    dec cx
    getFitBytePlaceToInsertInto_loop:
        cmp al,[bx]
        jbe getFitBytePlaceToInsertInto_end
        inc bx
        cmp al,[bx]
        ja getFitBytePlaceToInsertInto_loop_main
        jmp getFitBytePlaceToInsertInto_loop_break_branch
    getFitBytePlaceToInsertInto_loop_main:
        inc dx
        loop getFitBytePlaceToInsertInto_loop
    getFitBytePlaceToInsertInto_loop_break_branch:
        inc dx
        jmp getFitBytePlaceToInsertInto_end
    getFitBytePlaceToInsertInto_end_pre:
        pop bx
        mov dx,cx
        jmp getFitBytePlaceToInsertInto_end
    getFitBytePlaceToInsertInto_end_unual:
        push ax
        mov ax,6666
        call print16
        pop ax
        call println
    getFitBytePlaceToInsertInto_end:
        
pop bx
pop cx
pop ax
ret
getFitBytePlaceToInsertInto endp

getFitWordPlaceToInsertInto proc
;这个函数仅处理cx,数组长度已知的数组
;bx数组首地址,ax传入的值
;dl 插入位置          --dx将会被改变
push ax
push cx
push bx
    mov ch,0
    cmp cx,0
    je getFitWordPlaceToInsertInto_end_unual
    mov dx,0

    push bx
    add bx,cx
    add bx,cx
    sub bx,02h
    cmp ax,[bx]
    jae getFitWordPlaceToInsertInto_end_pre
    pop bx
    dec cx
    getFitWordPlaceToInsertInto_loop:
        cmp ax,[bx]
        jbe getFitWordPlaceToInsertInto_end
        add bx,02h
        cmp ax,[bx]
        ja getFitWordPlaceToInsertInto_loop_main
        jmp getFitWordPlaceToInsertInto_loop_break_branch
    getFitWordPlaceToInsertInto_loop_main:
        inc dx
        loop getFitWordPlaceToInsertInto_loop
    getFitWordPlaceToInsertInto_loop_break_branch:
        inc dx
        jmp getFitWordPlaceToInsertInto_end
    getFitWordPlaceToInsertInto_end_pre:
        pop bx
        mov dx,cx
        jmp getFitWordPlaceToInsertInto_end
    getFitWordPlaceToInsertInto_end_unual:
        push ax
        mov ax,6666
        call print16
        pop ax
        call println
    getFitWordPlaceToInsertInto_end:
        
pop bx
pop cx
pop ax
ret
getFitWordPlaceToInsertInto endp

insertByteIntoSortedArray proc
;cl 要处理的数组长度 ch 数组排序方式 0 for 升序,else for 降序
;dl 要插入的数据
push cx
push ax
push bx

pop bx
pop ax
pop cx
ret
insertByteIntoSortedArray endp
insertByteIntoArray proc
;cl为0则按照数组以0为结束
;cl不为0，按照数组长度为cl来进行处理
;dl插入位置,dh插入数字
push ax
push bx
push cx
push dx
    mov ch,0
    cmp cx,0h
    je insertByteIntoArray_get_cx
    jmp insertByteIntoArray_behave_cx
    insertByteIntoArray_get_cx:
        call getLengthOfByteArray
        mov cl,al
    insertByteIntoArray_behave_cx:
        sub cl,dl
        push dx
        mov dh,0
        add bx,dx
        pop dx
        call rightShiftByteArray
        mov [bx],dh
pop dx
pop cx
pop bx
pop ax
ret
insertByteIntoArray endp
insertWordIntoArray proc
;cl为0则按照数组以0为结束
;cl不为0，按照数组长度为cl来进行处理
;dl插入位置,ax插入数字
push ax
push bx
push cx
push dx
    mov ch,0
    cmp cx,0h
    je insertWordIntoArray_get_cx
    jmp insertWordIntoArray_behave_cx
    insertWordIntoArray_get_cx:
        push ax
        call getLengthOfWordArray
        mov cl,al
        pop ax
    insertWordIntoArray_behave_cx:
        sub cl,dl
        push dx
        add bl,dl
        adc bh,0
        add bl,dl
        adc bh,0
        pop dx
        call rightShiftWordArray
        mov [bx],ax
pop dx
pop cx
pop bx
pop ax
ret
insertWordIntoArray endp
rightShiftByteArray proc
;子程序修改了si,di的值
push ax
push cx
push bx
    mov ch,0
    cmp cx,0h
    je rightShiftByteArray_get_cx
    jmp rightShiftByteArray_behave_cx
    rightShiftByteArray_get_cx:
        call getLengthOfByteArray
        mov cl,al
    rightShiftByteArray_behave_cx:
        add bx,cx
        std
        mov di,bx
        mov si,bx
        dec si
        rep movsb
pop bx
pop cx
pop ax
ret
rightShiftByteArray endp
rightShiftWordArray proc
;子程序修改了si,di的值
push ax
push cx
push bx
    mov ch,0h
    cmp cx,0h
    je rightShiftWordArray_get_cx
    jmp rightShiftWordArray_behave_cx
    rightShiftWordArray_get_cx:
        call getLengthOfWordArray
        mov cl,al
    rightShiftWordArray_behave_cx:
        add bx,cx
        add bx,cx
        std
        mov di,bx
        mov si,bx
        sub si,2h
        rep movsw
pop bx
pop cx
pop ax
ret
rightShiftWordArray endp
getLengthOfByteArray proc
;输入参数bx,数组起始值
;输出参数al,计算到下一个0之间的元素个数
push cx
push bx
    mov al,0
    getLengthOfByteArray_loop:
        mov cl,[bx]
        cmp cl,0h
        je getLengthOfByteArray_break
        inc al
        inc bx
        jmp getLengthOfByteArray_loop
    getLengthOfByteArray_break:
pop bx
pop cx
ret
getLengthOfByteArray endp
getLengthOfWordArray proc
;输入参数bx,数组起始值
;输出参数al,计算到下一个0之间的元素个数
push cx
push bx
    mov al,0
    getLengthOfWordArray_loop:
        mov cx,[bx]
        cmp cx,0h
        je getLengthOfWordArray_break
        inc al
        add bx,02h
        jmp getLengthOfWordArray_loop
    getLengthOfWordArray_break:
pop bx
pop cx
ret
getLengthOfWordArray endp
printByteArray proc
;输出一个字节数组,
;bx提供数组首地址
;如果cx!=0那么直接输出cx个元素
;如果cx==0那么一直输出直到遇到第一个0
push ax
push cx
push bx
    mov ch,0
    cmp cx,0h
    jne printByteArray_with_cx
    jmp printByteArray_without_cx
    printByteArray_with_cx:
        printByteArray_with_cx_loop:
            mov al,[bx]
            call print8
            call printBlank
            inc bx
            loop printByteArray_with_cx_loop
        jmp printByteArray_end
    printByteArray_without_cx:
        dec bx
        printByteArray_without_cx_loop:
            inc bx
            mov al,[bx]
            cmp al,0h
            jne printByteArray_without_cx_not_end
            jmp printByteArray_end
        printByteArray_without_cx_not_end:
            call print8
            call printBlank
            jmp printByteArray_without_cx_loop
    printByteArray_end:
        pop bx
        pop cx
        pop ax
ret
printByteArray endp
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
            call print16
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
            call print16
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
print8 proc
        ;输入参数 al
        ;功能 输出al数字代表的字符,例如 al = 31,输出 '3''1' as  31
        push ax
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
            pop ax
    ret
print8 endp
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
        add dl,31h
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
print16 proc
        ;输入参数 ax
        ;功能 输出ax数字代表的字符,例如 ax = 31,输出 '3''1' as  31
        push ax
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
            pop ax
    ret
print16 endp
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
start:
    mov ax,data1
    mov ds,ax
    mov es,ax

    call input16
    mov bx,2
    call print16as
    call println
    mov bx,16
    call print16as
    call println
    call print16

    ; first question
        ; lea bx,ddarr
        ; mov cl,[bx]
        ; push cx
        ; inc cx
        ; call printWordArray
        ; call println
        ; pop cx
        ; add bx,02h
        ; mov ax,X
        ; call getFitWordPlaceToInsertInto
        ; call insertWordIntoArray
        ; mov al,dl
        ; call print8
        ; call println

        ; lea bx,ddarr
        ; inc cx
        ; mov [bx],cx
        ; mov cx,7
        ; call printWordArray
    mov ax,4c00h
    int 21h;调用dos退出函数

CODE1 ENDS
END START

    ; lea bx,barr1
    ; mov cl,[bx]
    ; push cx
    ; inc cx
    ; call printByteArray
    ; call println
    ; pop cx
    ; inc bx
    ; mov al,X
    ; call getFitBytePlaceToInsertInto
    ; mov dh,X
    ; call insertByteIntoArray

    ; lea bx,barr1
    ; mov cx,7
    ; call printByteArray