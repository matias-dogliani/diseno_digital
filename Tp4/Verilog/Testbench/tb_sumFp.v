`timescale 0.01ns/0.100ps
module tb_sumFp();

	localparam NB_IN_A = 16;
	localparam NBF_IN_A = 14;
	
	localparam NB_IN_B = 12;
	localparam NBF_IN_B = 11;
	
	localparam NB_IN_FR = 17;
    localparam NBF_IN_FR = 14;
 	
 	localparam NB_OUT =11; 
 	localparam NBF_OUT = 10;
 	
 	localparam NB_OUT_ROUND = 9;
 	localparam NBF_OUT_ROUND = 8; 
 	
 	reg signed [NB_IN_A-1 : 0]i_A ; 
	reg signed [NB_IN_B-1: 0]i_B ;
	reg clk; 
	reg [11:0]count; 
	
	wire signed [NB_IN_FR-1:0] full_res; 
	wire signed [NB_IN_B-1:0] trunc_ovf; 
	wire signed [NB_OUT -1:0] trunc_sat; 
	wire signed [NB_OUT_ROUND-1:0] sat_round; 


    integer A_vec; 
    integer B_vec  ;
    integer SumFullRes_vec;
    integer SumOvTrunc_vec; 
    integer SumSatTrunc_vec; 
    integer SumSatRound_vec;  
  
    reg Ap; 
    reg Bp;

   initial begin
    clk = 1'b0;  
	i_A  =	{NB_IN_A{1'b0}};
	i_B  =	{NB_IN_B{1'b0}};
    count = 0; 
	A_vec = $fopen("/home/matias_dogliani/Vivado_projects/Tp4/A.in","r");
	if(A_vec == 0) $stop;
	
	B_vec = $fopen("/home/matias_dogliani/Vivado_projects/Tp4/B.in","r");
    if(B_vec == 0) $stop;
	
	SumFullRes_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/SumFullResV.out","w");
	if(SumFullRes_vec == 0) $stop;
	
	SumOvTrunc_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/SumOvTruncV.out","w");
	if(SumOvTrunc_vec == 0) $stop;
	
	SumSatTrunc_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/SumSatTruncV.out","w");
	if(SumSatTrunc_vec == 0) $stop;
	
	SumSatRound_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/SumSatRoundV.out","w");
	if(SumSatRound_vec == 0) $stop;
	
	#100000000 $finish ;

   end 
    always #0.5 clk = ~clk;
   
	always @(posedge clk) begin
        count <= count +1'b1;
		Ap <= $fscanf(A_vec,"%b",i_A) ;
		Bp <= $fscanf(B_vec,"%b",i_B) ;
        
		if(Ap !=1 | Bp != 1 | count == 1000)begin 			//Fin del archivo 
			$fclose(A_vec);
			$fclose(B_vec); 
			$fclose(SumFullRes_vec);
			$fclose(SumOvTrunc_vec);
			$fclose(SumSatTrunc_vec) ;
			$fclose(SumSatRound_vec) ;
			$display("Done");
			$stop; 
		end
	end



	always @(negedge clk) begin
		$fdisplay(SumFullRes_vec,"%b",full_res);
		$fdisplay(SumOvTrunc_vec,"%b",trunc_ovf);
		$fdisplay(SumSatTrunc_vec,"%b",trunc_sat);
		$fdisplay(SumSatRound_vec,"%b",sat_round);
		
	end


sumFp 
	u_sumFp(
		.i_A(i_A),
		.i_B(i_B),
		.o_sumFR(full_res),
		.o_sumS_trunc_ov(trunc_ovf),
		.o_sumS_trunc_sat(trunc_sat),
		.o_sumS_round_sat(sat_round)

	);

endmodule