module sumFp
#(
	// Formato de A 
	parameter NB_IN_A =16, 							//Bit totales 
	parameter NBF_IN_A =14,							//Bits fraccionales 	
	parameter NBI_IN_A =NB_IN_A - NBF_IN_A,  		//Bit enteros  
	
	// Formato de B 	
	parameter NB_IN_B =12,			
	parameter NBF_IN_B =11,
	parameter NBI_IN_B =NB_IN_B - NBF_IN_B,

	// Salida	
	parameter NB_OUT = 11, 
	parameter NBF_OUT = 10,
	parameter NBI_OUT = (NB_OUT > NBF_OUT)? NB_OUT-NBF_OUT : 0,  //Test . Sino NB_OUT - NBF_OUT solo
	
	// Formato salida FR 
	parameter NBI_O_FR = ( NBI_IN_A  > NBI_IN_B  )? NBI_IN_A + 1 : NBI_IN_B + 1 ,    //+1 para Carry 
    parameter NBF_O_FR = ( NBF_IN_A > NBF_IN_B )? NBF_IN_A    : NBF_IN_B    ,
    parameter NB_O_FR = NBI_O_FR + NBF_O_FR 
)
(
	// Entradas 
    input  [NB_IN_A - 1:0] i_A,
    input  [NB_IN_B - 1:0] i_B,
	
	//Salidas 
	output [NB_O_FR - 1 : 0] o_sumFR,
	output [NB_OUT -1 : 0]	o_sumS_ov_t
);

	


    wire signed [NB_IN_A -1     : 0] a 	;   //Entrada signada 
    wire signed [NB_IN_B -1     : 0] b 	;   // Entrada b signada
	wire signed [NB_O_FR-1  	: 0] sumFR;   //suma full res
	reg  signed [NB_OUT - 1 : 0]  sumS_trunc_sat;
	
	
	assign a = i_A;
	assign b = i_B;

	/*Suma Full Resolution*/
	//Acomo el punto porque son de diferente formato 
	assign sumFR = (NBF_IN_A >= NBF_IN_B)?                           
                a + $signed( {b, { NBF_IN_A - NBF_IN_B {1'b0}}}):
                b + $signed( {a, { NBF_IN_B - NBF_IN_A {1'b0}}});
    

	/* Salifa Full Resolution */
	assign o_sumFR = sumFR; 
	
	/* Overflow y Truncado */	
	assign o_sumS_ov_t = sumFR[NB_O_FR-1 - (NBI_O_FR- NBI_OUT) -:NB_OUT];	

	/*Truncado y Saturacion */
  	always @(*) begin
        if ( &sumS_trunc_sat[(NB_FR -1)-:(NBI_FR-NBI_OUT)+1] || ~|sumS_trunc_sat[(NB_FR -1)-: (NBI_FR-NBI_OUT)+1])
            sumS_trunc_sat_trn_sat = sumS_trunc_sat[ (NB_FR -1) - (NBI_FR - NBI_OUT) -: NB_OUT ];

        else if ( sumS_trunc_sat[(NB_FR -1)] )
            sumS_trunc_sat_trn_sat = { 1'b1 , { NB_OUT-1 {1'b0} }};

        else
            sumS_trunc_sat_trn_sat = { 1'b0 , { NB_OUT-1 {1'b1} }};
    end

	



endmodule //sum