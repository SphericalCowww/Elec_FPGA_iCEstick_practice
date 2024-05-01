module basic_logic (
    input   [2:0]   pmod,
    output  [4:0]   led
);
    wire node1;
    wire node2;
    wire node3;
    assign node1  = (pmod[0] ~^ pmod[1]);
    assign led[0] = (node1 ~^ pmod[2]);
    assign node2  = (node1 & pmod[2]);
    assign node3  = (pmod[0] & pmod[1]);
    assign led[1] = node2 | node3;
    assign led[2] = 0;
    assign led[3] = 0;
    assign led[4] = 0;
    
endmodule








