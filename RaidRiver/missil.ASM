    .386
    .model flat, stdcall  ; 32 bit memory model
    option casemap :none  ; case sensitive
    include bitblt.inc    ; local includes for this file

	;código de link para imagem no arquivo RC
	aviao		     equ		101  ;respectivamente: nome do bitmap, operando usado para definir constantes, código definido no arquivo RSRC.rc para identificação de cada imagem
    helicopero       equ        103  ; ...
    bala             equ        104  ; ...
    barco            equ        102  ; ...
    fundo            equ        106  ; ...
    fuel             equ        105  ; ...
    placar           equ        107  ; ...
    explosao         equ        108  ; ...
    esquerda         equ        109  ; ...
    direita          equ        110  ; ...
    gasometro        equ        111  ; ...
    gas              equ        112  ; ...
    heliE            equ        113  ; ...

	CREF_TRANSPARENT  EQU 0FF00FFh
	CREF_TRANSPARENT2 EQU 0FF0000h
    
.code

start:                     ;método para iniciar o programa, sempre é o primeiro a ser chamado automaticamente por padrão
                           ;cria todos os bitmaps que serão usados e chama o procedimento que cria a janela
    invoke GetModuleHandle, NULL
    mov hInstance, eax 
    
    invoke LoadBitmap,hInstance, helicopero         ;encontra, pelo nome definido acima, o código do bitmap que queremos 
    mov hBmp2, eax                                  ;atribui o bitmap à variável para conseguirmos usá-lo depois no programa

    invoke GetCommandLine                           ;prepara para adicionar bitmap
    mov CommandLine, eax                            ;adiciona bitmap
    ;----------------------------------------------
    xor eax, eax                                    ; ...          
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance2, eax                             ; ...
 
    invoke LoadBitmap,hInstance2, aviao             ; ... 
    mov hBmp, eax                                   ; ...     

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;---------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance4, eax                             ; ...
 
    invoke LoadBitmap,hInstance4, barco             ; ...
    mov hBmp4, eax                                  ; ...                 

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance5, eax                             ; ...             
 
    invoke LoadBitmap,hInstance5, bala              ; ...
    mov hBmp5, eax                                  ; ...                 

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...       
    mov hInstance6, eax                             ; ...                 
 
    invoke LoadBitmap,hInstance6, explosao          ; ...
    mov hBmp6, eax                                  ; ...          

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ... 
    mov hInstance7, eax                             ; ...
  
    invoke LoadBitmap,hInstance7, fuel              ; ...
    mov hBmp7, eax                                  ; ...                    

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance8, eax                             ; ...
 
    invoke LoadBitmap,hInstance8, placar            ; ...
    mov hBmp8, eax                                  ; ...            

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance9, eax                             ; ...
 
    invoke LoadBitmap,hInstance9, esquerda          ; ...   
    mov hBmp9, eax                                  ; ...                  

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance10, eax                            ; ...
 
    invoke LoadBitmap,hInstance10, direita          ; ...
    mov hBmp10, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance11, eax                            ; ...
 
    invoke LoadBitmap,hInstance11, gasometro        ; ...
    mov hBmp11, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance12, eax                            ; ...
 
    invoke LoadBitmap,hInstance12, gas              ; ...
    mov hBmp12, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance13, eax                            ; ...
 
    invoke LoadBitmap,hInstance13, heliE              ; ...
    mov hBmp13, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    invoke WinMain,hInstance3,NULL,CommandLine,SW_SHOWDEFAULT ;chama o procedimento que criará a janela
    invoke ExitProcess,eax                                    ;sai do start

; #########################################################################

