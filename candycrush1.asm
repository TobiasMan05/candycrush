.ORIG x3000	 

	LD R0, start    ; posicion inicial = xC181
LD R3, dieciseis	; R3 = 16
LD R4, ancho		; R4 = 14 (ancho de una linea de caramelos)
ADD R4, R4, #-6     ; cantidad de filas (R4 = 8)

LOOP_CANDY
; bucle para crear caramelos de diferentes colores

LD R1, rojo			;cargar el color rojo en R1
JSR CREAR_CARAMELO
ADD R0, R0, R3		;avanza la posicion 16 unidades 
LD R1, azul
JSR CREAR_CARAMELO
ADD R0, R0, R3
LD R1, verde
JSR CREAR_CARAMELO
ADD R0, R0, R3
LD R1, rosa
JSR CREAR_CARAMELO
ADD R0, R0, R3
LD R1, amarillo
JSR CREAR_CARAMELO
ADD R0, R0, R3
LD R1, rojo
JSR CREAR_CARAMELO
ADD R0, R0, R3
LD R1, verde
JSR CREAR_CARAMELO
ADD R0, R0, R3
LD R1, rosa
JSR CREAR_CARAMELO


LD R2, salto		 ; salto entre filas de caramelos
ADD R0,R0,R2		 ; mueve R0 a la siguiente fila de caramelos
ADD R4,R4, #-1		 ; decrementa el contador de filas (8)
BRp LOOP_CANDY		 
BRnzp MAIN			 ; finaliza el bucle y salta a MAIN


; crear un caramelo
CREAR_CARAMELO
ST R4, E
ST R0, SAVEE_R0
ST R3, SAVEE_R3
ST R5, SAVEE_R5
ST R6, SAVEE_R6
ST R2, SAVEE_R2
;R0 posicion caramelo
;R1 color
LD R3, linea		; salto entre lineas = 114 (128 - 14)
LD R4, gris			; color gris de fondo
LD R5, ancho		; ancho del caramelo gris (14)
LD R6, candy		; lo que suma para ir a la posicion del caramelos (258 = 128 + 128 + 2)
ADD R6,R0,R6


; Dibuja el borde gris del caramelo
LOOP2
LD R2, ancho		; ancho del caramelo
LOOP
STR R4,R0,#0
ADD R0,R0,#1
ADD R2,R2,#-1
BRp LOOP
ADD R0,R0,R3		; mueve al siguiente renglon
ADD R5,R5,#-1
BRp LOOP2

ADD R5,R5,#10		; altura del caramelo (10)

; Dibuja el color principal del caramelo
LOOP3
ADD R2,R2,#10		; ancho del color (10)
LOOP4
STR R1,R6,#0		; dibuja el caramelo en el color definido por R1
ADD R6,R6,#1
ADD R2,R2,#-1
BRp LOOP4
ADD R6,R6,R3		; mueve al siguiente renglon
ADD R6,R6,#4
ADD R5,R5,#-1
BRp LOOP3
LD R0, SAVEE_R0
LD R3, SAVEE_R3
LD R4, E
LD R5, SAVEE_R5
LD R6, SAVEE_R6
LD R2, SAVEE_R2
RET


BORRAR
LD R4, negro		; carga el color negro (para borrar)
BRnzp SKIP			; si R4 no es cero, salta a la etiqueta SKIP

; seccion de entrada de seleccion
ENTER_SELECCION
LD R4, rojo_enter		; carga el color rojo (indica seleccion activa)
BRnzp SKIP				; salta a SKIP si no hay cambios

; Seccion de seleccion
SELECCION
LD R4, white		; carga el color blanco (para mostrar el objeto seleccionado)
SKIP
ST R2, SAVEE_R2
ST R5, SAVEE_R5
ST R7, SAVEE_R7

;R2 es la pocisicion que se le da en el main a la seleccion 

LD R3, dieciseis		; carga el valor 16
LD R5, linea			; carga 114
LD R6, ancho_pantalla	; carga el ancho de la pantalla (128)
LD R7, ancho			; carga el ancho del caramelo (16)
ADD R5, R5,#-2			; resta 2 para poder bajar hacia abajo la seleccion (112)

; bucle de seleccion para el lado (parte de arriba)
LOOP_SELECCION
STR R4,R2,#0			; pinta
ADD R2,R2,#1
ADD R3,R3,#-1
BRp LOOP_SELECCION

ADD R2,R2,R5			; baja 1 linea a la posicion

