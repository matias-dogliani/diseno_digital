module tb_FIRFilter (
	
);
    integer fd; 
    integer fdO; 
    
	reg [1:0] symb; 
	reg Fsymb; 
	reg clk; 
	reg [11:0] count; 
	reg [2-1:0]divisor; 
	reg enable; 
	reg reset; 
	
	wire [7:0]txSymb; 
	
    initial begin
        divisor = 2'b00; 
       reset = 1'b1; 
        enable = 1'b0; 
 	    clk = 1'b1;  
 	    count = 0; 
 	    #3 
		reset = 1'b0;
		fd= $fopen("/home/matias_dogliani/Vivado_projects/Tp5/aKI.in","r");
		fdO = $fopen("/home/matias_dogliani/Vivado_projects/Tp5/tb_filterI.out","w");
		if(fd == 0 || fdO == 0) $stop;
		//Fsymb = $fscanf(fd,"%b",symb) ;
		#1000000 $finish ;
   end 
    
	always #5 clk = ~clk;
    
	always @(posedge clk) begin  //Aca tengo que guardar el log 
        count <= count +1'b1;
        divisor <= divisor + 1'b1; 
        enable <= 1'b0; 
        if (divisor ==2'b11)begin 
            enable <= 1'b1; 
            end 
         end 
         
     always@(posedge clk)
          $fdisplay(fdO,"%b",txSymb);
          
     always@(*)begin
         if(enable)begin
		      Fsymb <= $fscanf(fd,"%b",symb) ;
		  end 
		  if(count == 4001)begin 			//Fin del archivo 
		      	$fclose(fd);
		      	$fclose(fdO);
			     $stop; 
		      end
		end 

FIRfilter 
    u_filter( 
       .i_ak (symb), 
       .i_clk (clk), 
       .i_enable (enable), 
       .i_reset (reset),
        .o_txsymb(txSymb)  
    );
 

endmodule //tb_FIRFilter