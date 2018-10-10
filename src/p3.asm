; Practica 3 #MASM#
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; ||------------------------------------------------------------------------------------||
; ||                                   Copiar                                         ||
; ||------------------------------------------------------------------------------------||
copiar MACRO cadena, destino
    ; xor di,di
    ; xor bl,bl
    local copiarL
    mov di,0

    copiarL:
        mov bl,cadena[di]
        mov destino[di], bl
        inc di
        cmp cadena[di],"$"
        jne copiarL
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Tamaño cadena                                    ||
; ||------------------------------------------------------------------------------------||
tamanoCadena MACRO cadena
    local forTamano, finCadena
    mov si,0
    forTamano:
        cmp cadena[si],"$"
        je finCadena
        inc si
        jmp forTamano
    finCadena:
        ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Imprimir                                         ||
; ||------------------------------------------------------------------------------------||
imprimir MACRO cadena
    xor dx,dx
    xor ax,ax
    mov ah,09
    lea dx,cadena
    int 21h
    xor dx,dx
    xor ax,ax
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Limpia pantalla                                  ||
; ||------------------------------------------------------------------------------------||
limpiarPantalla MACRO
    xor ax,ax
    mov ah, 03h
    int 10h
    xor ax,ax
    ; ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Salir                                            ||
; ||------------------------------------------------------------------------------------||
salir MACRO
    mov ah, 4ch	;Function (Quit with exit code (EXIT))
    int 21h			;Interruption DOS Functions
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Encabezado                                       ||
; ||------------------------------------------------------------------------------------||
mostrarEncabezado MACRO
    imprimir encabezado
    imprimir encabezado1
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Contar caracteres                                ||
; ||------------------------------------------------------------------------------------||
contarCaracteres MACRO
    
    ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Menu principal                                   ||
; ||------------------------------------------------------------------------------------||
mostrarMenu MACRO
    imprimir encebazadoM0
    imprimir menu
    imprimir menuF
    imprimir menuElige
ENDM
menuPrincipal MACRO
; __________________________________ Opciones de menu __________________________________
    ; Leyendo opción elegida
    mov ah, 03fh
    mov bx,00
    mov cx,32
    lea dx,menuOpcion
    int 21h

    mov si,0

    ; Verificando opción elegida
    cmp menuOpcion[si],"1"
    je esIgual1

    cmp menuOpcion[si],"2"
    jz esIgual2
    

    cmp menuOpcion[si],"3"
    jz esIgual3
    

    cmp menuOpcion[si],"4"
    jz esIgual4
    
    cmp menuOpcion[si],"5"
    jz esIgual5
    
    cmp menuOpcion[si],"6"
    jz esIgual6

    cmp menuOpcion[si],"7"
    jz esIgual7

    cmp menuOpcion[si],"8"
    jz esIgual8

    cmp menuOpcion[si],"9"
    jz esIgual9

; __________________________________ IFs de menu __________________________________
esIgual1:
    imprimir menuCargar        
    imprimir opcion1
    cargarArchivo  

esIgual2:
    imprimir menuCrear
    imprimir opcion2
    guardarReporte
    salir

esIgual3:
    imprimir menuResultados
    imprimir opcion3
    salir

esIgual4:
    imprimir menuSalir
    imprimir opcion4
    ; imprimir contenidoArchivo
    salir

;................ Inician funciones ....................
esIgual5:
    limpiarPantalla
    toLowerCase
    ; salir
    
esIgual6:
    limpiarPantalla
    toUpperCase
    ; salir

esIgual7:
    limpiarPantalla
    imprimir contenidoArchivo

esIgual8:
    salir

esIgual9:
    limpiarPantalla
    reverseString

; noEsIgual:
;     imprimir opcionIncorrecta
;     salir

ENDM

; ||------------------------------------------------------------------------------------||
; ||                                   Cargar archivo                                   ||
; ||------------------------------------------------------------------------------------||   
cargarArchivo MACRO
    call rutaArchivo
    call abrirArchivo    
    call leerArchivo
    call cerrarArchivo
    call main
; __________________________________ Ingresar nombreArchivo __________________________________
    rutaArchivo proc
        lea si, nombreArchivo
        mov ah, 01h         ; Entrada de caracter

        entradaTeclado:
            int 21h

            cmp al,0dh      ; Enter
            je zeroTerm

            mov [si],al
            inc si

            jmp entradaTeclado

        zeroTerm:
            mov byte ptr [si],0

    rutaArchivo endp    
