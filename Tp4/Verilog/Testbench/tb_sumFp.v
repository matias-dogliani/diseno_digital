`timescale 1ns/100ps
module tb_sumFp();

	localparam NB_IN_A = 16;
	localparam NBF_IN_A = 14;
	
	localparam NB_IN_B = 12;
	localparam NBF_IN_B = 11;

 	reg signed [16-1 : 0]i_A ; 
	reg signed [12_1: 0]i_B ;
	reg clk; 
	
	wire signed [17-1:0] full_res; 
	wire signed [11-1:0] trunc_ovf; 
	wire signed [11-1:0] trunc_sat; 
	wire signed [9-1:0] sat_round; 


    integer A_vec; 
    integer B_vec  ;
    integer SumFullRes_vec;
    integer SumOvTrunc_vec; 
    integer SumSatTrunc_vec; 
    integer SumSatRound_vec;  
  

   initial begin
    clk = 1'b0;  
	i_A  =	{NB_IN_A{1'b0}};
	i_B  =	{NB_IN_B{1'b0}};

	A_vec = $fopen("./A.in","r");
	if(!A_vec)
		$display("Error abriendo archivo A.in");
		$stop;
	
	B_vec = $fopen("./A.in","r");
   
	SumFullRes_vec= $fopen("SumFullResV.out","w");
	SumOvTrunc_vec= $fopen("SumOvTruncV.out","w");
	SumSatTrunc_vec= $fopen("SumSatTruncV","w");
	SumSatRound_vec= $fopen("SumSatRoundV","w");

   end 

	always @(posedge clk ) begin

		Ap <= $fscanf(A_vec,"%b",i_A)) ;
		Bp <= $fscanf(A_vec,"%b",i_A)) ;

		if(Ap !=1 | Bp != 1)				//Fin del archivo 
			$fclose(A_vec);
			$fclose(B_vec); 
			$fclose(SumFullRes_vec);
			$fclose(SumOvTrunc_vec);
			$fclose(SumSatTrunc_vec) ;
			$fclose(SumSatRound_vec) ;
			$display("Done");
		end 
	end

   always #20 clock = ~clock;

	always @(negedge clk ) begin
		
		$fdisplay(SumFullRes_vec,"%b",full_res)
		$fdisplay(SumOvTrunc_vec,"%b",trunc_ovf)
		$fdisplay(SumSatTrunc_vec,"%b",trunc_sat)
		$fdisplay(SumSatTrunc_vec,"%b",trunc_sat)

	end


sumFp 
	u_sumFp(
		.i_A(A),
		.i_B(B),
		.o_sumFR(full_res),
		.o_sumS_trunc_ov(trunc_ovf),
		.o_sumS_trunc_sat(trunc_sat),
		.o_sumS_round_sat(sat_round)

	);

endmodule