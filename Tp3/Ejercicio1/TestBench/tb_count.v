`timescale 1ns/100ps

module tb_counter();
  
  
   reg  [1 : 0]          sel  ;				//Selector de limite de cont	
   reg                   i_reset  ;				
   reg                   i_enable ;
   reg                   clock    ;
   wire                  o_enable ;				// Salida del modulo. Cuando llega al limite 
            											// el contador 
   initial begin

      clock               = 1'b0       ;
      sel                 = 2'b00      ;
      i_reset             = 1'b1       ;               // El contador en cero  / Reset NC / 
      i_enable            = 1'b0       ;    
                  
      #100 i_enable       = 1'b1;                    // habilito el contador 
             i_reset      = 1'b0;                    // Presiono el pulsador (como es NC cuando lo presiono es NA y toma cero) (pull down) 
      #20      
            i_reset       = 1'b1;                     //Presiono el pulsador NC (toma cero cuando lo presiono) 
      #1000                                           // Cuenta hasta R0
            i_reset       = 1'b0;                     //Presiono el pulsador
      #20      
            i_reset       = 1'b1;                      //Vuelve el pulsador             
            sel           = 2'b01;                    //Establezco Limite R1    
             	  
      #800
             i_reset      = 1'b0;                    // Presiono el pulsador (como es NC cuando lo presiono es NA y toma cero) (pull down) 
      #20      
            i_reset       = 1'b1;
            sel           = 2'b10;                    //Establezco Limite R1    
             	     
       #600
            i_enable      = 1'b0;                      //Deshabilito todo     	
      #10000000 $finish;                		      //Simul = 10ms  (10x10e6 x 1 x10e-9)
   end
   
   always #5 clock = ~clock;					           //clock de f = 1/2*5ns 

counter
    u_counter(
		.i_count_enable(i_enable), 
		.i_count_sel(sel), 
		.i_ck_reset(i_reset), 
		.clk(clock), 
		.o_shift_enable(o_enable)
    );

endmodule