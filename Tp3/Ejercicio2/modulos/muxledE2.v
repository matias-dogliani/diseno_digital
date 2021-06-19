// Bloque de LEDs con MEMORIA

module leds 
#(
	parameter N_LEDS = 4
)
(
	input  i_mux_sel ,  			//btn[0] 
	input [N_LEDS -1 : 0] i_shift_leds,
	input [N_LEDS -1 : 0] i_flash_leds,  
	input [N_LEDS -1 : 0] i_shift2_leds,  
	output [N_LEDS - 1 : 0] o_leds,
	output o_led_mux );
	
	reg [N_LEDS -1 : 0] r_led; 
	reg [2-1 : 0] estado;
   
    assign o_leds = r_led; 
    assign o_led_mux = i_mux_sel;  
    
    always @(*) begin 	// salida segun estado 
        case (estado)
            2'b00: begin
			  r_led = i_shift_leds;  
			end   
            2'b01: begin
			  r_led = i_flash_leds;  
			end   
            2'b10: begin
			  r_led = i_shift2_leds;  
			end   
		   default:begin
			  r_led =  {N_LEDS{1'b0}};
			   end
	    endcase
    end

  always @(posedge i_mux_sel) begin		
	  if (i_mux_sel) begin
		  	estado = estado + 1'b1; 
		  if (estado == 2'b11) 
		      estado = 2'b00; 
	      end 
      else 
        estado = 1'b11; 
  end 

endmodule //leds