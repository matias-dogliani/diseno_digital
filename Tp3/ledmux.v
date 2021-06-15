module ledmux 
#(
	parameter N_LEDS = 4
	parameter MUXSEL = 1	
	parameter N_COLORS = 3
)
(
	input [MUXSEL-1 : 0] mux_sel ,  			//btn[0] 
	input [N_COLORS -1 : 0] i_btn,				// 0_led[3:1] 
	input [N_LEDS - 1 : 0] i_led,				// LEDs de shift o Flash 
	output [N_LEDS - 1 : 0] o_led,
	output [N_LEDS - 1 : 0] o_led_r,
	output [N_LEDS - 1 : 0] o_led_g,
	output [N_LEDS - 1 : 0] o_led_b
);

	
	// Pulsadores a LEDS indicativos 
	assign o_led = i_btn ;




endmodule //ledmux