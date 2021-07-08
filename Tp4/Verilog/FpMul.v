module FpMul
#(

// Formato de A 
	parameter NB_IN_A =8, 							//Bit totales 
	parameter NBF_IN_A =6,							//Bits fraccionales 	
		
	// Formato de B 	
	parameter NB_IN_B =12,			
	parameter NBF_IN_B =11,
	
	// Salida	
	parameter NB_OUT = 12, 
	parameter NBF_OUT = 11,
		
	// Formato salida FR 
    parameter NB_O_FR =NB_IN_A + NB_IN_B,
    parameter NBF_O_FR = NBF_IN_A + NBF_IN_B,
 	parameter NBI_O_FR = NB_O_FR - NBF_O_FR, 
    
    parameter NB_O_ROUND = 10, 
    parameter NF_O_ROUND =9  

)(

// Entradas 
    input  [NB_IN_A - 1:0] i_A,
    input  [NB_IN_B - 1:0] i_B,
//Salidas 
	output [NB_O_FR - 1 : 0] o_mulFR,
	output [NB_OUT -1 : 0]	o_mulS_trunc_ov,
	output [NB_OUT -1 : 0]	o_mulS_trunc_sat ,
	output [NB_O_ROUND -1 : 0]	o_mulS_round_sat

);

 	localparam NBI_IN_A =NB_IN_A - NBF_IN_A;		//Bit enteros  
    localparam NBI_IN_B =NB_IN_B - NBF_IN_B;
    localparam NBI_OUT = (NB_OUT > NBF_OUT)? NB_OUT-NBF_OUT : 0;  //Test . Sino NB_OUT - NBF_OUT solo
    localparam NBI_O_ROUND = NB_O_ROUND - NF_O_ROUND;
    localparam NB_ROUND = (1 + NBI_O_FR + NBF_OUT + 1) ;  //Redondeo  

    wire signed [NB_IN_A -1     : 0] a 	;   //Entrada signada 
    wire signed [NB_IN_B -1     : 0] b 	;   // Entrada b signada
	wire signed [NB_O_FR-1  	: 0] mulFR;   //mula full res
	reg  signed [NB_OUT - 1 : 0]  mulS_trunc_sat;
    reg  signed [NB_ROUND - 1 : 0]  mul_r;
    reg  signed [NB_O_ROUND - 1 : 0]  mulS_round_sat;

	assign a = i_A;
	assign b = i_B;

	assign mulFR = $signed(a)*$signed(b);              //Parece ser necesario ese signed, por más que haya puesto el wire signed

/*Truncado y Saturacion */		
  	always @(*) begin
        if ( &mulFR[(NB_O_FR -1)-:(NBI_O_FR-NBI_OUT)+1] || ~|mulFR[(NB_O_FR -1)-: (NBI_O_FR-NBI_OUT)+1])
            mulS_trunc_sat = mulFR[ (NB_O_FR -1) - (NBI_O_FR - NBI_OUT) -: NB_OUT ];

        else if ( mulFR[(NB_O_FR -1)] )
            mulS_trunc_sat = { 1'b1 , { NB_OUT-1 {1'b0} }};				//Maximo negativa

        else
            mulS_trunc_sat = { 1'b0 , { NB_OUT-1 {1'b1} }};				// Maximo positivo
    end


	/*Saturacion y redondeo */
    always @(*) begin
        mul_r= $signed(mulFR[(NB_O_FR -1) -: (NB_ROUND -1)]) + $signed(2'b01); //Sumo + 1 LSB
	   	//Saturo de la misma forma que la anterior 
        
		if ( &mul_r[(NB_ROUND -1)-:(NBI_O_FR-NBI_O_ROUND)+1] || ~|mul_r[(NB_ROUND -1)-:(NBI_O_FR-NBI_O_ROUND) +1])
          mulS_round_sat = mul_r[(NB_ROUND -1) - (NBI_O_FR-NBI_O_ROUND) -1 -: NB_O_ROUND];

//         else if ( mul_r[(NB_ROUND -1)] )
//              mulS_round_sat = $signed({ 1'b1 , { NB_O_ROUND-1 {1'b0} }});
        
        else
            mulS_round_sat = $signed({ 1'b0 , { NB_O_ROUND-1 {1'b1} }});
    end


	/* Salida Full Resolution */
	assign o_mulFR = mulFR; 

	/* Salida  Truncado y Overflow */	
	assign o_mulS_trunc_ov = mulFR[NB_O_FR-1 - (NBI_O_FR- NBI_OUT) -:NB_OUT];	

	/* Salida  truncado y Saturacion */
	assign o_mulS_trunc_sat = mulS_trunc_sat; 

	/*Salida de redondeo y saturacion*/
	assign o_mulS_round_sat = mulS_round_sat ;	



endmodule //FpMul