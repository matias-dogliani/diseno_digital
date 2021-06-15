module flash 
#(
	parameter N_LEDS = 4
)
(	
	input i_ck_reset, 
	input i_enable, 
	input clock, 
	output o_flash);
	
	reg [N_LEDS -1 : 0 ] leds; 
	wire rst = ~i_ck_reset; 
	assign o_flash = leds;
	
	always @(posedge clock or posedge rst ) begin

		if(rst)
			leds <= {(N_LEDS -1){1'b1}}; 
		else if (i_enable) begin
			leds <= ~leds;
			else 
				leds <= leds; 

		end

		
	end 

endmodule //flash