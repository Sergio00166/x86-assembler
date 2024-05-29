%include "functions.asm"

section .bss
    buffer resb 32
    num1 resb 4
    num2 resb 4
    op resb 1
    bufflen equ $ - buffer

section .data
    msg db "Welcome to the most basic NASM x86-32 integrer calculator",0
    anum1 db "First number: ", 0
    anum2 db "Second number: ", 0
    opera db "Operation (+,-,*,/): ", 0
    result db "Result =  ", 0
    div_rest db "   Remainder = ", 0
    invopt db "[ERROR]: Invalid option ", 0
    invnn db "[ERROR]: Only numbers are allowed", 0
    negative db "-", 0

section .text
    global _start

_start:
    ; Print banner
    lea eax, msg
    call print
    call newline

    ; Ask for number 1
    mov eax, anum1
    call print
    call input
    lea eax, buffer
    call str2int
    mov [num1], eax
    call flush

    ; Ask for number 2
    mov eax, anum2
    call print
    call input
    lea eax, buffer
    call str2int
    mov [num2], eax
    call flush

    ; Ask for operation
    mov eax, opera
    call print
    call input
    mov al, [buffer]
    mov [op], al
    call flush

    ; Check options
    mov al, [op]
    cmp al, "*"
    je multiplica
    cmp al, "/"
    je divide
    cmp al, "+"
    je suma
    cmp al, "-"
    je resta
    jmp badarg

    set_reg:
        mov eax, [num1]
        mov ecx, [num2]
        ret

    multiplica:
        call set_reg
	    mul ecx
        call print_result
        call exit

    divide:
        call set_reg
        xor edx, edx
        div ecx
        call print_result
        lea eax, div_rest
        call print
        mov eax, edx
        call int2str
        call print
        call exit

    suma:
        call set_reg
        add eax, ecx
        call print_result
        call exit

    resta:
        call set_reg
        cmp eax, ecx
        jb resta_neg
        sub eax, ecx
        call print_result
        call exit

   resta_neg:
        sub ecx, eax
        mov eax, ecx
        call end_negative

   end_negative:
       push eax
       lea eax, result
       call print
       mov eax, negative
       call print
       pop eax
       call int2str
       call print
       call newline
       call exit

   notnumber:
       lea eax, invnn
       call print
       call newline
       mov eax, 1
       mov ebx, 1
       int 0x80

   badarg:
       lea eax, invopt
       call print
       call exit

   print_result:
       push eax
       lea eax, result
       call print
       pop eax
       call int2str
       call print
       ret