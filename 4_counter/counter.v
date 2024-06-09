module counter (
    input               clk,        //12MHz clock
    input       [1:0]   pmod,
    output  reg [3:0]   led
);
    wire reset;
    wire enable;
    assign reset  = pmod[0];
    assign enable = pmod[1];

    reg clk_div;
    reg [23:0] clk_iter;
    localparam CLK_DIV_MAX = 24'd6000000;               //1Hz, factor of 2 from "clk_div <= ~clk_div"

    always @ (posedge reset or posedge clk) begin
        if (reset == 1'b1) begin
            clk_iter <= 24'b0;
        end else if (CLK_DIV_MAX < clk_iter) begin
            clk_iter <= 24'b0;
            clk_div <= ~clk_div;
        end else begin 
            clk_iter <= clk_iter + 1;
        end
    end

    always @ (posedge reset or posedge clk_div) begin
        if (reset == 1'b1) begin
            led <= 4'b0000;
        end else if (enable == 1'b1) begin
            led <= led + 1'b1;
        end
    end
endmodule








