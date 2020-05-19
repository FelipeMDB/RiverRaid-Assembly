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

	CREF_TRANSPARENT  EQU 0FF00FFh
	CREF_TRANSPARENT2 EQU 0FF0000h
    
.code

start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    
    invoke LoadBitmap,hInstance, helicopero         ;encontra, pelo nome definido acima, o código do bitmap que queremos 
    mov hBmp2, eax                                  ;atribui o bitmap à variável para conseguirmos usá-lo depois no programa

    invoke GetCommandLine
    mov CommandLine, eax
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
 
    invoke LoadBitmap,hInstance11, gasometro          ; ...
    mov hBmp11, eax                                 ; ...

    invoke GetCommandLine                           ; ...
    mov CommandLine, eax                            ; ...
    ;--------------------------------------------
    invoke WinMain,hInstance3,NULL,CommandLine,SW_SHOWDEFAULT
    invoke ExitProcess,eax

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
    mov wc.hbrBackground, 0EH
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
    LOCAL Rct    :RECT
    LOCAL hDC    :DWORD
    LOCAL Ps     :PAINTSTRUCT
    LOCAL Rect   :RECT

    mov Rect.left, 0
    mov Rect.top, 0
    mov Rect.bottom, 498
    mov Rect.right, 1000000


  

    .if uMsg == WM_COMMAND
		mov eax,wParam

    .elseif uMsg == WM_CREATE                                         ;instancia posições

        ;mov	aviaoAtual, 0 

        ;Posicionamento inicial de cada componente, suas coordenadas x e y             
		mov aviaoPos.y, 450                    
		mov aviaoPos.x, 370                    

        mov barcoPos.y, 80
		mov barcoPos.x, 100

        mov heliPos.y, 300
		mov heliPos.x, 20

        mov fuelPos.y, 0
        mov fuelPos.x, 250

        mov explosaoPos.x,-100

        mov esqPos.x, 0
        mov esqPos.y, 1398

        mov dirPos.x,680
        mov dirPos.y,1398

		
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
        inc barcoPos.x
        
        .if barcoPos.x > 655
            mov barcoPos.x,162
        .endif     

    ;.elseif uMsg==WM_HELI
        invoke VerificaFuel
        invoke VerificaSeAcertouHeli
        inc heliPos.x

        .if heliPos.x > 655
            mov heliPos.x,162
        .endif

     .elseif uMsg==WM_DOWN  
            invoke Abaixa
            invoke InvalidateRect,hWnd, addr Rect,TRUE
                     
    .if perdeu > 0
        mov Rect.left, 45000
        mov Rect.top, 978970
        mov Rect.bottom, 8979780
        mov Rect.right, 987970
        
        invoke ExitProcess, 0
        szText msg,"Você foi atingido! Deseja jogar de novo?"
        invoke MessageBox,hWin,ADDR msg,ADDR szDisplayName,MB_OK
            .if eax == IDOK
                invoke ExitProcess, 0
            .endif
        .elseif acabouGasolina > 0
            mov Rect.left, 10000
            mov Rect.top, 100000
            mov Rect.bottom, 1000000
            mov Rect.right, 10000
            invoke ExitProcess, 0
            szText msgG,"Sua gasolina acabou, você perdeu! Deseja jogar de novo?"
            invoke MessageBox,hWin,ADDR msgG,ADDR szDisplayName,MB_YESNO
                .if eax == IDNO
                    invoke ExitProcess, 0
                .elseif
                    ;invoke ExitProcess, 0   ;AQUI GENTE
                .endif
                
    .endif

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
    inc tempo

    .if tempo == 1000
        inc acabouGasolina
    .endif

    .if achou == 0
        mov explosaoPos.y,0
        mov explosaoPos.x, -250        
    .endif
    dec achou

    .if acelera == 0        
        inc heliPos.y
        inc barcoPos.y 
        add fuelPos.y, 2
        inc explosaoPos.y
        xor ecx, ecx
        sub esqPos.y, 1
        sub dirPos.y, 1
    .elseif 
        dec acelera
        sub esqPos.y, 10
        sub dirPos.y, 10

        add heliPos.y, 10
        add barcoPos.y, 10 
        add fuelPos.y, 10
        xor ecx, ecx    
    .endif

    .if barcoPos.y > 465
        mov barcoPos.y,0
    .endif 

    .if heliPos.y > 465
        mov heliPos.y, 0
    .endif
    
    .if fuelPos.y > 485
        mov fuelPos.y, 0
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
    sub ecx, eax                            ;subtrai de eax e armazena em ecx
 
    .if ecx <= 18 && ebx <= 18
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

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    ret
VerificaSeAcertouHeli endp  

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
 
    .if ecx <= 18 && ebx <= 18
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
 
    .if ecx <= 26 && ebx <= 26
      add acelera, 500
    
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
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    mov edx, heliPos.x
    mov ebx, aviaoPos.x
    sub ebx, edx

    mov eax, aviaoPos.y
    mov ecx, heliPos.y
    sub ecx, eax
 
    .if ecx <= 20 && ebx <= 20
        xor ecx, ecx
        mov ecx, aviaoPos.x
        mov explosaoPos.x, ecx

        xor edx, edx
        mov edx, aviaoPos.y
        mov explosaoPos.y, edx
        inc perdeu
    .endif

    mov edx, barcoPos.x
    mov ebx, aviaoPos.x
    sub ebx, edx

    mov eax, aviaoPos.y
    mov ecx, barcoPos.y
    sub ecx, eax
 
    .if ecx <= 20 && ebx <= 20
        xor ecx, ecx
        mov ecx, aviaoPos.x
        mov explosaoPos.x, ecx

        xor edx, edx
        mov edx, aviaoPos.y
        mov explosaoPos.y, edx
        inc perdeu
    .endif

    ; mov edx, fuelPos.x
    ; mov ebx, aviaoPos.x
    ; sub ebx, edx

    ; mov eax, fuelPos.y
    ; mov ecx, barcoPos.y
    ; sub ecx, eax
 
    ; .if ecx <= 16 && ebx <= 16
    ;     xor ecx, ecx
    ;     mov ecx, aviaoPos.x
    ;     mov explosaoPos.x, ecx

    ;     xor edx, edx
    ;     mov edx, aviaoPos.y
    ;     mov explosaoPos.y, edx
    ;     inc perdeu
    ; .endif

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
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

    ;----------barco
    invoke SelectObject,memDC,hBmp4  ; selecionei o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,barcoPos.x,barcoPos.y,35,18,memDC,0,0,35,18,CREF_TRANSPARENT 

    ;----------bala
    .if atirou > 0
        .if balaPos.y <= 0
            mov atirou,0         
        .elseif   
            invoke SelectObject,memDC,hBmp5  ; selecionei o novo bitmap
            mov hOld, eax     
            INVOKE  TransparentBlt,hDC,balaPos.x,balaPos.y,10,19,memDC,0,0,10,19,CREF_TRANSPARENT 
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
    INVOKE  TransparentBlt,hDC,dirPos.x,0,150,800,memDC,0,esqPos.y,150,800,CREF_TRANSPARENT  

    ; ----------placar
    invoke SelectObject,memDC,hBmp8  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,0,492,835,120,memDC,0,0,800,180,CREF_TRANSPARENT 
    
    ; ----------gasometro
    invoke SelectObject,memDC,hBmp11  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,0,492,100,20,memDC,0,0,600,148,CREF_TRANSPARENT 
    ;-------------------------------------------------------
    invoke SelectObject,hDC,hOld
    invoke DeleteDC,memDC

    return 0
