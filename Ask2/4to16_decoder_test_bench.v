module decoder_4to16_test_bench;

reg[0:3] in; //4bit είσοδος
wire[0:15] out; //16bit έξοδος

decoder_4to16 dec(in, out); //δημιουργούμε ένα instance του decoder
//ο decoder θα δεχτεί ως είσοδο το 4bit register και θα βγάλει έξοδο την οποία θα την έχουμε σε ένα 16bit wire
initial begin
  in = 4'b0000; //αρχικά η είσοδος θα είναι η 0000
end
always begin
   #10 in = in + 1'b1; //καθε 10ps θα αλλάζει η είσοδος, αρχικά 0000, μετά από 10ps θα είναι 0001
   //μετά από 20ps θα είναι 0010.. κτλ
end
endmodule

