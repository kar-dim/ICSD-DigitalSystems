module fibonacci_behavioural(
    input clk,
    input reset,
    output [7:0]out
);

reg[7:0] prev;
reg[7:0] cur;
assign out = prev; //το αποτέλεσμα είναι το prev

always @(posedge clk or posedge reset) begin
    if (reset) begin
	    //το reset χρειάζεται για την αρχικοποιήση του κυκλώματος γενικά
        prev <= 8'b00000000;
        cur <= 8'b00000001;
    end
    else begin
	   //σε κάθε κύκλο ρολογιού (αν δεν έχει έρθει reset=1) prev = cur και cur = prev + cur
       prev <= cur;
       cur <= prev + cur;
    end
  end
endmodule
