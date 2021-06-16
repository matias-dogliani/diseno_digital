

module top 
#(
    parameter N_LEDS = 4, 
    parameter N_SW = 4, 
    parameter N_BTN = 4, 
    parameter N_ILEDS = 4
)

(	input [N_SW -1 : 0] i_sw, 
	input [N_BTN -1 : 0] i_btn, 
	input i_ck_reset, 
	input  clock,
	output [N_LEDS-1 : 0] o_led, 
	output [N_LEDS-1 : 0] o_led_r, 
	output [N_LEDS-1 : 0] o_led_g, 
	output [N_LEDS-1 : 0] o_led_b );


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
			.i_ck_reset(i_ck_reset),
			.i_shift_dir(i_sw[3]),			//Seleccion de dir 
			.o_shiftreg(leds_shiftreg)      //LEDs de salida del shift - entrada a mux led
		);

	flash
		u_flash(
			.clk(clock),
			.i_ck_reset(i_ck_reset),
			.i_enable(enable),
			.o_flash(leds_flash)			//LEDs de salida de flash - entrada de a mux led 
		);

	ledmux 
		u_mux(
			.i_mux_sel(i_btn[0]),			//Seleccion de modo 
			.i_shift_leds(leds_shiftreg),
			.i_flash_leds(leds_flash),
			.o_led_mux(o_led[0]),
			.o_leds(leds_mux));
	leds 							
		u_leds_box(
			.i_led(leds_mux), 					//LEDs que salen del mux
			.i_btn(i_btn[3:1]),			
			.o_led(o_led[N_LEDS-1 : 0]),  							//LEDs indicativos 
			.o_led_r(o_led_r[N_LEDS-1 : 0]),
			.o_led_g(o_led_g[N_LEDS-1 : 0]),
			.o_led_b(o_led_b[N_LEDS-1 : 0]));

endmodule //top