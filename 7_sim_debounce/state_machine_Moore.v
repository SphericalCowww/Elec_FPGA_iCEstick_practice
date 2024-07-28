module state_machine_Moore #(
    parameter CLK_ITER_WIDTH = 20,
    parameter CLK_ITER_MAX   = 600000 - 1   //0.1Hz, factor of 2 from "clk_div <= ~clk_div"
)(
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
    localparam  STATE_IDLE = 2'd0;
    localparam  STATE_PROC = 2'd1;
    localparam  STATE_DONE = 2'd2;

    reg                     clk_div;
    reg [CLK_ITER_WIDTH:0]  clk_iter;
//////////////////////////////////////////////////////////////////////////////////////////////
//clock handling
    always @ (posedge rst or posedge clk) begin
        if (rst == 1'b1) begin
            clk_iter <= 20'b0;
            clk_div  <= 0;
        end else if (clk_iter == CLK_ITER_MAX) begin
            clk_iter <= 20'b0;
            clk_div  <= ~clk_div;
        end else begin 
            clk_iter <= clk_iter + 1'b1;
        end
    end
//state handling
    always @ (posedge rst or posedge clk_div) begin
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if (go == 1'b1) begin
                        state <= STATE_PROC;
                    end
                end                
                STATE_PROC: state <= STATE_DONE;
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
    always @ (posedge rst or posedge clk_div) begin
        if (rst == 1'b1) begin
            led <= 4'b0;
        // enough time to catch the following before state goes to STATE_DONE?
        // note that mixing led with blocking/unblocking will create problem when combining
        //rst/go input  
        end else if (state == STATE_PROC) begin
            led <= led + 1'b1; 
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







