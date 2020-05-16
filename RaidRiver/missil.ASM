; #########################################################################

    .386
    .model flat, stdcall  ; 32 bit memory model
    option casemap :none  ; case sensitive

    include bitblt.inc    ; local includes for this file

	; código de link para imagem no arquivo RC
	aviao		     equ		101
    helicopero       equ        103
    bala             equ        104
    barco            equ        102
    fundo            equ        106
    fuel             equ        105
    placar           equ        107
    explosao         equ        108
    esquerda         equ        109
    direita          equ        110

	CREF_TRANSPARENT  EQU 0FF00FFh
	CREF_TRANSPARENT2 EQU 0FF0000h

; #########################################################################

.code

start:

    ;---------------------------------------------
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    
    invoke LoadBitmap,hInstance, helicopero
    mov hBmp2, eax

    invoke GetCommandLine
    mov CommandLine, eax
    ;----------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance2, eax
 
    invoke LoadBitmap,hInstance2, aviao
    mov hBmp, eax

    invoke GetCommandLine
    mov CommandLine, eax

    ;----------------------------------------------
    ;  xor eax, eax
    ; invoke GetModuleHandle, NULL
    ; mov hInstance3, eax
 
    ; invoke LoadBitmap,hInstance3, fundo
    ; mov hBmp3, eax

    ; invoke GetCommandLine
    ; mov CommandLine, eax
    ;-----------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance4, eax
 
    invoke LoadBitmap,hInstance4, barco
    mov hBmp4, eax

    invoke GetCommandLine
    mov CommandLine, eax
    ;--------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance5, eax
 
    invoke LoadBitmap,hInstance5, bala
    mov hBmp5, eax

    invoke GetCommandLine
    mov CommandLine, eax
    ;--------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL            
    mov hInstance6, eax
 
    invoke LoadBitmap,hInstance6, explosao
    mov hBmp6, eax

    invoke GetCommandLine
    mov CommandLine, eax
    ;--------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL           
    mov hInstance7, eax
 
    invoke LoadBitmap,hInstance7, fuel
    mov hBmp7, eax

    invoke GetCommandLine
    mov CommandLine, eax
   
    ;--------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance8, eax
 
    invoke LoadBitmap,hInstance8, placar
    mov hBmp8, eax

    invoke GetCommandLine
    mov CommandLine, eax
   
    ;--------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance9, eax
 
    invoke LoadBitmap,hInstance9, esquerda
    mov hBmp9, eax

    invoke GetCommandLine
    mov CommandLine, eax
   
    ;--------------------------------------------

    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance10, eax
 
    invoke LoadBitmap,hInstance10, direita
    mov hBmp10, eax

    invoke GetCommandLine
    mov CommandLine, eax
   
    
    ;--------------------------------------------
    invoke WinMain,hInstance3,NULL,CommandLine,SW_SHOWDEFAULT
    invoke ExitProcess,eax

; #########################################################################

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

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

    szText szClassName,"Missil_20_Class"

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

    invoke CreateWindowEx,WS_EX_LEFT,
                          ADDR szClassName,
                          ADDR szDisplayName,
                          WS_OVERLAPPEDWINDOW,
                          Wtx,Wty,Wwd,Wht,
                          NULL,NULL,
                          hInst,NULL
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
    LOCAL Rct    :RECT
    LOCAL hDC    :DWORD
    LOCAL Ps     :PAINTSTRUCT

    .if uMsg == WM_COMMAND
    ;======== menu commands ========
		mov eax,wParam

    .elseif uMsg == WM_CREATE                                         ;instancia posições
		
        ;invoke SelectObject,memDC,hBmp9  ; selecionei o novo bitmap
        ; hOld, eax     
        ;INVOKE  TransparentBlt,hDC,0, esqPos.x,142,800,caW,0,esqPos.y,142,800,CREF_TRANSPARENT  
        ;invoke SelectObject,hDC,var
        ;invoke DeleteDC,memDC


        mov	missilAtual, 0
		mov missilPos.y, 450              ;320
		mov missilPos.x, 370

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
		invoke InvalidateRect,hWnd,NULL,TRUE

    .elseif uMsg == WM_KEYDOWN
        mov     eax,lParam
        and     eax, 000Fh
        .if wParam == VK_RIGHT
            .if missilPos.x<650
                add missilPos.x, 10
            .endif
            
        .elseif wParam == VK_LEFT
           .if missilPos.x>158
                sub missilPos.x, 20
            .endif

        .elseif wParam == VK_UP
            mov ecx, missilPos.x
            add ecx, 13
            mov balaPos.x, ecx
            mov ebx, missilPos.y
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
        
		invoke InvalidateRect,hWnd,NULL,TRUE

    .elseif uMsg==WM_T           
		;invoke InvalidateRect,hWnd,NULL,TRUE	

        invoke VerificaSeAcertouBarco
        inc barcoPos.x
        
        .if barcoPos.x > 645
            mov barcoPos.x,162
        .endif     

    ;.elseif uMsg==WM_HELI
        invoke VerificaFuel
        invoke VerificaSeAcertouHeli
        inc heliPos.x

        .if heliPos.x > 645
            mov heliPos.x,162
        .endif

     .elseif uMsg==WM_DOWN                          
        invoke Abaixa
    invoke InvalidateRect,hWnd,NULL,TRUE

    ;invoke InvalidateRect,hWnd,NULL,TRUE

    .elseif uMsg == WM_CLOSE
        szText TheText,"Tem certeza que deseja sair?"
        invoke MessageBox,hWin,ADDR TheText,ADDR szDisplayName,MB_YESNO
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
    .if achou == 0
        mov explosaoPos.y,0
        mov explosaoPos.x, -250        
    .endif
    dec achou

    .if acelera == 0             ;aqui que tá errado
        inc heliPos.y
        inc barcoPos.y 
        add fuelPos.y, 2
        inc explosaoPos.y
        xor ecx, ecx
        sub esqPos.y, 1
        sub dirPos.y, 1
    .elseif 
        dec acelera
        sub esqPos.y, 2
        sub dirPos.y, 2

        add heliPos.y, 2
        add barcoPos.y, 2 
        add fuelPos.y, 2
        xor ecx, ecx    
    .endif

    .if barcoPos.y > 365
        mov barcoPos.y,0
    .endif 

    .if heliPos.y > 365
        mov heliPos.y, 0
    .endif
    
    .if fuelPos.y > 485
        mov fuelPos.y, 0
    .endif
