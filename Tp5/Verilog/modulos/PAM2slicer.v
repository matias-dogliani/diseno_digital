module PAM2slicer 
#(
	parameter NB_W = 8,   /*Resolución de symb*/
	parameter WL = 2	 /*Longitud de lo simbolos */
)
(

input signed [NB_W - 1 : 0 ] i_ak, 
output signed [WL -1 : 0]o_akhat	
);



assign o_akhat = (i_ak >=0 )? {2'b01} : { 2'b11};	 /*NO parametrizable pero simple */


endmodule //PAM2slicer