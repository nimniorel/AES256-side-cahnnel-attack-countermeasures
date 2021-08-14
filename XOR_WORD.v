//this module input variables of WORD and XOR it in WDDL type 

module 	XOR_WORD(
	
	input	[WORD-1:0]	In1_T,
	input	[WORD-1:0]	In1_F,
	input	[WORD-1:0]	In2_T,	
	input	[WORD-1:0]	In2_F,	
	output	[WORD-1:0]	Out_T,
	output	[WORD-1:0]	Out_F
);
	
	parameter WORD = 32;
		
	genvar i;
	generate
	for (i=0;i<WORD;i=i+1)
	begin: xoring

		XOR_GATE XOR1(
			.A_t(In1_T[i]),
			.A_f(In1_F[i]),
			.B_t(In2_T[i]),
			.B_f(In2_F[i]),
			.O_t(Out_T[i]),
			.O_f(Out_F[i])
		);
	
	end
	
	endgenerate
	
endmodule
