`timescale 1 ns / 10 ps              // set simulated unit / precision

module main_tb();
    wire clkDiv;
    reg clk = 0;
    reg rst = 0;
    localparam SIM_DURATION = 10000;    // in unit of timescale

    //simulation keeps on running the following
    always begin
        #41.667                     //delay by, 1/(2*41.67*1ns) ~ 12MHz of IceStick, round to precision
        clk = ~clk;
    end

    //unit under test (uut), 6/12MHz ~ 0.5us
    clock_divider #(.CLK_ITER_WIDTH(4), .CLK_ITER_MAX(6 - 1)) uut(
        .clk(clk),
        .rst(rst),
        .out_clk_div(clkDiv)
    );

    // pulse reset high at beginning
    initial begin
        #10             //delay by 10*1ns = 10ns 
        rst = 1'b1;
        #1              //delay by 1*1ns = 1ns 
        rst = 1'b0;
    end

    // output file
    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(2, main_tb);     //0 verbosity means max verbosity
        #(SIM_DURATION)
        $display("End of Sim.");
        $finish;
    end
endmodule


