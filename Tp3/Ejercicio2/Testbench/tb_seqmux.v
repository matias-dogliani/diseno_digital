`timescale 1ns/100ps
module tb_seqmux();


	reg rst;
	reg mux_sel; 
	reg [4 -1 : 0 ] shift_leds; 
	reg [4 -1 : 0 ] flash_leds; 
	reg [4 -1 : 0 ] shift2_leds; 
	wire [4 -1 : 0 ] o_mux;            //Salida del mux
    wire o_led;  
    wire estado; 
    
   initial begin

	  rst = 1'b1; 
	  shift_leds = 4'b1111; 
	  flash_leds = 4'b1110; 
	  shift2_leds = 4'b1101;
	  #10
	  rst = 1'b0;              //Simulo pulsador de rst 
	  #10 
	  rst = 1'b1; 
	  mux_sel = 1'b0;
	 #1000000 $finish;
   end

   always #50 mux_sel = ~ mux_sel;

   assign estado = tb_seqmux.u_seqmux.estado;  

seqmux
	u_seqmux(
	    .i_rst(rst),
		.i_mux_sel(mux_sel),
		.i_shift_leds(shift_leds),
		.i_shift2_leds(shift2_leds),
		.i_flash_leds(flash_leds), 
		.o_leds(o_mux),
		.o_led_mux(o_led)
	);

endmodule
