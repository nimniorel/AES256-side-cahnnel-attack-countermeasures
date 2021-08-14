module KeyExpantion_256(
	input						Clk,
	input						Reset,
	input			[2:0]		Multi_State,
	input			[N-1:0]		In_Key_T,
	input			[N-1:0]		In_Key_F,
	input			[ROUND-1:0]	Round_Number_T,
	input			[ROUND-1:0]	Round_Number_F,
	input                       flipflpoindicator,
	output reg	[N-1:0]		    Out_Key_T,
	output reg	[N-1:0]		    Out_Key_F
);

	parameter N = 256; //input size
	parameter WORD = 32; //number of bits in a word
	parameter ROUND=4; //number of rounds in bits
	
	wire	[N-1:0]		Out_T;
	wire	[N-1:0]		Out_F;
	wire	[WORD-1:0]	Rcon_output_T, Rot_output_T, Sub_output_T, WORD_4_out_T;
	wire	[WORD-1:0]	Rcon_output_F, Rot_output_F, Sub_output_F, WORD_4_out_F;
	wire	[ROUND-1:0]	Round_num_in_wire_T;
	wire	[ROUND-1:0]	Round_num_in_wire_F;
	reg	[1:0]		Sbox_State_1, Sbox_State_2;
	
	Rcon rcon(
		.Round_number_T(Round_num_in_wire_T),
		.Round_number_F(Round_num_in_wire_F),
		.Out_word_T(Rcon_output_T),
		.Out_word_F(Rcon_output_F)
	); //rcon output

	RotWord rot(
		.Input_Word_T(In_Key_T[WORD-1-:WORD]),
		.Input_Word_F(In_Key_F[WORD-1-:WORD]),
		.Output_Word_T(Rot_output_T),
		.Output_Word_F(Rot_output_F)
	); //rotate LSB word
		
	SubWord sub1(
		.Clk(Clk),
		.Reset(Reset),
		.Multi_Cycle_State(Sbox_State_1),
		.In_Word_T(Rot_output_T),
		.In_Word_F(Rot_output_F),
		.flipflpoindicator(flipflpoindicator),
		.Out_Word_T(Sub_output_T),
		.Out_Word_F(Sub_output_F)
	); //sub-bytes for Rotate word

	SubWord sub2(
		.Clk(Clk),
		.Reset(Reset),
		.Multi_Cycle_State(Sbox_State_2),
		.In_Word_T(Out_T[(N-3*WORD-1)-:WORD]),
		.In_Word_F(Out_F[(N-3*WORD-1)-:WORD]),
		.flipflpoindicator(flipflpoindicator),
		.Out_Word_T(WORD_4_out_T),
		.Out_Word_F(WORD_4_out_F)
	);

	//sub-bytes for the 4th word

	//calcultaing next round key

	assign Round_num_in_wire_T = Round_Number_T + 4'd1;
	assign Round_num_in_wire_F = Round_Number_F - 4'd1;

	
	always @(*) begin
	
	case (Multi_State)
	
	3'd0: begin
	Sbox_State_1 = 0;
	Sbox_State_2 = 0;
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	
	3'd1: begin
	Sbox_State_1 = 2'd1;
	Sbox_State_2 = 0;
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	
	3'd2: begin
	Sbox_State_1 = 2'd2;
	Sbox_State_2 = 0;
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	
	3'd3: begin
	Sbox_State_1 = 2'd3;
	Sbox_State_2 = 2'd1;
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end

	3'd4: begin
	Sbox_State_1 = 2'd3;
	Sbox_State_2 = 2'd2; 
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	
	3'd5: begin
	Sbox_State_1 = 2'd3;
	Sbox_State_2 = 3;
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

	end
	
	3'd6: begin
	Sbox_State_1 = 0;
	Sbox_State_2 = 0;
	Out_Key_T = 0;
	Out_Key_F =256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	
	3'd7: begin
	Sbox_State_1 = 2'd3;
	Sbox_State_2 = 2'd3;
	Out_Key_T = Out_T;
	Out_Key_F = Out_F;
	
	end	
	default: begin
	Sbox_State_1 = 0;
	Sbox_State_2 = 0;
	Out_Key_T = 0;
	Out_Key_F = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	end
	 
	endcase
	
end
	
	
//		Out_T[(N-1)-:WORD] 		<= In_Key_T[(N-1)-:WORD]^Sub_output_T^Rcon_output; //MSB
	XOR3_WORD XOR3_WORD(
		.In1_T(In_Key_T[(N-1)-:WORD]),
		.In1_F(In_Key_F[(N-1)-:WORD]),
		.In2_T(Sub_output_T),
		.In2_F(Sub_output_F),
		.In3_T(Rcon_output_T),
		.In3_F(Rcon_output_F),
		.Out_T(Out_T[(N-1)-:WORD]),
		.Out_F(Out_F[(N-1)-:WORD])
	);

