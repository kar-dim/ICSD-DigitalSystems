//test bench για το module που χρησιμοποιεί τον 8bit ripple carr adder
module fibonacci_adder_bench;

wire [7:0]out;
reg clk;
reg reset;
initial begin
	//αρχικοποίηση του clock
    clk = 0;
	//αρχικοποίηση του κυκλώματος
    #15 reset = 1;
    #10 reset = 0; //πρέπει να γίνει =0 κάποτε αλλιώς δε θα τρέξει το κύκλωμα
end

//instantiate του fibonacci module που χρησιμοποιεί τον 8bit ripple carry adder
fibonacci_adder fib_a(clk, reset, out);

always begin
    #10 clk = ~clk; //κάθε 10ps θα αλλάζει τιμή το clock
end

endmodule
