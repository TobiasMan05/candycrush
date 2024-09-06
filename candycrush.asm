.ORIG x3000     

        LD R0, rojo   
        LD R1, start   

        LD R2, ancho         
        LD R3, altura       
        LD R6, cant_cuadrados

DrawSquares
        
DrawRow
        LD R4, ancho         
DrawPixel

        STR R0, R1, #0       
        ADD R1, R1, #1       
        ADD R4, R4, #-1   
           
        BRp DrawPixel        
        
        LD R4, SCREEN_WIDTH  
        ADD R4, R4, #-16     
        ADD R1, R1, R4       

        ADD R4, R4, #-1      
        BRp DrawRow          
        
        ADD R1, R1, #1       
        LD R3, altura         
        ADD R6, R6, #-1      
        BRp DrawSquares      

        HALT                 


rojo    .FILL xF800   
start     .FILL xC000    
ancho         .FILL #16      
altura       .FILL #15      
SCREEN_WIDTH   .FILL #128     
cant_cuadrados    .FILL #8       
        .END
