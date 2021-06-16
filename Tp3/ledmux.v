//Multiplexor doble con entradas de 4b

module ledmux 
#(
	parameter N_LEDS = 4
	parameter MUXSEL = 1	
)
(
	input [MUXSEL-1 : 0] i_mux_sel ,  			//btn[0] 
	input [N_LEDS -1 : 0] i_shift_leds,
	input [N_LEDS -1 : 0] i_flash_leds,  
	output [N_LEDS - 1 : 0] o_leds,
	output o_led_mux );

	
  	localparam SHIFT = 1'b0 ; 
  	localparam FLASH = 1'b1 ;


  	assign o_leds = (mux_sel == SHIFT) ? shift_leds : flash_leds;
 	assign o_led_mux = mux_sel ;

endmodule //ledmux