//		Out_T[(N-WORD-1)-:WORD]    <= In_Key_T[(N-WORD-1)-:WORD]^Out_T[(N-1)-:WORD];		
	XOR_WORD XOR_WORD_1(
		.In1_T(In_Key_T[(N-WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-WORD-1)-:WORD]),
		.In2_T(Out_T[(N-1)-:WORD]),
		.In2_F(Out_F[(N-1)-:WORD]),
		.Out_T(Out_T[(N-WORD-1)-:WORD]),
		.Out_F(Out_F[(N-WORD-1)-:WORD])
	);

//		Out_T[(N-2*WORD-1)-:WORD]  <= In_Key_T[(N-2*WORD-1)-:WORD]^Out_T[(N-WORD-1)-:WORD];
	XOR_WORD XOR_WORD_2(
		.In1_T(In_Key_T[(N-2*WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-2*WORD-1)-:WORD]),
		.In2_T(Out_T[(N-WORD-1)-:WORD]),
		.In2_F(Out_F[(N-WORD-1)-:WORD]),
		.Out_T(Out_T[(N-2*WORD-1)-:WORD]),
		.Out_F(Out_F[(N-2*WORD-1)-:WORD])
	);		

//		Out_T[(N-3*WORD-1)-:WORD]  <= In_Key_T[(N-3*WORD-1)-:WORD]^Out_T[(N-2*WORD-1)-:WORD];
	XOR_WORD XOR_WORD_3(
		.In1_T(In_Key_T[(N-3*WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-3*WORD-1)-:WORD]),
		.In2_T(Out_T[(N-2*WORD-1)-:WORD]),
		.In2_F(Out_F[(N-2*WORD-1)-:WORD]),
		.Out_T(Out_T[(N-3*WORD-1)-:WORD]),
		.Out_F(Out_F[(N-3*WORD-1)-:WORD])
	);

//		Out_T[(N-4*WORD-1)-:WORD]  <= In_Key_T[(N-4*WORD-1)-:WORD]^WORD_4_out_T;
	XOR_WORD XOR_WORD_4(
		.In1_T(In_Key_T[(N-4*WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-4*WORD-1)-:WORD]),
		.In2_T(WORD_4_out_T),
		.In2_F(WORD_4_out_F),
		.Out_T(Out_T[(N-4*WORD-1)-:WORD]),
		.Out_F(Out_F[(N-4*WORD-1)-:WORD])
	);

//		Out_T[(N-5*WORD-1)-:WORD]  <= In_Key_T[(N-5*WORD-1)-:WORD]^Out_T[(N-4*WORD-1)-:WORD];
	XOR_WORD XOR_WORD_5(
		.In1_T(In_Key_T[(N-5*WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-5*WORD-1)-:WORD]),
		.In2_T(Out_T[(N-4*WORD-1)-:WORD]),
		.In2_F(Out_F[(N-4*WORD-1)-:WORD]),
		.Out_T(Out_T[(N-5*WORD-1)-:WORD]),
		.Out_F(Out_F[(N-5*WORD-1)-:WORD])
	);		

//		Out_T[(N-6*WORD-1)-:WORD]  <= In_Key_T[(N-6*WORD-1)-:WORD]^Out_T[(N-5*WORD-1)-:WORD];

	XOR_WORD XOR_WORD_6(
		.In1_T(In_Key_T[(N-6*WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-6*WORD-1)-:WORD]),
		.In2_T(Out_T[(N-5*WORD-1)-:WORD]),
		.In2_F(Out_F[(N-5*WORD-1)-:WORD]),
		.Out_T(Out_T[(N-6*WORD-1)-:WORD]),
		.Out_F(Out_F[(N-6*WORD-1)-:WORD])
	);

//		Out_T[(N-7*WORD-1)-:WORD]  <= In_Key_T[(N-7*WORD-1)-:WORD]^Out_T[(N-6*WORD-1)-:WORD];
	XOR_WORD XOR_WORD_7(
		.In1_T(In_Key_T[(N-7*WORD-1)-:WORD]),
		.In1_F(In_Key_F[(N-7*WORD-1)-:WORD]),
		.In2_T(Out_T[(N-6*WORD-1)-:WORD]),
		.In2_F(Out_F[(N-6*WORD-1)-:WORD]),
		.Out_T(Out_T[(N-7*WORD-1)-:WORD]),
		.Out_F(Out_F[(N-7*WORD-1)-:WORD])
	);	
	
	
		
	endmodule
	