LOOP1_SELECCION			; bucle de seleccion para abajo en ambos lados
STR R4,R2,#0
STR R4,R2,#15			; pinta el lado derecho del todo  
ADD R2,R2,R6			; suma 128
ADD R7,R7,#-1			; decrementa el contador de filas
BRp LOOP1_SELECCION

LD R3, dieciseis		; vuelve a cargar 16

; bucle de seleccion (parte de abajo)
LOOP2_SELECCION
STR R4,R2,#0
ADD R2,R2,#1
ADD R3,R3,#-1
BRp LOOP2_SELECCION

LD R2,SAVEE_R2
LD R5, SAVEE_R5
LD R7,SAVEE_R7

RET


start     	.FILL xC181
dieciseis .FILL #16
ancho 	.FILL #14 	 
rojo    	.FILL xF800
verde     	.FILL x03E0
gris     	.FILL x4210
white   	.FILL x7FFF
azul    	.FILL x001F
rosa	.FILL x3466
amarillo .FILL x7FE0
SAVEE_R0 	.BLKW 1
SAVEE_R2 	.BLKW 1
SAVEE_R3 	.BLKW 1
E 	.BLKW 1    
SAVEE_R5 	.BLKW 1   
SAVEE_R6 	.BLKW 1      	 
SAVEE_R7 	.BLKW 1


; seccion principal del programa
MAIN

LD R2, start_seleccion		; inicio seleccion (xC100)
ESPERALETRA
LDI R5,WAITKB				; carga la direccion de espera de entrada 
BRzp ESPERALETRA			; si no hay tecla presionada, vuelve a esperar
	
LD R5,SAVEE_R5

LDI R4,TECLADO				; carga la direccion del teclado en R4
LD R3, letraDneg			; carga la letra D (-100)
ADD R4 ,R4, R3				; suma R3 a R4 para verificar si es la entrada
BRz DERECHA					; si se detecta la entrada de direccion a la derecha (osea que la resta da 0), salta a DERECHA

LD R3, letraDpos			; carga la letra D positiva (100)
ADD R4 ,R4, R3				; suma R3 a R4 para volver al valor original de la letra ingresada
LD R3, letraAneg			; carga la letra A (-97)
ADD R4 ,R4, R3				; suma R3 a R4 para verificar si es la entrada
BRz IZQUIERDA				; si se detecta la entrada de direccion a la izquierda (osea que la resta da 0), salta a IZQUIERDA

LD R3, letraApos			; carga la letra A (97)
ADD R4 ,R4, R3				; suma R3 a R4 para volver al valor original de la letra ingresada

; y asi sucesivamente con todas las letras hasta que alguna coincida sino sigue esperando


LD R3, letraSneg
ADD R4 ,R4, R3
BRz ABAJO

LD R3, letraSpos
ADD R4 ,R4, R3
LD R3, letraWneg
ADD R4 ,R4, R3
BRz ARRIBA

LD R3, letraWpos
ADD R4 ,R4, R3
LD R3, teclaENTneg
ADD R4 ,R4, R3
BRz CAMBIO_CARAMELO

BRnzp ESPERALETRA			; si no hay teclas validas, vuelve a esperar

; movimiento a la Derecha
DERECHA	
ADD R5,R5,#-1			; resta uno ya que R5 funciona como flag (si es 0 esta en enter para poder cambiar el caramelo de lugar sino es la seleccion normal)
BRz INTERCAMBIAR_DER	; si R5 es cero, salta a INTERCAMBIAR_DER
JSR BORRAR				; llama a BORRAR para limpiar la seleccion con el color negro
ADD R2,R2,#15			
ADD R2,R2,#1			; mueve 16 lugares la posicion
JSR SELECCION			; llama a SELECCION para actualizar la seleccion en la nueva posicion (16 lugares a la derecha)
BRnzp ESPERALETRA		; salta a ESPERALETRA para esperar la proxima entrada


; movimiento a la Izquierda (que funciona igual que derecha pero resta 16 a la pocision)
IZQUIERDA
ADD R5,R5,#-1			
BRz INTERCAMBIAR_IZQ
JSR BORRAR
ADD R2,R2,#-15
ADD R2,R2,#-1			; mueve -16 lugares la posicion
JSR SELECCION			; llama a SELECCION para actualizar la seleccion en la nueva posicion (16 lugares a la derecha)
BRnzp ESPERALETRA


