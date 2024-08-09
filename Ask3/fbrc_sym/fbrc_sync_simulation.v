//σύγχρονος μετρητής για την εξομοίωση
module fbrc_sync_simulation (
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

//εδώ προσθέτουμε τον μετρητή καθυστέρησης, δηλαδή για να μπορέσουμε να δούμε οτι αναβοσβήνουν τα λαμπάκια
//πρέπει να βάλουμε καθυστέρηση αλλιώς οι εναλλαγές γίνονται πολύ γρήγορα και δε φαίνεται καμια εναλλαγή
//(Φαίνονται συνεχώς αναμμένα)
reg [24:0] delay_counter; 
wire enable;
//στην ουσία αυτό που κάνει ο μετρητής αυτός είναι να μετράει από το 0 μέχρι να γίνουν 1 όλα τα 25bits του delay_counter, όλα αυτά στην αρνητική ακμή του ρολογιού προφανώς (σε αυτή δουλεύουν και τα flip flops)
//αν τελειώσει το μέτρημα τότε enable=1 οπότε μπορούν να αλλάξουν τιμή οι έξοδοι flip flop
assign enable = (delay_counter == 25'd24999999) ? 1'b1: 1'b0;
always @ (negedge clk or posedge reset) begin
    if (reset)
        delay_counter <= 25'd0;
    else if (enable)
        delay_counter <= 25'd0;
	else
	    delay_counter <= delay_counter + 1'b1;
end

//instantiate των 4 flip flop
T_FF t_ff0(q[0], one, clk,  reset, enable);
T_FF t_ff1(q[1], q[0], clk, reset, enable);
T_FF t_ff2(q[2], q0q1, clk, reset, enable);
T_FF t_ff3(q[3], q2q1q0 , clk, reset, enable);

endmodule

//module για τα T flip flop, περνάμε και τη παράμετρο enable
module T_FF (q, t, clk, reset, enable);
output q;
input t, clk, reset, enable;
reg q;

always @ (posedge reset or negedge clk)
    if (reset)
        #1 q <= 1'b0;
	//μόνο όταν enable=1 (και t=1) μπορεί η έξοδος να αλλάξει
    else if (t == 1 && enable == 1)
        #2 q <= ~q;
endmodule
