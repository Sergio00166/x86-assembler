flush:
    xor eax, eax
    mov [buffer], eax
    ret

str2int:
    push ebx
    push edx
    push esi
    mov esi, eax
    xor eax, eax

.str2int_nxchr:
    mov ebx, 0
    mov bl, [esi]
    test bl, bl
    jz .str2int_done
    inc esi
    cmp bl, "0"
    jb notnumber
    cmp bl, "9"
    jg notnumber
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    jmp .str2int_nxchr

.str2int_done:
    pop esi
    pop edx
    pop ebx
    ret

int2str:
    push ebx
    push ecx
    push edx
    mov ebx, buffer + 11
    mov byte [ebx], 0
    mov ecx, 10

.int2str_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    dec ebx
    mov [ebx], dl
    test eax, eax
    jnz .int2str_loop
    mov eax, ebx
    pop edx
    pop ecx
    pop ebx
    ret

strlen:
    push ebx
    mov ebx, eax

.strlen_nextchar:
    cmp byte [eax], 0
    jz  .strlen_finished
    inc eax
    jmp .strlen_nextchar

.strlen_finished:
    sub eax, ebx
    pop ebx
    ret

newline:
    push eax
    mov eax, 0AH
    push eax
    mov eax, esp
    call print
    pop eax
    pop eax
    ret

print:
    push eax
    push ecx
    push edx
    mov ecx, eax
    call strlen
    mov edx, eax
    mov eax, ecx
    call stdout
    pop edx
    pop ecx
    pop eax
    ret

stdout:
    push ebx
    push eax
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop eax
    pop ebx
    ret

input:
    mov eax, 3
    mov ebx, 0
    lea ecx, buffer
    mov edx, bufflen
    int 0x80

    lea eax, buffer
    mov esi, eax
    mov edi, eax

.remove_newlines_loop:
    mov al, [esi]
    cmp al, 0
    je .skip_newline_done
    cmp al, 10
    je .skip_newline
    mov [edi], al
    inc edi

.skip_newline:
    inc esi
    jmp .remove_newlines_loop

.skip_newline_done:
    mov byte [edi], 0
    lea eax, buffer
    ret

exit:
    call newline
    mov eax, 1
    xor ebx, ebx
    int 0x80