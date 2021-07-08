module sumFp
#(
	// Formato de A 
	parameter NB_IN_A =16, 							//Bit totales 
	parameter NBF_IN_A =14,							//Bits fraccionales 	
		
	// Formato de B 	
	parameter NB_IN_B =12,			
	parameter NBF_IN_B =11,
	
	// Salida	
	parameter NB_OUT = 11, 
	parameter NBF_OUT = 10,
		
	// Formato salida FR 
	parameter NBI_O_FR = ( NBI_IN_A  > NBI_IN_B  )? NBI_IN_A + 1 : NBI_IN_B + 1 ,    //+1 para Carry 
    parameter NBF_O_FR = ( NBF_IN_A > NBF_IN_B )? NBF_IN_A    : NBF_IN_B,
    parameter NB_O_FR = NBI_O_FR + NBF_O_FR,
    
    parameter NB_O_ROUND = 9, 
    parameter NF_O_ROUND =8  
)
(
	// Entradas 
    input  [NB_IN_A - 1:0] i_A,
    input  [NB_IN_B - 1:0] i_B,
	
	//Salidas 
	output [NB_O_FR - 1 : 0] o_sumFR,
	output [NB_OUT -1 : 0]	o_sumS_trunc_ov,
	output [NB_OUT -1 : 0]	o_sumS_trunc_sat ,
	output [NB_O_ROUND -1 : 0]	o_sumS_round_sat
);

    localparam NBI_IN_A =NB_IN_A - NBF_IN_A;		//Bit enteros  
    localparam NBI_IN_B =NB_IN_B - NBF_IN_B;
    localparam NBI_OUT = (NB_OUT > NBF_OUT)? NB_OUT-NBF_OUT : 0;  //Test . Sino NB_OUT - NBF_OUT solo
    localparam NBI_O_ROUND = NB_O_ROUND - NF_O_ROUND;
    localparam NB_ROUND = (1 + NBI_O_FR + NBF_OUT + 1) ;  //Redondeo  

    wire signed [NB_IN_A -1     : 0] a 	;   //Entrada signada 
    wire signed [NB_IN_B -1     : 0] b 	;   // Entrada b signada
	wire signed [NB_O_FR-1  	: 0] sumFR;   //suma full res
	reg  signed [NB_OUT - 1 : 0]  sumS_trunc_sat;
    reg  signed [NB_ROUND - 1 : 0]  sum_r;
    reg  signed [NB_O_ROUND - 1 : 0]  sumS_round_sat;  


	assign a = i_A;
	assign b = i_B;

	/*Suma Full Resolution*/
	//Acomo el punto porque son de diferente formato 
	assign sumFR = (NBF_IN_A >= NBF_IN_B)?                           
                a + $signed( {b, { NBF_IN_A - NBF_IN_B {1'b0}}}):
                b + $signed( {a, { NBF_IN_B - NBF_IN_A {1'b0}}});
    


	/*Truncado y Saturacion */		
  	always @(*) begin
        if ( &sumFR[(NB_O_FR -1)-:(NBI_O_FR-NBI_OUT)+1] || ~|sumFR[(NB_O_FR -1)-: (NBI_O_FR-NBI_OUT)+1])
            sumS_trunc_sat = sumFR[ (NB_O_FR -1) - (NBI_O_FR - NBI_OUT) -: NB_OUT ];

        else if ( sumFR[(NB_O_FR -1)] )
            sumS_trunc_sat = { 1'b1 , { NB_OUT-1 {1'b0} }};				//Maximo negativa

        else
            sumS_trunc_sat = { 1'b0 , { NB_OUT-1 {1'b1} }};				// Maximo positivo
    end


	/*Saturacion y redondeo */
    always @(*) begin
        sum_r= $signed(sumFR[(NB_O_FR -1) -: (NB_ROUND -1)]) + $signed(2'b01); //Sumo + 1 LSB
	   	//Saturo de la misma forma que la anterior 
        
		if ( &sum_r[(NB_ROUND -1)-:(NBI_O_FR-NBI_O_ROUND)+2] || ~|sum_r[(NB_ROUND -1)-:(NBI_O_FR-NBI_O_ROUND) +2])
          sumS_round_sat = sum_r[(NB_ROUND -1) - (NBI_O_FR-NBI_O_ROUND) -1 -: NB_O_ROUND];

//         else if ( sum_r[(NB_ROUND -1)] )
//              sumS_round_sat = $signed({ 1'b1 , { NB_O_ROUND-1 {1'b0} }});
        
        else
            sumS_round_sat = $signed({ 1'b0 , { NB_O_ROUND-1 {1'b1} }});
    end


	/* Salida Full Resolution */
	assign o_sumFR = sumFR; 

	/* Salida  Truncado y Overflow */	
	assign o_sumS_trunc_ov = sumFR[NB_O_FR-1 - (NBI_O_FR- NBI_OUT) -:NB_OUT];	

	/* Salida  truncado y Saturacion */
	assign o_sumS_trunc_sat = sumS_trunc_sat; 

	/*Salida de redondeo y saturacion*/
	assign o_sumS_round_sat = sumS_round_sat ;


endmodule //sum