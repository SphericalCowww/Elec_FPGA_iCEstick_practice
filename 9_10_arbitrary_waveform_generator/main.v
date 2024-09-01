module main(
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
    localparam PERIOD_LED  = 120000000;     //1Hz
    localparam PERIOD_RES  = 2;             //60MHz, to capture the clock cycle more reliably
    localparam PERIOD_FUNC = 12;            //10MHz
    localparam FUNC_ITER_MAX = PERIOD_FUNC/PERIOD_RES;
    localparam FUNC_WIDTH    = $clog2(FUNC_ITER_MAX) + 2;
    
    //parameter [FUNC_WIDTH-1:0] func_iter = 0;
    //reg [FUNC_WIDTH-1:0] func_iter = 0;
    //wire [FUNC_WIDTH-1:0] func_iter = 0;

    reg [7:0] func_iter = 0;

//////////////////////////// Put the AWG formula here:
    //assign pmod = 8'b01010101;
    assign pmod = func_iter;
    //assign pmod = (8'd256 - 8'd1)*(func_iter/FUNC_ITER_MAX);
    //assign pmod = 8'd128 + $rtoi(80*($sin(func_iter*2*PI/FUNC_ITER_MAX)));

//////////////////////////////////////////////////////









    //clock handling
    _clock_divider #(.CLK_ITER_MAX(PERIOD_LED - 1)) clk_div_obj_led(
        .ref_clk(ref_clk),
        .rst(rst),
        .out_clk_tick(clk_tick_led)
    );
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
    //led handling
    always @ (posedge rst or posedge clk_tick_led) begin
        if (rst == 1'b1) begin
            led <= 1'b0;
        end else if (clk_tick_led == 1'b1) begin
            led <= ~led;
        end
    end
    //output handling
    always @ (posedge clk_tick_res) begin
        if (func_iter == FUNC_ITER_MAX - 1) begin
            func_iter <= 0;
        end else begin
            func_iter <= func_iter + 1;
        end
    end
endmodule


