`timescale 1ns/100ps

module tb_lfsr (
	
);

localparam SEED = 9'h1FE;
localparam ORDER = 9;  

localparam TBFileName = "/home/matias_dogliani/Vivado_projects/Tp5/tb_PRBSeqQ.out";
integer fd;

reg i_clk;
reg i_enable; 
reg i_reset; 
reg [11:0]count;
wire o_prbSeq; 

initial begin
	count=0; 
	i_clk = 1'b1; 
	i_enable = 1'b1; 
	i_reset = 1'b1;
	fd = $fopen(TBFileName,"w");if (fd == 0)$stop;  
    #5 
    i_reset = 1'b0; 
	#400000
	$fclose(fd);
	$finish ; 
end

//clk 
always #5 i_clk = ~i_clk; 

	
always @(negedge i_clk) begin
    count <= count +1'b1;
    if(count == 11'd1000)begin	//Fin del archivo 
			$fclose(fd);
			$stop; 
	end
	else 	
		$fdisplay(fd,"%b",o_prbSeq);

end

lfsr #(.SEED (SEED))
    u_lfsr(
		.i_reset (i_reset), 
		.i_clk (i_clk), 
		.i_enable (i_enable),
		.o_prbSeq (o_prbSeq)
	);





endmodule //tb_lfsr