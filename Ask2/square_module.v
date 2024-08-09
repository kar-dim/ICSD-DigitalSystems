module square(
   input [3:0]in,
   output [7:0]out
);
//εδώ δηλώνουμε τα wires που θα περιέχουν τα NOT της εισόδου
wire not_in3;
wire not_in2; 
wire not_in1;
wire not_in0; 
//δημιουργούμε τις NOT πύλες τις εισόδου
not(not_in3, in[3]);
not(not_in2, in[2]);
not(not_in1, in[1]);
not(not_in0, in[0]);

//επειδή θα χρειαστούμε τα xor(in[3], in[2]) και xor(in[2], in[1]) στη συνέχεια
//τα δημιουργούμε και τα περνάμε στα 2 wires
wire xor_in3_in2;
wire xor_in2_in1;
xor(xor_in3_in2, in[3], in[2]);
xor(xor_in2_in1, in[2], in[1]);

//στη συνέχεια δημιουργούμε τις πύλες εξόδου για κάθε έξοδο
//οι έξοδοι προέκυψαν από τους χάρτες karnaugh που κάναμε

//out7 = AND(in3, in2);
and(out[7], in[3], in[2]);

//out6 = AND(OR(in1, ~in2), in3)
wire temp_6_or1;
or(temp_6_or1, not_in2, in[1]);
and(out[6], in[3], temp_6_or1);

//out5 = OR( AND(XOR(in3,in2),in1), AND(in3, in0) )
wire temp_5_and1;
wire temp_5_and2;
and(temp_5_and1, in[1], xor_in3_in2);
and(temp_5_and2, in[3], in[2], in[0]);
or(out[5], temp_5_and1, temp_5_and2);

//out4 = OR( AND(XOR(in3,in2), in0), AND(~in1 , ~in0, in2) )
wire temp4_and1;
wire temp4_and2;
and(temp4_and1, in[0], xor_in3_in2);
and(temp4_and2, in[2], not_in1, not_in0);
or(out[4], temp4_and1, temp4_and2); 

//out3 = AND(XOR(in2,in1), in0)
and(out[3], in[0], xor_in2_in1);

//out2 = AND(in1, ~in0)
and(out[2], in[1], not_in0);

//out1 =0 
assign out[1] = 0;

//out0 = in0
assign out[0] = in[0];

endmodule
