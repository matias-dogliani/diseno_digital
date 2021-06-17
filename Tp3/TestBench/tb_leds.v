`timescale 1ns/100ps

module tb_ledmux();
   
    reg clock; 
	reg [4-1 : 0] leds;
	reg [2 : 0] btn;			//seleccionadores de color 
	wire [2:0] o_led;			//Indicadores de color seleccionado 
	wire [4-1 : 0] leds_r;
	wire [4-1 : 0] leds_g;
	wire [4-1 : 0] leds_b;

            										// el contador 
   initial begin
       clock = 1'b0;
	   leds = 4'b0111;
	   btn = 3'b000;
	   #100 
	   btn = 3'b100;			//Rojo 
	   #100 
	   btn = 3'b010;			//Verde 
	   #100 
	   btn = 3'b001;			//Azul 
	   #100 
	   #2000000 $finish ;
   end
   
   always #5 clock = ~clock;
   
	leds 
		u_leds(
			.clk(clock),
			.i_led(leds),
			.i_btn(btn),
			.o_led(o_led),
			.o_led_r(leds_r),
			.o_led_g(leds_g),
			.o_led_b(leds_b)
		);
endmodule