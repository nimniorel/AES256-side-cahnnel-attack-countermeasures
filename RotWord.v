module RotWord (
	input	[WORD-1:0]	Input_Word_T,
	input	[WORD-1:0]	Input_Word_F,
	output	[WORD-1:0]	Output_Word_T,
	output	[WORD-1:0]	Output_Word_F
);		// module name and ports list.
	//parameters declaration
	parameter BYTE =8; //number of bits in a byte
	parameter WORD = 32; //number of bits in a word

	//rotating the word
	assign Output_Word_T[WORD-1-:WORD] = {Input_Word_T[(3*BYTE-1)-:BYTE],Input_Word_T[(2*BYTE-1)-:BYTE],Input_Word_T[(BYTE-1)-:BYTE],
					Input_Word_T[(WORD-1)-:BYTE]};
    assign Output_Word_F[WORD-1-:WORD] = {Input_Word_F[(3*BYTE-1)-:BYTE],Input_Word_F[(2*BYTE-1)-:BYTE],Input_Word_F[(BYTE-1)-:BYTE],
    Input_Word_F[(WORD-1)-:BYTE]};
    
endmodule
