module fibonacci_behavioural_simulation(
    input clk,
    input reset,
	//η έξοδος είναι οι τιμές που πρέπει να πάρουν τα τρία 7bit displays.
    output [6:0] hex0,
    output [6:0] hex1,
    output [6:0] hex2
);

reg[7:0] prev;
reg[7:0] cur;
reg[6:0] hex0_value;
reg[6:0] hex1_value;
reg[6:0] hex2_value;
wire enable;
reg [24:0] delay_counter; 

reg [6:0] leds [0:10]; //ένας πίνακας 10 θέσεων στον οποίο κάθε θέση είναι 7bit και αναπαριστά ένα αναμμένο led

assign enable = (delay_counter == 25'd24999999) ? 1'b1: 1'b0; //enable γίνεται ίσο με 1 μόνο όταν ο μετρητής φτάσει στο τέλης της μέτρησης
assign hex0 = hex0_value;
assign hex1 = hex1_value;
assign hex2 = hex2_value;

//εδώ είναι ο μετρητής
always @ (posedge clk or posedge reset) begin
    if (reset)
        delay_counter <= 25'd0;
    else if (enable)
        delay_counter <= 25'd0;
    else
	delay_counter <= delay_counter + 1'b1;
end

//το βασικό κύκλωμα για το fibonacci
always @(posedge clk or posedge reset) begin
    if (reset) begin
        prev <= 8'b00000000;
        cur <= 8'b00000001;
		delay_counter <= 25'd0;
		//οι τιμές αυτές προκύπτουν έτσι επειδή θέλουμε να ανάβουν οι σωστές "παυλίτσες" των leds.
		//πχ για το 0 να είναι όλες εκτός της μεσαίας η οποία είναι το γράμμα 'G', δηλαδή το hex[6], και επειδή τα leds ανάβουν με 0,
		//εμείς θα θέσουμε με 0 όλα εκτός από τη 1η θέση (η οποία είναι η 6η, η "G"). Με παρόμοιο τρόπο βγαίνουν και οι υπόλοιπες τιμές.
		leds[0] <= 7'b1000000; //ανάβει το 0
		leds[1] <= 7'b1111001; //ανάβει το 1
		leds[2] <= 7'b0100100; //ανάβει το 2
		leds[3] <= 7'b0110000; //ανάβει το 3
		leds[4] <= 7'b0011001; //ανάβει το 4
		leds[5] <= 7'b0010010; //ανάβει το 5
		leds[6] <= 7'b0000010; //ανάβει το 6
		leds[7] <= 7'b1111000; //ανάβει το 7
		leds[8] <= 7'b0000000;//ανάβει το 8
		leds[9] <= 7'b0010000; //ανάβει το 9
		leds[10] <= 7'b0111111; //ανάβει το - (άκυρη τιμή)
    end
	//επιτρέπεται να "προχωρήσει" το κύκλωμα παρακάτω μόνο αν ο μετρητής έχει τελειώσει να μετράει
    else if (enable == 1) begin
       prev <= cur;
       cur <= prev + cur;
    end
end

//εδώ είναι ο decoder, μόνο για τις τιμές που μας ενδιαφέρουν ανάβουμε τα leds, δηλαδή για τις τιμές 0,1,2,...233, για την ακολουθία fibonacci δηλαδή
always @(*) begin
	case (prev)
		8'b00000000: begin//0 
			hex0_value = leds[0]; //0
			hex1_value = leds[0]; //0
			hex2_value = leds[0]; //0
		end
		8'b00000001: begin//1
			hex0_value = leds[1]; //1
			hex1_value = leds[0]; //0
			hex2_value = leds[0]; //0
		end
		8'b00000010: begin//2
			hex0_value = leds[2]; //2
			hex1_value = leds[0]; //0
			hex2_value = leds[0]; //0
		end
		8'b00000011: begin//3
			hex0_value = leds[3]; //3
			hex1_value = leds[0]; //0
			hex2_value = leds[0]; //0
		end
		8'b00000101: begin//5
			hex0_value = leds[5]; //5
			hex1_value = leds[0]; //0
			hex2_value = leds[0]; //0
		end
		8'b00001000: begin//8
			hex0_value = leds[8]; //8
			hex1_value = leds[0]; //0
			hex2_value = leds[0]; //0
		end
		8'b00001101: begin//13
			hex0_value = leds[3]; //3
			hex1_value = leds[1]; //1
			hex2_value = leds[0]; //0
		end
		8'b00010101: begin//21
			hex0_value = leds[1]; //1
			hex1_value = leds[2]; //2
			hex2_value = leds[0]; //0
		end
		8'b00100010: begin//34
			hex0_value = leds[4]; //4
			hex1_value = leds[3]; //3
			hex2_value = leds[0]; //0
		end
		8'b00110111: begin//55
			hex0_value = leds[5]; //5
			hex1_value = leds[5]; //5
			hex2_value = leds[0]; //0
		end
		8'b01011001: begin//89
			hex0_value = leds[9]; //9
			hex1_value = leds[8]; //8
			hex2_value = leds[0]; //0
		end
		8'b10010000: begin//144
			hex0_value = leds[4]; //4
			hex1_value = leds[4]; //4
			hex2_value = leds[1]; //1
		end
		8'b11101001: begin//233
			hex0_value = leds[3]; //3
			hex1_value = leds[3]; //3
			hex2_value = leds[2]; //2
		end
		default: begin
			hex0_value = leds[10]; //-
			hex1_value = leds[10]; //-
			hex2_value = leds[10]; //-
		end
	endcase
end
endmodule

