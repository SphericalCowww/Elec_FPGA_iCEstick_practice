`timescale 1 ns / 10 ps              // set simulated unit / precision

module main_tb();
    wire [3:0]  led;
    wire        done_sig;
    reg clk = 0;
    reg rst = 0;
    reg go  = 0;
    localparam SIM_DURATION = 250000;    // in unit of timescale
    integer debounceIter = 0;

    // simulation keeps on running the following
    always begin
        #41.667                     //delay by, 1/(2*41.67*1ns) ~ 12MHz of IceStick, round to precision
        clk = ~clk;
    end

    // unit under test (uut), wait for 3/12MHz ~ 0.25us to avoid debouncing
    state_machine_Moore #(.CLK_ITER_WIDTH(2), .CLK_ITER_MAX(3 - 1)) uut(
        .clk(clk),
        .rstInput(rst),
        .goInput(go),
        .led(led),
        .doneSig(done_sig)
    );

    // pulse reset high at beginning
    initial begin
        #10             //delay by 10*1ns = 10ns 
        rst = 1'b1;
        #1              //delay by 1*1ns = 1ns 
        rst = 1'b0;
    end

    // pressing go periodically
    always begin
        #10000           //delay by 10000*1ns = 10.0us 
        go = 1'b1;
        #1000            //lasting 1000*1ns = 1.0us 
        go = 1'b1;
        for (debounceIter = 0; debounceIter < 32; debounceIter = debounceIter + 1) begin
            #1
            go = $urandom%2;
        end 
        #1
        go = 1'b0;
    end

    // output file
    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);     //0 verbosity means max verbosity
        #(SIM_DURATION)
        $display("End of Sim.");
        $finish;
    end
endmodule


