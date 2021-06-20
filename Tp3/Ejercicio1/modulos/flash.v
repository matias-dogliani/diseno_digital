module flash 
#(
	parameter N_LEDS = 4
)
(	
	input clk, 
	input i_ck_rst, 
	input i_enable, 
	output [N_LEDS -1 : 0 ] o_flash);
	
	reg [N_LEDS -1 : 0 ] leds; 
	wire rst = ~i_ck_rst; 
	assign o_flash = leds;
	
	always @(posedge clk or posedge rst ) begin
		if(rst)
			leds <= 4'b1111;
		else if (i_enable) begin
			leds <= ~leds;
			end
		else 
			leds <= leds; 
				
	end 

endmodule //flash