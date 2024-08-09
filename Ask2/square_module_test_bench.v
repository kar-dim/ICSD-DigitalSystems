module square_module_test_bench;

reg[3:0] in;
wire[7:0] out;

square sq0(in, out);

//αρχικοποίηση πρώτα την είσοδο με 0
initial begin
    in = 4'b0000;
end
//κάθε 10ps αλλάζει η τιμή +1 (άρα επειδή είναι 4bit -> στα 160ps θα έχουν ληφθεί όλες οι πιθανές εισόδοι
always begin
    #10 in = in + 1'b1;
end
endmodule
