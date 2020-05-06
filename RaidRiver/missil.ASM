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
    ;terraE           equ        105
    ;fuel             equ        107

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
    xor eax, eax
    invoke GetModuleHandle, NULL
    mov hInstance4, eax
 
    invoke LoadBitmap,hInstance4, barco
    mov hBmp4, eax

    invoke GetCommandLine
    mov CommandLine, eax
    ;--------------------------------------------
    ;xor eax, eax
    ;invoke GetModuleHandle, NULL            ;aqui
    ;mov hInstance6, eax
 
    ;invoke LoadBitmap,hInstance6, terraE
    ;mov hBmp6, eax

    ;invoke GetCommandLine
    ;mov CommandLine, eax
    ;--------------------------------------------
    ;xor eax, eax
    ;invoke GetModuleHandle, NULL           
    ;mov hInstance7, eax
 
    ;invoke LoadBitmap,hInstance7, fuel
    ;mov hBmp7, eax

    ;invoke GetCommandLine
    ;mov CommandLine, eax
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
    mov hInstance3, eax
 
    invoke LoadBitmap,hInstance3, fundo
    mov hBmp3, eax

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
    mov wc.hbrBackground,  10h
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

    mov Wwd, 800
    mov Wht, 500

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
		mov	missilAtual, 0
		mov missilPos.y, 400
		mov missilPos.x, 100

        mov barcoPos.y, 80
		mov barcoPos.x, 100

        mov heliPos.y, 300
		mov heliPos.x, 10
		
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

		
    .elseif uMsg == WM_SIZE
;    // obter o tamanho da janela
    
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
            add missilPos.x, 10
            
        .elseif wParam == VK_LEFT
            sub missilPos.x, 20

        .elseif wParam == VK_UP
            mov ecx, missilPos.x
            mov balaPos.x, ecx
            mov ebx, missilPos.y
            mov balaPos.y, ebx
            mov atirou, 1
        .endif
		
    .elseif uMsg == WM_PAINT
        invoke BeginPaint,hWin,ADDR Ps
        mov hDC, eax
        invoke Paint_Proc,hWin,hDC
        invoke EndPaint,hWin,ADDR Ps
        return 0

   	    
   .elseif uMsg==WM_FINISH
        .if atirou == 1
            sub balaPos.y, 1
        .endif

		.if missilPos.y <= 0                              ;aviao
			mov missilPos.y,100
			mov missilPos.x,100
		.endif 
		invoke InvalidateRect,hWnd,NULL,TRUE	

    .elseif uMsg==WM_BARCO                               

        inc barcoPos.x
        
        .if barcoPos.x > 800
            mov barcoPos.y,80
            mov barcoPos.x,0
        .endif 

    .elseif uMsg==WM_HELI
        inc heliPos.x

        .if heliPos.x > 800
            mov heliPos.y,80
            mov heliPos.x,0
        .endif 

;		invoke InvalidateRect,hWnd,NULL,TRUE

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

Paint_Proc proc hWin:DWORD, hDC:DWORD

    LOCAL hOld:DWORD
    LOCAL memDC :DWORD
 
    
    invoke CreateCompatibleDC,hDC
    mov memDC, eax
    
    ;------------fundo
    invoke SelectObject,memDC,hBmp3  ; selecionei o novo bitmap
    mov hOld, eax    
    INVOKE  TransparentBlt,hDC,0,0,1000,1000,memDC,0,256,32,32,CREF_TRANSPARENT    
 
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
    INVOKE  TransparentBlt,hDC,barcoPos.x,100,35,18,memDC,0,0,35,18,CREF_TRANSPARENT 

    ;----------bala
    .if atirou == 1 
        .if balaPos.y <= 0
            mov atirou,0
        .elseif   
            invoke SelectObject,memDC,hBmp5  ; selecionei o novo bitmap
            mov hOld, eax     
            INVOKE  TransparentBlt,hDC,balaPos.x,balaPos.y,10,19,memDC,0,0,10,19,CREF_TRANSPARENT 
        .endif
    .endif

  ;---------------------------------------
  ;verifica se o usuário perdeu o jogo
  mov ebx, barcoPos.x          ;melhorar lógica disso dps
  mov ecx,  barcoPos.y
  .if missilPos.x == ebx
    .if missilPos.y == ecx
        mov perdeu, 1
    .endif
  .endif 
  mov ebx, heliPos.x
  mov ecx, heliPos.y
  .if missilPos.x == ebx
    .if missilPos.y == ecx
        mov perdeu, 1
    .endif
  .endif 

  .if perdeu == 1
    invoke MessageBox,NULL,ADDR SuccessString,ADDR AppName,MB_OK 
  .endif

  ;verifica se acertou
  ; 1 - achou, 2 - não achou e falta verificar barco, 3- não acertou

  verificaTodos:
    .if achou == 1 ;achou um helicoptero
        ;acabou
    .elseif 
        .if achou == 2
            jmp testaB
        .elseif ;achou == 3
            jmp fim
        .endif
    .endif    

    testaH:
        mov ebx, heliPos.x
        mov ecx, heliPos.y
        ;add ebx, 2
        ;add ecx, 2
        jmp verificaSeAcertou

    verificaSeAcertou:
            .if ebx <= balaPos.x 
                .if ebx >= balaPos.x
                    .if ecx <= balaPos.y
                        .if ecx >= balaPos.y
                            mov achou, 1
                        .endif
                    .endif
                .endif           
            .endif
            jmp verificaTodos
    testaB:  
        mov ebx, barcoPos.x
        mov ecx, barcoPos.y
        jmp verificaTodos

  fim:
    invoke SelectObject,hDC,hOld
    invoke DeleteDC,memDC

    return 0

Paint_Proc endp

; ########################################################################


ThreadProc PROC USES ecx Param:DWORD

    invoke WaitForSingleObject,hEventStart,2 ;INFINITE

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

    invoke WaitForSingleObject,hEventStart,10 ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_BARCO,NULL,NULL
	    jmp   ThreadBarcoProc     
    .ENDIF
        
    jmp   ThreadBarcoProc
        
    ret
ThreadBarcoProc ENDP

ThreadHeliProc PROC USES ecx Param:DWORD                      

    invoke WaitForSingleObject,hEventStart,10 ;INFINITE

	.IF eax == WAIT_TIMEOUT	
	    invoke PostMessage,hWnd,WM_HELI,NULL,NULL
	    jmp   ThreadHeliProc     
    .ENDIF
        
    jmp   ThreadHeliProc
        
    ret
ThreadHeliProc ENDP

end start