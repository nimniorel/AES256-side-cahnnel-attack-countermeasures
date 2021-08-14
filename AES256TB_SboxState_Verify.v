module AES256_tb_SboxStateVerify (Cipher_in_T,
Cipher_in_F,flipflpoindicator,
,ResetAll,Clk,Done,Plain_Text_T,Plain_Text_F,Reset,Key_T,Key_F,compareFlag,compareFlag_f) ;
	parameter N = 128; //input size
	parameter N_key = 256; //key size
	parameter num_inputs =1010 ; //number of iterations WAS 65280
	parameter DELAY = 661;

	input Clk,Done,ResetAll;
	input [N-1:0] Cipher_in_T;
	input [N-1:0] Cipher_in_F;
	input         flipflpoindicator;
	(* KEEP = "true" *) output reg [N-1:0] Plain_Text_T;
	(* KEEP = "true" *) output reg [N-1:0] Plain_Text_F;
	(* KEEP = "true" *) output [N_key-1:0] Key_T;
	(* KEEP = "true" *) output [N_key-1:0] Key_F;
	(* KEEP = "true" *) output reg compareFlag;
	(* KEEP = "true" *) output reg compareFlag_f;
	                    output reg Reset; 
    
	reg       flipflpoindicator2;
	reg [15:0] total_counter; //count 65280 iterations
	reg [2:0] state;
	reg [9:0] delayCounter;
	reg       Done2;
  
	

	//STATE = 0 - PRESENT IDLE, WAITING FOR RESET_ALL TRIGGER
	//STATE = 1 - RESET_ALL TRIGGER OCCURED
	//STATE = 2 - INITIALIZE THE SYSTEM
	//STATE = 3 - ENCRYPTION PROCESS, SINGLE TRACE, SAMPLING THE CIPHER_TEXT AT DONE SIGNAL AND NOT DURING THE PRECHATGE PHASE
	//STATE = 4 - MAKING A DELAY BETWEEN TWO ENCRYPTIONS
	
	assign Key_T = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
	assign Key_F = 256'hFFEEDDCCBBAA99887766554433221100FFEEDDCCBBAA99887766554433221100;
	
	always@ (posedge Clk)begin
		case(state)
			3'h0 : begin
			 total_counter <= 16'b0;
            (* dont_touch = "true" *) Plain_Text_T <= 128'b0;
            (* dont_touch = "true" *) Plain_Text_F <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            //compareFlag <= 0;
	         (* dont_touch = "true" *) delayCounter <= 0;
				if (ResetAll)begin
					state <= 1;
					Reset <= 1;
					compareFlag <= 0;
					compareFlag_f <= 0;
					(* dont_touch = "true" *) delayCounter <= 0;
				end
				else begin
					state <= 0;
					
				end	
				
			end
			3'h1 : begin
				if (!ResetAll)
					state <= 2;
				else
					state <= 1;
			end
			3'h2 : begin
				total_counter <= 0;
				Reset <= 1;
				(* dont_touch = "true" *) Plain_Text_T <= 128'b0;
				(* dont_touch = "true" *) Plain_Text_F <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

				state <= 3;	
			end
			3'h3 : begin
				if ((Done2)&&(flipflpoindicator2))begin
					state <= 4;
					Plain_Text_T <= Cipher_in_T;
					Plain_Text_F <= Cipher_in_F;
					total_counter <= total_counter + 1;
					Reset <= 1;

					if ((Cipher_in_T == 128'h0ac204a018dea065bb094af9225cd4b7) && (Cipher_in_F == 128'hf53dfb5fe7215f9a44f6b506dda32b48)) begin //for 1000 traces
						compareFlag <= 1;
						compareFlag_f <= 1;
							
				end
				end
				else begin
					(* dont_touch = "true" *) delayCounter <= 0;
					Reset <= 0;
				end
			end

			3'h4 :begin
				delayCounter <= delayCounter + 1;
				if (delayCounter == DELAY)
					state <= 5;
				else
					state <= 4;
			end
						
			3'h5 :begin
				//state <= 0;
				if (total_counter < num_inputs)begin //count to 'num_inputs'
					state <= 3;
				end
				else begin //encrypting done
					state <= 0;

				end
			end
			
//			3'h6 :begin
//				state <= 0;
			
			//end
			default : state <= 0;
		endcase

	end
	//delayed in 1 clock to sync the feedback
    always@ (posedge Clk)begin
    Done2<=Done;
    flipflpoindicator2<=flipflpoindicator;
    end	
//initial begin
//	state <= 0;
//	total_counter <= 16'b0;
	
//	(* dont_touch = "true" *) Plain_Text_T <= 128'b0;
//	(* dont_touch = "true" *) Plain_Text_F <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

//	//countStates <= 0;
//	compareFlag <= 0;
//	(* dont_touch = "true" *) delayCounter <= 0;
//	//Reset <= 1'b1;

//end

endmodule