; #########################################################################
    ;Ana Clara Sampaio Pires   - 18201
    ;Ariane Paula Barros       - 18173
    ;Felipe Melchior de Britto - 18200  

;     include files
;     ~~~~~~~~~~~~~
    include \MASM32\INCLUDE\windows.inc
    include \MASM32\INCLUDE\masm32.inc
    include \MASM32\INCLUDE\gdi32.inc
    include \MASM32\INCLUDE\user32.inc
    include \MASM32\INCLUDE\kernel32.inc
    include \MASM32\INCLUDE\Comctl32.inc
    include \MASM32\INCLUDE\comdlg32.inc
    include \MASM32\INCLUDE\shell32.inc

    INCLUDE \Masm32\Include\msimg32.inc
    INCLUDE \Masm32\Include\oleaut32.inc
    INCLUDE \Masm32\Macros\macros.asm



;     libraries
;     ~~~~~~~~~
    includelib \MASM32\LIB\masm32.lib
	  includelib \MASM32\LIB\gdi32.lib
    includelib \MASM32\LIB\user32.lib
    includelib \MASM32\LIB\kernel32.lib
    includelib \MASM32\LIB\Comctl32.lib
    includelib \MASM32\LIB\comdlg32.lib
    includelib \MASM32\LIB\shell32.lib

    INCLUDELIB \Masm32\Lib\msimg32.lib
    INCLUDELIB \Masm32\Lib\oleaut32.lib
    INCLUDELIB \Masm32\Lib\msvcrt.lib
    INCLUDELIB \Masm32\Lib\masm32.lib

; #########################################################################

        ;=================
        ; Local prototypes
        ;=================
    WinMain      PROTO :DWORD,:DWORD,:DWORD,:DWORD
    WndProc      PROTO :DWORD,:DWORD,:DWORD,:DWORD   
    TopXY        PROTO :DWORD,:DWORD
    FillBuffer   PROTO :DWORD,:DWORD,:BYTE
    Paint_Proc   PROTO :DWORD,:DWORD
    VerificaSeAcertouHeli PROTO 
    VerificaSeAcertouHeliDois PROTO
    VerificaSeAcertouBarco PROTO 
    VerificaSeAcertouBarcoDois PROTO
    VerificaFuel PROTO 
    Abaixa PROTO
    VerificaSePerdeu PROTO
    verifica PROTO :DWORD,:DWORD,:DWORD,:DWORD 

    ;=============
    ; Local macros
    ;=============

    szText MACRO Name, Text:VARARG
      LOCAL lbl
        jmp lbl
          Name db Text,0
        lbl:
    ENDM

    m2m MACRO M1, M2
      push M2
      pop  M1
    ENDM

    return MACRO arg
      mov eax, arg
      ret
    ENDM

.data ;variáveis que começam zeradas
    szDisplayName db "Raid River",0
    CommandLine   dd 0
    hWnd          dd 0
    hInstance     dd 0
    hInstance2    dd 0
    hInstance3    dd 0
    hInstance4    dd 0
    hInstance5    dd 0
    hInstance6    dd 0
    hInstance7    dd 0
    hInstance8    dd 0
    hInstance9    dd 0
    hInstance10   dd 0
    hInstance11   dd 0
    hInstance12   dd 0
    hInstance13   dd 0
    hInstance14   dd 0
    hInstance15   dd 0
    hInstance16   dd 0


    hIcon         dd 0

    hBmp          dd 0
    hBmp2         dd 0
    hBmp3         dd 0
    hBmp4         dd 0
    hBmp5         dd 0
    hBmp6         dd 0
    hBmp7         dd 0
    hBmp8         dd 0
    hBmp9         dd 0   
    hBmp10        dd 0   
	  hBmp11        dd 0   
	  hBmp12        dd 0   
	  hBmp13        dd 0   
	  hBmp14        dd 0  
  	hBmp15        dd 0  
  	hBmp16        dd 0  

    memDC2        DWORD 0 
    x	 		  dd 0
    trasp		  dd  0
    achou		  dd  0
    atirou    dd 0
    acelera   dd 0
    perdeu    dd 0
    count dd 0
    evitaLoop  dd 0
    acabouGasolina dd 0
    heliParaEsq   dd 0
    heli2ParaEsq   dd 0
    barcoParaEsq    dd 0 
    barco2ParaEsq   dd 0

    hitpoint 	    POINT <>
    posicao       POINT <>
    ThreadID 	  dd 0
    ExitCode 	  dd 0
    hThread 	  dd 0
    hEventStart   dd 0
    tempo     dd  0

    aviaoAtual   dd 0
    aviaoPos     POINT <>

    balaPos     POINT <>
    heliPos 	  POINT <>
    heliDoisPos 	  POINT <>
    barcoDoisPos 	  POINT <>
    barcoPos 	  POINT <>
    fuelPos     POINT <>
    explosaoPos POINT <>
    terraPos      POINT <>
    gasPos      POINT <>
    heliEPos 	  POINT <>
    heliEDoisPos 	  POINT <>
    barcoEPos 	  POINT <>
    barcoEDoisPos 	  POINT <>
    winPos 	  POINT <>
    gameOverPos 	  POINT <>

    hThreadDown 	 dd 0
    ThreadDownID  dd 0

    NomeFonte db 'courier new', 0

    hThreadBarco	  dd 0
    ThreadBarcoID  dd 0

    hThreadHeli	  dd 0
    ThreadHeliID  dd 0

    hThreadBala	  dd 0
    ThreadBalaID  dd 0
    pontInt db "p: ",0
    AppName  db "Raid River",0
    SuccessString db "Você perdeu!Deseja jogar novamente?",0
  	EventStop BOOL FALSE
    pontuacao dw 0

.data?         ;variáveis sem valor inicial
hwnd HANDLE ? 
    

.const         ;constantes
	IDM_EXIT equ 1     
	WM_FINISH equ WM_USER+100h
  WM_BARCO   equ WM_USER+101h
  WM_HELI   equ WM_USER+102h
  WM_DOWN   equ WM_USER+103h
  WM_BALA   equ WM_USER+104h
  WM_T   equ WM_USER+105h
	
        
        

; ########################### Inserted modules ############################


; #########################################################################
