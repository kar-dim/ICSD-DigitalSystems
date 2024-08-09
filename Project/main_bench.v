module main_bench;

reg clk;
reg keyb_clk;
reg keyb_data;
reg [10:0] keypad8; //πλήκτρο keypad8
reg [10:0] keypad4; //πλήκτρο keypad4
reg [10:0] f0;
reg [10:0] minus; //πλήκτρο keypad -
reg [10:0] equals; //πλήκτρο =
reg reset;
wire[6:0] hex7;
wire[6:0] hex6;
wire[6:0] hex5;
wire[6:0] hex4;
wire[6:0] hex1;
wire[6:0] hex0;
integer i,j;

wire keyb_clk_wire = keyb_clk;

initial begin
 
 clk = 0;
 keyb_clk=0;
 #1 i=0;
 #1 j=0;
 reset = 0;
 keypad8 = 11'b01010111011;
 keypad4 = 11'b01101011011;
 f0 = 11'b00000111111;
 minus = 11'b01101111011;
 equals = 11'b01010101011;
 //αρχικοποίηση του κυκλώματος
 #3 reset =1;
 #3 reset = 0;
 
 
end

//instantiate το κύκλωμα
main m(clk, reset, keyb_clk_wire, keyb_data, hex7, hex6, hex5, hex4, hex1, hex0);


always begin
  #5 clk = ~clk;
end

always begin
  #50 keyb_clk =~keyb_clk;
end


always @(negedge keyb_clk) begin
   //j==0: στέλνουμε scan code (πχ keypad4)
   if (j==0) begin
       keyb_data = keypad4[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j==1: στέλνουμε scan code του f0
   else if (j==1) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
    //j==2: στέλνουμε scan code του keypad4 ξανά
   else if (j==2) begin
       keyb_data = keypad4[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=3: στέλνουμε scan code keypad-
   else if (j==3) begin
       keyb_data = minus[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

   //j=4: στέλνουμε scan code f0
   else if (j==4) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=5: στέλνουμε scan code keypad- ξανά
   else if (j==5) begin
       keyb_data = minus[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=6: στέλνουμε scan code του δεύτερου αριθμού (keypad8)
   else if (j==6) begin
       keyb_data = keypad8[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

   //j=7: στέλνουμε scan code tou f0
   else if (j==7) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

//j=8: στέλνουμε scan code keypad8 ξανά
   else if (j==8) begin
       keyb_data = keypad8[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

 //j=9: στέλνουμε scan code tou =
   else if (j==9) begin
       keyb_data = equals[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
 //j=10: στέλνουμε scan code tou f0
   else if (j==10) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

 //j=11: στέλνουμε scan code tou = ξανά
   else if (j==11) begin
       keyb_data = equals[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

end

endmodule
