
module AES_TOP(
	input		TOP_ResetAll,
	input		TOP_Clk,
	output	CompareFlag_p,
	output	CompareFlag_f,
	output	trigger
);


	wire  Reset;
	wire Done;
	wire flipflpoindicator;
	
	
	
	
	
	wire [255:0] In_Key_T;
	wire [255:0] In_Key_F;
	wire [127:0] Plain_In_T,Plain_In_F;
	wire [127:0] Cipher_text_T,Cipher_text_F;
	wire local_clk;
	//Conection between the feedback control unit and the encrypt unit	
   My_Clock1(
 
  .CLK_IN1(TOP_Clk),
  .CLK_OUT1(local_clk)
 );
	
	
	AES256_tb_SboxStateVerify TB(
								 .Cipher_in_T(Cipher_text_T),
								 .Cipher_in_F(Cipher_text_F),
								 .ResetAll(TOP_ResetAll),
								 .flipflpoindicator(flipflpoindicator),
								 .Clk(local_clk),
								 .Done(Done),
								 .Plain_Text_T(Plain_In_T),
								 //.Plain_Text_F(),
								 .Reset(Reset),
								 .Key_T(In_Key_T),
								 
								 
								 
								 
								//.Key_F(),
								 .compareFlag(CompareFlag_p),
								 .compareFlag_f(CompareFlag_f)
	);

	//WDDL_AES256_FSMSboxState AES256(Clk,Plain_In,Reset,In_Key,Cipher_text,Done,trigger);

	Regular_AES256_FSMSboxState AES256(
		.Clk(local_clk),
		.Plain_text_T(Plain_In_T),
		.flipflpoindicator(flipflpoindicator),
		.Reset(Reset),
		.In_Key_T(In_Key_T),
		.Cipher_text_T(Cipher_text_T),
		.Cipher_text_F(Cipher_text_F),
		.Done(Done),
		.trigger(trigger)
	);
	

endmodule