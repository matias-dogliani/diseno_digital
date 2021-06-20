`timescale 1ns/100ps

module tb_flash();
   
	reg clock;
	reg enable; 
	reg rst;	
	wire [4-1 : 0] r_flash;
            											// el contador 
   initial begin

	  clock = 1'b0; 
	  enable = 1'b0; 
	  rst = 1'b1;				//El reset es NC 
	  #10 
	  rst = 1'b0; 				//Pulso el reset 
	  #10						
	  rst = 1'b1;              // 1111
	  #100000 $finish ;
   end
   
   always #5 clock = ~clock;					           //clock de f = 1/2*5ns 
   always #40 enable= ~enable;			//Flash de LEDS 
   
    flash
		flash(
			.clk(clock),
			.i_ck_rst(rst),
			.i_enable(enable),
			.o_flash(r_flash));

endmodule