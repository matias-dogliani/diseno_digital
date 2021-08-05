module lfsr
#(
	parameter PRBSn= 9, 
	parameter SEED = 9'h1AA 

)
( 
	input i_reset, 
	input i_clk, 
	input i_enable,

	output  o_prbSeq 
);


    localparam FBReg = 5;

    reg [PRBSn-1:0] lfsrReg; 
    wire feedback; 
    
    assign feedback = (lfsrReg[FBReg-1] ^ lfsrReg[0]); 
    assign o_prbSeq = lfsrReg[0]; 

    always @(posedge i_clk or posedge i_reset) begin
	   if(i_reset) begin
	       	lfsrReg <=SEED; 
            end 
	   else begin
	       if(i_enable) begin
	           lfsrReg[PRBSn-1] <= feedback; 
	           lfsrReg[PRBSn-2:0] <= lfsrReg[PRBSn-1:1];
	       end
	       else begin
	           lfsrReg <= lfsrReg; 
	       end
	 	
        end 
       
end





endmodule //lfsr