; __________________________________ Abrir archivo __________________________________
    abrirArchivo proc near
        lea dx, nombreArchivo
        mov al, 0           ; Abre para lectura
        mov ah, 3dh         ; Abre el archivo        
        int 21h

        ; jc malaLectura

        mov handlerArchivo, ax

        ; xor si,si
        lea si, contenidoArchivo

        ; malaLectura:
        ;     imprimir errorCargaNoExiste
        ;     imprimir errorEligeOtro
        ;     ret
        
        ret
    abrirArchivo endp
; __________________________________ Leer archivo __________________________________
    leerArchivo proc near

        leerLinea:
            mov ah, 3fh         ; Lee contenido del archivo
            mov bx, handlerArchivo    ; Valor del handlerArchivo
            lea dx, CharBF     ; (Buffer) contenido del archivo | Muestra contenido
            mov cx, 1           ; Leer 1 Byte
            int 21h             ; DOS Int
            
            jc malaLecturaVacio     ; Error

            cmp ax, 0           ; 0 bytes leidos?
            je finArchivo       ; SI -> Fin del archivo encontrado        

            mov al, CharBF     ; No, carga el caracter
            ; cmp al, 0ah         ; LF
            ; je LF               ; SI -> LF
            cmp al, '$'
            je finArchivo
            cmp al, 40h         ; Es una @
            jz malaLecturaArroba     ; Error
            cmp al, 60h         ; Es una ´
            jz malaLecturaTilde     ; Error

            mov [si],al
            inc si
            
            jmp leerLinea     ; Repite...

        finArchivo:
            lea dx,contenidoArchivo   ; DX=offset(dirección) del texto
            mov ah,40h          ; Imprime
            mov cx,si           ; CX = # de caracteres, Mueve el apuntador al ultimo caracter
            sub cx,dx           ; Resta el offset del texto (en DX) de CX
                                ; Para obtener el numero actual de caracteres en el buffer
            mov bx,1
            int 21h

             ;.................Funciones.........................
            ;  toLowerCase
            ;  toUpperCase

            ; mov ah, 4ch
            ; int 21h    
            ret
        ; Guardar en el string 
        LF:
            lea dx, contenidoArchivo   ; DX=offset(dirección) del texto
            mov ah,40h          ; Imprime
            mov cx,si           ; CX = # de caracteres, Mueve el apuntador al ultimo caracter
            sub cx,dx           ; Resta el offset del texto (en DX) de CX
                                ; Para obtener el numero actual de caracteres en el buffer
            ; mov bx,1
            int 21h

           

            mov si,dx           ; Empieza desde el inicio del buffer
                                ; (DX=Inicio del buffer de texto)

            ; ;.................Funciones.........................
            ;  toLowerCase
            jmp leerLinea

        ; Verificando errores
        malaLecturaVacio:
            imprimir errorCargaVacio
            imprimir errorEligeOtro
        malaLecturaArroba:
            imprimir errorCargaArroba
            imprimir errorEligeOtro
        malaLecturaTilde:
            imprimir errorCargaTilde
            imprimir errorEligeOtro

        ret
    leerArchivo endp
; __________________________________ Cerrar archivo __________________________________
    cerrarArchivo proc near        
        mov ah, 3eh          ; Cerrar archivo
        mov bx, handlerArchivo
        int 21h
        ret
    cerrarArchivo endp

    ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Guardar reporte                                  ||
; ||------------------------------------------------------------------------------------||
guardarReporte MACRO ;, contenidoToUpperCase, contenidoToString
; Etiquetas
local escribirReporteL

call crearReporte
; call abrirReporte
call escribirReporte
call cerrarReporte
; ____________________________________ Crear reporte ____________________________________
    crearReporte proc near
        mov ah,3ch      ; Crear archivo
        mov cx, 00h       
        lea dx, offset nombreReporte
        int 21h
        ret
        mov handlerReporte,ax
    crearReporte endp
; __________________________________ Abrir reporte __________________________________
    ; abrirReporte proc near
    ;     lea dx, nombreReporte
    ;     mov al, 010b           ; Abre para lectura
    ;     mov ah, 3dh         ; Abre el archivo        
    ;     int 21h

    ;     ; jc malaLectura

    ;     mov handlerReporte, ax

    ;     ; xor si,si
    ;     lea si, contenidoArchivo

    ;     ; malaLectura:
    ;     ;     imprimir errorCargaNoExiste
    ;     ;     imprimir errorEligeOtro
    ;     ;     ret
        
    ;     ret
    ; abrirReporte endp

