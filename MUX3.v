module MUX3 (
    input [31:0] A, B, C,
    input [1:0] select,
    output [31:0] out
);
    assign out = (select == 2'b00) ? A :
                 (select == 2'b01) ? B :
                 (select == 2'b10) ? C : 32'b0;
endmodule