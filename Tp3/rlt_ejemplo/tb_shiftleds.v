// TB
// ShiftLeds
`define N_LEDS 4
`define NB_SEL 2
`define NB_COUNT 14
`define NB_SW 4

`timescale 1ns/100ps

module tb_shiftleds();

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

   wire [NB_COUNT - 1 : 0] tb_count;

   assign tb_count = tb_shiftleds.u_shiftleds.counter;

   initial begin
      i_sw[0]             = 1'b0       ;
      clock               = 1'b0       ;
      i_reset             = 1'b0       ;
      i_sw[2:1]           = `NB_SEL'h0 ;
      i_sw[3]             = 1'b0       ;
      #100 i_reset        = 1'b1       ;
      #100 i_sw[0]        = 1'b1       ;
      #1000000 i_sw[2:1]  = `NB_SEL'h1 ;
      #1000000 i_sw[2:1]  = `NB_SEL'h2 ;
      #1000000 i_sw[3]    = 1'b1       ;
      #1000000 i_sw[2:1]  = `NB_SEL'h3 ;
      #1000000 $finish                 ;
   end

   always #5 clock = ~clock;

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