WinMain proc hInst     :DWORD,hPrevInst :DWORD, CmdLine :DWORD, CmdShow   :DWORD

    ;====================
    ; Put LOCALs on stack
    ;====================

    LOCAL wc   :WNDCLASSEX
    LOCAL msg  :MSG
    LOCAL Wwd  :DWORD
    LOCAL Wht  :DWORD
    LOCAL Wtx  :DWORD
    LOCAL Wty  :DWORD

    ;==================================================
    ; Fill WNDCLASSEX structure with required variables
    ;==================================================

    invoke LoadIcon,hInst,500    ; icon ID
    mov hIcon, eax

    szText szClassName,"Raid_River_Cass"

    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc,    offset WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    m2m wc.hInstance,      hInst
    mov wc.hbrBackground, 0EH     ;define a cor do plano de fundo, azul escuro
    mov wc.lpszMenuName,   NULL   ;OFFSET MenuName
    mov wc.lpszClassName,  offset szClassName
    m2m wc.hIcon,          hIcon
    invoke LoadCursor,NULL,IDC_ARROW
    mov wc.hCursor,        eax
    m2m wc.hIconSm,        hIcon

    invoke RegisterClassEx, ADDR wc

    ;================================
    ; Centre window at following size
    ;================================

    mov Wwd, 850
    mov Wht, 650

    invoke GetSystemMetrics,SM_CXSCREEN
    invoke TopXY,Wwd,eax
    mov Wtx, eax

    invoke GetSystemMetrics,SM_CYSCREEN
    invoke TopXY,Wht,eax
    mov Wty, eax
    
    invoke CreateWindowEx,WS_EX_LEFT, ADDR szClassName, ADDR szDisplayName, WS_OVERLAPPEDWINDOW, 
                          Wtx,Wty,Wwd,Wht, NULL,NULL, hInst,NULL

    
    mov   hWnd,eax

    invoke ShowWindow,hWnd,SW_SHOWNORMAL
    invoke UpdateWindow,hWnd

    ;===================================
    ; Loop until PostQuitMessage is sent
    ;===================================

    StartLoop:
      invoke GetMessage,ADDR msg,NULL,0,0
      cmp eax, 0
      je ExitLoop
      invoke TranslateMessage, ADDR msg
      invoke DispatchMessage,  ADDR msg
      jmp StartLoop
    ExitLoop:
      return msg.wParam

WinMain endp

; #########################################################################

