module main_bench;

reg clk;
reg keyb_clk;
reg keyb_data;
reg [10:0] keypad9; //πλήκτρο keypad9
reg [10:0] keypad0; //πλήκτρο keypad0
reg [10:0] f0;
reg [10:0] plus; //πλήκτρο keypad+
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
 keypad9 = 11'b01011111011;
 keypad0 = 11'b00000111011;
 f0 = 11'b00000111111;
 plus = 11'b01001111011;
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
   //j==0: στέλνουμε scan code του keypad9
   if (j==0) begin
       keyb_data = keypad9[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j==1: στέλνουμε f0
   else if (j==1) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
    //j==2: στέλνουμε keypad9 ξανά
   else if (j==2) begin
       keyb_data = keypad9[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=3: στέλνουμε keypad9 ξανά (εδώ είναι μη αναμενόμενη τιμή)
   else if (j==3) begin
       keyb_data = keypad9[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

   //j=4: στέλνουμε f0
   else if (j==4) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=5: στέλνουμε keypad9 ξανά
   else if (j==5) begin
       keyb_data = keypad9[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=6: στέλνουμε keypad+
   else if (j==6) begin
       keyb_data = plus[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

   //j=7: στέλνουμε f0
   else if (j==7) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

//j=8: στέλνουμε keypad+ ξανά
   else if (j==8) begin
       keyb_data = plus[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

 //j=9: στέλνουμε keypad0
   else if (j==9) begin
       keyb_data = keypad0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
 //j=10: στέλνουμε f0
   else if (j==10) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end

 //j=11: στέλνουμε keypad0 ξανά
   else if (j==11) begin
       keyb_data = keypad0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=11: στέλνουμε "="
   else if (j==12) begin
       keyb_data = equals[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=11: στέλνουμε f0
   else if (j==13) begin
       keyb_data = f0[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
   //j=11: στέλνουμε "=" ξανά
   else if (j==14) begin
       keyb_data = equals[10-i];
       i=i+1;
       if (i==11) begin
          i=0;
          j=j+1;
       end
   end
end

endmodule
