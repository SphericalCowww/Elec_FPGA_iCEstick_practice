module main(
    input               clk,        //12MHz clock
    input               rstInput,
    input               goInput, 
    output  reg [3:0]   led,
    output  reg         doneSig
);
//////////////////////////////////////////////////////////////////////////////////////////////
    wire    rst;
    wire    go;
    assign  rst = rstInput;
    assign  go  = goInput;

    localparam  STATE_IDLE  = 2'd0;
    localparam  STATE_POS   = 2'd1;
    localparam  STATE_NEG   = 2'd2;
    localparam  STATE_DONE  = 2'd3;
    reg [1:0]   state = STATE_IDLE;

    reg         clkDiv;
//////////////////////////////////////////////////////////////////////////////////////////////
//clock handling
    clock_divider #(.CLK_ITER_WIDTH(24), .CLK_ITER_MAX(1200000 - 1)) clk_div_obj1(
        .clk(clk),
        .rst(rst),
        .out_clk_div(clkDiv)
    );
//state handling
    always @ (posedge rst or posedge clkDiv) begin
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (go == 1'b1) begin
                        state <= STATE_POS;
                    end
                end                
                STATE_POS: begin
                    if (go == 1'b1) begin
                        if (led < (4'b1111 - 1)) begin
                            state <= STATE_POS;
                        end else begin
                            state <= STATE_NEG;
                        end
                    end else begin
                        state <= STATE_DONE;
                    end
                end
                STATE_NEG: begin
                    if (go == 1'b1) begin
                        if (4'b0001 < led) begin
                            state <= STATE_NEG;
                        end else begin
                            state <= STATE_POS;
                        end
                    end else begin
                        state <= STATE_DONE;
                    end 
                end 
                STATE_DONE: begin
                    if (go == 1'b0) begin
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
            led <= 4'b0;
        // enough time to catch the following before state goes to STATE_DONE?
        // note that mixing led with blocking/unblocking will create problem when combining
        //rst/go input  
        end else if (state == STATE_POS) begin
            led <= led + 1'b1; 
        end else if (state == STATE_NEG) begin
            led <= led - 1'b1;
        end 
    end
    always @ ( * ) begin
        if (state == STATE_DONE) begin
            doneSig = 1'b1;                     //blocking assignment
        end else begin
            doneSig = 1'b0;                     //blocking assignment
        end
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////







