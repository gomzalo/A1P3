;mmm
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
    mov ax, 4c00h	;Function (Quit with exit code (EXIT))
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
    jz esIgual1

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
    salir

esIgual4:
    imprimir menuSalir
    imprimir opcion4
    salir
    
; noEsIgual:
;     imprimir opcionIncorrecta
;     salir

ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Cargar archivo                                   ||
; ||------------------------------------------------------------------------------------||
    
; __________________________________ Ingresar nombre archivo __________________________________
cargarArchivo MACRO
    ;nombreArchivoo proc
        ; ; Leyendo ruta ingresada
        ; mov ah, 3fh
        ; mov bx, 00
        ; mov cx, 100
        ; mov dx, offset [nombreArchivo]
        ; int 21h
        ; ; Mostrando ruta ingresada
        ; mov ah, 09h
        ; lea dx, strRuta
        ; int 21h
        ; lea dx, nombreArchivo
        ; int 21h
    ;nombreArchivoo endp
    
; __________________________________ Leer archivo __________________________________
    ;pusha
    mov ah, 3dh         ; Abre el archivo
    mov al, 00           ; Abre para leer
    lea dx, nombreArchivo
    int 21h
    ;jc malaLectura
    mov [archivoM], ax
    xor si,si

    imprimir strRuta
    imprimir nombreArchivo
    

    mov ah, 3fh         ; Lee contenido del archivo
    lea dx, textoBF     ; (Buffer) contenido del archivo | Muestra contenido
    mov cx, 40          ; Leer 1 Byte
    mov bx, archivoM  ; Valor del handle
    int 21h
    ;cmp ax, 0
    ;jz finArchivo
    ;jc malaLectura

    mov bx, [archivoM]
    mov ah, 3eh          ; Cerrar archivo
    int 21h

    imprimir strContenido
    imprimir textoBF
    imprimir saltoret

    call main
    ret
ENDM
; ||------------------------------------------------------------------------------------||
; ||                                   Guardar en arreglo                               ||
; ||------------------------------------------------------------------------------------||
guardarCadena MACRO
    mov cx,5
    mov si,0
    mov bx, textoBF
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
errorCarga1         db      "El archivo no existe.                              ",13,10,"$"
errorCarga2         db      "Se encontro un caracter invalido.                  ",13,10,"$"
;                   Variables para cargar archivo
strRuta             db      10,13,"El archivo se llama:                        ","$"
strContenido        db      10,13,"Contenido:                                  ",13,10,13,10,"$"
nombreArchivo       db      "a.arq", "$";32 dup(0),0
textoBF             dw      ?
archivoM            dw      ?
; _________________________________ ALMACENAR ARCHIVO _________________________________ 
arrayCadena         dw      ?
ttlNumbers          db      "Numeross                                          ",13,10,"$"

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