Abaixa ENDP


VerificaSeAcertouHeli proc ;pos:POINT<>     verificacao se o missel entrou em contato com helicoptero
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
      mov balaPos.x, 0                      ;'apaga' a bala pois ela acertou o alvo
    .endif

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    ret
VerificaSeAcertouHeli endp  

VerificaSeAcertouBarco proc ;pos:POINT<>
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
      mov balaPos.x, 0                      ;'apaga' a bala pois ela acertou o alvo
          
    .endif

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax
    ret
VerificaSeAcertouBarco endp 

VerificaFuel proc ;pos:POINT<>
    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx
    xor eax, eax

    mov edx, fuelPos.x
    mov ebx, missilPos.x
    sub ebx, edx

    mov eax, missilPos.y
    mov ecx, fuelPos.y
    sub ecx, eax
 
    .if ecx <= 16 && ebx <= 16
      mov achou, 3
      add acelera, 5
      ;invoke Abaixa
       ;exibir explosao
      ;xor ecx, ecx
      ;mov ecx, fuelPos.x
      ;mov explosaoPos.x, ecx

      ;xor edx, edx
      ;mov edx, fuelPos.y
      ;mov explosaoPos.y, edx
    
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
    ret
VerificaFuel endp  

Paint_Proc proc hWin:DWORD, hDC:DWORD

    LOCAL hOld:DWORD
    LOCAL memDC :DWORD

    ;invoke VerificaSeAcertouHeli
  
    invoke CreateCompatibleDC,hDC
    mov memDC, eax
    
    ;------------fundo
    ; mov ecx, exibiu

    ; .if ecx != 1
    ;     invoke SelectObject,memDC,hBmp3  ; selecionei o novo bitmap
    ;     mov hOld, eax    
    ;     INVOKE  TransparentBlt,hDC,0,0,1000,1000,memDC,0,256,32,32,CREF_TRANSPARENT 
    ;     mov exibiu, 1 
    ; .endif
  ;----------fuel
    invoke SelectObject,memDC,hBmp7  ; selecionei o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,fuelPos.x,fuelPos.y,28,55,memDC,0,0,28,55,CREF_TRANSPARENT 

    ;-----------aviao
    invoke SelectObject,memDC,hBmp  ; selecionei o novo bitmap
    mov hOld, eax                                                 
    INVOKE  TransparentBlt,hDC,missilPos.x,missilPos.y,32,32,memDC,0,0,40,37,CREF_TRANSPARENT 

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

    ;----------placar
    ;invoke SelectObject,memDC,hBmp8  ; seleciona o novo bitmap
    ;mov hOld, eax     
    ;INVOKE  TransparentBlt,hDC,0,361,785,100,memDC,0,0,800,180,CREF_TRANSPARENT 

    ;----------explosao
    invoke SelectObject,memDC,hBmp6  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,explosaoPos.x, explosaoPos.y,30,23,memDC,0,0,30,23,CREF_TRANSPARENT  

    ;----------terraEsquerda
    invoke SelectObject,memDC,hBmp9  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,0, esqPos.x,142,800,memDC,0,esqPos.y,142,800,CREF_TRANSPARENT  
    
    ;----------terraDireita
    invoke SelectObject,memDC,hBmp10  ; seleciona o novo bitmap
    mov hOld, eax     
    INVOKE  TransparentBlt,hDC,dirPos.x,0,150,800,memDC,0,esqPos.y,150,800,CREF_TRANSPARENT  
    
    
    ;-------------------------------------------------------
    invoke SelectObject,hDC,hOld
    invoke DeleteDC,memDC

    return 0

Paint_Proc endp

; ########################################################################


ThreadProc PROC USES ecx Param:DWORD

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

ThreadBarcoProc PROC USES ecx Param:DWORD                      

    invoke WaitForSingleObject,hEventStart,20 ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_T,NULL,NULL
	    jmp   ThreadBarcoProc     
    .ENDIF
        
    jmp   ThreadBarcoProc
        
    ret
ThreadBarcoProc ENDP

ThreadHeliProc PROC USES ecx Param:DWORD                      

    invoke WaitForSingleObject,hEventStart,20 ;INFINITE
    
	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_T,NULL,NULL
	    jmp   ThreadHeliProc     
    .ENDIF
        
    jmp   ThreadHeliProc
        
    ret
ThreadHeliProc ENDP

ThreadBalaProc PROC USES ecx Param:DWORD                      

    invoke WaitForSingleObject,hEventStart,1 ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_BALA,NULL,NULL
	    jmp   ThreadBalaProc     
    .ENDIF
        
    jmp   ThreadBalaProc
        
    ret
ThreadBalaProc ENDP

ThreadDownProc PROC USES ecx Param:DWORD                      

    invoke WaitForSingleObject,hEventStart,80       ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_DOWN,NULL,NULL
	    jmp   ThreadDownProc     
    .ENDIF
        
    jmp   ThreadDownProc
        
    ret
ThreadDownProc ENDP

end start                                             ;finaliza o codigo  