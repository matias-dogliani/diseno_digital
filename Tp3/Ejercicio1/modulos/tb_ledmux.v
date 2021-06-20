`timescale 1ns/100ps

module tb_ledmux();
   
	reg boton;	
	reg [4-1 : 0] shift_leds;
	reg [4-1 : 0] flash_leds;
	wire [4-1 : 0] leds;
	wire led_mux;
            										// el contador 
   initial begin
	   boton = 1'b0; 
	   shift_leds [4-1 : 0] = 4'b1111; 
	   flash_leds [4-1 : 0] = 4'b0000;
	   #50 
	   shift_leds [4-1 : 0] = 4'b1110; 
	   flash_leds [4-1 : 0] = 4'b0101;
	   #50 
	   shift_leds [4-1 : 0] = 4'b0111; 
	   flash_leds [4-1 : 0] = 4'b1011;
	   #50 
	   shift_leds [4-1 : 0] = 4'b0000; 
	   flash_leds [4-1 : 0] = 4'b0000;
	   #50 
	  #100000 $finish ;
   end
   
   always #25 boton= ~boton;				//Cambio la salida cada25
   
	ledmux
		u_ledmux(
			.i_mux_sel(boton),
			.i_shift_leds(shift_leds),
			.i_flash_leds(flash_leds),
			.o_leds(leds),
			.o_led_mux(led_mux)
		);

endmodule