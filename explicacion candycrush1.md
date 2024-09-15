    start: es en donde empieza a pintar el cuadrado gris.
    candy: Guarda la dirección base del primer caramelo en la tabla. Todos los caramelos están organizados en memoria a partir de esta posición(128 + 128 + 2, 2 para abajo y 2 a la derecha, esto se lo sumo al start para empezar a pintar el caramelo de color).
    rojo, verde, azul, amarillo, rosa: Cada una de estas variables contiene el color de un tipo de caramelo, definido en formato hexadecimal.
    start y start_seleccion: Posiciones iniciales para dibujar los caramelos y la selección, respectivamente.
    salto: Define cuánto debes mover la posición al cambiar de fila (128 - 14, 14 es el ancho del cuadrado gris)
    ancho y ancho_pantalla: Definen el ancho de cada caramelo(14) y el ancho total de la pantalla(128).

Funciones Principales
1. CREAR_CARAMELO

Esta es la función encargada de dibujar cada caramelo en la pantalla. Al invocarla, toma el color almacenado en el registro R1 y dibuja un cuadrado en la posición actual (R0). El ciclo de esta función utiliza varios loops internos:

    Loop2: Aquí, el programa dibuja las líneas horizontales que componen el borde del caramelo. Se van añadiendo pixeles uno por uno usando STR R4, R0, #0, donde R4 contiene el color gris.

    Loop3 y Loop4: En estos loops, se dibuja el interior del caramelo, esta vez con el color que está en R1. El ciclo se repite hasta completar las dimensiones del caramelo.

Contexto del Bucle LOOP_CANDY

Este bucle organiza la disposición de los caramelos en una tabla de 8x8 (128x124 píxeles en total). Cada caramelo ocupa una celda y tiene un tamaño de 10x10 píxeles. Los caramelos se dibujan en la pantalla en 8 columnas y 8 filas, intercalando colores.
Variables usadas en LOOP_CANDY:

    R0: Registra la posición en memoria donde se dibuja el caramelo actual.
    R1: Contiene el color del caramelo que se va a dibujar.
    R3: Es el valor que se suma a R0 para avanzar a la siguiente posición de caramelo (en la misma fila o al pasar a la siguiente fila).
    R4: Cuenta las iteraciones del bucle, controlando cuántas filas de caramelos se han dibujado.
    salto: Define cuánto se debe saltar en memoria cuando se completa una fila de caramelos para pasar a la siguiente.

Código del LOOP_CANDY:

LOOP_CANDY
    LD R1, rojo
    JSR CREAR_CARAMELO
    ADD R0, R0, R3
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
    LD R2, salto
    ADD R0, R0, R2
    ADD R4, R4, #-1
    BRp LOOP_CANDY


    Iniciar el bucle: El bucle comienza cargando el color del primer caramelo (en este caso, rojo) en el registro R1:

LD R1, rojo
JSR CREAR_CARAMELO

    LD R1, rojo: Carga el color rojo en el registro R1.
    JSR CREAR_CARAMELO: Llama a la subrutina que dibuja el caramelo en la posición actual, usando el color que está en R1 (rojo en este caso).

Actualizar posición: Después de dibujar el caramelo rojo, el programa suma el valor de R3 (que contiene el valor 16, el ancho de un caramelo más espacio entre ellos) a R0 para moverse a la posición del siguiente caramelo en la misma fila:

ADD R0, R0, R3

Esto asegura que el próximo caramelo no se dibuje encima del anterior.

Repetir con otros colores: El bucle repite el proceso para los demás colores (azul, verde, rosa, amarillo, etc.). Cada vez:

    Carga un color diferente en R1.
    Llama a la subrutina CREAR_CARAMELO para dibujar el caramelo.
    Actualiza la posición R0 para moverse al siguiente espacio en la misma fila.

Final de la fila: Una vez que se han dibujado los caramelos correspondientes a una fila (8 en total), el bucle debe "saltar" a la siguiente fila en la tabla.

LD R2, salto
ADD R0, R0, R2

    LD R2, salto: Carga en R2 el valor de salto necesario para moverse a la siguiente fila de caramelos.
    ADD R0, R0, R2: Suma este valor de salto a R0 para actualizar la posición y empezar a dibujar la siguiente fila de caramelos en la tabla.

