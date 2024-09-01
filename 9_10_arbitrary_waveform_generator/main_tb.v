`timescale 1 ns / 10 ps              // set simulated unit / precision

module main_tb();
    reg  ref_clk = 0;
    reg [7:0] pmod;
    reg  led;

    localparam PI = 3.1415926;

    reg rst = 1'b0;            //no rst, running out of outputs
    reg clk_tick_led = 0;
    reg clk_tick_res = 0;
    reg clk_tick_func = 0;
    localparam PERIOD_LED  = 60;     //1MHz
    localparam PERIOD_RES  = 4;      //6MHz, to capture the clock cycle more reliably
    localparam PERIOD_FUNC = 60;     //1MHz
    localparam FUNC_ITER_MAX = PERIOD_FUNC/PERIOD_RES;
    localparam FUNC_WIDTH    = $clog2(FUNC_ITER_MAX) + 1;
    reg [FUNC_WIDTH-1:0] func_iter = 0;





//////////////////////////// Put the AWG formula here:
    //assign pmod = (8'd256 - 8'd1)*(func_iter/FUNC_ITER_MAX);
    //assign pmod = 8'd128 + $rtoi(80*($sin(func_iter*2*PI/FUNC_ITER_MAX)));

//////////////////////////////////////////////////////







    ///////////////////////////////////////////////////////////////////////////////////////////////////
    localparam SIM_DURATION = 10000;    // in unit of timescale
    initial begin
        led = 0;
        $display("FUNC_ITER_MAX  = ", FUNC_ITER_MAX);
        $display("FUNC_WIDTH     = ", FUNC_WIDTH);
        $display("func_iter_init = ", func_iter);
    end
    // simulation keeps on running the following
    always begin
        #41.667                     //delay by, 1/(2*41.67*1ns) ~ 12MHz of IceStick, round to precision
        ref_clk = ~ref_clk;
    end
    always begin
        #(41.667*PERIOD_LED)
        clk_tick_led = ~clk_tick_led;
        #41.667
        clk_tick_led = ~clk_tick_led;
    end
    always begin
        #(41.667*PERIOD_RES)
        clk_tick_res = ~clk_tick_res;
        #41.667
        clk_tick_res = ~clk_tick_res;
    end
    always begin
        #(41.667*PERIOD_FUNC)
        clk_tick_func = ~clk_tick_func;
        #41.667
        clk_tick_func = ~clk_tick_func;
    end
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //clock handling; sim cannot do phase-locked loop
    /*
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
    */
    //led handling
    always @ (posedge rst or posedge clk_tick_led) begin
        if (rst == 1'b1) begin
            led <= 1'b0;
        end else if (clk_tick_led == 1'b1) begin
            led <= ~led;
        end
    end
    //output handling
    always @ (posedge rst) begin
        func_iter <= 0;
    end
    always @ (posedge clk_tick_func) begin
        func_iter <= 0;
    end
    always @ (posedge clk_tick_res) begin
        func_iter <= func_iter + 1;
        pmod <= 8'd128 + $rtoi(128*($sin(func_iter*2*PI/FUNC_ITER_MAX)));
        $display(pmod);
    end
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // output file
    initial begin
        $display("func_iter_fin  = ", func_iter);
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);     //0 verbosity means max verbosity
        #(SIM_DURATION)
        $display("End of Sim.");
        $finish;
    end
endmodule


