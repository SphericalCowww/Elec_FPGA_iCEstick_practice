module blockRAMtester #(
    parameter   INIT_FILE = ""
)(
    input               clk,        //12MHz clock
    input               w_en,
    input               r_en,
    input       [3:0]   w_addr,     //4 bits
    input       [3:0]   r_addr,
    input       [1:0]   w_data,     //2 bits
    output  reg [1:0]   r_data
);
    reg     [1:0]   mem[0:15];      //2^(3+1) = 15+1
//////////////////////////////////////////////////////////////////////////////////////////////
    // memory bus system
    always @ (posedge clk) begin
        if (w_en == 1'b1) begin
            mem[w_addr] <= w_data;
        end
        if (r_en == 1'b1) begin            
            r_data <= mem[r_addr];
        end
    end

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end


/*
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
*/
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////







