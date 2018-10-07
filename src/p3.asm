;mmm
.model small
.stack

.data
; _________________________________ ENCABEZADO _________________________________ 
encabezado0    	    db		13,10,"|_________________________________________________|",
                            13,10,"| Universidad de San Carlos de Guatemala          |",
                            13,10,"| Facultad de Ingenieria                          |",
                            13,10,"| Escuela de ciencias y sistemas                  |",
                            13,10,"| Arquitectura de Computadores y Ensambladores 1  |",
                            13,10,"| Seccion B                                       |",
                            13,10,"| Segundo semestre 2018                           |",
                            13,10,"| Gonzalo Antonio Garcia Solares                  |",
                            13,10,"| 201318652                                       |",
                            13,10,"| Tercera practica                                |",
                            13,10,"|_________________________________________________|",13,10,"$"
; _________________________________ MENU _________________________________ 
encebazadoM0        db      "||===============================================||",13,10,"$"
encebazadoM1        db      "||-----------------------------------------------||",13,10,"$"
encebazadoM2        db      "||                 Menu principal                ||",13,10,"$"
encebazadoM3        db      "||-----------------------------------------------||",13,10,"$"
encebazadoM4        db      "||===============================================||",13,10,"$"
menuCargar          db      "1. Cargar archivo                                  ",13,10,"$"
menuReporte         db      "2. Crear reporte                                   ",13,10,"$"
menuResultados      db      "3. Mostrar Resultados                              ",13,10,"$"
menuSalir           db      "4. Salir                                           ",13,10,"$"
menuFin             db      "___________________________________________________",13,10,"$"
menuElige           db      10,13,"Bienvenido, elige una opcion...              ","$"
menuOpcion          db      32 dup(0),"$"
; _________________________________ CARGAR ARCHIVO _________________________________ 
opcion1             db      "Ingresa la ruta del archivo (con extension .arq).  ",13,10,"$"
opcion11            db      10,13,"Ejemplo: %%archivo.arq%%                           ","$"
errorCarga1         db      "El archivo no existe.                              ",13,10,"$"
errorCarga2         db      "Se encontro un caracter invalido.                  ",13,10,"$"
;                   Variables para cargar archivo
strRuta             db      10,13,"El archivo se llama:                        ","$"
nombreArchivo       db      "archivo2.arq",0;32 dup(0),0
textoBF             dw      ?
archivoM            dw      ?
; _________________________________ ALMACENAR ARCHIVO _________________________________ 
arrayCadena         dw      ?
ttlNumbers          db      "Numeross                                          ",13,10,"$"

; _________________________________ CREAR REPORTE _________________________________ 
opcion2             db      "Se genero el reporte.                              ",13,10,"$"
; _________________________________ MOSTRAR RESULTADOS _________________________________ 
opcion3             db      "Los resultados, respecto a los datos son:          ",13,10,"$"
; _________________________________ SALIR _________________________________ 
opcion4             db      "Abandonando el programa, hasta pronto.             ",13,10,"$"


;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
.code

main proc
    ; Inicializa DS
    mov ax, @data
    mov ds, ax
    
    call encabezadoMenu
    call menu
    call limpiarPantalla

;    .exit
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::        
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

; ||------------------------------------------------------------------------------------||
; ||                                   Encabezado                                       ||
; ||------------------------------------------------------------------------------------||
    encabezadoMenu proc
        mov ah, 09h
        lea dx, encabezado0
        int 21h
    encabezadoMenu endp
; ||------------------------------------------------------------------------------------||
; ||                                   Menu principal                                   ||
; ||------------------------------------------------------------------------------------||
; __________________________________ Mostrar encabezados de menu __________________________________
    menu proc
        mov ah, 09h
        lea dx, encebazadoM0
        int 21h
        lea dx, encebazadoM1
        int 21h
        lea dx, encebazadoM2
        int 21h
        lea dx, encebazadoM3
        int 21h
        lea dx, encebazadoM4
        int 21h
; __________________________________ Mostrar opciones de menu __________________________________
        lea dx, menuCargar
        int 21h
        lea dx, menuReporte
        int 21h
        lea dx, menuResultados
        int 21h
        lea dx, menuSalir
        int 21h
        lea dx, menuFin
        int 21h
        lea dx, menuElige
        int 21h
; __________________________________ Opciones de menu __________________________________
        ; Leyendo opción elegida
        mov ah, 3fh
        mov bx, 00        
        mov cx, 100
        mov dx, offset [menuOpcion]
        int 21h
        ; Mostrando opción elegida
        mov ah, 09h
        lea dx,menuOpcion
        int 21h
        ; Verificando opción elegida
        cmp dx,1
        je esIgual1

        cmp dx,2
        je esIgual2

        cmp dx,3
        je esIgual3

        cmp dx,4
        je esIgual4

; __________________________________ IFs de menu __________________________________
        esIgual1:
            mov ah, 09
            lea dx, opcion1
            int 21h
            lea dx, opcion11
            int 21h
            ;call nombreArchivoo
            call cargarArchivo

        esIgual2:
            mov ah, 09
