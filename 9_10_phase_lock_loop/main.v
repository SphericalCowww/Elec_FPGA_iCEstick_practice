module main(
    input ref_clk,        //12MHz clock
    input rstI,
    output reg led
);
    wire rst;
//    wire clk_pll;
    wire clk_tick;
    assign rst = rstI;

    //clock handling
    _clock_divider #(.CLK_ITER_MAX(12000000 - 1)) clk_div_obj(
        .ref_clk(ref_clk),
        .rst(rst),
//        .clk_pll(clk_pll),
        .out_clk_tick(clk_tick)
    );
    //LED handling
    always @ (posedge rst or posedge clk_tick) begin
        if (rst == 1'b1) begin
            led <= 1'b0;
        end else if (clk_tick == 1'b1) begin
            led <= ~led;
        end
    end
endmodule


