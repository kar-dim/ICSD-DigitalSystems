module FA_s(
    input A,
    input B,
    input Cin,
    input Cout,
    output S
);
    wire a_cin_and;
    wire a_b_and;
    wire b_cin_and;
    xor(S, A, B, Cin);
    and(a_b_and, A, B);
    and(b_cin_and, B, Cin);
    and(a_cin_and, A, Cin);
    or(Cout, a_cin_and, a_b_and, b_cin_and);
endmodule