;            lea dx, opcion2
            int 21h
            call salir

        esIgual3:
            mov ah, 09
            lea dx, opcion3
            int 21h
            call salir

        esIgual4:
            mov ah, 09
            lea dx, opcion4
            int 21h
            call salir

    menu endp

; ||------------------------------------------------------------------------------------||
; ||                                   Cargar archivo                                   ||
; ||------------------------------------------------------------------------------------||
    
; __________________________________ Ingresar nombre archivo __________________________________
    cargarArchivo proc
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
        mov al, 0           ; Abre para leer
        lea dx, nombreArchivo
        int 21h
        ;jc malaLectura
        mov [archivoM], ax
        xor si,si

        mov ah, 3fh         ; Lee contenido del archivo
        lea dx, textoBF     ; (Buffer) contenido del archivo
        mov cx, 40          ; Leer 1 Byte
        mov bx, archivoM  ; Valor del handle
        int 21h
        ; cmp ax, 0
        ; jz finArchivo
        ;jc malaLectura

        mov bx, [archivoM]
        mov ah, 3eh          ; Cerrar archivo
        int 21h

        ; mov ah,09h          ; Mostrar contenido
        ; lea dx, textoBF
        ; int 21h
        ret
    cargarArchivo endp
; ||------------------------------------------------------------------------------------||
; ||                                   Split comas                                      ||
; ||------------------------------------------------------------------------------------||
    ; mov cx, 0
    ; mov dx, 0
    ; mov di, 0
    ; mov ax, 0
    ; encontrarComa:
    ;     mov bl, textoBF[si] ; Almacena lo leido del texto
    ;     cmp bl, 3bh         ; Compara si es ,
    ;     je  Num
    ;     cmp bl, 2ch         ; Compara si es ;
    ;     je Num
    ;     inc si
    ;     inc cx
    ; ; Verificar si esta entre 0-9
    ;     cmp bl, 30h		;
    ;     jl  noEsNum		; 0-9 (0x30 and 0x39)
    ;     cmp bl, 39h		;
    ;     jg  noEsNum		;
    ;     jmp encontrarComa
    ; Num:
    ;     cmp cx, 1
    ;     je unD
    ;     cmp cx, 2
    ;     je dosD
    ;     cmp cx, 3
    ;     je tresD

    ; unD:
    ;     dec si
    ;     mov bl,textoBF[si]
    ;     sub bl,30h
    ;     mov arrayCadena[di],bl
    ;     inc di
    ;     inc di
    ;     inc si
    ;     inc dx
    ;     xor cx,cx
    ;     mov bl,textoBF[si]
    ;     cmp bl,3bh
    ;     je noEsNum
    ;     inc si
    ;     jmp encontrarComa
    
    ; dosD:
    ;     dec si
    ;     dec si
    ;     mov bl,textoBF[si]
    ;     sub bl,30h
    ;     mov ax,bl
    ;     mul ax,10
    ;     mov arrayCadena[di],bl
    ;     inc di
    ;     inc di
    ;     inc si
    ;     inc dx
    ;     xor cx,cx
    ;     mov bl,textoBF[si]
    ;     sub al,30h
    ;     add al,bl
    ;     ;cmp al,3bh
    ;     cmp bl,3bh
    ;     je noEsNum
    ;     inc si
    ;     jmp encontrarComa

    ; tresD:
    ;     dec si
    ;     dec si
    ;     dec si
    ;     mov bl,textoBF[si]
    ;     sub bl,30h
    ;     mov ax,bl
    ;     mul ax,10
    ;     mov arrayCadena[di],bl
    ;     inc di
    ;     inc di
    ;     inc si
    ;     inc dx
    ;     xor cx,cx
    ;     mov bl,textoBF[si]
    ;     sub al,30h
    ;     add al,bl
    ;     ;cmp al,3bh
    ;     cmp bl,3bh
    ;     je noEsNum
    ;     inc si
    ;     jmp encontrarComa

    ; noEsNum:
    ;     ret

    ; printArreglo:
    ;     mov ah,09h
    ;     lea dx, arrayCadena
    ;     int 21h
; ||------------------------------------------------------------------------------------||
; ||                                   Guardar en arreglo                               ||
; ||------------------------------------------------------------------------------------||
    guardarCadena proc
        mov cx,5
        mov si,0
        mov bx, textoBF
    guardarCadena endp
; ||------------------------------------------------------------------------------------||
; ||                                   Limpia pantalla                                  ||
; ||------------------------------------------------------------------------------------||
    limpiarPantalla proc
        mov ah, 06h
        mov al, 3
        int 10h
        ret
    limpiarPantalla endp
; ||------------------------------------------------------------------------------------||
; ||                                   Salir                                            ||
; ||------------------------------------------------------------------------------------||
    salir proc
        mov ax, 4c00h	;Function (Quit with exit code (EXIT))
        int 21h			;Interruption DOS Functions
    salir endp
    
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
main endp
end main
