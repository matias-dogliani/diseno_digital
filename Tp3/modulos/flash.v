module flash 
#(
	parameter N_LEDS = 4
)
(	
	input clk, 
	input i_ck_reset, 
	input i_enable, 
	output o_flash);
	
	reg [N_LEDS -1 : 0 ] leds; 
	wire rst = ~i_ck_reset; 
	assign o_flash = leds;
	
	always @(posedge clk or posedge rst ) begin

		if(rst)
			leds <= {(N_LEDS -1){1'b1}}; 
		else if (i_enable) begin
			leds <= ~leds;
			end
		else 
			leds <= leds; 
				
	end 

endmodule //flash