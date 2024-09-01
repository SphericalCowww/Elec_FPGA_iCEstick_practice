module _clock_divider #(
    parameter CLK_ITER_MAX = 120000000 - 1       // CLK_ITER_MAX default for 1Hz
)(
    input ref_clk,          // 12MHz clock
    input rst,

//    output clk_pll,         // 120MHz clock after phase_lock_loop
    output out_clk_tick
);
    wire clk_pll;           // 120MHz clock after phase_lock_loop
    localparam CLK_ITER_WIDTH = (CLK_ITER_MAX == 1) ? 1 : $clog2(CLK_ITER_MAX);

    reg [CLK_ITER_WIDTH-1:0] clk_iter;
    assign out_clk_tick = (CLK_ITER_MAX < clk_iter) ? 1'b1 : 1'b0;

    //instantiate PLL (120 MHz)
    //cite: github.com/ShawnHymel/introduction-to-fpga/blob/main/09-pll-and-glitches/example-01-pll/pll_test.v
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),   // Don't use fine delay adjust
        .PLLOUT_SELECT("GENCLK"),   // No phase shift on output
        .DIVR(4'b0000),             // Reference clock divider
        .DIVF(7'b1001111),          // Feedback clock divider
        .DIVQ(3'b011),              // VCO clock divider
        .FILTER_RANGE(3'b001)       // Filter range
    ) phase_lock_loop (
        .REFERENCECLK(ref_clk),     // Input clock
        .PLLOUTCORE(clk_pll),       // Output clock
        .LOCK(),                    // Locked signal
        .RESETB(1'b1),              // Active low reset
        .BYPASS(1'b0)               // No bypass, use PLL signal as output
    );

    //iterate clock and tick clock divider
    always @ (posedge rst or posedge clk_pll) begin
        if (rst == 1'b1) begin
            clk_iter <= 0;
        end else if (out_clk_tick == 1'b1) begin 
            clk_iter <= 0; 
        end else begin 
            clk_iter <= clk_iter + 1;
        end
    end
endmodule








