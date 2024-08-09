module main (
    input clk,
    input reset,
    inout keyb_clk,
    input keyb_data,
    //hex7: πρώτος αριθμός
    output [6:0] hex7,
    //hex6: '+' ή '-' σύμβολο
    output [6:0] hex6,
    //hex5: δεύτερος αριθμός
    output [6:0] hex5,
    //hex4: '=' σύμβολο
    output [6:0] hex4,
    //hex1: το πιο σημαντικό ψηφίο αποτελέσματος (πχ 2+9=11 -> 1) ή σύμβολο '-' (πχ 0-9 -> -)
    output [6:0] hex1,
	//hex0: λιγότερο σημαντικό ψηφίο αποτελέσματος (πχ 3+9=12 -> 2)
    output [6:0] hex0
);

reg [5:0] keyb_clk_sreg; //λαμβάνει το clock (του keyboard)
reg [10:0] keyb_data_sreg; //λαμβάνει 11bit scan κωδικό
reg [5:0] keyb_data_sreg_dec; //το decoded data register
//leds: πίνακας που έχει τιμή κατάλληλη για το άνναμα ενός led, άρα ο leds[0] 
//έχει την decoded μορφή ενός 7bit αριθμού τέτοια ώστε να εμφανίζεται το 0.
reg [6:0] leds [0:13]; 
//registers που κρατάνε τις τιμές για το ποια leds θα ανάψουν
reg[6:0] hex7_value;
reg[6:0] hex6_value;
reg[6:0] hex5_value;
reg[6:0] hex4_value;
reg[6:0] hex1_value;
reg[6:0] hex0_value;
//registers που δίνουν την έξοδο του 2ου decoder, o 2ος decoder βγάζει ως έξοδο 2 αποτελέσματα τα οποία είναι
//οι κατάλληλες τιμές για να ανάψουν τα leds ανάλογα του τι του δίνετα ως είσοδος (στo case), αν του δωθεί θετικός αριθμός <10
//τότε θα δώσει τιμή στον led1 (led2 σβηστό), αν του δωθεί αρνητικός θα δώσει και στα δύο regs τιμή (o led1 θα είναι η παύλα) ενώ αν είναι 0 θα δώσει
//στο led1 τιμή 0 (led2 σβηστό), τέλος αν είναι θετικός>10 θα δώσει και στα 2 regs τιμή (o led1 θα είναι το 1)
reg[6:0] led1;
reg[6:0] led2;
//οδήγηση tou keyb_clk ώστε να μη μπορεί το keyboard να στείλει δεδομένα πριν ο register γίνει reset
assign keyb_clk = (!keyb_data_sreg[0]) ? 1'b0 : 1'bz;
//assign τον output wire με τις τιμές των register
assign hex7 = hex7_value;
assign hex6 = hex6_value;
assign hex5 = hex5_value;
assign hex4 = hex4_value;
assign hex1 = hex1_value;
assign hex0 = hex0_value;

//αρχικοποίηση του leds array
always @(posedge clk or posedge reset) begin
   if (reset) begin
	leds[0] <= 7'b1000000;
	leds[1] <= 7'b1111001;
	leds[2] <= 7'b0100100;
	leds[3] <= 7'b0110000;
	leds[4] <= 7'b0011001;
	leds[5] <= 7'b0010010;
	leds[6] <= 7'b0000010;
	leds[7] <= 7'b1111000;
	leds[8] <= 7'b0000000;
	leds[9] <= 7'b0010000; 
	leds[10] <= 7'b0111111; //σύμβολο '-'
	leds[11] <= 7'b0101011; //σύμβολο '+' δε γίνεται σε μορφή "digital clock"
	//βάζουμε αντι για αυτό το σύμβολο 'π', π=πρόσθεση
	leds[12] <= 7'b0110111; //σύμβολο '='
	leds[13] <= 7'b0000100; //σύμβολο 'e'
	
   end
end

//always block για τον keytboard clock register
always @ (posedge clk or posedge reset)
begin
   if(reset)
       keyb_clk_sreg <= 6'b000000;
   else
   //κάθε φορά που έρχεται ένας κύκλος ρολογιού (του κυκλώματος, όχι του keyboard)
   //γίνεται shift η τιμή του καταχωρητή κατα 1 μονάδα δεξια και μπαίνει στο πιο σημαντικό ψηφίο
   //η τιμή του keyboard clock, επειδή το keyboard clock είναι πολύ αργό, ενδέχεται να υπάρχει θόρυβος
   //κατα την εναλλαγή του
       keyb_clk_sreg <= {keyb_clk, keyb_clk_sreg[5:1]};
