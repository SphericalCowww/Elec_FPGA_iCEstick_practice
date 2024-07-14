module clock_divider #(
    parameter CLK_ITER_WIDTH                  = 24,
    parameter [CLK_ITER_WIDTH:0] CLK_ITER_MAX = 6000000 - 1
)(
    input clk,        //12MHz clock
    input rst,

    output reg out_clk_div
);
    //parameter CLK_ITER_WIDTH                  = 24;
    //parameter [CLK_ITER_WIDTH:0] CLK_ITER_MAX = 6000000 - 1; //1Hz, factor of 2 from "out_clk_div <= ~out_clk_div"

    reg [CLK_ITER_WIDTH:0] clk_iter;

    always @ (posedge rst or posedge clk) begin
        if (rst == 1'b1) begin
            clk_iter    <= 24'b0;
            out_clk_div <= 0;
        end else if (CLK_ITER_MAX < clk_iter) begin
            clk_iter    <= 24'b0;
            out_clk_div <= ~out_clk_div;
        end else begin 
            clk_iter <= clk_iter + 1;
        end
    end

endmodule








