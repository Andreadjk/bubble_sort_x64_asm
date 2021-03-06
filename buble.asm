section .data

hello : dd 2,7,4,6,0,9
return : db "",10
section .bss
 LETTER: RESB 1
 NUMBER: RESB 19
 
section .text 


global _start

PRINTDEC:
 LEA R9, [NUMBER + 18] ; last character of buffer
 MOV R10, R9         ; copy the last character address
 MOV RBX, 10         ; base10 divisor

 DIV_BY_10:

 XOR RDX, RDX          ; zero rdx for div
 DIV RBX            ; rax:rdx = rax / rbx
 ADD RDX, 0x30      ; convert binary digit to ascii
 TEST RAX,RAX          ; if rax == 0 exit DIV_BY_10
 JZ LAST_REMAINDER
 MOV byte [R9], DL       ; save remainder
 SUB R9, 1               ; decrement the buffer address
 JMP DIV_BY_10

 LAST_REMAINDER:

 TEST DL, DL       ; if DL (last remainder) != 0 add it to the buffer
 JZ CHECK_BUFFER
 MOV byte [R9], DL       ; save remainder
 SUB R9, 1               ; decrement the buffer address

 CHECK_BUFFER:

 CMP R9, R10       ; if the buffer has data print it
 JNE PRINT_BUFFER 
 MOV byte [R9], '0' ; place the default zero into the empty buffer
 SUB R9, 1

 PRINT_BUFFER:

 ADD R9, 1          ; address of last digit saved to buffer
 SUB R10, R9        ; end address minus start address
 ADD R10, 1         ; R10 = length of number
 MOV RAX, 1         ; NR_write
 MOV RDI, 1         ;     stdout
 MOV RSI, R9        ;     number buffer address
 MOV RDX, R10       ;     string length
 SYSCALL

 RET

;esi store all array name hello
;r10d increment first label example for or while
;r11d increment second label for or while
;r12d size of array
;r13d store value of first variable after action bubble sort's , will store new array created
;r15 increment for print array
_start:
mov r12d,5
mov r10d,0
mov RSI,0
mov esi,hello
mov r15d,0
jmp for_one

inc_first_for:
              inc r10d ; i++


    for_one:
            cmp r10d,r12d ; i > 5 ?
            ja exit_1_1   ; if yes exit from  master for/while
            
            mov r11d,0    ; k = 0;
    for_two:
            cmp r11d,r12d ; k > 5?
            ja inc_first_for ; yes go to increment and return to master for/while
            mov r13d,[r10d * 4 + esi] ; var = hello[i];
            cmp r13d,[r11d * 4 + esi] ; if var < hello[k]
            jb  bubble ; go to bubble 
            inc r11d; k++
            jmp for_two ; return to second for/while
bubble:
            mov eax,[r11d * 4 + esi] ; var2 = hello[k]
            
            mov [r10d * 4 + esi], eax ; hello[i] = var2
            mov [r11d * 4 + esi], r13d;  hello[k] =  var
            inc r11d; k++;
            jmp for_two ;return to second for/while

exit_1_1:
            mov r13d,esi ;Section for print array modified. r13 store new array modified. r13 is modified and hello is static
            jmp exit_1_2

exit_1_2:
            cmp r15d,r12d                         
            ja exit_1_3                                                               ;while(j < 6){PRINTDEC(hello[j]); print("\n"); j++;}
mov eax,[r15d * 4 + r13d]

CALL PRINTDEC
mov rax, 1
    mov rdi, 1
    mov rsi, return
    mov rdx, 1
    syscall

inc r15d
             jmp exit_1_2
exit_1_3:
               MOV RAX, 60
               MOV RDI, 0
               syscall
