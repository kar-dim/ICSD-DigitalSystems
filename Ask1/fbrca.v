module FBRCA (
    input  [3:0] A,
    input  [3:0] B,
    input   Cin,
    output [3:0] S,
    output Cout
);
wire [2:0] temp_cout;
FA_s fa0(A[0], B[0], Cin, temp_cout[0] ,S[0]);
FA_s fa1(A[1], B[1], temp_cout[0], temp_cout[1], S[1]);
FA_s fa2(A[2], B[2], temp_cout[1], temp_cout[2], S[2]);
FA_s fa3(A[3], B[3], temp_cout[2], Cout, S[3]);
endmodule
