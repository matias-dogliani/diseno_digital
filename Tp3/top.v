`define N_LEDS 4			// Numero de LEDS  
`define N_SW				//Switches  
`define N_BTN				//Botones selectores  
`define N_ILEDS 4 			//LEDs indicadores 

module top 
(
	
	input [N_SW -1 : 0] i_sw, 
	input [N_BTN -1 : 0] i_btn, 
	input i_ck_reset, 
	input  clock,
	output [N_LEDS-1 : 0] o_led, 
	output [N_LEDS-1 : 0] o_led_r, 
	output [N_LEDS-1 : 0] o_led_g, 
	output [N_LEDS-1 : 0] o_led_b);


	wire enable;							//habilita shiftreg, flash - Salida de counter 
	wire [N_LEDS-1 : 0 ] leds_shiftreg;		// salida del bloque shiftreg 
	wire [N_LEDS-1 : 0 ] leds_flash ;		// salida del bloque flash  
	wire [N_LEDS-1 : 0 ] leds_mux; 			// salida del mux de modos 


	counter //Falta acomodar en counter.v 
		u_counter( 
			.clk(clock),
			.i_count_enable(i_sw[0]),
			.i_count_sel(i_sw[2:1]),
			.i_ck_reset(i_ck_reset),
			.o_shift_enable(enable)			//Habilita el shift y flash
		);

	shiftreg
		u_shift(
			.clk(clock),
			.i_shift_enable(enable),
			.i_ck_reset(),
			.i_shift_dir(),
			.o_shiftreg()
		);

	flash
		u_flash(
			.clk(clock),
			.i_ck_reset(i_ck_reset),
			.i_enable(enable),
			.o_flash(leds_flash)
		);

	ledmux 
		u_mux(
			.i_mux_sel(),
			.i_shift_leds(leds_shiftreg),
			.i_flash_leds(leds_flash),
			.o_led_mux(o_led[0])
			.o_leds(leds_mux),
		);
	leds 
		u_leds_box(
			.i_led(), //LEDs que salen del mux
			.i_btn(),			
			.o_led()  //LEDs indicativos 
			.o_led_r(),
			.o_led_g(),
			.o_led_b(),
		);

endmodule //top