module main(
    input clk,        //12MHz clock
);
    reg w_en = 1;
    reg r_en = 1;
    reg c_en = 1;
    reg  [7:0] w_addr;
    reg  [7:0] r_addr;
    reg  [15:0] w_data;
    reg  [15:0] mask;
    wire [15:0] r_data;
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // the following is using the inference method, can't be synthesized => ICESTORM_RAM:  0/16  0%
    /*
    reg [7:0] mem[0:15];

    always @ (posedge clk) begin
        if (w_en == 1'b1) begin
            mem[w_addr] <= w_data;
        end
        if (r_en == 1'b1) begin
            r_data <= mem[r_addr];
        end
    end
    */

    // the following is using the instantiate method, also can't be synthesized
    // https://www.reddit.com/r/yosys/comments/fyxubo/synthesizing_ice40_512x8_block_ram/
    SB_RAM40_4K #(
        .READ_MODE(1),
        .WRITE_MODE(1)
    ) mem (
        .RDATA(r_data),
        .RADDR(r_addr),
        .RCLK(clk),
        .RCLKE(c_en),
        .RE(r_en),
        .WADDR(w_addr),
        .WCLK(clk),
        .WCLKE(c_en),
        .WDATA(w_data),
        .WE(c_en),
        .MASK(mask)
    ); 
endmodule


