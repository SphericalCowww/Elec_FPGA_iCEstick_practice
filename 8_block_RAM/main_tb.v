`timescale 1 ns / 10 ps              // set simulated unit / precision

module main_tb();
    reg clk     = 0;
    reg rst     = 0;
    reg iterLED = 0;
    reg [1:0] led;
    reg doneSig;

    wire clkDiv;

    localparam STATE_IDLE = 2'd0;
    localparam STATE_ITER = 2'd1;
    localparam STATE_READ = 2'd2;
    localparam STATE_DONE = 2'd3;
    reg [1:0]  state      = STATE_IDLE;

    reg w_en = 0;
    reg r_en = 0;
    reg  [3:0] w_addr;
    reg  [3:0] r_addr;
    reg  [1:0] w_data;
    wire [1:0] r_data;
 
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    localparam SIM_DURATION = 32000;    // in unit of timescale

    // simulation keeps on running the following
    always begin
        #41.667                     //delay by, 1/(2*41.67*1ns) ~ 12MHz of IceStick, round to precision
        clk = ~clk;
    end

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //clock handling, parameter adjusted for sim
    _clock_divider #(.CLK_ITER_WIDTH(4), .CLK_ITER_MAX(6 - 1)) clk_div_obj(    
        .clk(clk),
        .rst(rst),
        .out_clk_div(clkDiv)
    );
    //RAM IO
    _block_16x4_RAM #(.INIT_FILE("_block_16x4_RAM_init.txt")) _block_RAM_obj (
        .clk(clk),
        .w_en(w_en),
        .r_en(r_en),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_data(w_data),
        .r_data(r_data)
    );
    //state handling
    always @ (posedge rst or posedge clkDiv) begin
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (iterLED == 1'b1) begin
                        state <= STATE_ITER;
                    end
                end                
                STATE_ITER: begin
                    if (iterLED == 1'b1) begin
                        state <= STATE_READ;
                    end else begin
                        state <= STATE_DONE;
                    end
                end
                STATE_READ: begin
                    if (iterLED == 1'b1) begin
                        state <= STATE_ITER;
                    end else begin
                        state <= STATE_DONE;
                    end
                end
                STATE_DONE: begin
                    if (iterLED == 1'b0) begin
                        state <= STATE_IDLE;
                    end
                end
                default: state <= STATE_IDLE;
            endcase
        end 
    end
    //LED handling
    always @ (posedge rst or posedge clkDiv) begin
        if (rst == 1'b1) begin
            led <= 2'b0;
        end else if (state == STATE_ITER) begin
            r_en <= 1'b1;
            r_addr <= r_addr + 4'b1;
        end else if (state == STATE_READ) begin
            led <= r_data;   
        end 
    end
    always @ ( * ) begin
        if (state == STATE_DONE) begin
            r_en    = 1'b0;                     //blocking assignment
            doneSig = 1'b1;                     //blocking assignment
        end else begin
            doneSig = 1'b0;                     //blocking assignment
        end
    end

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // pulse reset high at beginning
    initial begin
        #10             //delay by 10*1ns = 10ns 
        rst     = 1'b1;
        #1              //delay by 1*1ns = 1ns 
        rst     = 1'b0;
        iterLED = 1'b0;        

        r_addr = 4'b0;
        w_data = 4'b0;
    end

    // read value in each address
    always begin
        #2000
        iterLED = 1'b1;
        #10000
        iterLED = 1'b0;
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