Control del bucle: Cada vez que el bucle completa una fila de caramelos, se decrementa R4, que contiene el número de filas que faltan por dibujar. Si aún quedan filas por dibujar, el bucle se repite:

ADD R4, R4, #-1
BRp LOOP_CANDY

    ADD R4, R4, #-1: Decrementa R4 en uno (indicando que una fila ha sido completada).
    BRp LOOP_CANDY: Si R4 sigue siendo positivo, el programa vuelve al principio del bucle para dibujar la siguiente fila de caramelos. Si no, el bucle termina.

La función SELECCION es clave para el manejo visual de la selección del caramelo. Su propósito es dibujar un borde alrededor del caramelo actualmente seleccionado, lo cual es fundamental para que el usuario sepa qué caramelo está interactuando en el juego.

Variables y registros iniciales:
        R2: Este registro contiene la posición actual en la memoria de video donde se debe dibujar la selección.
        R4: Almacena el color del borde (blanco en este caso).
        R3: Representa el número de píxeles en cada lado del borde.
        R5, R6, R7: Estas variables almacenan datos como el tamaño de las líneas y el ancho de la pantalla.

    Guardar el estado:

ST R2, SAVEE_R2
ST R7, SAVEE_R7

Estas instrucciones almacenan los valores actuales de los registros R2 y R7 en variables de respaldo (ubicadas en la memoria). Esto es importante porque los registros se modificarán durante la función, y se necesita restaurarlos antes de volver al flujo principal.

Primer bucle de selección (LOOP_SELECCION): Este bucle se encarga de dibujar una línea horizontal que forma parte del borde superior del caramelo.

asm

LOOP_SELECCION
STR R4,R2,#0      ; Dibuja el color blanco en la posición actual
ADD R2,R2,#1      ; Mueve la posición de memoria al siguiente pixel
ADD R3,R3,#-1     ; Decrementa el contador de píxeles
BRp LOOP_SELECCION; 

Mover a la siguiente línea: Una vez que el borde superior está dibujado, se mueve hacia la línea de píxeles inferior.

ADD R2,R2,R5      ; Mueve la posición en memoria a la siguiente línea (hacia abajo)

Segundo bucle (LOOP1_SELECCION): En este bucle, se dibujan los lados verticales del borde (a la izquierda y a la derecha del caramelo).


LOOP1_SELECCION
STR R4,R2,#0      ; Dibuja el lado izquierdo
STR R4,R2,#15     ; Dibuja el lado derecho
ADD R2,R2,R6      ; Mueve hacia la siguiente línea
ADD R7,R7,#-1     ; Decrementa el contador de líneas
BRp LOOP1_SELECCION; Si no ha terminado, repite el ciclo

Tercer bucle (LOOP2_SELECCION): Finalmente, este ciclo se encarga de dibujar la línea inferior del borde, similar al primer bucle.

LOOP2_SELECCION
STR R4,R2,#0      ; Dibuja el borde inferior
ADD R2,R2,#1      ; Mueve la posición al siguiente pixel
ADD R3,R3,#-1     ; Decrementa el contador de píxeles
BRp LOOP2_SELECCION

Restaurar los registros guardados:

LD R2, SAVEE_R2   ; Recupera el valor original de R2
LD R7, SAVEE_R7   ; Recupera el valor original de R7

Terminar la función con RET: La instrucción RET en el ensamblador LC3 tiene un papel crucial. Al final de una subrutina, RET (abreviación de "Return") indica al procesador que debe regresar al punto de la ejecución inmediatamente después de donde se llamó la subrutina. El registro R7 juega un papel importante aquí, ya que contiene la dirección de retorno (la dirección en memoria a la que debe regresar el flujo de control).

En otras palabras, cuando se ejecuta JSR SELECCION, la dirección de la siguiente instrucción se almacena en R7. Al final de la subrutina, la instrucción RET usa el valor almacenado en R7 para volver al punto de la ejecución donde se dejó.

Antes de mover la selección, la función BORRAR elimina el borde blanco actual. Esto se logra dibujando el color negro en la misma posición del borde anterior. Una vez que se borra el borde, la nueva posición de selección es dibujada en blanco.
4. Control de Movimiento

