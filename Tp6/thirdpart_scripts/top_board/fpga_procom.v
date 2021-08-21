module fpga_procom 
#(
  parameter NB_LEDS               = 4,
  parameter NB_SWITCHES           = 4,
  parameter NB_RGB                = 3,
  parameter NB_GPIOS              = 32,
  parameter USE_VIO               = 1
)
(
  output [NB_RGB - 1 : 0]                     o_leds_rgb0,
  output [NB_RGB - 1 : 0]                     o_leds_rgb1,
  output [NB_RGB - 1 : 0]                     o_leds_rgb2,
  output [NB_RGB - 1 : 0]                     o_leds_rgb3,
  output [NB_LEDS - 1 : 0]                    o_leds,

  output                                      o_tx_uart,
  input                                       i_rx_uart,

  input                                       i_reset,
  input [NB_SWITCHES - 1 : 0]                 i_sw,
  input                                       i_clk100
);

  ///////////////////////////////////////////
  // Vars
  ///////////////////////////////////////////
  wire [NB_GPIOS - 1 : 0]                     gpo0;
  wire [NB_GPIOS - 1 : 0]                     gpi0;

  wire                                        locked;
  wire                                        clockdsp;

  ///////////////////////////////////////////
  // MicroBlaze
  ///////////////////////////////////////////
  MicroGPIO
    u_micro
    (
      .clock100         ( clockdsp  ),  // Clock de aplicacion
      .gpio_rtl_tri_o   ( gpo0      ),  // GPIO output
      .gpio_rtl_tri_i   ( gpi0      ),  // GPIO input
      .reset            ( i_reset   ),  // Hard Reset
      .sys_clock        ( i_clk100  ),  // Clock de FPGA
      .o_lock_clock     ( locked    ),  // Salida Lock Clock
      .usb_uart_rxd     ( i_rx_uart ),  // UART RX
      .usb_uart_txd     ( o_tx_uart )   // UART TX
    );

  ///////////////////////////////////////////
  // Leds
  ///////////////////////////////////////////
  assign o_leds[0] = locked;
  assign o_leds[1] = ~i_reset;
  assign o_leds[2] = gpo0[12];
  assign o_leds[3] = gpo0[13];

  assign o_leds_rgb0[0] = gpo0[0];
  assign o_leds_rgb0[1] = gpo0[1];
  assign o_leds_rgb0[2] = gpo0[2];

  assign o_leds_rgb1[0] = gpo0[3];
  assign o_leds_rgb1[1] = gpo0[4];
  assign o_leds_rgb1[2] = gpo0[5];

  assign o_leds_rgb2[0] = gpo0[6];
  assign o_leds_rgb2[1] = gpo0[7];
  assign o_leds_rgb2[2] = gpo0[8];

  assign o_leds_rgb3[0] = gpo0[9];
  assign o_leds_rgb3[1] = gpo0[10];
  assign o_leds_rgb3[2] = gpo0[11];

  ///////////////////////////////////////////
  // VIO
  ///////////////////////////////////////////
  generate
    if(USE_VIO)
    begin
      wire                      fromHard;
      wire [NB_SWITCHES-1 : 0]  fromVio;
      assign gpi0[NB_SWITCHES-1 : 0] = fromHard ? i_sw : fromVio;

      vio
        u_vio
        (
          .clk_0        ( clockdsp                    ),
          .probe_in0_0  ( {gpo0[2] ,gpo0[1] ,gpo0[0]} ),
          .probe_in1_0  ( {gpo0[5] ,gpo0[4] ,gpo0[3]} ),
          .probe_in2_0  ( {gpo0[8] ,gpo0[7] ,gpo0[6]} ),
          .probe_in3_0  ( {gpo0[11],gpo0[10],gpo0[9]} ),
          .probe_out0_0 ( fromHard                    ),
          .probe_out1_0 ( fromVio                     )
        );
    end
    else
    begin
      assign gpi0[NB_SWITCHES-1 : 0] = i_sw;
    end
  endgenerate

  assign gpi0[NB_GPIOS-1 : NB_SWITCHES] = {NB_GPIOS-NB_SWITCHES{1'b0}};

endmodule
