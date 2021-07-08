`timescale 0.01ns/0.100ps
module tb_sumFp();

	localparam NB_IN_A = 8;
	localparam NBF_IN_A = 6;
	
	localparam NB_IN_B = 12;
	localparam NBF_IN_B = 11;
	
	localparam NB_OUT_FR =NB_IN_A + NB_IN_B;
    localparam NBF_OUT_FR = NBF_IN_A + NBF_IN_B;
 	
 	localparam NB_OUT =12; 
 	localparam NBF_OUT = 11;
 	
 	localparam NB_OUT_ROUND = 10;
 	localparam NBF_OUT_ROUND = 9; 
 	
 	reg signed [NB_IN_A-1 : 0]i_A ; 
	reg signed [NB_IN_B-1: 0]i_B ;
	reg clk; 
	reg [11:0]count; 
	
	wire signed [NB_OUT_FR-1:0] full_res; 
	wire signed [NB_IN_B-1:0] trunc_ovf; 
	wire signed [NB_OUT -1:0] trunc_sat; 
	wire signed [NB_OUT_ROUND-1:0] sat_round; 


    integer A_vec; 
    integer B_vec  ;
    integer MulFullRes_vec;
    integer MulOvTrunc_vec; 
    integer MulSatTrunc_vec; 
    integer MulSatRound_vec;  
  
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
	
	MulFullRes_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/MulFullResV.out","w");
	if(MulFullRes_vec == 0) $stop;
	
	MulOvTrunc_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/MulOvTruncV.out","w");
	if(MulOvTrunc_vec == 0) $stop;
	
	MulSatTrunc_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/MulSatTruncV.out","w");
	if(MulSatTrunc_vec == 0) $stop;
	
	MulSatRound_vec= $fopen("/home/matias_dogliani/Vivado_projects/Tp4/MulSatRoundV.out","w");
	if(MulSatRound_vec == 0) $stop;
	
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
			$fclose(MulFullRes_vec);
			$fclose(MulOvTrunc_vec);
			$fclose(MulSatTrunc_vec) ;
			$fclose(MulSatRound_vec) ;
			$display("Done");
			$stop; 
		end
	end



	always @(negedge clk) begin
		$fdisplay(MulFullRes_vec,"%b",full_res);
		$fdisplay(MulOvTrunc_vec,"%b",trunc_ovf);
		$fdisplay(MulSatTrunc_vec,"%b",trunc_sat);
		$fdisplay(MulSatRound_vec,"%b",sat_round);
		
	end


FpMul
	u_FpMul(
		.i_A(i_A),
		.i_B(i_B),
		.o_mulFR(full_res),
		.o_mulS_trunc_ov(trunc_ovf),
		.o_mulS_trunc_sat(trunc_sat),
		.o_mulS_round_sat(sat_round)

	);
endmodule