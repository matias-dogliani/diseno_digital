module downsampler 
#(
	parameter WL = 2,		/*Longitud de los simbolos */
	parameter N_OS = 4,		/* Tasa de submuestreo*/
	parameter To = 1d'1,		/*FASE*/ 

)
(
	input i_clk,
	input i_enable,  
	input i_reset,
	input [ WL-1: 0 ]i_ak,

	output [WL -1 : 0]o_ak 

);


	localparam CL = $clog2(N_OS)		/*Largo del contador para downsampler*/



	reg signed [WL-1 : 0] akDwn; 
	reg [CL-1 : 0 ] counter; 
	reg signed [WL-1 : 0] symb [0:N_OS - 1]; 		/*Buffer de simbolos */
	reg [CL -1 :0] counter_enable; 
	reg enabledwn; 

	always @(posedge i_clk or posedge i_reset) begin
		if (i_reset)
			counter_enable <= {CL - 1 {1'b0}}; 
			enabledwn = 1'b0; 
		else 
			if (counter_enable == To)
				enabledwn = 1'b1; 
			else 
				counter_enable <= counter_enable + 1'b1; 	
	end

	always @(posedge i_clk or posedge i_reset) begin
		if (i_reset)
			counter <= {CL-1 {1'b0}}; 
		else if (i_enable && enabledwn)
			counter <= counter +1'b1; 
		else
			counter <= counter; 
	end


	always @(posedge i_clk or posedge i_reset) begin
		if (i_reset)
			symb [0 : N_OS -1] <= {WL-1 {1'b0}}
		else
			symb[counter] <= i_ak; 		
	end

	assign o_ak = symb[N_OS-1];

endmodule //downsampler