end

//always block για τον data shift register
always @(posedge clk or posedge reset)
begin
    if (reset)
        keyb_data_sreg <= 11'b11111111111;
	//αν το τελευταίο ψηφίο του data register είναι 0 τότε τον κάνουμε επαναφορά
    else if (!keyb_data_sreg[0])
        keyb_data_sreg <= 11'b11111111111;
	//αν clock είναι 000111 σημαίνιε πως έφτασε αρνητική ακμή χωρίς θόρυβο οπότε μπορούμε να πάρουμε
	//ένα bit από το keyboard (shift μια μονάδα δεξια στον καταχωρητή δεδομένων)
    else if (keyb_clk_sreg == 6'b000111)
        keyb_data_sreg <= {keyb_data, keyb_data_sreg[10:1]};
end
 
 
 
//always block για το decoding του keyboard data (8bit) σε 6bit
//ξέρουμε (από το link που δόθηκε στην εκφώνηση) πως το 11bit scan code ξεκινάει με το start 
//bit (0) και τελειώνει με το parity bit καθώς και με το stop bit (1), άρα το "payload" είναι 
//τα 8 bits που απομένουν (Scan code), μετατρέψαμε τα αντίστοιχα HEX values από το scan table
//σε δυαδικo 6bit, οποτε ο παρακάτω decoder κάνει ακριβώς αυτό

always@(*) begin
	casex(keyb_data_sreg)
            11'bxx01110000x: begin //scan table του KEYPAD 0-> hex(70)
               keyb_data_sreg_dec = 6'b000000;
            end
            11'bxx01101001x: begin //scan table του KEYPAD 1-> hex(69)
               keyb_data_sreg_dec = 6'b000001;
            end
            11'bxx01110010x: begin //scan table του KEYPAD 2-> hex(72)
               keyb_data_sreg_dec = 6'b000010;
            end
            11'bxx01111010x: begin //scan table του KEYPAD 3-> hex(7A)
               keyb_data_sreg_dec = 6'b000011;
            end
            11'bxx01101011x: begin //scan table του KEYPAD 4-> hex(6B)
               keyb_data_sreg_dec = 6'b000100;
            end
            11'bxx01110011x: begin //scan table του KEYPAD 5-> hex(73)
               keyb_data_sreg_dec = 6'b000101;
            end
            11'bxx01110100x: begin //scan table του KEYPAD 6-> hex(74)
               keyb_data_sreg_dec = 6'b000110;
            end
            11'bxx01101100x: begin //scan table του KEYPAD 7-> hex(6C)
               keyb_data_sreg_dec = 6'b000111;
            end
            11'bxx01110101x: begin //scan table του KEYPAD 8-> hex(75)
               keyb_data_sreg_dec = 6'b001000;
            end
            11'bxx01111101x: begin //scan table του KEYPAD 9-> hex(7D)
               keyb_data_sreg_dec = 6'b001001;
            end
	    11'bxx01111011x: begin //scan table του KEYPAD - -> hex(7B)
               keyb_data_sreg_dec = 6'b110110; //το '-' το θεωρούμε ως το 110110 (-10)
            end
	    11'bxx01111001x: begin //scan table του KEYPAD + -> hex(7C)
                keyb_data_sreg_dec = 6'b110101; //το '+' το θεωρούμε ως το 110101 (-11)
            end
	    11'bxx01010101x: begin //scan table του = -> hex(55) x10101010xx
               keyb_data_sreg_dec = 6'b110100; //το '=' το θεωρούμε ως το 110100 (-12)
            end
		
	    //έχουμε βάλει να αναγνωρίζονται αριθμοί μονο του keypad, αν και θα μπορούσαμε να 
	    //κάναμε ακριβώς το ίδιο πράγμα  και για τους αριθμούς κάτω από τα F1-F9 κουμπιά 
	    //απλώς βάζοντας τις τιμές τους από το scan table
        //αλλα εφόσον δεν απαίτεται δε το κάναμε, άρα αν πατηθούν αυτοί τότε δεν επιτρέπονται 
	    //(θεωρούνται μη αριθμοί), και γενικώς ότι δεν ανήκει στα παραπάνω
	     default: begin
	        keyb_data_sreg_dec = 6'b100000; //100000: θεωρείται ένα άκυρο key
	    end
       endcase
   end





/* ========================= 

STATE MACHINE

   ========================= */


//ορίζουμε τις πιθανές καταστάσεις (one hot encoding)
parameter WAIT_OPERAND1 = 6'b000001;
parameter WAIT_OPERATOR = 6'b000010;
parameter WAIT_OPERAND2 = 6'b000100;
parameter WAIT_EQ = 6'b001000;
parameter WAIT_F0 = 6'b010000;
parameter AFTER_F0 = 6'b100000;

//καταχωρητές που κρατάνε τις καταστάσεις (τωρινή, καθώς και κατάσταση calculator)
reg [5:0] state;
reg [5:0] current_state;

//register που κρατάει τιμή για το αν έχουμε πρόσθεση ή αφαίρεση (true=αφαίρεση, false=πρόσθεση)
reg sub;
//register που κρατάει τη δυαδική τιμή των δύο αριθμών
reg [5:0] op1, op2;
//register sfalmatos
reg error;

//αποτέλεσμα είναι op1 + op2 XOR 6 φορες το sub (0 ή 1) + sub, άρα πχ για sub=1 -> op1 + (op2 XOR 111111) 
//+ 1, δηλαδή result θα έχει το αποτέλεσμα είτε της αφαίρεση είτε της πρόσθεσης σε μορφή συμπληρώματος ως προς 2
wire [5:0] result = op1 + (op2 ^ {6{sub}}) + sub;
//mux για να έρουμε αν o decoder2 θα δεχτεί το result ή το αποτέλεσμα του decoder1
wire [5:0] mux_out = (state==WAIT_EQ) ? result : keyb_data_sreg_dec;

//το FSM ξεκινάει εδώ τη λειτουργία του
always @(posedge clk or posedge reset) begin
   if (reset) begin
      state <= WAIT_OPERAND1; //το FSM ξεκινάει όταν περιμένει τον πρώτο αριθμό
      current_state <= WAIT_OPERAND1;
      error <= 0;
      sub <= 0;
      //αρχικοποίηση led να μην ανάβουν
      hex7_value <= 7'b1111111;
      hex6_value <= 7'b1111111;
      hex5_value <= 7'b1111111;
      hex4_value <= 7'b1111111;
      hex1_value <= 7'b1111111;
      hex0_value <= 7'b1111111;
      //αρχικοποίηση των register που κρατάνε τις τιμές των αριθμών στο 0
      op1 <= 0;
      op2 <= 0;
   end
   //σήμα enable, MONO αν έχουμε ένα πλήρες keyboard πακέτο πρέπει να δουλέψει το FSM
   else if(!keyb_data_sreg[0]) begin
      //ανάλογα σε ποιο state είμαστε κάνουμε τις απαραίτητες ενέργειες 
     case(state)
         WAIT_OPERAND1: begin
			//όταν περιμένουμε τον πρώτο αριθμό, όλα τα leds είναι σβηστά εκτός του πρώτου led
			 hex6_value <= 7'b1111111;
     	     hex5_value <= 7'b1111111;
      	     hex4_value <= 7'b1111111;
      	     hex1_value <= 7'b1111111;
             hex0_value <= 7'b1111111;
             //τώρα θέτρουμε τον καταχωρητή op1
			 op1 <= keyb_data_sreg_dec;
			 //αν decoder1 έχει άκυρη τιμή τότε bit σφάλματος 1, (δηλαδή είτε εντελώς άκυρη είτε +,- η =
             if (keyb_data_sreg_dec == 6'b100000 || keyb_data_sreg_dec== 6'b110110 || keyb_data_sreg_dec == 6'b110101 || keyb_data_sreg_dec == 6'b110100 ) begin
					error <= 1;
					//εμφάνιση του e
					hex7_value <= leds[13];	
			end
	     else begin
			error <=0;
			//τώρα θέτουμε τον καταχωρητή του πρώτου led στην τιμή που βγάζει ο δεύτερος decoder
	        hex7_value <= led1;
	     end
		//προχωράμε τις καταστάσεις
		current_state <= state;
        state <= WAIT_F0;
	 end
	 WAIT_OPERATOR: begin
	     //περιμένουμε "+" ή "-"
	     if (keyb_data_sreg_dec == 6'b110110 || keyb_data_sreg_dec ==6'b110101) begin
		     error <=0;
		    //έλεγχος αν πατήθηκε το - ή to +
		    if (keyb_data_sreg_dec == 6'b110110)
		        sub <= 1; //αφαίρεση
		    else begin
		        sub <=0; //πρόσθεση
		    end
			//εμφάνιση στο 2ο led display τον operator
			hex6_value <= led1;
	    end
	    //σφάλμα αν δεν έρθει - ή +
	     else begin
			 error <= 1;
			 //εμφάνιση του e
	    	 hex6_value <= leds[13];
	     end
	     //προχωράμε τις καταστάσεις
	     current_state <= state;
	     state <= WAIT_F0;
         end
		 
		 //περιμένουμε τον δεύτερο αριθμό
         WAIT_OPERAND2: begin
		//τώρα θέτουμε τον καταχωρητή op2
	     op2 <= keyb_data_sreg_dec;
         if (keyb_data_sreg_dec == 6'b100000 || keyb_data_sreg_dec== 6'b110110 || keyb_data_sreg_dec == 6'b110101 || keyb_data_sreg_dec == 6'b110100 ) begin
		    //αν σφάλμα τότε καταχωρητής τρίτου display να εμφανίσει το e
			error <= 1;
			hex5_value <= leds[13];
	     end
	     else begin
			error <=0;
			//καταχωρητής τρίτου display -> 2ος αριθμός
	        hex5_value <= led1;
	     end
		current_state <= state;
		state <= WAIT_F0;
	 end
	 //περιμένουμε το "="
     WAIT_EQ: begin
	   //αν έρθει το "="
	   if (keyb_data_sreg_dec == 6'b110100) begin
			error <=0;
			hex4_value <= leds[12]; //hex4 σύμβολο "="
			hex1_value <= led1; //hex1 το πιο σημαντικό ψηφίο ή το "-"
			hex0_value <= led2; //λιγότερο σημαντικό (αν υπάρχει)
		
	   end
	   else begin
	      error <=1;
	      hex4_value <= leds[13]; //εμφάνιση του "e"
	   end
	   current_state <= state;
	   state <= WAIT_F0;
       end
	   
	   /*ΚΑΤΑΣΤΑΣΕΙΣ WAIT_F0 ΚΑΙ AFTER_F0 */
	   
	   //WAIT_F0: αναμένουμε το F0 και προχωράμε τη κατάσταση στην AFTER_F0
       WAIT_F0: begin
	   //έλεγχος του scan code, περιμένουμε να είναι του F0
            casex(keyb_data_sreg)
				11'bxx11110000x: begin
					state <= AFTER_F0;
	        end
            default: begin
                state <= WAIT_F0;
            end
         endcase
	end
    AFTER_F0: begin
	   //εφόσον λάβουμε το F0, πρέπει να αποφασίσουμε σε ποιο state να πάμε
	   //auto γίνεται χάρης στο current_state
	    if (error)
			//καταρχήν αν έχουμε σφάλμα δεν αλλάζουμε state στον calculator
			state <= current_state;
	    else begin
			//αν δεν υπάρχει σφάλμα πάμε στην επομενη κατάσταση
			if (current_state == WAIT_OPERAND1)
				state <= WAIT_OPERATOR;
            else if (current_state == WAIT_OPERATOR)
				state <= WAIT_OPERAND2;
			else if (current_state == WAIT_OPERAND2)
				state <= WAIT_EQ;
			else if (current_state == WAIT_EQ) begin
				state <= WAIT_OPERAND1;
	        end
	    end
    end
	//σαν reset είναι σε οποιαδήποτε άλλη περίπτωση (ώστε να μη προκύψει latch)
         default: begin
       	     state <= WAIT_OPERAND1; 
    	     current_state <= WAIT_OPERAND1;
     	     error <= 0;
     	     sub <= 0;
       	     //αρχικοποίηση led να μην ανάβουν
     	     hex7_value <= 7'b1111111;
     	     hex6_value <= 7'b1111111;
     	     hex5_value <= 7'b1111111;
     	     hex4_value <= 7'b1111111;
     	     hex1_value <= 7'b1111111;
     	     hex0_value <= 7'b1111111;
      	     //αρχικοποίηση των register που κρατάνε τις τιμές των αριθμών στο 0
     	     op1 <= 0;
     	     op2 <= 0;

         end
     endcase
   end

end


//always block για το decoding του decoded keyboard data register (δηλαδή ο 6bit δυαδικός θα γίνει decode
//ώστε να ανάψει το κατάλληλο led με τη βοήθεια του leds πινακα) η αν έχει πατηθεί το "=" 
//τότε να γίνει decode το αποτέλεσμα της πράξης
always @(*) begin
		case(mux_out)
			6'b000000: begin
			   led1 = leds[0]; //έξοδος -> να ανάψει το 0
			   led2 = 7'b1111111;
			end
			6'b000001: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 1
			   led2 = 7'b1111111;
			end
			6'b000010: begin
			   led1 = leds[2]; //έξοδος -> να ανάψει το 2
			   led2 = 7'b1111111;
			end
			6'b000011: begin
			   led1= leds[3];  //έξοδος -> να ανάψει το 3
			   led2 = 7'b1111111;
			end
			6'b000100: begin
			   led1 = leds[4]; //έξοδος -> να ανάψει το 4
			   led2 = 7'b1111111;
			end
			6'b000101: begin
			   led1 = leds[5]; //έξοδος -> να ανάψει το 5
			   led2 = 7'b1111111;
			end
			6'b000110: begin
			   led1 = leds[6]; //έξοδος -> να ανάψει το 6
			   led2 = 7'b1111111;
			end
			6'b000111: begin
			   led1 = leds[7]; //έξοδος -> να ανάψει το 7
			   led2 = 7'b1111111;
			end
			6'b001000: begin
			   led1 = leds[8]; //έξοδος -> να ανάψει το 8
			   led2 = 7'b1111111;
			end
			6'b001001: begin
			   led1 = leds[9]; //έξοδος -> να ανάψει το 9
			   led2 = 7'b1111111;
			end
			6'b001010: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 10
               led2 = leds[0];
			end
			6'b001011: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 11
               led2 = leds[1];
			end
			6'b001100: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 12
               led2 = leds[2];
			end
			6'b001101: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 13
               led2 = leds[3];
			end
			6'b001110: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 14
               led2 = leds[4];
			end
			6'b001111: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 15
               led2 = leds[5];
			end
			6'b010000: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 16
               led2 = leds[6];
			end
			6'b010001: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 17
               led2 = leds[7];
			end
			6'b010010: begin
			   led1 = leds[1]; //έξοδος -> να ανάψει το 18
               led2 = leds[8];
			end
			

			6'b111111: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -1
			   led2 = leds[1];
			end
			6'b111110: begin 
			   led1 = leds[10]; //έξοδος -> να ανάψει το -2
			   led2 = leds[2];
			end
			6'b111101: begin 
			   led1 = leds[10]; //έξοδος -> να ανάψει το -3
			   led2 = leds[3];
			end
			6'b111100: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -4
			   led2 = leds[4];
			end
			6'b111011: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -5
			   led2 = leds[5];
			end
			6'b111010: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -6
			   led2 = leds[6];
			end
			6'b111001: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -7
			   led2 = leds[7];
			end
			6'b111000: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -8
			   led2 = leds[8];
			end
			6'b110111: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -9
			   led2 = leds[9];
			end


			6'b110110: begin
			   led1 = leds[10]; //έξοδος -> να ανάψει το -
			   led2 = 7'b1111111;
			end
			6'b110101: begin
			   led1 = leds[11]; //έξοδος -> να ανάψει το + (π)
			   led2 = 7'b1111111;
			end
			6'b110100: begin
			   led1 = leds[12]; //έξοδος -> να ανάψει το =
			   led2 = 7'b1111111;
			end

			//άκυρη τιμή
			default: begin
			   led1 = leds[13]; ////έξοδος -> να ανάψει το "e" (leds[13]= άναμμα του "e")
			   led2 = 7'b1111111;
			end
		endcase
  	 end


endmodule