La función MAIN actúa como el bucle principal de tu programa, gestionando la entrada del usuario (las teclas que presiona) y decidiendo cómo mover la selección del caramelo basado en esas entradas.
1. Preparación inicial

LD R2, start_seleccion (R2 se carga con la dirección de memoria inicial donde se encuentra el caramelo seleccionado. Aquí es donde se inicia la selección de caramelos)

2. Bucle de espera de entrada (ESPERALETRA)

ESPERALETRA
LDI R5,WAITKB
BRzp ESPERALETRA

Este bucle tiene la función de esperar a que el usuario presione una tecla. El programa lee el estado del teclado en la dirección de memoria WAITKB (mapeada a la entrada del teclado). Si no se ha presionado ninguna tecla, el programa sigue esperando.

WAITKB: Esta es la ubicación de la memoria que indica si una tecla ha sido presionada. El bucle verifica si no hay entrada (la tecla no se ha presionado) y, si es así, vuelve a comprobar hasta que detecta una.

3. Procesar la tecla presionada

LDI R4,TECLADO
LD R3, letraDneg
ADD R4 ,R4, R3
BRz DERECHA

Una vez que una tecla ha sido presionada, el valor de la tecla se carga desde la dirección de memoria TECLADO (que contiene el código de la tecla presionada). Dependiendo de cuál fue la tecla presionada, el programa ejecuta las siguientes instrucciones para determinar si la tecla corresponde a un movimiento.

    letraDneg y letraDpos: Estas constantes contienen valores para la tecla D, que se utiliza para mover la selección a la derecha. Si el valor almacenado en R4 coincide con estos valores, el programa redirige el flujo a la subrutina DERECHA con BRz DERECHA.

    Este proceso se repite para las teclas A (izquierda), S (abajo), y W (arriba), usando los valores correspondientes (letraAneg, letraApos, letraSneg, etc.).

4. Movimiento a la derecha (DERECHA)

DERECHA
JSR BORRAR
ADD R2, R2, #15
ADD R2, R2, #1
JSR SELECCION
BRnzp ESPERALETRA

Si se detecta que la tecla presionada fue la D, el programa llama a la subrutina DERECHA:

    JSR BORRAR: Antes de mover la selección, la función BORRAR elimina el borde blanco actual (rellenando con negro) en la posición anterior.

    Movimiento: Luego, la dirección R2 (que apunta al caramelo seleccionado) se incrementa para mover el borde a la derecha. En concreto, el valor #15 mueve la posición 15 píxeles a la derecha, y #1 ajusta para el desplazamiento exacto.

    JSR SELECCION: Después de actualizar la posición, la subrutina SELECCION dibuja el nuevo borde blanco en la nueva posición seleccionada.

    Regresar al bucle: Tras mover la selección y actualizar el borde, el programa regresa al bucle principal (ESPERALETRA) para esperar la siguiente entrada del usuario.

5. Movimiento a la izquierda (IZQUIERDA)

El proceso es similar a DERECHA, pero esta vez se restan valores a R2 para mover la selección hacia la izquierda:

IZQUIERDA
JSR BORRAR
ADD R2, R2, #-15
ADD R2, R2, #-1
JSR SELECCION
BRnzp ESPERALETRA

Aquí se resta #15 y #1 para mover el borde hacia la izquierda, y luego se vuelve a dibujar el borde con SELECCION.
6. Movimiento hacia abajo (ABAJO)

Cuando el usuario presiona la tecla S para moverse hacia abajo:

ABAJO
JSR BORRAR
LD R4, salto_selec
ADD R2, R2, R4
JSR SELECCION
BRnzp ESPERALETRA

El valor R4 se carga con salto_selec, que es el desplazamiento necesario para mover la selección una fila hacia abajo. Este valor luego se suma a R2 para cambiar de fila.
7. Movimiento hacia arriba (ARRIBA)

El proceso es casi idéntico al de mover hacia abajo, pero con un valor negativo para moverse hacia arriba:

ARRIBA
JSR BORRAR
LD R4, salto_selec_neg
ADD R2, R2, R4
JSR SELECCION
BRnzp ESPERALETRA

El valor salto_selec_neg es un número negativo que, al sumarlo a R2, mueve la selección hacia arriba.




