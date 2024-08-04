`timescale 1 ns / 10 ps              // set simulated unit / precision

module main_tb();
    wire    [1:0]   r_data;
    reg     clk  = 0;
    reg     rst  = 0;
    reg     w_en = 0;
    reg     r_en = 0;
    reg     [3:0]   w_addr;
    reg     [3:0]   r_addr;
    reg     [1:0]   w_data;

    localparam SIM_DURATION = 32000;    // in unit of timescale
    integer debounceIter = 0;
    integer addr_iter = 0;

    // simulation keeps on running the following
    always begin
        #41.667                     //delay by, 1/(2*41.67*1ns) ~ 12MHz of IceStick, round to precision
        clk = ~clk;
    end

    // 
    blockRAMtester #(.INIT_FILE("blockRAMtester.txt")) uut (
        .clk(clk),
        .w_en(w_en),
        .r_en(r_en),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_data(w_data),
        .r_data(r_data)
    );

    // pulse reset high at beginning
    initial begin
        #10             //delay by 10*1ns = 10ns 
        rst = 1'b1;
        #1              //delay by 1*1ns = 1ns 
        rst = 1'b0;
        
        w_data = 4'b0;
    end

    // read value in each address
    always begin
        #2000
        for (addr_iter = 0; addr_iter < 16; addr_iter = addr_iter+1) begin
            #(2*41.667)
            r_addr = addr_iter;
            r_en = 1'b1;
            #(2*41.667)
            r_en = 1'b0;
            r_addr = 0;
        end
    end

    // pressing go periodically
    always begin
        #5000            //lasting 1000*1ns = 1.0us 
        w_addr = 12;
        w_data <= w_data + 4'b1;
        w_en   = 1'b1;
        #(2*41.667)
        w_en   = 1'b0;
        w_addr = 0;
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


