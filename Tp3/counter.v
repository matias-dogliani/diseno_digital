module counter  
#(   
    parameter NB_COUNT  =32        //No tiene sentido parametrizar 
                                    // los sw_selector porque tengoq que cambiar el assign (y no se usa un generate o algo asi)
)
 (
    output o_shift_enable, 
    input i_count_enable,             // i_sw[0] 
    input [1:0] i_count_sel,            // i_sw[2:1]     
    input i_ck_reset ,                  //reset asincrono
    input clk                       // clk100Mhz
    );

    // Valor de numeros a comparar  
    localparam R0  = (2**(NB_COUNT-10))-1 ;
    localparam R1  = (2**(NB_COUNT-9))-1  ;
    localparam R2  = (2**(NB_COUNT-8))-1  ;
    localparam R3  = (2**(NB_COUNT-7))-1  ;
  
    // Selector 
    localparam SEL0  = 2'b00;
    localparam SEL1  = 2'b01;
    localparam SEL2  = 2'b11;
 
   
    wire[NB_COUNT - 1 : 0] limite_cuenta ;   //Limite a comparar 
    reg [NB_COUNT - 1 : 0] counter ;        //Contador
    reg enable_shiftreg; 
    
    assign limite_cuenta= (i_count_sel[1:0]==SEL0) ? R0 :       // Mux
                          (i_count_sel[1:0]==SEL1) ? R1 :
                          (i_count_sel[1:0]==SEL2) ? R2 : R3;
    assign rst = ~i_ck_reset;  
    assign o_shift_enable = enable_shiftreg;
    
    // logica secuencial 
    always @(negedge clk or posedge rst) begin
       if (rst)
                counter  <= {NB_COUNT{1'b0}};

       else if (i_count_enable) begin            
           
           if(counter>=limite_cuenta) begin                 //Comparador 
                counter  <= {NB_COUNT{1'b0}};
                enable_shiftreg <= 1'b1;
         end
            else begin
                counter  <= counter + {{NB_COUNT-1{1'b0}},{1'b1}};       //counter ++
                enable_shiftreg <= 1'b0; 
            end
       end
       else 
            counter <= counter;     //no cambia si no esta habilitado  
    end
   

endmodule //counter