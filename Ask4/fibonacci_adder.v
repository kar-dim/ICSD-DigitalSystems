module fibonacci_adder(
    input clk,
    input reset,
    output [7:0]out
);

reg cin; //είναι ίσο με 0 και χρειάζεται να μπει στον 8bit ripple carry adder
reg dont_care;
reg[7:0] prev;
reg[7:0] cur;

//prev_wire και cur_wire χρειάζονται ώστε να συνδέσουν τους registers με τον adder
//ενώ το add_wire έχει το αποτέλεσμα του adder
wire [7:0] prev_wire;
wire [7:0] cur_wire;
wire [7:0] add_wire;

assign prev_wire = prev;
assign cur_wire = cur;
assign out = prev;

//instantiate του 8bit ripple carry adder, ώστε κάθε φορά να προσθέτει τα prev και cur
EBRCA ebrca(prev_wire, cur_wire, cin, add_wire, dont_care);
always @(posedge clk or posedge reset) begin
	//το reset χρειάζεται για την αρχικοποιήση του κυκλώματος γενικά
    if (reset) begin
        prev <= 8'b00000000;
        cur <= 8'b00000001;
	    cin <= 1'b0;
    end
    else begin
       prev <= cur;
       cur <= add_wire;  //cur <= cur + prev στην ουσία
    end
  end
endmodule
