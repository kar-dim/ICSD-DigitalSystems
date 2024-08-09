//Ασύγχρονος 4bit μετρητής
module FBRC_Async (
    output [3:0]q, //q είναι η 4bit έξοδος
    input clk, //
    input reset
);
reg one = 1'b1; //χρησιμοποιείται για να αρχικοποιήσει το Τ των T Flip Flop με 1
//δημιουργία των 4 Flip Flop, το clock του 1ου είναι το clock αλλά των επόμενων είναι η έξοδος των προηγούμενων 
T_FF t_ff0(q[0], one, clk,  reset);
T_FF t_ff1(q[1], one, q[0], reset);
T_FF t_ff2(q[2], one, q[1], reset);
T_FF t_ff3(q[3], one, q[2], reset);

endmodule
