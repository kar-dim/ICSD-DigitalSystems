module EBRCA (
    input  [7:0] A,
    input  [7:0] B,
    input   cin,
    output [7:0] s,
    output Cout
);
wire temp_wire;
FBRCA fbrca0(A[3:0], B[3:0], cin, s[3:0], temp_wire );
FBRCA fbrca1(A[7:4], B[7:4], temp_wire, s[7:4], Cout );
endmodule
