//module για t flip flop
module T_FF (q, t, clk, reset);
output q;
input t, clk, reset;
reg q;
//όταν φτάσει η αρνητική ακμή ή το reset τότε το flip flop ενεργοποιείται
always @ (posedge reset or negedge clk)
	//αν reset=1 τοτε η εξοδος γίνεται 0
    if (reset)
        #1 q <= 1'b0;
	//ενώ αν reset=0 και toggle=1 τότε αντιστρέφεται η είσοδος
    else if (t == 1)
        #2 q <= ~q;
endmodule