WndProc proc hWin   :DWORD, uMsg   :DWORD, wParam :DWORD, lParam :DWORD

    LOCAL var    :DWORD
    LOCAL caW    :DWORD
    LOCAL caH    :DWORD
    LOCAL hDC    :DWORD
    LOCAL Ps     :PAINTSTRUCT
    LOCAL Rect   :RECT

    mov Rect.left, 0
    mov Rect.top, 0
    mov Rect.bottom, 800
    mov Rect.right, 1000000

    .if uMsg == WM_COMMAND
		mov eax,wParam

    .elseif uMsg == WM_CREATE                                         ;instancia posições
        ;mov	aviaoAtual, 0 

        ;Posicionamento inicial de cada componente, suas coordenadas x e y             
		mov aviaoPos.y, 450                    
		mov aviaoPos.x, 370  

        mov sera, 0                 

        mov barcoPos.y, 80
		mov barcoPos.x, 100

        mov barcoDoisPos.y, 400
		mov barcoDoisPos.x, 10

        mov heliPos.y, 300
		mov heliPos.x, 20

        mov heliDoisPos.y, 100
		mov heliDoisPos.x, 656

        mov fuelPos.y, 0
        mov fuelPos.x, 250

        mov explosaoPos.x,-100

        mov esqPos.x, 0
        mov esqPos.y, 1398

        mov dirPos.x, 680
        mov dirPos.y, 1398

        mov gasPos.x, 520
        mov gasPos.y, 525

        mov tempo, 500

		
		invoke CreateEvent,NULL,FALSE,FALSE,NULL
		mov    hEventStart,eax

		mov    eax,OFFSET ThreadProc
		invoke CreateThread,NULL,NULL,eax,\
		                    NULL,NORMAL_PRIORITY_CLASS,\
		                    ADDR ThreadID
		mov    hThread,eax

		mov    eax,OFFSET ThreadBarcoProc
		invoke CreateThread,NULL,NULL,eax,\
		                    NULL,NORMAL_PRIORITY_CLASS,\
		                    ADDR ThreadBarcoID
		mov    hThreadBarco,eax

        mov    eax,OFFSET ThreadHeliProc
		invoke CreateThread,NULL,NULL,eax,\
		                    NULL,NORMAL_PRIORITY_CLASS,\
		                    ADDR ThreadHeliID
		mov    hThreadHeli,eax

        mov    eax,OFFSET ThreadBalaProc
		invoke CreateThread,NULL,NULL,eax,\
		                    NULL,NORMAL_PRIORITY_CLASS,\
		                    ADDR ThreadBalaID
		mov    hThreadBala,eax

        mov    eax,OFFSET ThreadDownProc
		invoke CreateThread,NULL,NULL,eax,\
		                    NULL,NORMAL_PRIORITY_CLASS,\
		                    ADDR ThreadDownID
		mov    hThreadDown,eax

        
        szText inicio,"O jogo vai comecar, prepare-se!"
        invoke MessageBox,hWin,ADDR inicio,ADDR szDisplayName,MB_OK
		

    .elseif uMsg == WM_SIZE
    ;obter o tamanho da janela
    
    .elseif uMsg == WM_LBUTTONDOWN
		mov eax,lParam
		and eax,0ffffh
		mov hitpoint.x,eax
		mov eax,lParam
		shr eax,16
		mov hitpoint.y,eax
		;invoke InvalidateRect,hWnd,NULL,TRUE

    .elseif uMsg == WM_KEYDOWN
        mov     eax,lParam
        and     eax, 000Fh
        
    .if wParam == VK_RIGHT
        .if aviaoPos.x<650
            add aviaoPos.x, 10
        .endif
        
    .elseif wParam == VK_LEFT
        .if aviaoPos.x>158
            sub aviaoPos.x, 20
        .endif

    .elseif wParam == VK_UP 
        mov ecx, aviaoPos.x
        add ecx, 13
        mov balaPos.x, ecx
        mov ebx, aviaoPos.y
        mov balaPos.y, ebx
        inc atirou
    .endif

     .elseif uMsg == WM_PAINT
        invoke BeginPaint,hWin,ADDR Ps
        mov hDC, eax
        invoke Paint_Proc,hWin,hDC
        invoke EndPaint,hWin,ADDR Ps
        return 0
    .elseif uMsg==WM_BALA
		 .if atirou >= 1
            sub balaPos.y, 1
        .endif

   .elseif uMsg==WM_FINISH        
		;invoke InvalidateRect,hWnd,NULL,TRUE

    .elseif uMsg==WM_T  
        invoke VerificaSePerdeu         
        invoke VerificaSeAcertouBarco
        invoke VerificaSeAcertouBarcoDois
        inc barcoPos.x
        
        .if barcoPos.x > 655
            mov barcoPos.x,162
        .endif  

        inc barcoDoisPos.x
        
        .if barcoDoisPos.x > 655
            mov barcoDoisPos.x,162
        .endif    

    ;.elseif uMsg==WM_HELI
        invoke VerificaFuel
        invoke VerificaSeAcertouHeli
        invoke VerificaSeAcertouHeliDois
        inc heliPos.x
        dec heliDoisPos.x

        .if heliPos.x > 655
            mov heliPos.x,162
        .endif

        .if heliDoisPos.x < 10
            mov heliDoisPos.x,670
        .endif

     .elseif uMsg==WM_DOWN  
            invoke Abaixa
            invoke InvalidateRect,hWnd, addr Rect,TRUE
                     
        
    ; .if sera == 0
    ;     .if perdeu > 0  || acabouGasolina > 0
    ;     ;mov Rect.bottom, 0
    ;     ;mov Rect.right, 0
    ;     ;invoke InvalidateRect,hWnd, addr Rect,TRUE
    ;     invoke verifica, hWin,uMsg,wParam,lParam         
    ;     .endif
    ; .endif

    .elseif uMsg == WM_CLOSE
        szText perg,"Tem certeza que deseja sair?"
        invoke MessageBox,hWin,ADDR perg,ADDR szDisplayName,MB_YESNO
          .if eax == IDNO
            return 0
          .endif

    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0 
    .endif

    invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret
WndProc endp

