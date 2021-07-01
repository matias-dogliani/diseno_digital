localparam NB_IN  = 6;
localparam NBF_IN = 5;
localparam NBI_IN = NB_IN-NBF_IN;

localparam NB_FULL_RES  = 2*NB_DATA;
localparam NBF_FULL_RES = 2*NBF_DATA;
localparam NBI_FULL_RES = NB_FULL_RES-NBF_FULL_RES;

localparam NB_OUT  = 6;
localparam NBF_OUT = 5;
localparam NBI_OUT = NB_OUT-NBF_OUT;

wire signed [NB_IN-1 : 0] a;
wire signed [NB_IN-1 : 0] b;
wire signed [NB_FULL_RES-1 : 0] c;

//Constantes, solo a modo de ejemplo
assign a = 6'b011000;
assign b = 6'b011101;

assign c = a * b;

// TRN & OVF
wire signed [NB_OUT-1 : 0] c_trn_ovf;

assign c_trn_ovf = c[NB_FULL_RES-2 -: NB_OUT];

// TRN & SAT
wire signed [NB_OUT-1 : 0] c_trn_sat;

assign c_trn_sat = (&c[NB_FULL_RES-1 -: 2] || ~|c[NB_FULL_RES-1 -: 2]) ?
                   c[NB_FULL_RES-2 -: NB_OUT] :
                   c[NB_FULL_RES-1] ? {1'b1,{NB_OUT-1{1'b0}}} : {1'b0,{NB_OUT-1{1'b1}}};

// RND & SAT
wire signed [(1+NBI_FULL_RES+NBF_OUT+1)-1 : 0] c_rnd;
wire signed [NB_OUT-1 : 0] c_rnd_sat;

assign c_rnd = $signed(c[NB_FULL_RES-1 -: NBI_FULL_RES+NBF_OUT+1]) + $signed(2'b01);

assign c_rnd_sat = (&c_rnd[(1+NBI_FULL_RES+NBF_OUT+1)-1 -: 3] || ~|c_rnd[(1+NBI_FULL_RES+NBF_OUT+1)-1 -: 3]) ?
                   c_rnd[(1+NBI_FULL_RES+NBF_OUT+1)-1 -2 -: NB_OUT] :
                   c_rnd[(1+NBI_FULL_RES+NBF_OUT+1)-1] ? {1'b1,{NB_OUT-1{1'b0}}} : {1'b0,{NB_OUT-1{1'b1}}};
