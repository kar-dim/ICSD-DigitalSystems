module decoder_4to16(
    input [0:3]in, //είσοδος 4bit
    output [0:15]out //έξοδος 16bit
);

//χρειαζόμαστε τα NOT της εισόδου οπότε τα βάζουμε σε wires
wire not_in0;
wire not_in1;
wire not_in2;
wire not_in3;
not(not_in0, in[0]);
not(not_in1, in[1]);
not(not_in2, in[2]);
not(not_in3, in[3]);

//εφαρμογή του διαγράμματος, απλώς δημιουργούμε τις AND πύλες και βάζουμε τις κατάλληλες εισόδους
//οι οποίες είναι είτε τα NOT της εισόδου (τα έχουμε βάλει σε wires από πριν) είτε οι ίδιες οι τιμές της εισόδου
and(out[15], not_in3, not_in2, not_in1, not_in0);
and(out[14], not_in1, not_in2, not_in3, in[0]);
and(out[13], not_in0, not_in2, not_in3, in[1]);
and(out[12], not_in2, not_in3, in[0], in[1]);
and(out[11], not_in0, not_in1, not_in3, in[2]);
and(out[10], not_in1, not_in3, in[0], in[2]);
and(out[9], not_in0, not_in3, in[1], in[2]);
and(out[8], not_in3, in[0], in[1], in[2]);
and(out[7], not_in0, not_in1, not_in2, in[3]);
and(out[6], not_in1, not_in2, in[0], in[3]);
and(out[5], not_in0, not_in2, in[1], in[3]);
and(out[4], not_in2, in[0], in[1], in[3]);
and(out[3], not_in0, not_in1, in[2], in[3]);
and(out[2], not_in1, in[0], in[2], in[3]);
and(out[1], not_in0, in[1], in[2], in[3]);
and(out[0], in[0], in[1], in[2], in[3]);

endmodule
