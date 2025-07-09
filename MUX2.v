module MUX2 (
    input [31:0] A, B,
    input select,
    output [31:0] out
);
    assign out = select ? B : A;
endmodule