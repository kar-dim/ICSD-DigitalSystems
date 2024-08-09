module test_bench_s;
reg [2:0] in;
wire S, Cout;
FA_s fa0 (in[2], in[1], in[0], S, Cout);
initial
in = 3'b000;
always
#10 in = in + 1;
endmodule
