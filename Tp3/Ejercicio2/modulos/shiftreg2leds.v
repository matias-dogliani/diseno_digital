module shiftreg2led

    #(
      parameter N_LEDS    = 4
      ) 
     (
        input clock,
        input i_reset,
        input i_enable,
        input i_dir,
        output [N_LEDS-1:0] o_shift2);
    
    reg [2:0] estado;
    reg [N_LEDS-1:0] r_shift2);


    assign o_shift2 = r_shift2; 


    always @(*) begin 	// salida segun estado 
        case (estado)
            2'b00:   r_shift2 = 4'b0110;
            2'b01:   r_shift2 = 4'b1001;
            2'b10:   r_shift2 = 4'b0000;
            default: r_shift2 = 4'b0000;
        endcase
    end
   
   
    always @(posedge clock or negedge i_reset) begin
        if (!i_reset) begin
            estado <= 2'b00;                                   
        end
        else if (i_enable) begin
             if (i_dir == 1'b1) begin
                estado <= estado + 1'b1; 	//va incrementado para cumplir la secuencia
            end
            else begin
               estado <= estado - 1'b1;
            end
        end
    end
endmodule