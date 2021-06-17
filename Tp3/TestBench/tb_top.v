`timescale 1ns/100ps

module tb_top();
   
    localparam  N_LEDS = 4; 
    localparam  N_SW = 4; 
    localparam  N_BTN = 4; 
    localparam  N_ILEDS = 4;  
	
	reg [N_SW -1 : 0] sw; 
	reg [N_BTN -1 : 0] btn;
	reg ck_reset; 
	reg  clock;
	wire [N_LEDS-1 : 0] led; 
	wire [N_LEDS-1 : 0] led_r, 
	wire [N_LEDS-1 : 0] led_g, 
	wire [N_LEDS-1 : 0] led_b );
   
   initial begin

	  clock = 1'b0; 
	  sw = 4'b000; 
	  btn = 4'b000; 
	  ck_reset = 1'b1;  
	  #20
	  ck_reset = 1'b0;     // Presiono el reset 
	  #5
	  ck_reset = 1'b1; 	
	  #100 
	  sw = 4'b1011; 		//Derecha, R1, count  enable
	  #100 
	  btn= 4'b1001; 		//Un color, modo flash 
	  #100 
	  sw = 4'b0001; 		//Izquierda, R0, count  enable
	  btn= 4'b0100; 		//Un color, modo shift 
   	  #20
	  ck_reset = 1'b0;     // Presiono el reset 
	  #5
	  ck_reset = 1'b1; 
   
   end
   
   always #5 clock = ~clock;					           //clock de f = 1/2*5ns 

	top 
		u_top(
			.i_sw(sw),
			.i_btn(btn),
			.i_ck_reset(ck_reset),
			.clock(clock),
			.o_led(led),
			.o_led_r(led_r),	
			.o_led_g(led_g),	
			.o_led_b(led_b)
		);

endmodule