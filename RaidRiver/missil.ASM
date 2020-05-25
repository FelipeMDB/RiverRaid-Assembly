    .386
    .model flat, stdcall  ; 32 bit memory model
    option casemap :none  ; case sensitive
    include bitblt.inc    ; local includes for this file
	include \Masm32\include\winmm.inc 
    includelib \Masm32\lib\winmm.lib

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
    barcoE           equ       114  ; ...
    win              equ       115  ; ...
    gameOver         equ       116  ; ...

	CREF_TRANSPARENT  EQU 0FF00FFh
	CREF_TRANSPARENT2 EQU 0FF0000h


; ----------------------------------------------------------------------
; Prototypes are used in conjunction with the MASM "invoke" syntax for
; checking the number and size of parameters passed to a procedure. This
; improves the reliability of code that is written where errors in
; parameters are caught and displayed at assembly time.
; ----------------------------------------------------------------------

        WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
        WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        TopXY PROTO   :DWORD,:DWORD
		PlaySound	PROTO	STDCALL :DWORD, :DWORD, :DWORD
; #########################################################################






.data

    FileName0       db "00explosion_8bits.wav",0            ;som de explosao versao 1, nao utilizado por ser desagradavel
    FileName1       db "01explosion_8bits_versao2.wav",0    ;som de explosao dos obstaculos
    FileName2       db "02explosion_nave.wav",0             ;som de explosao da nave do jogador
    FileName3       db "03game_over.wav",0                  ;som de derrota (nava explodiu)
    FileName4       db "04laser_shot.wav",0                 ;som do tiro da nave do jogador
    FileName5       db "05victory.wav",0                    ;som de vitoria, venceu a fase

    Play0	  db "00explosion_8bits.wav",0		; Arquivo de Som
    Play1	  db "01explosion_8bits_versao2.wav",0		; Arquivo de Som
    Play2	  db "02explosion_nave.wav",0		; Arquivo de Som
    Play3	  db "03game_over.wav",0		; Arquivo de Som
    Play4	  db "04laser_shot.wav",0		; Arquivo de Som
    Play5	  db "05victory.wav",0		; Arquivo de Som
    somDeTiro db 0                      ;variavel para contagem do tiro (som desencadeado apenas no momento de uso do laser/tiro)

    ; - MCI_OPEN_PARMS Structure ( API=mciSendCommand ) -
    open_dwCallback     dd ?
    open_wDeviceID     dd ?
    open_lpstrDeviceType  dd ?
    open_lpstrElementName  dd ?
    open_lpstrAlias     dd ?

    ; - MCI_GENERIC_PARMS Structure ( API=mciSendCommand ) -
    generic_dwCallback   dd ?

    ; - MCI_PLAY_PARMS Structure ( API=mciSendCommand ) -
    play_dwCallback     dd ?
    play_dwFrom       dd ?
    play_dwTo        dd ?





    
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
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance14, eax                            ; ...
 
    invoke LoadBitmap,hInstance14, barcoE              ; ...
    mov hBmp14, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance15, eax                            ; ...
 
    invoke LoadBitmap,hInstance15, win              ; ...
    mov hBmp15, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;-----------------------------------------------------
    xor eax, eax                                    ; ...
    invoke GetModuleHandle, NULL                    ; ...
    mov hInstance16, eax                            ; ...
 
    invoke LoadBitmap,hInstance16, gameOver              ; ...
    mov hBmp16, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;-----------------------------------------------------
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

