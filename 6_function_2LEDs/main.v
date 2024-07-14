module main(
    input clk,        //12MHz clock
    input rstInput,

    output [1:0] led
);
    wire rst;
    assign rst = rstInput;

    clock_divider clk_div_obj1(
        .clk(clk),
        .rst(rst),
        .out_clk_div(led[0])
    );
    defparam clk_div_obj1.CLK_ITER_WIDTH = 32;
    defparam clk_div_obj1.CLK_ITER_MAX   = 1500000 - 1;

    clock_divider #(.CLK_ITER_WIDTH(24), .CLK_ITER_MAX(6000000 - 1)) clk_div_obj2(
        .clk(clk),
        .rst(rst),
        .out_clk_div(led[1])
    );
endmodule








