`timescale 1ns/100ps
module tb_ledmuxE2();


	reg mux_sel; 
	reg [4 -1 : 0 ] shift_leds; 
	reg [4 -1 : 0 ] flash_leds; 
	reg [4 -1 : 0 ] shift2_leds; 
	reg [4 -1 : 0 ] o_mux;  
    reg o_led;  
   
   initial begin

	  shift_leds = 4'b1111; 
	  flash_leds = 4'b1110; 
	  shift2_leds = 4'b1101; 
	  mux_sel = 1'b0;
      #1000000 $finish                 ;
   end

   always #20 mux_sel = ~ mux_sel;

muxledE2
	u_muxE2(
		.i_mux_sel(mux_sel),
		.i_shift_leds(shift_leds),
		.i_shift2_leds(shift2_leds),
		.i_flash_leds(flash_leds), 
		.o_leds(o_mux),
		.o_led_mux(o_led)
	);

endmodule