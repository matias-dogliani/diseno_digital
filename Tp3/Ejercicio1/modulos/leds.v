// Bloque de LEDs con MEMORIA

module leds 
#(
	parameter N_LEDS = 4,
	parameter COLOR = 3
)
(
	input clk,
	input [N_LEDS -1 : 0] i_led, 		// Valores de LEDs (de FLASH o de SHIFT)
	input [COLOR -1:0] i_btn,			// Botones de seleccion de colores 					 
	output [COLOR -1:0] o_led,			// LEDs de seleccion de colores  
	output [N_LEDS -1 : 0] o_led_r,		// LEDs rojos 
	output [N_LEDS -1 : 0] o_led_g,
	output [N_LEDS -1 : 0] o_led_b
);
	
	reg [N_LEDS -1 : 0] led_r;
	reg [N_LEDS -1 : 0] led_g;
	reg [N_LEDS -1 : 0] led_b;
    reg [COLOR-1:0] led_ind; 
    
    assign o_led_r = led_r;
    assign o_led_g = led_g;
    assign o_led_b = led_b;
    assign o_led = led_ind; 
    
always @(posedge clk) begin 				
	case (i_btn)
		3'b100  :begin 
		      led_r <= i_led;  led_ind[COLOR-1:0]<= 3'b100;
		      led_g <= {N_LEDS{1'b0}};  
		      led_b <= {N_LEDS{1'b0}}; 
		 end 	
		3'b010  :begin  
		      led_r <= {N_LEDS{1'b0}}; 
		      led_g <= i_led;  led_ind[COLOR-1:0]<= 3'b010; 
		      led_b <= {N_LEDS{1'b0}};
		 end 
		3'b001  :begin  
		    
		      led_r <= {N_LEDS{1'b0}};  
		      led_g <= {N_LEDS{1'b0}};
		      led_b <= i_led;  led_ind[COLOR-1:0]<= 3'b001;
		end 
		default : begin   // No cambia nada 
		    led_ind <= led_ind;  
			led_r <= led_r;  
			led_g <= led_g; 
			led_b <= led_b; 
		end
			
	endcase

end



endmodule //leds