WndProc proc hWin   :DWORD,
             uMsg   :DWORD, 
             wParam :DWORD, 
             lParam :DWORD

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

        mov barcoDoisPos.y, 1000
		mov barcoDoisPos.x, 1000

        mov heliPos.y, 300
		mov heliPos.x, 20

        mov heliDoisPos.y, 10000
		mov heliDoisPos.x, 10000

        mov fuelPos.y, 0
        mov fuelPos.x, 250

        mov explosaoPos.x,-100

        mov esqPos.x, 0
        mov esqPos.y, 1398

        mov dirPos.x, 680
        mov dirPos.y, 1398

        mov gasPos.x, 520
        mov gasPos.y, 525

        mov heliEPos.x, 1000
        mov heliEPos.y, 1000

        mov heliEDoisPos.x, 625
        mov heliEDoisPos.y, 100

        mov barcoEPos.x, 1000
        mov barcoEPos.y, 1000

        mov barcoEDoisPos.x, 625
        mov barcoEDoisPos.y, 400

        mov winPos.x, 1000
        mov winPos.y, 1000

        mov gameOverPos.x, 1000
        mov gameOverPos.y, 1000

        mov tempo, 500

        mov heli2ParaEsq, 1
        mov barco2ParaEsq, 1

		
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

        
        szText inicio,"PREPARE-SE!"
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
        inc somDeTiro
        .if somDeTiro == 1
            invoke PlaySound, ADDR Play4, NULL, SND_FILENAME or SND_ASYNC ; SOM DA BALA
        .endif
        mov ecx, aviaoPos.x
        add ecx, 13
        mov balaPos.x, ecx
        mov ebx, aviaoPos.y
        mov balaPos.y, ebx
        inc atirou
        dec somDeTiro
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
		invoke InvalidateRect,hWnd,NULL,TRUE

    .elseif uMsg==WM_BARCO             ;chamado da thread a cada passo de seu timer
        invoke VerificaSePerdeu         
        invoke VerificaSeAcertouBarco
        invoke VerificaSeAcertouBarcoDois

        .if barcoParaEsq == 0
            inc barcoPos.x                    ;incrementa a posição do helicóptero 1, para ele se movimentar para a direita

            .if barcoPos.x > 650              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, barcoPos.y
                mov barcoEPos.y, ecx

                xor ecx, ecx
                mov ecx, barcoPos.x
                mov barcoEPos.x, ecx
                mov barcoPos.y, 1000

                mov barcoParaEsq, 1
            .endif
        .elseif
            dec barcoEPos.x

            .if barcoEPos.x < 145              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, barcoEPos.y
                mov barcoPos.y, ecx

                xor ecx, ecx
                mov ecx, barcoEPos.x 
                mov barcoPos.x, ecx
                mov barcoEPos.y, 1000

                mov barcoParaEsq, 0
            .endif
        .endif
        ; inc barcoPos.x
         
        ; .if barcoPos.x > 655       ;verifica se a posição x do barco 1 passou do limite
        ;     mov barcoPos.x,162     ;se passou, mudamos sua coordenada x para sua posição inicial, onde pode ser visto na tela
        ; .endif  

        .if barco2ParaEsq == 0
            inc barcoDoisPos.x                    ;incrementa a posição do helicóptero 1, para ele se movimentar para a direita

            .if barcoDoisPos.x > 655              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, barcoDoisPos.y
                mov barcoEDoisPos.y, ecx

                xor ecx, ecx
                mov ecx, barcoDoisPos.x
                mov barcoEDoisPos.x, ecx
                mov barcoDoisPos.y, 1000

                mov barco2ParaEsq, 1
            .endif
        .elseif
            dec barcoEDoisPos.x

            .if barcoEDoisPos.x < 145              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, barcoEDoisPos.y
                mov barcoDoisPos.y, ecx

                xor ecx, ecx
                mov ecx, barcoEDoisPos.x 
                mov barcoDoisPos.x, ecx
                mov barcoEDoisPos.y, 1000

                mov barco2ParaEsq, 0
            .endif
        .endif

        ; inc barcoDoisPos.x         ;incrementa a posição do barco, para ele "ir para frente"
        
        ; .if barcoDoisPos.x > 655   ;verifica se a posição x do barco 2 passou do limite
        ;     mov barcoDoisPos.x,162 ;se passou, mudamos sua coordenada x para sua posição inicial, onde pode ser visto na tela
        ; .endif    

    .elseif uMsg==WM_HELI
        invoke VerificaFuel              ;verifica se o jogador passou pela posição do combustível
        invoke VerificaSeAcertouHeli     ;verifica se o jogador passou pela posição do helicóptero 1
        invoke VerificaSeAcertouHeliDois ;verifica se o jogador passou pela posição do helicóptero 2
       
        .if heliParaEsq == 0
            inc heliPos.x                    ;incrementa a posição do helicóptero 1, para ele se movimentar para a direita

            .if heliPos.x > 655              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, heliPos.y
                mov heliEPos.y, ecx

                xor ecx, ecx
                mov ecx, heliPos.x
                mov heliEPos.x, ecx
                mov heliPos.y, 1000

                mov heliParaEsq, 1
            .endif
        .elseif
            dec heliEPos.x

            .if heliEPos.x < 145              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, heliEPos.y
                mov heliPos.y, ecx

                xor ecx, ecx
                mov ecx, heliEPos.x 
                mov heliPos.x, ecx
                mov heliEPos.y, 1000

                mov heliParaEsq, 0
            .endif
        .endif

        .if heli2ParaEsq == 0
            inc heliDoisPos.x                    ;incrementa a posição do helicóptero 1, para ele se movimentar para a direita

            .if heliDoisPos.x > 655              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, heliDoisPos.y
                mov heliEDoisPos.y, ecx

                xor ecx, ecx
                mov ecx, heliDoisPos.x
                mov heliEDoisPos.x, ecx
                mov heliDoisPos.y, 1000

                mov heli2ParaEsq, 1
            .endif
        .elseif
            dec heliEDoisPos.x

            .if heliEDoisPos.x < 145              ;verifica se a posição x do helicóptero 1 passou do limite
                xor ecx, ecx
                mov ecx, heliEDoisPos.y
                mov heliDoisPos.y, ecx

                xor ecx, ecx
                mov ecx, heliEDoisPos.x 
                mov heliDoisPos.x, ecx
                mov heliEDoisPos.y, 1000

                mov heli2ParaEsq, 0
            .endif
        .endif
        

     .elseif uMsg==WM_DOWN               ;chamado da thread a cada passo de seu timer     
            invoke Abaixa                ;chama procedimento que incrementa a coordenada y dos elementos da tela, para dar a impressão que o avião está indo para frente
            invoke InvalidateRect,hWnd, addr Rect,TRUE   ;Atualiza a tela, redesenhando a áerea delimitada pelo Rec de novo

    .elseif uMsg == WM_CLOSE             ;verifica se o jogador quer fechar a tela e parar a execução
        szText perg,"Tem certeza que deseja sair?"         ;mensagem de confirmação exibida para o usuário confirmar sua saída
        invoke MessageBox,hWin,ADDR perg,ADDR szDisplayName,MB_YESNO ;criação da MessageBox, com as opções sim ou não, com o texto acima
          .if eax == IDNO   ;se o jogador não quer fechar o progama
            return 0        ;retorna zero, voltando à execução do jogo normalmente
          .endif

    .elseif uMsg == WM_DESTROY       ;se o programa for fechado
        invoke PostQuitMessage,NULL  
        return 0                     ;interrompemos a execução
    .endif

    invoke DefWindowProc,hWin,uMsg,wParam,lParam   ;define o estado atual da janela, atualizando suas características
    ret
