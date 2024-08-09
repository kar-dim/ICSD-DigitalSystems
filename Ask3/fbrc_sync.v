//Σύγχρονος 4bit μετρητής
module FBRC_Sync (
    output [3:0]q,
    input clk,
    input reset
);
reg one = 1'b1;

wire q0q1;
//q0q1 = q1 and q2
and(q0q1, q[0], q[1]);

wire q2q1q0;
//q2q1q0 = q2 and q1 and q0
and(q2q1q0, q[2], q0q1);

//δημιουργία ττων 4 flip Flop, παίρνουν τα ίδια clock,reset και το Τ τους καθορίζεται από το κύκλωμα
//δηλαδή του 1ου είναι 1, του 2ου είναι η έξοδος του 1ου, του 3ου είναι AND(έξοδος 1ου ,έξοδος 2ου) και του
// τελευταίου είναι AND(AND(έξοδος 1ου ,έξοδος 2ου) , έξοδος 3ου)
T_FF t_ff0(q[0], one, clk,  reset);
T_FF t_ff1(q[1], q[0], clk, reset);
T_FF t_ff2(q[2], q0q1, clk, reset);
T_FF t_ff3(q[3], q2q1q0 , clk, reset);

endmodule