; ____________________________________ Escribir reporte ____________________________________
    escribirReporte proc near
        ; mov cx, 1000
        
            ; push cx
            mov ah,40h
            mov bx,handlerReporte
            lea dx, contenidoArchivo
            tamanoCadena contenidoArchivo
            mov cx,si
            int 21h

    escribirReporte endp
; __________________________________ Cerrar reporte __________________________________
    cerrarReporte proc near        
        mov ah, 3eh          ; Cerrar archivo
        mov bx, handlerReporte
        int 21h
        ret
    cerrarReporte endp
ret
ENDM
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;|||||||||||||||||||||||||||||||| FUNCIONES|||||||||||||||||||||||||||||||||||||||||||||||||
; ||------------------------------------------------------------------------------------||
; ||                                   toLowerCase                                      ||
; ||------------------------------------------------------------------------------------||
toLowerCase MACRO
local finCadena, leerC, ok
call tolwr
; call main

copiar contenidoArchivo,strToLowerCaseContenido

tolwr proc near
    imprimir strToLowerCase

        xor bx,bx
        lea bx, strToLowerCaseContenido
        
        leerC:
            cmp byte ptr[bx],'$'
            je finCadena
            cmp byte ptr[bx],'A'
            jb ok
            cmp byte ptr[bx],'Z'
            ja ok
            add byte ptr[bx],20h
            
            ok:
                inc bx
                jmp leerC
            finCadena:
                imprimir strToLowerCaseContenido
                ret
    ret 
tolwr endp

ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   toUpperCase                                      ||
; ||------------------------------------------------------------------------------------||
toUpperCase MACRO
local finCadena, leerC, ok
call toupr
; call main

copiar contenidoArchivo,strToUpperCaseContenido

toupr proc near
    imprimir strToUpperCase

        xor bx,bx
        lea bx, strToUpperCaseContenido
        
        leerC:
            cmp byte ptr[bx],'$'
            je finCadena
            cmp byte ptr[bx],'a'
            jb ok
            cmp byte ptr[bx],'z'
            ja ok
            sub byte ptr[bx],20h
            
            ok:
                inc bx
                jmp leerC
            finCadena:
                imprimir strToUpperCaseContenido
                ret
    ret
toupr endp

ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   toString
; ||------------------------------------------------------------------------------------||
toString MACRO
    copiar contenidoArchivo,strToString
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   reverseString                                    ||
; ||------------------------------------------------------------------------------------||
reverseString MACRO
local leerC, leerC2, vacio
call rvrs
; call main

copiar contenidoArchivo,strReverseStringContenido
; xor si, si
; xor di, di
rvrs proc near
    imprimir strReverseString
            lea si, strReverseStringContenido
            mov cl, [si+1]
            mov ch,0
            add si, cx
            inc si
            lea di, strReverseStringContenido2
            jcxz vacio
        ; leerC:
        ;     inc si
        ;     cmp byte ptr[si],"$"
        ;     jne leerC

        ;     dec si
        ;     lea di,
        
        leerC2:
            mov al, byte ptr[si]
            mov byte ptr[di],al
            dec si
            inc di
            loop leerC2

        vacio:
            imprimir strReverseStringContenido2
    ret
rvrs endp
ENDM
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.model large
.stack 4096
.data
;|||||||||||||||||||||||||||||||| VARIABLES ||||||||||||||||||||||||||||||||||||||||||||||||||||
saltoret            db 13,10,"$"
; _________________________________ ENCABEZADO _________________________________ 
encabezado    	    db		"|___________________________________________________|",13,10,
                            "| Universidad de San Carlos de Guatemala            |",13,10,
                            "| Facultad de Ingenieria                            |",13,10,
                            "| Escuela de ciencias y sistemas                    |",13,10,
                            "| Arquitectura de Computadores y Ensambladores 1 A  |",13,10,"$"
encabezado1         db      "| Segundo semestre 2018                             |",13,10,
                            "| Gonzalo Antonio Garcia Solares                    |",13,10,
                            "| 201318652                                         |",13,10,
                            "| Tercera practica                                  |",13,10,
                            "|___________________________________________________|",13,10,"$"
; _________________________________ MENU _________________________________ 
encebazadoM0        db      13,10,"||=================================================||",13,10,
                            "||-------------------------------------------------||",13,10,
                            "||                 Menu principal                  ||",13,10,
                            "||-------------------------------------------------||",13,10,
                            "||=================================================||",13,10,"$"
