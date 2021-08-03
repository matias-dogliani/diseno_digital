module tb_mapper (
	
);

    integer fd; 
    integer fdO; 
  	reg PRBit; 
	reg Rc; 
	wire [1:0] o_symb; 

    initial begin
 	    clk = 1'b1;  
 	    count = 0; 
		fd= $fopen("/home/matias_dogliani/Vivado_projects/Tp5/PRBSeqI.in","r");
		fdO = $fopen("/home/matias_dogliani/Vivado_projects/Tp5/tb_mapper.out","w");
		if(fd == 0) $stop;
		if(fdO == 0) $stop;
	 	#1000000 $finish ;
   end 
    
	always #0.5 clk = ~clk;
   
	always @(posedge clk) begin
        count <= count +1'b1;
		Rc <= $fscanf(fd,"%b",PRBit) ;
		if(count == 1000)begin 			//Fin del archivo 
			$fclose(fd);
			$stop; 
		end
	end 


	always @(posedge clk) begin
		$fdisplay(fdO,"%b",o_symb);


	mapper
		u_mapper(
			.i_rbit (PRBit),
			.o_symb (o_symb)
		); 







endmodule //tb_mapper