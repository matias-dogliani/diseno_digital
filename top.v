
/*La particion de un diseno digital en modulos es importante */

module top (
    
     input clock, 
     input i_reset, 
     input [3:0] i_sw,
     output [3:0] o_led,
     output [3:0] o_led_b,
     output [3:0] o_led_g
 
 );


 /*Instancio los modulos ya creados */
    wire enable; 
    wire [3:0] output_shift; 
  
    count 
        u_count (
            
            .clock(clock),
            .i_reset(i_reset), 
            .i_enable(i_sw[0]), 
            .i_sel(i_sw[2:1]), 
            .o_enable(enable) 
        );

    
    shiftreg 
        u_shiftreg(
            
            .clock(clock), 
            .i_reset(i_reset), 
            .i_enable(enable),
            .o_shift(output_shift)      
        
        );

assing o_led = 

 endmodule  



