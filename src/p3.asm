; Practica 3 #MASM#
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; ||------------------------------------------------------------------------------------||
; ||                                   Imprimir                                         ||
; ||------------------------------------------------------------------------------------||
imprimir MACRO cadena
    mov ah,09
    lea dx,cadena
    int 21h
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Limpia pantalla                                  ||
; ||------------------------------------------------------------------------------------||
limpiarPantalla MACRO
    mov ah, 06h
    mov al, 3
    int 10h
    ret
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
    

; __________________________________ IFs de menu __________________________________
esIgual1:
    imprimir menuCargar        
    imprimir opcion1
    cargarArchivo  

esIgual2:
    imprimir menuCrear
    imprimir opcion2    
    salir

esIgual3:
    imprimir menuResultados
    imprimir opcion3
    ;................ Inician funciones ....................
    ; imprimir strToLowerCase1
    toLowerCase
    salir

esIgual4:
    imprimir menuSalir
    imprimir opcion4
    ; imprimir contenidoArchivo
    salir
    
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
; __________________________________ Ingresar nombre archivo __________________________________
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
            mov bx, handlerArchivo    ; Valor del handle
            lea dx, CharBF     ; (Buffer) contenido del archivo | Muestra contenido
            mov cx, 1           ; Leer 1 Byte
            int 21h             ; DOS Int
            
            jc malaLecturaVacio     ; Error

            cmp ax, 0           ; 0 bytes leidos?
            je finArchivo       ; SI -> Fin del archivo encontrado
            
            mov al, CharBF     ; No, carga el caracter
            cmp al, 0ah         ; LF
            je LF               ; SI -> LF
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
            mov bx,1
            int 21h

            mov si,dx           ; Empieza desde el inicio del buffer
                                ; (DX=Inicio del buffer de texto)

            ;.................Funciones.........................
            ; toLowerCase
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
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;|||||||||||||||||||||||||||||||| FUNCIONES|||||||||||||||||||||||||||||||||||||||||||||||||
; ||------------------------------------------------------------------------------------||
; ||                                   toLowerCase                                       ||
; ||------------------------------------------------------------------------------------||
toLowerCase MACRO
call leer
call main
;....................................
    ; mov [bx], offset CharBF
    ; mov cx,4
    
    ; leer proc near       
    ;     cmp [bx], word ptr 20h
    ;     je e
    ;     add [bx], word ptr 32

    ;     e:
    ;         mov dx,[bx]
    ;         mov ah,02h
    ;         int 21h
    ;         inc bx

    ;     finCadena:
    ; ;         ret
    ;     loop leer
    ;     ret
    ; leer endp
;....................................
    lea si,contenidoArchivo
    mov si,0
    leer:
        cmp contenidoArchivo[si], 20h    ; MAY
        je esMayuscula

        mov ah,02h      ;Imprime caracter
        int 21h
        inc si
        finCadena:
            ret
        esMayuscula:
            add contenidoArchivo[si],32
            ; mov dx,contenidoArchivo[si]
            mov ah,02h
            int 21h
            inc si
            ret
        jmp leer
;....................................
ret
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
contenidoArchivo          db      255 dup(0),"$"
; _________________________________ FUNCIONES _________________________________ 
; contadorLineas      db      0
;................................ toLowerCase ................................................
; strToLowerCase      db      ?
strToLowerCase1     db      "To Lower Case:                                         ",13,10,13,10,"$"

; _________________________________ CREAR REPORTE _________________________________ 
menuCrear         db 13,10,13,10,"------------------ Crear reporte -----------------",13,10,13,10,"$"
opcion2             db      "Se genero el reporte.                              ",13,10,"$"
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