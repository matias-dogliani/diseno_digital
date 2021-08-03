module mapper (
	input i_rbit, 
	output [1:0] o_symb	
);

assign o_symb[1:0] = i_rbit ? $signed(2'b01) : $signed(2'b11);

endmodule //mapper