menu                db      "1. Cargar archivo                                  ",13,10,
                            "2. Crear reporte                                   ",13,10,
                            "3. Mostrar Resultados                              ",13,10,
                            "4. Salir                                           ",13,10,
                            "5. toLowerCase                                     ",13,10,"$"
menuF               db      "6. toUpperCase                                     ",13,10,
                            "7. toString                                        ",13,10,
                            "8. concat                                          ",13,10,
                            "9. reverseString                                   ",13,10,
                            "___________________________________________________",13,10,"$"
menuElige           db      10,13,10,13,"Bienvenido, elige una opcion...      ",13,10,13,10,"$"
menuOpcion          db      ?,10,13,"$"
; _________________________________ CARGAR ARCHIVO _________________________________ 
menuCargar          db 13,10,13,10,"------------------ Cargar archivo -----------------",13,10,13,10,"$"
opcion1             db      "Ingresa la ruta del archivo (con extension .arq).  ",13,10,13,10,"$"
errorCargaNoExiste  db      "El archivo no existe.                              ",13,10,"$"
errorCargaVacio     db      "Archivo vacio.                              ",13,10,"$"
errorCargaArroba    db      13,10,"Se encontro un caracter invalido: @                  ",13,10,"$"
errorCargaTilde     db      13,10,"Se encontro un caracter invalido: Tilde              ",13,10,"$"
errorEligeOtro      db      13,10,"Elige otro archivo.                                  ",13,10,"$"
;                   Variables para cargar archivo
strRuta             db      10,13,"El archivo se llama:                        ","$"
strContenido        db      10,13,"Contenido:                                  ",13,10,13,10,"$"
;................................ Ruta Archivo ................................................
; nombreArchivo       db      "may.arq", 0;
; nombreArchivo       db      80 dup(0)
nombreArchivo       db      255 dup(0)
; nombreArchivo       db      ?
;...........................................................................................
CharBF              db      ?,"$"
handlerArchivo      dw      ?,"$"
contenidoArchivo    db      1000 dup(0),"$"
; contenidoArchivo    db      ?
; _________________________________ FUNCIONES _________________________________ 
; contadorLineas      db      0
;................................ toLowerCase ................................................
strToLowerCase     db      "To Lower Case:                                         ",13,10,13,10,"$"
strToLowerCaseContenido db  1000 dup(0),"$"
;................................ toUpperCase ................................................
strToUpperCase     db      "To Upper Case:                                         ",13,10,13,10,"$"
strToUpperCaseContenido db  1000 dup(0),"$"
;................................ toString ................................................
strToString                 db      "To String",13,10,13,10,"$"
strToStringContenido         db      1000 dup(0),"$"
;................................ concat ................................................
strConcat               db      "Concat",13,10,13,10,"$"
strConcatContenido      db      1000 dup(0),"$"
;................................ reverseString ................................................
strReverseString              db      "reverse String                               ",13,10,"$"
strReverseStringContenido      db      1000 dup(0),"$"
strReverseStringContenido2      db      1000 dup(0),"$"

; _________________________________ CREAR REPORTE _________________________________ 
menuCrear         db 13,10,13,10,"------------------ Crear reporte -----------------",13,10,13,10,"$"
opcion2             db      "Se genero el reporte.                              ",13,10,"$"
;....................................................................................
nombreReporte       db      "reporte.json","$"
handlerReporte      dw      ?
;....................................................................................
reprteFecha         db      ""
reporteLlaveAbre    db      "{"
reporteLlaveCierra    db      "}"
reporteCorcheteAbre    db      "["
reporteCorcheteCierra    db      "]"
; _________________________________ MOSTRAR RESULTADOS _________________________________ 
menuResultados     db 13,10,13,10,"------------------- Resultados ------------------",13,10,13,10,"$"
opcion3             db      "Los resultados, respecto a los datos son:          ",13,10,"$"
; _____________________________________________ SALIR _____________________________________________ 
menuSalir          db 13,10,13,10,"--------------------- Salir ---------------------",13,10,13,10,"$"
opcion4             db      "Abandonando el programa, hasta pronto.             ",13,10,"$"
opcionIncorrecta    db      "Elige una opcion correcta.                         ",13,10,"$"
;...........................................................................................

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.code

    ; Inicializa DS
    mov ax, @data
    mov ds, ax
    mostrarEncabezado

    main proc        
        mostrarMenu
        menuPrincipal
    ;    .exit
     main endp

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
end