module shiftreg 
#(parameter N_LEDS = 4)

(
	input clk, 
	input i_shift_enable, 
	input i_ck_rst, 
	input i_shift_dir,
	output [N_LEDS - 1 : 0] o_shiftreg
);

	localparam DER = 1'b1; 
	localparam IZQ = 1'b0; 

	wire rst; 
	reg [N_LEDS - 1 : 0] shift_reg;

 	assign rst = ~i_ck_rst; 
	assign o_shiftreg = shift_reg;	

	always @(posedge clk or posedge rst ) begin		
		if(rst)																// rst --> algun valor en 1 
			shift_reg <= {{(N_LEDS-2){1'b0}},1'b1 };                        //shift_reg <= {{3{1'b0}},1'b1 };
		
		else if (i_shift_enable)begin											//Contador llego al limite 
		
			if (i_shift_dir == DER)begin
				shift_reg <= {shift_reg[0],shift_reg[N_LEDS-1:1]};
			end
			
			else if (i_shift_dir == IZQ) begin
			 	shift_reg <= {shift_reg[N_LEDS-2:0],shift_reg[N_LEDS-1]};	
			end
		end 	
		
		else begin														//Disable 
			shift_reg <= shift_reg;										//Explicito   
		end
endmodule