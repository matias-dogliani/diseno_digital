`timescale 1ns/100ps

module tb_shiftreg();
   
	reg clock;
	reg enable; 
	reg  dir; 
	reg rst;	
	wire [4-1 : 0] r_shiftreg;
            											// el contador 
   initial begin

	  clock = 1'b0; 
	  enable = 1'b0; 
	  dir = 1'b0; 				//Izquierda 
	  rst = 1'b1;				//El reset es NC 
	  #100 
	  rst = 1'b0; 				//Pulso el reset 
	  #20						
	  rst = 1'b1;              // 1100
	  #100 
	//  enable = 1'b1;			//Habilito el shift 
	  #2
	//  enable = 1'b0; 			// Lo deshabilito despues de 2 shifts				
	  #100
	  dir = 1'b1;				//Derecha 
	 // enable = 1'b1; 
	  #4
	//  enable = 1'b0;				//4 desplazamientos  a la derecha 	
	  #100 
	  rst = 1'b0; 				//Pulso el reset 
	  #20						
	  rst = 1'b1;   	
	  #100 						//Observo las salidas de forma resetedas
      #1000000 $finish;                		      
   end
   
   always #5 clock = ~clock;					           //clock de f = 1/2*5ns 
   always #20 enable= ~enable; 
   
    shiftreg
		u_shiftreg(
			.clk(clock),
			.i_shift_enable(enable),
			.i_ck_rst(rst),
			.i_shift_dir(dir),
			.o_shiftreg(r_shiftreg));

endmodule