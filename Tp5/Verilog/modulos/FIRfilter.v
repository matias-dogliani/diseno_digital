module FIRfilter
#(
	parameter N_OS = 4, 
	parameter LFILT = 6,				/*Baudios Filt*/ 
	parameter NB_O = 8, 
	parameter NBF_O = 7

)
(
	input [1:0] i_ak, 
	input i_clk, 
	input i_enable, 
	input i_reset, 

	output [NB_O:0] o_txsymb
);

	localparam NB_COEF = 8; 
	localparam SUMFR = 11;  //Capaz que mejor si lo trunco ahí 
	
	 
    integer i;
    integer j; 
    
    reg signed [10-1:0] mul [0:LFILT-1]; 
	reg signed [12-1:0] ShiftReg ; 
	reg signed [1:0] ak; 
	reg signed [SUMFR -1:0] sum; 
	reg [2-1 : 0] MuxSel ; 

	reg signed [10-1:0] mul0;
	reg signed [10-1:0] mul1; 
	reg signed [10-1:0] mul2; 
	reg signed [10-1:0] mul3; 
	reg signed [10-1:0] mul4; 
	reg signed [10-1:0] mul5; 

	 

	wire signed [NB_COEF -1 : 0] coef [0 : LFILT -1][0 : N_OS-1]; 
	`include "./coffs.v"


    /*Shift Register*/
	always @(posedge i_clk or posedge i_reset) begin
		if (i_reset)
			ShiftReg <= { LFILT-1{ 2'b00 }}; 

		else begin
			if(i_enable)	
				ShiftReg <= {ShiftReg[ (LFILT-1)*2-1 : 0 ],i_ak}; 
			else 
				ShiftReg <= ShiftReg;
		end
	end
	
	/*Mux para coeficientes = LFILT = 6*/  
	always @( *) begin
	
	   mul0 = $signed ( $signed(ShiftReg[11:10]) *coef[0][MuxSel]); 
	   mul1 = $signed ( $signed(ShiftReg[9:8]) * coef[1][MuxSel]);
	   mul2 = $signed ( $signed(ShiftReg[7:6]) * coef[2][MuxSel]);
	   mul3 = $signed ( $signed (ShiftReg[5:4]) * coef[3][MuxSel]);
	   mul4 = $signed ( $signed(ShiftReg[3:2]) * coef[4][MuxSel]);
	   mul5 = $signed ( $signed(ShiftReg[1:0]) * coef[5][MuxSel]);
	      	     
	end
	

    /*Selector de Mux input - frecuencia del clk */

    always @(posedge i_clk or posedge i_reset) begin
		if(i_enable || i_reset)
			MuxSel <= {2-1 {1'b0}};
		else 
			MuxSel <= MuxSel + {1'b1};
	end

	/*Sumatorias - y[n]*/
	always @( *) begin
		sum = $signed ( mul0 + mul1 + mul2 + mul3 + mul4 + mul5 ); 
	end

	
    assign o_txsymb = sum; 

endmodule //FIRfilter