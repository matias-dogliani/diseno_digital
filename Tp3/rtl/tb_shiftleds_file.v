// TB
// ShiftLeds
`define N_LEDS 4
`define NB_SEL 2
`define NB_COUNT 14
`define NB_SW 4

`timescale 1ns/100ps

module tb_shiftleds_file();

   parameter N_LEDS   = `N_LEDS   ;
   parameter NB_SEL   = `NB_SEL   ;
   parameter NB_COUNT = `NB_COUNT ;
   parameter NB_SW    = `NB_SW    ;

   wire [N_LEDS - 1 : 0] o_led    ;
   wire [N_LEDS - 1 : 0] o_led_b  ;
   wire [N_LEDS - 1 : 0] o_led_g  ;
   reg [NB_SW   - 1 : 0] i_sw     ;
   reg                   i_reset  ;
   reg                   clock    ;

   reg [NB_SW   - 1 : 0] switch_tmp;
   reg                   reset_tmp ;

   integer               fid_reset  ;
   integer               fid_switch ;
   integer               code_error ;
   integer               code_error1;
   integer               ptr_switch ;

   initial begin
      //fid_reset  = $fopen("/home/mmacchi/procom/vectors/reset.out","r");
      fid_reset  = $fopen("C:/clasesProcom/Parte04_Verilog/GP2/rtl/vectors/reset.out","r");
	   if(fid_reset==0) $stop;
      //fid_switch = $fopen("/home/mmacchi/procom/vectors/switch.out","r");
      fid_switch  = $fopen("C:/clasesProcom/Parte04_Verilog/GP2/rtl/vectors/switch.out","r");
	   if(fid_switch==0) $stop;
      clock    = 1'b0  ;
   end

   always #2.5 clock = ~clock;

   always@(posedge clock) begin
      code_error <= $fscanf(fid_reset,"%d",reset_tmp);
      if(code_error!=1) $stop;

      for(ptr_switch=0;ptr_switch<NB_SW;ptr_switch = ptr_switch+1) begin
	     code_error1 <= $fscanf(fid_switch,"%d",switch_tmp[(ptr_switch+1)-1 -: 1]);
	     if(code_error1!=1) $stop;
	  end

      i_reset <= reset_tmp;
      i_sw    <= switch_tmp;
      $display("%d",i_reset);
   end

   shiftleds
     #(
       .N_LEDS   (N_LEDS)  ,
       .NB_SEL   (NB_SEL)  ,
       .NB_COUNT (NB_COUNT),
       .NB_SW    (NB_SW)
       )
   u_shiftleds
     (
      .o_led     (o_led)    ,
      .o_led_b   (o_led_b)  ,
      .o_led_g   (o_led_g)  ,
      .i_sw      (i_sw)     ,
      .i_reset   (i_reset)  ,
      .clock     (clock)
      );
   
endmodule // tb_shiftleds