verifica proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD ;Procedimento chamado quando o usuário perdeu, pergunta se ele quer jogar novamente ou sair
       
        mov sera, 2 
        .if perdeu > 0                                            ;verifica se perdeu porque foi atingido por um obstáculo
            szText msg,"Voce foi atingido! Deseja jogar de novo?" ;cria a variavel contendo o texto que será a mensagem
            invoke MessageBox,hWin,ADDR msg,ADDR szDisplayName,MB_YESNO  ;cria a message box, do tipo de resposta SIM ou NAO, com o texto criado acima
            .if eax == IDNO               ;se o usuário escolheu sair
                invoke ExitProcess, 0     ;abortamos o programa, terminamos a execução
            .elseif                       ;se o usuário escolheu jogar novamente
                mov perdeu, 0
                mov acabouGasolina, 0
                ;mov tempo, 500
                ;invoke ShowWindow,hWnd,SW_SHOWNORMAL
                ;invoke UpdateWindow,hWin
                invoke WinMain, hWin,uMsg,wParam,lParam
            .endif 
        .elseif
            szText msgG,"Sua gasolina acabou, voce perdeu! Deseja jogar de novo?"  ;cria a variavel contendo o texto que será a mensagem
            invoke MessageBox,hWin,ADDR msgG,ADDR szDisplayName,MB_YESNO  ;cria a message box, do tipo de resposta SIM ou NAO, com o texto criado acima
            .if eax == IDNO               ;se o usuário escolheu sair
                invoke ExitProcess, 0     ;abortamos o programa, terminamos a execução
            .elseif                       ;se o usuário escolheu jogar novamente
                mov perdeu, 0
                mov acabouGasolina, 0
                ;mov tempo, 500
                invoke WndProc, NULL, NULL, NULL, NULL ;chama o procedimento que cria a janela novamente, recomeçando o jogo          
            .endif                        ;determina que o if acabou
        .endif 
verifica endp                                 ;fim da definição do procedimento

; ########################################################################

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    return sDim
TopXY endp

; #########################################################################

Abaixa proc 
    .if sera == 0
        .if perdeu > 0  || acabouGasolina > 0
        ;mov Rect.bottom, 0
        ;mov Rect.right, 0
        ;invoke InvalidateRect,hWnd, addr Rect,TRUE
        invoke verifica, NULL,NULL,NULL, NULL        
        .endif
    .endif
    .if tempo > 0
        dec tempo
    .endif

    .if tempo == 1
        inc acabouGasolina
    .elseif

    ;0->    272
    ;1000-> 520
    ;248
    ; 248    -  1000
    ; pos x  -  tempo 
    ;multiplicar o tempo por 248 e dividir por 1000
    ; somar 272

    xor eax,eax
    xor ecx, ecx

    mov eax, tempo
    mov ecx, 248
    imul ecx

    xor ecx,ecx
    mov ecx, 500

    div ecx

    add eax, 272

    mov gasPos.x, eax

    .if achou == 0
        mov explosaoPos.y,0
        mov explosaoPos.x, -250        
    .endif
    dec achou

    .if acelera == 0        
        inc heliPos.y
        inc heliDoisPos.y
        inc barcoPos.y 
        inc barcoDoisPos.y 
        add fuelPos.y, 2
        inc explosaoPos.y
        xor ecx, ecx

        sub esqPos.y, 2
        .if esqPos.y <= 10
            mov esqPos.y, 1398
        .endif

        sub dirPos.y, 2
        .if dirPos.y <= 10
            mov dirPos.y, 1398
        .endif

    .elseif         
        xor ebx, ebx
        mov ebx, acelera
        
        dec acelera        ;18173

        sub esqPos.y, ebx
        .if esqPos.y <= 10
            mov esqPos.y, 1398
        .endif

        sub dirPos.y, ebx
        .if dirPos.y <= 10
            mov dirPos.y, 1398
        .endif

        add heliPos.y, ebx
        add heliDoisPos.y, ebx
        add barcoPos.y, ebx 
        add barcoDoisPos.y, ebx 
        add fuelPos.y, ebx
        xor ecx, ecx    
    .endif

    .if barcoPos.y > 465
        mov barcoPos.y,0
    .endif 

    .if barcoDoisPos.y > 465
        mov barcoDoisPos.y,0
    .endif

    .if heliPos.y > 465
        mov heliPos.y, 0
    .endif

    .if heliDoisPos.y > 465
        mov heliDoisPos.y, 0
    .endif
    
    .if fuelPos.y > 485
        mov fuelPos.y, 0
    .endif
    .endif
Abaixa ENDP