WndProc endp                ;término da definição do procedimento

verifica proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD ;Procedimento chamado quando o usuário perdeu, pergunta se ele quer jogar novamente ou sair
       
        mov sera, 2                                                   ;necesário para não entrar em loop e exibir diversas vezes na execução repetida da chamada desse procedimento
        .if perdeu > 0                                                ;verifica se foi atingido ou se sua gasolina acabou                                       ;verifica se perdeu porque foi atingido por um obstáculo
            mov aviaoPos.x,0
            mov gameOverPos.x,0
            mov gameOverPos.y,0
            invoke PlaySound, ADDR Play2, NULL, SND_FILENAME or SND_ASYNC ; SOM DE EXPLOSAO DA NAVE
            invoke PlaySound, ADDR Play3, NULL, SND_FILENAME or SND_ASYNC ; SOM DE DERROTA
            szText msg,"Voce foi atingido!"                           ;cria a variavel contendo o texto que será a mensagem
            invoke MessageBox,hWin,ADDR msg,ADDR szDisplayName,MB_OK  ;cria a message box, do tipo que notifica o usuário e espera sua confirmação, com texto criado acima
            .if eax == IDOK            
                invoke ExitProcess, 0                                 ;interrompe e execução do programa, fecha a janela
            .endif 
        .elseif
            mov gameOverPos.x,0
            mov gameOverPos.y,0
            invoke PlaySound, ADDR Play3, NULL, SND_FILENAME or SND_ASYNC ; SOM DE DERROTA
            szText msgG,"Sua gasolina acabou, voce perdeu!"  ;cria a variavel contendo o texto que será a mensagem
            invoke MessageBox,hWin,ADDR msgG,ADDR szDisplayName,MB_OK  ;cria a message box, do tipo que notifica o usuário e espera sua confirmação, com texto criado acima
            .if eax == IDOK               
                invoke ExitProcess, 0                   ;interrompe e execução do programa, fecha a janela
            .endif                                      ;determina que o if acabou
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

