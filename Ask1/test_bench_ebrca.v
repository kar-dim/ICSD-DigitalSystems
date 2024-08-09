module test_bench_ebrca;

reg[7:0] in1;
reg[7:0] in2;
wire[8:0] s; 
reg cin;

EBRCA ebrca0(in1, in2, cin, s[7:0], s[8] );
initial begin
    in1 = 8'b00000000;
    in2 = 8'b00000000;
    cin = 1'b0;
end
always begin
   #10 in1 = in1 + 1'b1;
   #2560 in2 = in2 + 1'b1;
end
endmodule
