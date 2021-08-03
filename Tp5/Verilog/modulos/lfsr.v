module lfsr
#(
	parameter PRBS_ORDER = 9, 
	parameter SEED = 9'h1AA 

)
( 
	input i_reset, 
	input i_clk, 
	input i_enable,

	output o_prbSeq 
);



localparam FBReg = 5;

reg [PRBS_ORDER-1 : 0] lfsrReg; 

always @(posedge i_clk or posedge i_reset) begin

	if(i_reset)
		lfsrReg <=SEED; 

	else if(i_enable)				//Shift at Baud Rate	
		lfsrReg <= { lfsrReg[PRBS_ORDER-2 : 0],lfsrReg[PRBS_ORDER-1]^ lfsrReg[FBReg-1] }; 
	
	else
          lfsrReg <= lfsrReg;

	
end

assign  o_prbSeq = lfsrReg[PRBS_ORDER-1];    



endmodule //lfsr