; movimiento hacia Abajo
ABAJO
ADD R5,R5,#-1
BRz INTERCAMBIAR_ABAJO
JSR BORRAR
LD R4, salto_selec		; le da el valor 1920 (128 x 15)
ADD R2,R2,R4			; suma a la pocision 1920 (para bajar 15 pixeles)
JSR SELECCION
BRnzp ESPERALETRA


; movimiento hacia Arriba
ARRIBA
ADD R5,R5,#-1
BRz INTERCAMBIAR_ARRIBA
JSR BORRAR
LD R4, salto_selec_neg	; le da el valor -1920 
ADD R2,R2,R4			; suma a la pocision -1920 (para subir 15 pixeles)
JSR SELECCION
BRnzp ESPERALETRA

; intercambio hacia la Derecha del caramelo
INTERCAMBIAR_DER

LD R5, saber_color			; le da el valor 389 (128 + 128 + 128 + 5)
ADD R5,R2,R5				; suma a la pocision 389 para saber el color del caramelo donde esta 
LDR R6,R5,#0				; guarda el color en R6

ADD R5,R5,#15				; mueve a la derecha 15 lugares R5
LDR R5,R5,#0				; carga el color en R5 del caramelo de la derecha 

LD R0,negro					; le da valor x0000 a R0
LD R4, seleccion2gris		; carga 129 (128 + 1)
ADD R0,R4,R2				; guarda en R0 la posicion R2 mas R4 (donde empieza el caramelo)

LD R1,negro					; le da valor x0000 a R1 
ADD R1,R1,R5				; le da a R1 el color del caramelo de la derecha 

JSR CREAR_CARAMELO			; llama a crear caramelo con el nuevo color que estaba en la derecha y lo vuelve a pintar

ADD R0,R0,#15
ADD R0,R0,#1				; le suma 16 a la posicion

LD R1,negro					; le da valor x0000 a R1 

ADD R1,R1,R6				; le da a R1 el color del caramelo que habia en donde se estaba antes 
JSR CREAR_CARAMELO			; llama a crear caramelo con el nuevo color que estaba en la posiciopn anterior y lo vuelve a pintar en la derecha 
JSR VERIFICAR_COLOR
ADD R2, R2, #15
ADD R2, R2, #1

JSR VERIFICAR_COLOR
ADD R2, R2, #-16
JSR SELECCION
BRnzp ESPERALETRA


; Intercambio hacia la Izquierda del caramelo (funciona igual que el derecho pero restando en las posiciones)
INTERCAMBIAR_IZQ
LD R5, saber_color 
ADD R5,R2,R5
LDR R6,R5,#0
ADD R5,R5,#-15				; resta 15 para saber el color de la isquierda
LDR R5,R5,#0

LD R0,negro ;darle valor 0
LD R4, seleccion2gris

ADD R0,R4,R2

LD R1,negro 
ADD R1,R1,R5

JSR CREAR_CARAMELO

ADD R0,R0,#-16				; le resta 16 a la posicion
LD R1,negro
ADD R1,R1,R6

JSR CREAR_CARAMELO
JSR VERIFICAR_COLOR
ADD R2, R2, #-16

JSR VERIFICAR_COLOR
ADD R2, R2, #15
ADD R2, R2, #1
JSR SELECCION
BRnzp ESPERALETRA


; Intercambio hacia Abajo del caramelo 
INTERCAMBIAR_ABAJO
LD R5, saber_color				; le da el valor 389 (128 + 128 + 128 + 5)
LD R7, saber_color_abajo		; carga 2180 para saber el color de abajo (128 x 17 + 4)
LD R3, salto_selec				; carga el valor para el salto de seleccion hacia abajo (1920 = 128 x 15)

ADD R5,R2,R5					; guarda en R5 la pocision en el color del caramelo donde esta 
LDR R6,R5,#0					; guarda el color en R6

ADD R5,R5,R7					; mueve hacia abajo R5 para saber el color del caramelo de abajo
LDR R5,R5,#0					; guarda el color en R5

LD R0,negro						; le da valor x0000 a R0
LD R4, seleccion2gris			; carga 129 (128 + 1)
ADD R0,R4,R2					; guarda en R0 la posicion R2 mas R4

LD R1,negro						; le da valor x0000 a R0
ADD R1,R1,R5					; le da a R1 el color del caramelo de abajo

JSR CREAR_CARAMELO				; llama a crear caramelo con el nuevo color que estaba abajo y lo vuelve a pintar

ADD R0,R0,R3					; ajusta la seleccion, R3 = (1920 = 128 x 15)
LD R1,negro						; le da valor x0000 a R1 
ADD R1,R1,R6					; le da a R1 el color que estaba en la anterior posicion

