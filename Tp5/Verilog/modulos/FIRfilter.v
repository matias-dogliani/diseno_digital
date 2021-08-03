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

	output [NBI_O:0] o_txsymb 	
);

	localparam NB_COEF = 8; 
	localparam SUMFR = 11;  
	integer i; 

	reg [1:0] ShiftReg [LFILT-1:0]; 
	reg signed [1:0] ak; 
	reg signed [SUMFR -1:0] sum; 
	reg [2-1 : 0] MuxSel ; 
	wire signed [10-1:0] mul; 	
	wire signed [NB_COEF -1 : 0] coef [0 : LFILT -1][0 : N_OS-1]; 
	`include "coffs.v"


	/*Shift Register*/
	always @(posedge i_clk or posedge i_reset) begin
		if (i_reset)
			ShiftReg <= { LFILT-1{ 2'b00 }}; 

		else begin

			if(i_enable)	
				ShiftReg <= {ShiftReg[LFIT-2:0],i_ak}; 
			else 
				ShiftReg <= ShiftReg;
		end
	end
	
	/*Mux para coeficientes = LFILT = 6*/  
	always @( *) begin
		for (i = 0 ; i < LFILT ; i = i+1)begin
			mul = $signed( i_ak[i] * $signed ( coef[MuxSel][LFILT])) ;	
		end
	end

	/*Sumatorias - y[n]*/

	always @( *) begin
		sum = 0; 
		for (i = 0 ; i < LFILT ; i = i+1)begin
			sum = sum+mul[i]; 			
		end
	end

	/*MuxSel a frecuencia de clk */

	always @(posedge i_clk or posedge i_reset) begin

		if(i_enable || i_reset)
			MuxSel <= {2-1 {1'b0}}
		else 
			MuxSel <= MuxSel + {1'b1}
	end

endmodule //FIRfilter