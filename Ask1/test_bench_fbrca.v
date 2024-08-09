module test_bench_fbrca;

reg[3:0] in1;
reg[3:0] in2;
wire[4:0] s; 
reg cin;

FBRCA fbrca0(in1, in2, cin, s[3:0], s[4] );

initial begin
    in1 = 4'b0000;
    in2 = 4'b0000;
    cin = 1'b0;
end
always begin
   #10 in1 = in1 + 1'b1;
   #160 in2 = in2 + 1'b1;
end
endmodule
