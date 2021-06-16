// Bloque de LEDs 

module leds 
#(
	parameter N_LEDS = 4,
	parameter COLOR = 3
)
(
	input [N_LEDS -1 : 0] i_led, 		// Valores de LEDs (de FLASH o de SHIFT)
	input [COLOR -1:0] i_btn,			// Botones de seleccion de colores 					 
	output [COLOR -1:0] o_led,			// LEDs de seleccion de colores  
	output [N_LEDS -1 : 0] o_led_r,		// LEDs rojos 
	output [N_LEDS -1 : 0] o_led_g,
	output [N_LEDS -1 : 0] o_led_b
);
	assign o_led = i_btn;   //Los LEDs indicativos corresponden con los btn de seleccion de color 

	reg [N_LEDS -1 : 0] led_r;
	reg [N_LEDS -1 : 0] led_g;
	reg [N_LEDS -1 : 0] led_b;

always @(*) begin 		//Aca creo que seria mejor si va un clock + Agregar input clk  		

	case (i_btn)
		3'b100  : led_r <= i_led; 	
		3'b010  : led_g <= i_led; 	
		3'b001  : led_b <= i_led; 	
		default : begin
			led_r <= led_r;
			led_g <= led_g;
			led_b <= led_b;
		end
			
	endcase

end



endmodule //leds