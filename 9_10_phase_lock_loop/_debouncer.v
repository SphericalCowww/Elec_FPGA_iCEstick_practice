//ref: github.com/ShawnHymel/introduction-to-fpga/blob/main/10-metastability/example-03-better-debouncer/debouncer.v
module _debouncer #(
    parameter CLK_ITER_MAX = 1200000 - 1   //0.1Hz
)(
    input   ref_clk,        //120MHz clock
    input   rstI,
    input   sigI,
    output  reg sigO
);
//////////////////////////////////////////////////////////////////////////////////////////////
    wire    rst;
    assign  rst = rstI;

//    wire clk_pll;
    wire clk_tick;
    wire sig_edge;
    reg detect1;
    reg detect2;
    assign sig_edge = detect1 ^ detect2;        //true if different
//////////////////////////////////////////////////////////////////////////////////////////////
    //clock handling
    _clock_divider #(.CLK_ITER_MAX(CLK_ITER_MAX)) clk_div_obj(
        .ref_clk(ref_clk),
        .rst(rst),
//        .clk_pll(clk_pll),
        .out_clk_tick(clk_tick)
    );
    //debouncing
    always @ (posedge clk_tick or posedge rst) begin
        if (rst == 1'b1) begin
            detect1 <= 0;
            detect2 <= 0;
            sigO    <= 0;
        end else begin
            detect1 <= sigI;
            detect2 <= detect1;
            if (sig_edge == 1'b1) begin
                sigO <= detect2;
            end
        end
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////







