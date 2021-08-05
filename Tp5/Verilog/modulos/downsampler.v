module downsampler 
#(
	parameter WL = 2,		/*Longitud de los simbolos */
	parameter NB_W = 8,     /*Resolución de los símbolos */
	parameter N_OS = 4,		/* Tasa de submuestreo*/
	parameter To = 1'd1		/*FASE*/ 

)
(
	input i_clk,
	input i_enable,  
	input i_reset,
	input [ NB_W - 1: 0 ]i_ak,

	output [NB_W - 1 : 0]o_ak 

);


	localparam CL = $clog2(N_OS);		/*Largo del contador para downsampler*/



	reg signed [WL-1 : 0] akDwn; 
	reg [CL-1 : 0 ] counter; 
	reg signed [NB_W - 1 : 0] symb [0:N_OS - 1]; 		/*Buffer de simbolos */
	reg [CL -1 :0] counter_enable; 
	reg enabledwn; 

	always @(posedge i_clk or posedge i_reset) begin           /*Retardo la fase de muestreo*/
		if (i_reset)begin
			counter_enable <= {CL - 1 {1'b0}}; 
			enabledwn <= 1'b0; 
		  end 
		else 
			if (counter_enable == To)
				enabledwn = 1'b1; 
			else 
				counter_enable <= counter_enable + 1'b1; 	
	end

	always @(posedge i_clk or posedge i_reset) begin       /*Submuestre cada N, una vez que pasó el retardo */
		if (i_reset)
			counter <= {CL-1 {1'b0}}; 
		else if (i_enable && enabledwn)
			counter <= counter +1'b1; 
		else
			counter <= counter; 
	end


	always @(posedge i_clk or posedge i_reset) begin       /*Guardo los símbolos en memoria, solo tomo cada N la salida*/
		if (i_reset)begin
			symb[0]  <= { {WL-1 {1'b0}}  };
			symb[1]  <= { {WL-1 {1'b0}}  };
			symb[2]  <= { {WL-1 {1'b0}}  };
			symb[3]  <= { {WL-1 {1'b0}}  };
			end
		else
			symb[counter] <= i_ak; 		
	end

	assign o_ak = symb[N_OS-1];

endmodule //downsampler