module state_machine_Mealy(
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

    reg [1:0]   state;
    localparam  STATE_IDLE  = 2'd0;
    localparam  STATE_PROC  = 2'd1;

    reg         clkDiv;
    reg [19:0]  clkIter;
    localparam  CLK_DIV_MAX = 20'd600000 - 1;   //0.1Hz, factor of 2 from "clkDiv <= ~clkDiv"
//////////////////////////////////////////////////////////////////////////////////////////////
//clock handling
    always @ (posedge rst or posedge clk) begin
        if (rst == 1'b1) begin
            clkIter <= 20'b0;
        end else if (clkIter == CLK_DIV_MAX) begin
            clkIter <= 20'b0;
            clkDiv  <= ~clkDiv;
        end else begin 
            clkIter <= clkIter + 1'b1;
        end
    end
//state handling
    always @ (posedge rst or posedge clkDiv) begin
        if (rst == 1'b1) begin
            led <= 4'b0;
            state <= STATE_IDLE;
        end else begin
            case(state)
                STATE_IDLE: begin
                    doneSig <= 1'b0;
                    if (go == 1'b1) begin
                        led <= led + 1'b1;  // not an ideal position, should be in STATE_PROC
                        state <= STATE_PROC;
                    end
                end                
                STATE_PROC: begin
                    if (go == 1'b0) begin
                        state <= STATE_IDLE;
                        doneSig <= 1'b1;
                    end
                end
                default: state <= STATE_IDLE;
            endcase
        end 
    end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////