Abaixa proc ;Procedimento chamado a cada segundo, para atualizar a coordenada y de cada elemento da tela
            ;para criar a impressão que o avião está se movimentando para frente, quando na verdade são os outros
            ;elementos que estão "indo para baixo"
    .if sera == 0      ;se o usuário não perdeu o jogo até agora
        .if perdeu > 0  || acabouGasolina > 0 ;verifica se acabou de perder
        invoke verifica, NULL,NULL,NULL, NULL ;chamada do procedimento para interromper e avisar o jogador que perdeu
        .endif
    .endif
    .if tempo > 0     ;se o tempo de vida não acabou
        dec tempo     ;decrementamos 1 segundo de seu tempo de vida
    .endif

    .if tempo < 2          ;se acabou o tempo de vida
        inc acabouGasolina  ;incrementamos a variável que representa que acabou a gasoline, e portanto o jogo acabou
    .elseif

    ;0->    272
    ;1000-> 520
    ;248
    ; 248    -  1000
    ; pos x  -  tempo 
    ;multiplicar o tempo por 248 e dividir por 1000
    ; somar 272

    xor eax,eax               ;apaga qualquer valor que tenha nos registradores para auxiliarem na lógica abaixo
    xor ecx, ecx             

    mov eax, tempo
    mov ecx, 248
    imul ecx

    xor ecx,ecx
    mov ecx, 500

    div ecx

    add eax, 272

    mov gasPos.x, eax

    .if achou == 0              ;verifica se a bomba já foi exibida 
        mov explosaoPos.y,0     ;se já foi, tiramos ela da vista da tela
        mov explosaoPos.x, -250 ;posicionamos o bitmap da explosão fora dos limites de visão da janela do jogo
    .endif
    dec achou                   ;diminuimos o tempo em que a explosão será exibida

    .if acelera == 0            ;se a velocidade da movimentação da tela é a original, sem sofrer influências do combustível     
        .if heliParaEsq == 0 
            inc heliPos.y           ;incrementamos a coordenada y de cada elemento para irem mais para baixo da janela
        .elseif
            inc heliEPos.y
        .endif

        .if heli2ParaEsq == 0 
            inc heliDoisPos.y           ;incrementamos a coordenada y de cada elemento para irem mais para baixo da janela
        .elseif
            inc heliEDoisPos.y
        .endif

        .if barcoParaEsq == 0 
            inc barcoPos.y           ;incrementamos a coordenada y de cada elemento para irem mais para baixo da janela
        .elseif
            inc barcoEPos.y
        .endif

        .if barco2ParaEsq == 0 
            inc barcoDoisPos.y           ;incrementamos a coordenada y de cada elemento para irem mais para baixo da janela
        .elseif
            inc barcoEDoisPos.y
        .endif

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

    .elseif                   ;se o valor da variável acelerafor diferente de zero, 
                              ;o jogador passou pelo combústivel, então devemos acelerar a movimentação da tela
        .if acelera <= 10     ;se o efeito do combustível estiver acabando
            dec acelera       ;decrementamos acelera, que funciona como um timer
            xor ebx, ebx      ;limpamos o registrador para usá-lo como auxiliar
            mov ebx, 3        ;atribuimos ao registrador o valor que 
        .elseif acelera <= 20 ;se devemos acelerar, mas não na velocidade máxima
            dec acelera       ;decrementamos acelera, que funciona como um timer
            xor ebx, ebx      ;limpamos o registrador para usá-lo como auxiliar
            mov ebx, 8
        .elseif               ;se devemos acelerar na velocidade máxima
            dec acelera       ;decrementamos acelera, que funciona como um timer
            xor ebx, ebx      ;limpamos o registrador para usá-lo como auxiliar
            mov ebx, 15
        .endif

        sub esqPos.y, ebx
        .if esqPos.y <= 10
            mov esqPos.y, 1398
        .endif

        sub dirPos.y, ebx
        .if dirPos.y <= 10
            mov dirPos.y, 1398
        .endif

        .if heliParaEsq == 0 
           add heliPos.y, ebx
        .elseif
            add heliEPos.y, ebx
        .endif
        
        .if heli2ParaEsq == 0 
           add heliDoisPos.y, ebx
        .elseif
            add heliEDoisPos.y, ebx
        .endif

        .if barcoParaEsq == 0 
           add barcoPos.y, ebx
        .elseif
            add barcoEPos.y, ebx
        .endif

        .if barco2ParaEsq == 0 
           add barcoDoisPos.y, ebx
        .elseif
            add barcoEDoisPos.y, ebx
        .endif

        add fuelPos.y, ebx
        xor ecx, ecx    
    .endif

    .if barcoParaEsq == 0 
        .if barcoPos.y > 465
            mov barcoPos.y, 0
        .endif
    .elseif
        .if barcoEPos.y > 465
            mov barcoEPos.y, 0
        .endif
    .endif

    .if barco2ParaEsq == 0 
        .if barcoDoisPos.y > 465
            mov barcoDoisPos.y, 0
        .endif
    .elseif
        .if barcoEDoisPos.y > 465
            mov barcoEDoisPos.y, 0
        .endif
    .endif


    .if heliParaEsq == 0 
        .if heliPos.y > 465
            mov heliPos.y, 0
        .endif
    .elseif
        .if heliEPos.y > 465
            mov heliEPos.y, 0
        .endif
    .endif


    .if heli2ParaEsq == 0 
        .if heliDoisPos.y > 465
            mov heliDoisPos.y, 0
        .endif
    .elseif
        .if heliEDoisPos.y > 465
            mov heliEDoisPos.y, 0
        .endif
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
    
    .if heliParaEsq == 0
        mov edx, heliPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, heliPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .elseif
        mov edx, heliEPos.x                      ;guarda em ecx a posicao 'y' do helicoptero
        mov ecx, heliEPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .endif

    mov ebx, balaPos.x                      ;guarda em ebx a posicao x da bala
    sub ebx, edx                            ;subtrai de ebx e armazena em edx

    mov eax, balaPos.y                      ;guarda em eax a posicao 'y' da bala
    sub ecx, eax       
    
                         ;subtrai de eax e armazena em ecx
    
    .if ecx <= 35 && ebx <= 35
    ;exibir explosao
    mov achou, 3
    xor ecx, ecx

    .if heliParaEsq == 0
        mov ecx, heliPos.x
    .elseif
        mov ecx, heliEPos.x
    .endif

    mov explosaoPos.x, ecx

    xor edx, edx

    .if heliParaEsq == 0
        mov edx, heliPos.y
    .elseif
        mov edx, heliEPos.y
    .endif

    mov explosaoPos.y, edx

    .if heliParaEsq == 0
        mov heliPos.x, 0
        mov heliPos.y, 0
    .elseif
        mov heliEPos.x, 1000
        mov heliPos.x, 0
        mov heliPos.y, 0
        mov heliParaEsq, 0
    .endif

    mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
    invoke PlaySound, ADDR Play1, NULL, SND_FILENAME or SND_ASYNC ; SOM DE EXPLOSAO DO HELICOPTERO
    .endif
    ret
