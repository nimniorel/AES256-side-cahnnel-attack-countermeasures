module ShiftRows (
	input	[N-1:0]	Text_In_T,
	input	[N-1:0]	Text_In_F,
	output 	[N-1:0]	Out_Text_T,
	output 	[N-1:0]	Out_Text_F
);	
	// module name and ports list.
	//parameters declaration
	parameter N=128; //inputs size
	parameter BYTE =8; //number of bits in a byte
	parameter WORD = 32; //number of bits in a word
	
	//TRUE
	//first row
	assign Out_Text_T[WORD-1:0] = {Text_In_T[(WORD-1):(WORD-BYTE)],Text_In_T[(N-BYTE-1):(N-2*BYTE)],Text_In_T[(2*WORD+2*BYTE-1):(2*WORD+BYTE)],
										Text_In_T[(WORD+BYTE-1):(WORD)]};
	//second row
	assign Out_Text_T[2*WORD-1-:WORD] = {Text_In_T[(2*WORD-1)-:BYTE],Text_In_T[(3*BYTE-1)-:BYTE],Text_In_T[(3*WORD+2*BYTE-1)-:BYTE],
					Text_In_T[(2*WORD+BYTE-1)-:BYTE]};
	//third row				
	assign Out_Text_T[3*WORD-1-:WORD] = {Text_In_T[(3*WORD-1)-:BYTE],Text_In_T[(2*WORD-BYTE-1)-:BYTE],Text_In_T[(2*BYTE-1)-:BYTE],
					Text_In_T[(3*WORD+BYTE-1)-:BYTE]};
	//forth word				
	assign Out_Text_T[4*WORD-1-:WORD] = {Text_In_T[(4*WORD-1)-:BYTE],Text_In_T[(3*WORD-BYTE-1)-:BYTE],Text_In_T[(2*WORD-2*BYTE-1)-:BYTE],
					Text_In_T[(BYTE-1)-:BYTE]};
//FALSE
	//first row
	assign Out_Text_F[WORD-1:0] = {Text_In_F[(WORD-1):(WORD-BYTE)],Text_In_F[(N-BYTE-1):(N-2*BYTE)],Text_In_F[(2*WORD+2*BYTE-1):(2*WORD+BYTE)],
										Text_In_F[(WORD+BYTE-1):(WORD)]};
	//second row
	assign Out_Text_F[2*WORD-1-:WORD] = {Text_In_F[(2*WORD-1)-:BYTE],Text_In_F[(3*BYTE-1)-:BYTE],Text_In_F[(3*WORD+2*BYTE-1)-:BYTE],
					Text_In_F[(2*WORD+BYTE-1)-:BYTE]};
	//third row				
	assign Out_Text_F[3*WORD-1-:WORD] = {Text_In_F[(3*WORD-1)-:BYTE],Text_In_F[(2*WORD-BYTE-1)-:BYTE],Text_In_F[(2*BYTE-1)-:BYTE],
					Text_In_F[(3*WORD+BYTE-1)-:BYTE]};
	//forth word				
	assign Out_Text_F[4*WORD-1-:WORD] = {Text_In_F[(4*WORD-1)-:BYTE],Text_In_F[(3*WORD-BYTE-1)-:BYTE],Text_In_F[(2*WORD-2*BYTE-1)-:BYTE],
					Text_In_F[(BYTE-1)-:BYTE]};

endmodule
