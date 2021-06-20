// Bloque de LEDs 

module leds 
#(
	parameter N_LEDS = 4,
	parameter COLOR = 3
)
(
	input clk,
	input [N_LEDS -1 : 0] i_led, 		// Valores de LEDs (de FLASH o de SHIFT)
	input [COLOR-1:0] i_btn,			// Botones de seleccion de colores (Son solo 3 botones para este modulo) 					 
	output [COLOR -1:0] o_led,			// leds de seleccion de colores  
	output [N_LEDS -1 : 0] o_led_r,		// leds rojos 
	output [N_LEDS -1 : 0] o_led_g,
	output [N_LEDS -1 : 0] o_led_b
);

	//Definicion de estados 
	localparam E0 = 2'b00;  
	localparam E1 = 2'b01;  
	localparam E2 = 2'b10;  
	localparam E3 = 2'b11;  
	
	reg [COLOR-1:0] ESTADO; 				// 4 estados. Uno para cada color mas uno inicial 
	reg [COLOR-1:0] ESTADO_PROX; 				// 4 estados. Uno para cada color mas uno inicial 
	reg [COLOR -1:0] led;			// leds de seleccion de colores  
	reg [N_LEDS -1 : 0] led_r;		// leds rojos 
	reg [N_LEDS -1 : 0] led_g;
	reg [N_LEDS -1 : 0] led_b;
	
	assign o_led = led;
	assign o_led_r = led_r;
	assign o_led_g = led_g;
	assign o_led_b = led_b;
	
	always @(posedge clk ) begin		//Actualizacion de estados 
		ESTADO <= ESTADO_PROX;			//Se puede agregar un rst para volver al estado inicial 
	end

	always @( *) begin				// Definicion de transicion de estados - Combinacional entre estados actual y entradas
		case (ESTADO) 				

			E0: begin
				if (i_btn[COLOR-1:0] == 3'b001 )
					ESTADO_PROX = E1;	
				else if (i_btn[COLOR-1:0] == 3'b010 )
					ESTADO_PROX = E2;	
				else if (i_btn[COLOR-1:0] == 3'b100 )
					ESTADO_PROX = E3;	
				else 
					ESTADO_PROX = E0; 
			end
			E1: begin
				if (i_btn[COLOR-1:0] == 3'b010 )
					ESTADO_PROX = E2;	
				else if (i_btn[COLOR-1:0] == 3'b100 )
					ESTADO_PROX = E3;	
				else 
					ESTADO_PROX = E1; 
			end
			E2: begin
				if (i_btn[COLOR-1:0] == 3'b001 )
					ESTADO_PROX = E1;	
				else if (i_btn[COLOR-1:0] == 3'b100 )
					ESTADO_PROX = E3;	
				else 
					ESTADO_PROX = E2; 
			end
			E3: begin
				if (i_btn[COLOR-1:0] == 3'b001 )
					ESTADO_PROX = E1;	
				else if (i_btn[COLOR-1:0] == 3'b010 )
					ESTADO_PROX = E2;	
				else 
					ESTADO_PROX = E3; 
			end
			
			default: ESTADO_PROX=E0; 
		
		endcase


	end

	always @(*) begin			//Maq de Moore - Las salidas depende del estado actual 
		case (ESTADO)
			E0: begin
				led = {(COLOR){1'b0}};
				led_r = {(N_LEDS){1'b0}};
				led_g = {(N_LEDS){1'b0}};
				led_b = {(N_LEDS){1'b0}};
			end
			E1: begin
				led = 3'b001;
				led_r =i_led; 
				led_g = {(N_LEDS){1'b0}};
				led_b = {(N_LEDS){1'b0}};
			end
			E2: begin
				
				led = 3'b010;
				led_r = {(N_LEDS){1'b0}};
				led_g =i_led; 
				led_b = {(N_LEDS){1'b0}};
			end
			E3: begin
				
				led = 3'b100;
				led_r = {(N_LEDS){1'b0}};
				led_g = {(N_LEDS){1'b0}};
				led_b =i_led; 
			end
			default: begin
				led = {(COLOR){1'b0}};
				led_r = {(N_LEDS){1'b0}};
				led_g = {(N_LEDS){1'b0}};
				led_b = {(N_LEDS){1'b0}};
			end
		endcase	
	end

endmodule //leds