VerificaSeAcertouHeli endp  

VerificaSeAcertouHeliDois proc                  ;verificacao se o missel entrou em contato com helicoptero
    xor edx, edx                            ;limpa os registradores 
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    .if heli2ParaEsq == 0
        mov edx, heliDoisPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, heliDoisPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .elseif
        mov edx, heliEDoisPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, heliEDoisPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .endif

    mov ebx, balaPos.x                      ;guarda em ebx a posicao x da bala
    sub ebx, edx                            ;subtrai de ebx e armazena em edx

    mov eax, balaPos.y                      ;guarda em eax a posicao 'y' da bala
    sub ecx, eax       
    
                         ;subtrai de eax e armazena em ecx
    
    .if ecx <= 35 && ebx <= 35
    ;exibir explosao
    mov achou, 3
    xor ecx, ecx
    xor edx, edx

    .if heli2ParaEsq == 0
        mov ecx, heliDoisPos.x
        mov edx, heliDoisPos.y
    .elseif
        mov ecx, heliEDoisPos.x
        mov edx, heliEDoisPos.y
    .endif

    mov explosaoPos.x, ecx
    mov explosaoPos.y, edx
    .if heli2ParaEsq == 0
        mov heliDoisPos.x, 660  
    .elseif
        mov heliEDoisPos.x, 660   
    .endif

    mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
    invoke PlaySound, ADDR Play1, NULL, SND_FILENAME or SND_ASYNC ; SOM DE EXPLOSAO DO HELICOPTERO
    .endif
    ret
VerificaSeAcertouHeliDois endp 