JSR CREAR_CARAMELO				; espera otras entradas
JSR VERIFICAR_COLOR

ADD R2, R2, R3
JSR VERIFICAR_COLOR
LD R4, salto_selec_neg
ADD R2,R2,R4
JSR SELECCION
BRnzp ESPERALETRA

; Intercambio hacia Arriba (lo mismo que el de intercambio hacia abajo pero con otros valores de movimientos)
INTERCAMBIAR_ARRIBA
LD R5, saber_color        	 
LD R7, saber_color_arriba 	 
LD R3, salto_selec_neg     	; carga el valor para el salto de seleccion hacia arrriba (-1920 = 128 x -15)

ADD R5, R2, R5            	 
LDR R6, R5, #0    	 
    
ADD R5, R2, R7          	 
LDR R5, R5, #0         	 
LD R0, negro          
	
LD R4, seleccion2gris     	 
ADD R0, R4, R2            	 

LD R1, negro               	 
ADD R1, R1, R5            	 

JSR CREAR_CARAMELO         	 

ADD R0, R0, R3            	 
LD R1, negro              	 
ADD R1, R1, R6             	 

JSR CREAR_CARAMELO       
JSR VERIFICAR_COLOR

ADD R2, R2, R3
JSR VERIFICAR_COLOR
LD R4, salto_selec
ADD R2,R2,R4
  	 
JSR SELECCION              	 
BRnzp ESPERALETRA           	; espera otras entradas


CAMBIO_CARAMELO
ADD R5,R5,#-1
BRnp seguir						;mientras sea positivo o 0
JSR SELECCION
BRnzp ESPERALETRA
seguir
LD R5, dieciseis
ADD R5,R5,#-15					;para q la flag valga 1
ST R5,SAVEE_R5
JSR ENTER_SELECCION
BRnzp ESPERALETRA
BRzp CAMBIO_CARAMELO

candy .FILL #258


negro    	.FILL x0000

linea       	.FILL #114  
salto_selec	.FILL #1920
salto_selec_neg	.FILL #-1920

rojo_enter .FILL x7C00
salto .FILL x710
ancho_pantalla .FILL #128
seleccion2gris .FILL #129
start_seleccion .FILL xC100
TECLADO .FILL xFE02
letraDneg .FILL #-100
letraDpos .FILL #100
letraAneg .FILL #-97
letraApos .FILL #97
letraSneg .FILL #-115
letraSpos .FILL #115
letraWneg .FILL #-119
letraWpos .FILL #119
teclaENTneg .FILL #-10
saber_color .FILL #389
saber_color_abajo .FILL #2180
saber_color_arriba .FILL #-509

WAITKB .FILL xFE00
GUARDAR_AUX_R2 	.BLKW 1
GUARDAR_AUX_R6 	.BLKW 1
SAVEE_R1 	.BLKW 1
SAVEEE_R4 	.BLKW 1
SAVEEE_R0 	.BLKW 1
SAVEEE_R3 	.BLKW 1
SAVEEE_R5 	.BLKW 1
SAVEEE_R6 	.BLKW 1
SAVEEE_R2 	.BLKW 1
SAVEEE_R7 	.BLKW 1

VERIFICAR_COLOR
ST R4, SAVEEE_R4
ST R0, SAVEEE_R0
ST R3, SAVEEE_R3
ST R5, SAVEEE_R5
ST R6, SAVEEE_R6
ST R2, SAVEEE_R2
ST R1, SAVEE_R1
ST R7, SAVEEE_R7

LD R5, saber_color ;para saber color
LD R3, salto_selec_neg
LD R4, salto_selec
LD R0, negro
LD R1, negro

ADD R5,R2,R5
LDR R6,R5,#0
ST R6, GUARDAR_AUX_R6
ST R2, GUARDAR_AUX_R2
LD R2,negro

ADD R5,R5,R3

LDR R1,R5,#0
NOT R1,R1
ADD R1,R1,#1
ADD R7,R1,R6
BRnp VER_ABAJO1
ADD R0,R0,#1

ADD R5,R5,R3
LDR R1,R5,#0
NOT R1,R1
ADD R1,R1,#1
ADD R7,R1,R6
BRnp VER_ABAJO2
ADD R0,R0,#1

VER_ABAJO2
ADD R5,R5,R4
VER_ABAJO1
ADD R5,R5,R4

LD R1, negro

