module xmult (
	input 	[BYTE-1:0]	Input_Byte_T,
	input 	[BYTE-1:0]	Input_Byte_F,
	output	[BYTE-1:0]	Output_Byte_T,
	output	[BYTE-1:0]	Output_Byte_F
);
	// checks the MSB of the Input_Byte: if it is 0 ?ƒ  shift left
	// if it is a 1 ?ƒ  shift to the left and XOR with {1B}.
	
	parameter BYTE = 8;
	wire tmpXOR1_T,tmpXOR3_T,tmpXOR4_T;
	wire tmpXOR1_F,tmpXOR3_F,tmpXOR4_F;
	

	XOR_GATE XOR_1(
		.A_t(Input_Byte_T[0]),
		.A_f(Input_Byte_F[0]),
		.B_t(1'b1),
		.B_f(1'b0),
		.O_t(tmpXOR1_T),
		.O_f(tmpXOR1_F)
	);
	
	XOR_GATE XOR_2(
		.A_t(Input_Byte_T[2]),
		.A_f(Input_Byte_F[2]),
		.B_t(1'b1),
		.B_f(1'b0),
		.O_t(tmpXOR3_T),
		.O_f(tmpXOR3_F)
	);
	
	XOR_GATE XOR_3(
		.A_t(Input_Byte_T[3]),
		.A_f(Input_Byte_F[3]),
		.B_t(1'b1),
		.B_f(1'b0),
		.O_t(tmpXOR4_T),
		.O_f(tmpXOR4_F)
	);
	
	
	assign Output_Byte_T[0] = (!Input_Byte_T[7]) ? 1'b0 : 1'b1;
	assign Output_Byte_F[0] = (!Input_Byte_F[7]) ? 1'b0 : 1'b1;
//	assign Output_Byte_T[1] = (!Input_Byte_T[7]) ? Input_Byte_T[0] : tmpXOR1_T;
//	assign Output_Byte_F[1] = (!Input_Byte_F[7]) ? Input_Byte_F[0] : tmpXOR1_F;
	assign Output_Byte_T[1] = (!Input_Byte_T[7]) ? Input_Byte_T[0] : tmpXOR1_T;
	assign Output_Byte_F[1] = (!Input_Byte_F[7]) ? tmpXOR1_F       : Input_Byte_F[0];
	assign Output_Byte_T[2] = Input_Byte_T[1];
	assign Output_Byte_F[2] = Input_Byte_F[1];
//	assign Output_Byte_T[3] = (!Input_Byte_T[7]) ? Input_Byte_T[2] : tmpXOR3_T;
//	assign Output_Byte_F[3] = (!Input_Byte_F[7]) ? Input_Byte_F[2] : tmpXOR3_F;
//	assign Output_Byte_T[4] = (!Input_Byte_T[7]) ? Input_Byte_T[3] : tmpXOR4_T;
//	assign Output_Byte_F[4] = (!Input_Byte_F[7]) ? Input_Byte_F[3] : tmpXOR4_F;
	assign Output_Byte_T[3] = (!Input_Byte_T[7]) ? Input_Byte_T[2] : tmpXOR3_T;
	assign Output_Byte_F[3] = (!Input_Byte_F[7]) ? tmpXOR3_F       : Input_Byte_F[2] ;
	assign Output_Byte_T[4] = (!Input_Byte_T[7]) ? Input_Byte_T[3] : tmpXOR4_T;
	assign Output_Byte_F[4] = (!Input_Byte_F[7]) ? tmpXOR4_F       : Input_Byte_F[3];
	assign Output_Byte_T[7:5] = Input_Byte_T[6:4];
	assign Output_Byte_F[7:5] = Input_Byte_F[6:4];
	
endmodule