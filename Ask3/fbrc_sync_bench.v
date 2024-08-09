//test bench για τον σύγχρονο μετρητή
module fbrc_sync_bench;

wire[3:0] out;
reg clk;
reg reset;

initial begin
    reset = 0;
    clk = 0;
    #15 reset = 1; //χρειάζεται reset=1 για να αρχικοποιηθεί ο μετρητής
    #10 reset = 0; //αφού αρχικοποιηθεί κλείνουμε το reset
end

FBRC_Sync fbrc_a( out, clk, reset); //δημιουργία του σύγχρονου μετρητή
always begin
   #10 clk= ~clk; //clock=10ps
end
endmodule