Paint_Proc endp

; ########################################################################


ThreadProc PROC USES ecx Param:DWORD  ;Thread executada para desenhar o bitmap do avião

    invoke WaitForSingleObject,hEventStart,100000 ;INFINITE

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

ThreadBarcoProc PROC USES ecx Param:DWORD     ;Thread executada para desenhar o bitmap do barco                 

    invoke WaitForSingleObject,hEventStart,20 ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_T,NULL,NULL
	    jmp   ThreadBarcoProc     
    .ENDIF
        
    jmp   ThreadBarcoProc
        
    ret
ThreadBarcoProc ENDP

ThreadHeliProc PROC USES ecx Param:DWORD     ;Thread executada para desenhar o bitmap do helicopero                 

    invoke WaitForSingleObject,hEventStart,20 ;INFINITE
    
	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_T,NULL,NULL
	    jmp   ThreadHeliProc     
    .ENDIF
        
    jmp   ThreadHeliProc
        
    ret
ThreadHeliProc ENDP

ThreadBalaProc PROC USES ecx Param:DWORD     ;Thread executada para desenhar o bitmap d  bala, a cada 1 segundo, para ser rápida  (a cada um segundo ela é desenhada em sua posição, que muda constantemente quando o avião atira)                

    invoke WaitForSingleObject,hEventStart,1 ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_BALA,NULL,NULL
	    jmp   ThreadBalaProc     
    .ENDIF
        
    jmp   ThreadBalaProc
        
    ret
ThreadBalaProc ENDP

ThreadDownProc PROC USES ecx Param:DWORD     ;Thread executada para desenhar o ambiente, como todos os seus elementos exceto o avião, sempre mais "para baixo", criando a impressão que o avião está ind para frente               

    invoke WaitForSingleObject,hEventStart,80       ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_DOWN,NULL,NULL
	    jmp   ThreadDownProc     
    .ENDIF
        
    jmp   ThreadDownProc
        
    ret
ThreadDownProc ENDP

end start                                             ;finaliza o codigo  