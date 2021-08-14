 module SubWord (
	input				Clk,
	input			 	Reset,
	input	[1:0]		Multi_Cycle_State,
	input	[WORD-1:0]	In_Word_T,
	input	[WORD-1:0]	In_Word_F,
	input               flipflpoindicator,
	output	[WORD-1:0]	Out_Word_T,
	output	[WORD-1:0]	Out_Word_F
);		
	// module name and ports list.
	//parameters declaration
	
	parameter BYTE =8; //number of bits in a byte
	parameter WORD = 32; //number of bits in a word
	
	
	genvar i;
	//using s-box 4 times
	generate
			for (i=0;i<(WORD/BYTE);i=i+1)
				begin: sbox
					Sbox8b sbox (
						.Clk(Clk),
						.Reset(Reset),
						.multi_cycle(Multi_Cycle_State),
						.Sbox_In_T(In_Word_T[i*BYTE+:BYTE]),
						.Sbox_In_F(In_Word_F[i*BYTE+:BYTE]),
						.flipflpoindicator(flipflpoindicator),
						.Sbox_Out_T(Out_Word_T[i*BYTE+:BYTE]),
						.Sbox_Out_F(Out_Word_F[i*BYTE+:BYTE])
					);
				end
	endgenerate
	
endmodule