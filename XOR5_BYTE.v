//this module input 5 variables of BYTE and XOR it in WDDL type 

module 	XOR5_BYTE(
	
	input		[BYTE-1:0]	In1_T,
	input		[BYTE-1:0]	In1_F,
	input		[BYTE-1:0]	In2_T,
	input		[BYTE-1:0]	In2_F,
	input		[BYTE-1:0]	In3_T,
	input		[BYTE-1:0]	In3_F,
	input 		[BYTE-1:0]	In4_T,
	input 		[BYTE-1:0]	In4_F,
	input 		[BYTE-1:0]	In5_T,
	input 		[BYTE-1:0]	In5_F,
	output		[BYTE-1:0]	Out_T,
	output		[BYTE-1:0]	Out_F
);
	
	parameter BYTE = 8;
	
	wire [BYTE-1:0] tmp1_T, tmp2_T;
	wire [BYTE-1:0] tmp1_F, tmp2_F;
	
	genvar i;
	generate
	for (i=0;i<BYTE;i=i+1)
	begin: xoring
		XOR_3_GATE XOR3_1(
			.A_t(In1_T[i]),
			.A_f(In1_F[i]),
			.B_t(In2_T[i]),
			.B_f(In2_F[i]),
			.C_t(In3_T[i]),
			.C_f(In3_F[i]),
			.O_t(tmp1_T[i]),
			.O_f(tmp1_F[i])
		);
		
		XOR_GATE XOR1(
			.A_t(In4_T[i]),
			.A_f(In4_F[i]),
			.B_t(In5_T[i]),
			.B_f(In5_F[i]),
			.O_t(tmp2_T[i]),
			.O_f(tmp2_F[i])
		);
	
		XOR_GATE XOR6(
			.A_t(tmp1_T[i]),
			.A_f(tmp1_F[i]),
			.B_t(tmp2_T[i]),
			.B_f(tmp2_F[i]),
			.O_t(Out_T[i]),
			.O_f(Out_F[i])
		);	
	
	end
	
	endgenerate
	
	
endmodule
