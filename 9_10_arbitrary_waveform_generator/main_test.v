module main_test(
    input  ref_clk,             //12MHz clock
    output wire [7:0] pmod,
    output reg led
);
    (* PULLMODE="NONE" *)       // Attempt to disable pull-up/pull-down  
    (* IO_TYPE="LVCMOS33" *)    // Attempt to set pmod low at 0V and high at 3.3V

    localparam PI = 3.1415926;

    reg  rst = 1'b0;            //no rst, running out of outputs
    wire clk_tick_led;
    wire clk_tick_res;
    wire clk_tick_func;
    localparam PERIOD_RES  = 1;            
    localparam PERIOD_FUNC = 120; 
    localparam FUNC_ITER_MAX = PERIOD_FUNC/PERIOD_RES;
    localparam FUNC_WIDTH    = $clog2(FUNC_ITER_MAX) + 2;
    
    //parameter [FUNC_WIDTH-1:0] func_iter = 0;
    reg [FUNC_WIDTH-1:0] func_iter = 0;
    //wire [FUNC_WIDTH-1:0] func_iter = 0;
    //reg [7:0] func_iter = 0;

//////////////////////////// Put the AWG formula here:
    //assign pmod = 8'b10000000;
    //assign pmod = 8'b10101010;
    //assign pmod = func_iter;
    //assign pmod = 128*(func_iter/FUNC_ITER_MAX));
    //assign pmod = 8'd128 + $rtoi(80*($sin(func_iter*2*PI/FUNC_ITER_MAX)));
    assign pmod = (func_iter < FUNC_ITER_MAX/2) ? 8'b10000000 : 8'd00000000;
    //assign pmod = (0 < func_iter) ? (8'b10000000*(func_iter/FUNC_ITER_MAX)) : 8'd00000000;
//////////////////////////////////////////////////////









    //clock handling
    _clock_divider #(.CLK_ITER_MAX(PERIOD_RES - 1)) clk_div_obj_res(
        .ref_clk(ref_clk),
        .rst(rst),
        .out_clk_tick(clk_tick_res)
    );
    _clock_divider #(.CLK_ITER_MAX(PERIOD_FUNC - 1)) clk_div_obj_func(
        .ref_clk(ref_clk),
        .rst(rst),
        .out_clk_tick(clk_tick_func)
    );
    //output handling
    always @ (posedge clk_tick_res) begin
        if (func_iter == FUNC_ITER_MAX - 1) begin
            func_iter <= 0;
        end else begin
            func_iter <= func_iter + 1;
        end
    end

endmodule