VerificaSeAcertouHeli proc                  ;verificacao se o missel entrou em contato com helicoptero
    xor edx, edx                            ;limpa os registradores 
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    
    mov edx, heliPos.x                      ;guarda em edx a posicao 'x' do helicoptero
    mov ebx, balaPos.x                      ;guarda em ebx a posicao x da bala
    sub ebx, edx                            ;subtrai de ebx e armazena em edx

    mov eax, balaPos.y                      ;guarda em eax a posicao 'y' da bala
    mov ecx, heliPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    sub ecx, eax       
    
                         ;subtrai de eax e armazena em ecx
    
    .if ecx <= 35 && ebx <= 35
    ;exibir explosao
    mov achou, 3
    xor ecx, ecx
    mov ecx, heliPos.x
    mov explosaoPos.x, ecx

    xor edx, edx
    mov edx, heliPos.y
    mov explosaoPos.y, edx
    mov heliPos.x, 0      
    mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
    .endif
    ret
VerificaSeAcertouHeli endp  

VerificaSeAcertouHeliDois proc                  ;verificacao se o missel entrou em contato com helicoptero
    xor edx, edx                            ;limpa os registradores 
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    
    mov edx, heliDoisPos.x                      ;guarda em edx a posicao 'x' do helicoptero
    mov ebx, balaPos.x                      ;guarda em ebx a posicao x da bala
    sub ebx, edx                            ;subtrai de ebx e armazena em edx

    mov eax, balaPos.y                      ;guarda em eax a posicao 'y' da bala
    mov ecx, heliDoisPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    sub ecx, eax       
    
                         ;subtrai de eax e armazena em ecx
    
    .if ecx <= 35 && ebx <= 35
    ;exibir explosao
    mov achou, 3
    xor ecx, ecx
    mov ecx, heliDoisPos.x
    mov explosaoPos.x, ecx

    xor edx, edx
    mov edx, heliDoisPos.y
    mov explosaoPos.y, edx
    mov heliDoisPos.x, 660     
    mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
    .endif
    ret
VerificaSeAcertouHeliDois endp 

VerificaSeAcertouBarco proc 
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    mov edx, barcoPos.x
    mov ebx, balaPos.x
    sub ebx, edx

    mov eax, balaPos.y
    mov ecx, barcoPos.y
    sub ecx, eax
 
    .if ecx <= 40 && ebx <= 40
       ;exibir explosao
       mov achou, 3
      xor ecx, ecx
      mov ecx, barcoPos.x
      mov explosaoPos.x, ecx

      xor edx, edx
      mov edx, barcoPos.y
      mov explosaoPos.y, edx
      mov barcoPos.x, 0  
      mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
          
    .endif

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    ret
VerificaSeAcertouBarco endp 

VerificaSeAcertouBarcoDois proc 
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    mov edx, barcoDoisPos.x
    mov ebx, balaPos.x
    sub ebx, edx

    mov eax, balaPos.y
    mov ecx, barcoDoisPos.y
    sub ecx, eax
 
    .if ecx <= 40 && ebx <= 40
       ;exibir explosao
       mov achou, 3
      xor ecx, ecx
      mov ecx, barcoDoisPos.x
      mov explosaoPos.x, ecx

      xor edx, edx
      mov edx, barcoDoisPos.y
      mov explosaoPos.y, edx
      mov barcoDoisPos.x, 0  
      mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
          
    .endif

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    ret
VerificaSeAcertouBarcoDois endp 

VerificaFuel proc 
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    mov edx, fuelPos.x
    mov ebx, aviaoPos.x
    sub ebx, edx

    mov eax, aviaoPos.y
    mov ecx, fuelPos.y
    sub ecx, eax
 
    .if ecx <= 26 && ebx <= 46
      add acelera, 38       ;18173

      add tempo, 50

      .if tempo > 500
        mov tempo, 500
      .endif   

      add fuelPos.x,20

      .if fuelPos.x>650
        mov fuelPos.x, 200
      .endif
      mov fuelPos.y, 0      
    .endif

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    mov edx, fuelPos.x
    mov ebx, balaPos.x
    sub ebx, edx

    mov eax, balaPos.y
    mov ecx, fuelPos.y
    sub ecx, eax
 
    .if ecx <= 26 && ebx <= 26
      sub tempo, 150
      mov achou, 3
      
      ;exibir explosao
      xor ecx, ecx
      mov ecx, fuelPos.x
      mov explosaoPos.x, ecx

      xor edx, edx
      mov edx, fuelPos.y
      mov explosaoPos.y, edx
    
      add fuelPos.x,20

      .if fuelPos.x>650
        mov fuelPos.x, 200
      .endif
        mov fuelPos.y, 0      
    .endif

    ret
