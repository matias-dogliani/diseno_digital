module sumFp(
#(
	// Formato de A 
	parameter NB_IN_A =16 							//Bit totales 
	parameter NBF_IN_A =14							//Bits fraccionales 	
	parameter NBI_IN_A =NB_IN_A - NBF_IN_A,  		//Bit enteros  
	
	// Formato de B 	
	parameter NB_IN_B =12,			
	parameter NBF_IN_B =11,
	parameter NBI_IN_B =NB_IN_B - NBF_IN_B,

	// Salida	
	parameter NB_OUT = 11, 
	parameter NBF_OUT = 10,
	parameter NBI_OUT = (NB_OUT > NBF_OUT)? NB_OUT-NBF_OUT : 0;  //Test . Sino NB_OUT - NBF_OUT solo
	

)
	// Entradas 
    input  [NB_IN_A - 1:0] i_A,
    input  [NB_IN_B - 1:0] i_B,


	//Salidas 

	output [NB_OUT -1 : 0]	o_sumS_11_10_ov_t, 
);

	// Formato salida FR 
    localparam NBI_O_FR = ( NBI_IN_A  > NBI_IN_B  )? NBI_IN_A + 1 : NBI_IN_B + 1 ;    //+1 para Carry 
    localparam NBF_O_FR = ( NBF_IN_A > NBF_IN_B )? NBF_IN_A    : NBF_IN_B    ;
    localparam NB_O_FR = NBI_O_FR + NBF_O_FR ;


    wire signed [NB_IN_A -1     : 0] a 	;   //Entrada signada 
    wire signed [NB_IN_B -1     : 0] b 	;   // Entrada b signada
	wire signed [NB_O_FR-1  	: 0] sum;   //suma full res

	assign a = i_A;
	assign b = i_B;

	/*Suma Full Resolution*/
	assign [NB_O_FR-1  	: 0] sum = a + b; 
	
	/*S(11.10) con overflow y truncado */	
	assign o_sumS_11_10_ov_t = sum[NB_FULL_RES -1 - (NBI_O_FR- NBI_OUT) -:NB_OUT]	


endmodule //sum
