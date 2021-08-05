module prbs_checker
#(
    parameter N_PRBS = 9
 )
(
    input i_clock,
    input i_reset,
    input i_enable,
    input i_resync,
    input i_ref_bit, //desde PRBS_GEN
    input i_bit,     //salida del DSP
    output o_led
);

    localparam NB_SR_CHECK = (2**N_PRBS)-1;

    wire [NB_SR_CHECK-1:0] PRBS_checker_mux_in;
    reg [NB_SR_CHECK-2:0] PRBS_checker_reg;

    reg [N_PRBS-1:0] PRBS_errors;

    reg [N_PRBS-1:0] PRBS_checker_pos;
    reg [N_PRBS-1:0] PRBS_checker_cnt;
    reg [N_PRBS-1:0] PRBS_error_min;
    reg [N_PRBS-1:0] PRBS_index_min;

    reg PRBS_checker_locked;

    reg [64-1:0] errors_count;
    reg [64-1:0] bits_count;

    assign PRBS_checker_mux_in = {PRBS_checker_reg,i_ref_bit};

    always@(posedge i_clock)
    begin
        if (i_enable)
        begin
            PRBS_checker_reg <= {PRBS_checker_reg[NB_SR_CHECK-3:0],i_ref_bit};
        end
    end

    always@(posedge i_clock or negedge i_reset)
    begin
        if(!i_reset || i_resync)
        begin
            PRBS_checker_cnt <= {N_PRBS{1'b0}};
            PRBS_errors <= {N_PRBS{1'b0}};
            PRBS_checker_pos <= {N_PRBS{1'b0}};
            PRBS_error_min <= {N_PRBS{1'b1}};
            PRBS_index_min <= {N_PRBS{1'b0}};
            PRBS_checker_locked <= 1'b0;
            errors_count <= {64{1'b0}};
            bits_count <= {64{1'b0}};
        end
        else if (i_enable)
        begin
            if(PRBS_checker_locked==1'b0)
            begin
                if(PRBS_checker_cnt == NB_SR_CHECK-1)
                begin
                    PRBS_checker_cnt <= {N_PRBS{1'b0}};
                    PRBS_errors <= {N_PRBS{1'b0}};
                    if (PRBS_errors < PRBS_error_min)
                    begin
                        PRBS_error_min <= PRBS_errors;
                        PRBS_index_min <= PRBS_checker_pos;
                    end
                    if(PRBS_checker_pos== NB_SR_CHECK-1)
                    begin
                        PRBS_checker_locked <= 1'b1;
                    end
                    else 
                    begin
                        PRBS_checker_pos <= PRBS_checker_pos + 1'b1;
                    end
                end
                else begin
                    PRBS_checker_cnt <= PRBS_checker_cnt + 1'b1;
                    PRBS_errors <= PRBS_errors + (i_bit ^ PRBS_checker_mux_in[PRBS_checker_pos]);
                end
            end
            else begin
                errors_count <= errors_count + (i_bit ^ PRBS_checker_mux_in[PRBS_index_min]);
                bits_count <= bits_count + 1'b1;
            end            
        end
    end

    assign o_led = PRBS_checker_locked & errors_count==64'b0;

endmodule