VerificaFuel endp  

VerificaSePerdeu proc 
    LOCAL aux:DWORD
    mov aux, 0

    prepara:
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    .if aux == 0
        mov edx, heliPos.x
        mov ebx, aviaoPos.x
        sub ebx, edx

        mov eax, aviaoPos.y
        mov ecx, heliPos.y
        sub ecx, eax
        inc aux
        jmp ok

    .elseif aux == 1
        mov edx, barcoPos.x
        mov ebx, aviaoPos.x
        sub ebx, edx

        mov eax, aviaoPos.y
        mov ecx, barcoPos.y
        sub ecx, eax
        inc aux
        jmp ok
    .elseif aux == 2
        mov edx, heliDoisPos.x
        mov ebx, aviaoPos.x
        sub ebx, edx

        mov eax, aviaoPos.y
        mov ecx, heliDoisPos.y
        sub ecx, eax
        inc aux
        jmp ok
    .elseif aux == 3
        mov edx, barcoDoisPos.x
        mov ebx, aviaoPos.x
        sub ebx, edx

        mov eax, aviaoPos.y
        mov ecx, barcoDoisPos.y
        sub ecx, eax
        inc aux
        jmp ok
    .elseif aux == 4
        ret
    .endif

    ok:
        .if ecx <= 20 && ebx <= 20
            xor ecx, ecx
            mov ecx, aviaoPos.x
            mov explosaoPos.x, ecx

            xor edx, edx
            mov edx, aviaoPos.y
            mov explosaoPos.y, edx
            inc perdeu
        .endif
        jmp prepara

    ret
VerificaSePerdeu endp 

Paint_Proc proc hWin:DWORD, hDC:DWORD  ;método que desenha todos os elementos da tela

    LOCAL hOld:DWORD
    LOCAL memDC :DWORD
  
    invoke CreateCompatibleDC,hDC
    mov memDC, eax

    ;----------fuel
    invoke SelectObject,memDC,hBmp7  ; selecionei o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,fuelPos.x,fuelPos.y,28,55,memDC,0,0,28,55,CREF_TRANSPARENT 

    ;-----------aviao
    invoke SelectObject,memDC,hBmp  ; selecionei o novo bitmap
    mov hOld, eax                                                 
    INVOKE  TransparentBlt,hDC,aviaoPos.x,aviaoPos.y,32,32,memDC,0,0,40,37,CREF_TRANSPARENT 

    ;----------helicoptero
    invoke SelectObject,memDC,hBmp2  ; selecionei o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,heliPos.x,heliPos.y,32,23,memDC,0,0,32,23,CREF_TRANSPARENT    
    INVOKE  TransparentBlt,hDC,heliDoisPos.x,heliDoisPos.y,32,23,memDC,0,0,32,23,CREF_TRANSPARENT    
    ;----------barco
    invoke SelectObject,memDC,hBmp4  ; selecionei o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,barcoPos.x,barcoPos.y,35,18,memDC,0,0,35,18,CREF_TRANSPARENT 
    INVOKE  TransparentBlt,hDC,barcoDoisPos.x,barcoDoisPos.y,35,18,memDC,0,0,35,18,CREF_TRANSPARENT 
    ;----------bala
    .if atirou > 0
        .if balaPos.y <= 0
            mov atirou,0         
        .elseif   
            invoke SelectObject,memDC,hBmp5  ; selecionei o novo bitmap
            mov hOld, eax     
            INVOKE  TransparentBlt,hDC,balaPos.x,balaPos.y,10,19,memDC,0,0,10,19,CREF_TRANSPARENT 
            ;sub balaPos.y, 25
            ;INVOKE  TransparentBlt,hDC,balaPos.x,balaPos.y,10,19,memDC,0,0,10,19,CREF_TRANSPARENT 
            ;sub balaPos.y, 23
            ;INVOKE  TransparentBlt,hDC,balaPos.x,balaPos.y,10,19,memDC,0,0,10,19,CREF_TRANSPARENT 
        .endif
    .endif

    ;----------explosao
    invoke SelectObject,memDC,hBmp6  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,explosaoPos.x, explosaoPos.y,30,23,memDC,0,0,30,23,CREF_TRANSPARENT  

    ;----------terraEsquerda
    invoke SelectObject,memDC,hBmp9  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC, 0,esqPos.x, 142,800,memDC,0,esqPos.y,142,800,CREF_TRANSPARENT  
    
    ;----------terraDireita
    invoke SelectObject,memDC,hBmp10  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,dirPos.x,0,160,800,memDC,0,dirPos.y,150,800,CREF_TRANSPARENT  

    ; ----------placar
    invoke SelectObject,memDC,hBmp8  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,0,492,835,120,memDC,0,0,800,180,CREF_TRANSPARENT 
    
    ; ----------gasometro
    invoke SelectObject,memDC,hBmp11  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,250,520,300,65,memDC,0,0,600,130,CREF_TRANSPARENT 

    ; ----------gas

    ;272 - E => vazio
    ;400 - 1/2 => metade
    ;520 - F => cheio

    invoke SelectObject,memDC,hBmp12  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,gasPos.x,gasPos.y,7,20,memDC,0,0,7,20,CREF_TRANSPARENT 

    ; ----------heliE
    invoke SelectObject,memDC,hBmp13  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,500,500,32,23,memDC,0,0,32,23,CREF_TRANSPARENT 

    ;-------------------------------------------------------
    invoke SelectObject,hDC,hOld
    invoke DeleteDC,memDC

    return 0
