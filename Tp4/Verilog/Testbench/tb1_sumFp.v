`timescale 1ns/100ps
module tb_sumFp();

 	reg signed [16-1 : 0] A ; 
	reg signed [12_1: 0]B ;
	wire [17-1:0] full_res; 
	wire [11-1:0] trunc_ovf; 
	wire [11-1:0] sat_ovf; 
	wire [11-1:0] sat_round; 
   
   
   initial begin
     clock = 1'b0;  
	 A = 28672;
	 B = 512 ;
	  #1000 $finish                 ;
   end

   always #5 clock = ~clock;

 u_ledmuxE2
	u_ledmuxE2(
		.i_mux_sel(mux_sel),
		.i_shift_leds(shift_leds),
		.i_shift2_leds(shift2_leds),
		.i_flash_leds(flash_leds), 
		.o_leds(o_mux),
		.o_led_mux(o_led)
	);

sumFp 
	u_sumFp(
		.i_A(A),
		.i_B(B),
		.o_sumS_trunc_ov(),
		.o_sumS_trunc_sat(),
		.o_sumS_round_sat()

	)

endmodule