VerificaSeAcertouBarco proc 
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    .if barcoParaEsq == 0
        mov edx, barcoPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, barcoPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .elseif
        mov edx, barcoEPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, barcoEPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .endif

    mov ebx, balaPos.x
    sub ebx, edx

    mov eax, balaPos.y
    sub ecx, eax
 
    .if ecx <= 40 && ebx <= 40
       ;exibir explosao
       mov achou, 3
        xor ecx, ecx
        xor edx, edx

    .if barcoParaEsq == 0
        mov ecx, barcoPos.x
        mov edx, barcoPos.y
    .elseif
        mov ecx, barcoEPos.x
        mov edx, barcoEPos.y
    .endif

      mov explosaoPos.x, ecx
      mov explosaoPos.y, edx

      .if barcoParaEsq == 0
        mov barcoPos.x, 0  
      .elseif
        mov barcoEPos.x, 0  
      .endif

      mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
      invoke PlaySound, ADDR Play1, NULL, SND_FILENAME or SND_ASYNC ; SOM DE EXPLOSAO DO BARCO
          
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

    .if barco2ParaEsq == 0
        mov edx, barcoDoisPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, barcoDoisPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .elseif
        mov edx, barcoEDoisPos.x                      ;guarda em edx a posicao 'x' do helicoptero
        mov ecx, barcoEDoisPos.y                      ;guarda em ecx a posicao 'y' do helicoptero
    .endif

    mov ebx, balaPos.x
    sub ebx, edx

    mov eax, balaPos.y
    sub ecx, eax
 
    .if ecx <= 40 && ebx <= 40
       ;exibir explosao
        mov achou, 3
        xor ecx, ecx
        xor edx, edx

        .if barco2ParaEsq == 0
            mov ecx, barcoDoisPos.x
            mov edx, barcoDoisPos.y
        .elseif
            mov ecx, barcoEDoisPos.x
            mov edx, barcoEDoisPos.y
        .endif
      
        mov explosaoPos.x, ecx
        mov explosaoPos.y, edx

        .if barco2ParaEsq == 0
            mov barcoDoisPos.x, 0  
        .elseif
            mov barcoEDoisPos.x,0
        .endif
        mov balaPos.x, -20                      ;'apaga' a bala pois ela acertou o alvo
        invoke PlaySound, ADDR Play1, NULL, SND_FILENAME or SND_ASYNC ; SOM DE EXPLOSAO DO HELICOPTERO
          
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
      add acelera, 58      

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
        
      invoke PlaySound, ADDR Play1, NULL, SND_FILENAME or SND_ASYNC ; SOM DE EXPLOSAO DO FUEL  
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
    INVOKE  TransparentBlt,hDC,heliEPos.x,heliEPos.y,32,23,memDC,0,0,32,23,CREF_TRANSPARENT 
    INVOKE  TransparentBlt,hDC,heliEDoisPos.x,heliEDoisPos.y,32,23,memDC,0,0,32,23,CREF_TRANSPARENT 

    ; ----------barcoE
    invoke SelectObject,memDC,hBmp14  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,barcoEPos.x,barcoEPos.y,35,18,memDC,0,0,35,18,CREF_TRANSPARENT 
    INVOKE  TransparentBlt,hDC,barcoEDoisPos.x,barcoEDoisPos.y,35,18,memDC,0,0,35,18,CREF_TRANSPARENT 

    ; ----------win
    invoke SelectObject,memDC,hBmp15  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,winPos.x,winPos.y,850,650,memDC,0,0,850,650,CREF_TRANSPARENT 

    ; ----------game over
    invoke SelectObject,memDC,hBmp16  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,gameOverPos.x,gameOverPos.y,850,650,memDC,0,0,850,650,CREF_TRANSPARENT 
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
	    invoke PostMessage,hWnd,WM_BARCO,NULL,NULL
	    jmp   ThreadBarcoProc     
    .ENDIF
        
    jmp   ThreadBarcoProc
        
    ret
ThreadBarcoProc ENDP

ThreadHeliProc PROC USES ecx Param:DWORD          ;Thread executada para desenhar o bitmap do helicopero                 

    invoke WaitForSingleObject,hEventStart,10     ;define o timer, de quanto em quanto tempo essa thread será chamada ;INFINITE
    
	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_HELI,NULL,NULL
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

	.IF eax == WAIT_TIMEOUT	                        ;se o tempo definido acima acabou
	    invoke PostMessage,hWnd,WM_DOWN,NULL,NULL
	    jmp   ThreadDownProc                        ;inicia essa thread de novo
    .ENDIF
        
    jmp   ThreadDownProc
        
    ret
ThreadDownProc ENDP

end start                                             ;finaliza o codigo  