Paint_Proc endp

; ########################################################################


ThreadProc PROC USES ecx Param:DWORD  ;Thread executada para desenhar o bitmap do avião

    invoke WaitForSingleObject,hEventStart,100000 ;define o timer, de quanto em quanto tempo essa thread será chamada

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_FINISH,NULL,NULL
	    jmp   ThreadProc     

	.ELSEIF eax == WAIT_OBJECT_0	
	    invoke PostMessage,hWnd,WM_FINISH,NULL,NULL
	    jmp   ThreadProc
    .ENDIF
        
    jmp   ThreadProc
        
    ret
ThreadProc ENDP

ThreadBarcoProc PROC USES ecx Param:DWORD         ;Thread executada para desenhar o bitmap do barco                 

    invoke WaitForSingleObject,hEventStart,20     ;define o timer, de quanto em quanto tempo essa thread será chamada

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_T,NULL,NULL
	    jmp   ThreadBarcoProc     
    .ENDIF
        
    jmp   ThreadBarcoProc
        
    ret
ThreadBarcoProc ENDP

ThreadHeliProc PROC USES ecx Param:DWORD          ;Thread executada para desenhar o bitmap do helicopero                 

    invoke WaitForSingleObject,hEventStart,20     ;define o timer, de quanto em quanto tempo essa thread será chamada ;INFINITE
    
	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_T,NULL,NULL
	    jmp   ThreadHeliProc     
    .ENDIF
        
    jmp   ThreadHeliProc
        
    ret
ThreadHeliProc ENDP

ThreadBalaProc PROC USES ecx Param:DWORD             ;Thread executada para desenhar o bitmap d  bala, a cada 1 segundo, para ser rápida  (a cada um segundo ela é desenhada em sua posição, que muda constantemente quando o avião atira)                

    invoke WaitForSingleObject,hEventStart,1         ;define o timer, de quanto em quanto tempo essa thread será chamada

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_BALA,NULL,NULL
	    jmp   ThreadBalaProc     
    .ENDIF
        
    jmp   ThreadBalaProc
        
    ret
ThreadBalaProc ENDP

ThreadDownProc PROC USES ecx Param:DWORD     ;Thread executada para desenhar o ambiente, como todos os seus elementos exceto o avião, sempre mais "para baixo", criando a impressão que o avião está ind para frente               

    invoke WaitForSingleObject,hEventStart,80       ;define o timer, de quanto em quanto tempo essa thread será chamada

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_DOWN,NULL,NULL
	    jmp   ThreadDownProc     
    .ENDIF
        
    jmp   ThreadDownProc
        
    ret
ThreadDownProc ENDP

end start                                             ;finaliza o codigo  