ADD R5,R5,R4
LDR R3,R5,#0
NOT R3,R3
ADD R3,R3,#1
ADD R7,R3,R6
BRnp VER
ADD R1,R1,#1

ADD R5,R5,R4
LDR R3,R5,#0
NOT R3,R3
ADD R3,R3,#1
ADD R7,R3,R6
BRnp VER
ADD R1,R1,#1


VER
ADD R2,R1,R0
ADD R2,R2,#-1
BRnz VER_DERECHA
LD R2, GUARDAR_AUX_R2
ST R2, GUARDAR_AUX_R2
LD R3,seleccion2gris
ADD R2,R2,R3
ADD R3,R0,#0
ADD R4,R1,#0
LD R5, salto_selec_neg
LOOP_BORRAR_ARRIBA
ADD R3,R3,#-1
BRn BORRA_ABAJO
LD R1,negro
ADD R0,R2,#0
JSR CREAR_CARAMELO
ADD R2,R2,R5
ADD R0,R2,#0
JSR CREAR_CARAMELO
BRnzp LOOP_BORRAR_ARRIBA

BORRA_ABAJO
LD R2, GUARDAR_AUX_R2
ST R2, GUARDAR_AUX_R2
LD R3,seleccion2gris
ADD R2,R2,R3
LD R5, salto_selec
LOOP_BORRAR_ABAJO
ADD R4,R4,#-1
BRn VER_DERECHA

ADD R0,R2,#0
JSR CREAR_CARAMELO

ADD R2,R2,R5
ADD R0,R2,#0

JSR CREAR_CARAMELO
BRnzp LOOP_BORRAR_ABAJO

VER_DERECHA
LD R2, GUARDAR_AUX_R2
ST R2, GUARDAR_AUX_R2
LD R5, saber_color ;para saber color
LD R0, negro
LD R1, negro
LD R3, negro

ADD R5,R2,R5
LD R6, GUARDAR_AUX_R6

ADD R5, R5, #15
ADD R5, R5, #1

LDR R1,R5,#0
NOT R1,R1
ADD R1,R1,#1
ADD R7,R1,R6

BRnp VER_IZQUIERDA2
ADD R0,R0,#1

ADD R5, R5, #15
ADD R5, R5, #1

LDR R1,R5,#0
NOT R1,R1
ADD R1,R1,#1
ADD R7,R1,R6

BRnp VER_IZQUIERDA1
ADD R0,R0,#1

VER_IZQUIERDA1
ADD R5, R5, #-16
VER_IZQUIERDA2
ADD R5, R5, #-16

ADD R5, R5, #-16

LD R1, negro

LDR R3,R5,#0
NOT R3,R3
ADD R3,R3,#1
ADD R7,R3,R6

BRnp VER2

ADD R1,R1,#1

ADD R5, R5, #-16

LDR R3,R5,#0
NOT R3,R3
ADD R3,R3,#1
ADD R7,R1,R6

BRnp VER2
ADD R1,R1,#1

VER2
ADD R2,R0,R1
ADD R2,R2,#-1
BRnz FINAL_FUNCION

LD R2, GUARDAR_AUX_R2
ST R2, GUARDAR_AUX_R2
LD R3,seleccion2gris
ADD R2,R2,R3
ADD R3,R0,#0
ADD R4,R1,#0

LOOP_BORRAR_IZQ
LD R1,negro
ADD R3,R3,#-1
BRn BORRAR_DERECHA
ADD R0,R2,#0
JSR CREAR_CARAMELO
ADD R2,R2,#-16
ADD R0,R2,#0
JSR CREAR_CARAMELO
BRnzp LOOP_BORRAR_IZQ

BORRAR_DERECHA
LD R2, GUARDAR_AUX_R2
ST R2, GUARDAR_AUX_R2
LD R3,seleccion2gris
ADD R2,R2,R3
LOOP_BORRAR_DERECHA
ADD R4,R4,#-1
BRn FINAL_FUNCION
ADD R0,R2,#0
JSR CREAR_CARAMELO
ADD R2,R2,#15
ADD R2,R2,#1
ADD R0,R2,#0
JSR CREAR_CARAMELO
BRnzp LOOP_BORRAR_DERECHA

FINAL_FUNCION
LD R4, SAVEEE_R4
LD R0, SAVEEE_R0
LD R3, SAVEEE_R3
LD R5, SAVEEE_R5
LD R6, SAVEEE_R6
LD R2, SAVEEE_R2
LD R1, SAVEE_R1
LD R7, SAVEEE_R7

RET
