module SubBytes (
	input			Clk,
	input           Reset,
	input	[1:0]	Multi_Cycle_State,
	input	[N-1:0]	SubByte_In_T,
	input	[N-1:0]	SubByte_In_F,
	input           flipflpoindicator,
	output	[N-1:0]	SubByte_Out_T,
	output	[N-1:0]	SubByte_Out_F
);		// module name and ports list.

	parameter N=128; //inputs size
	parameter BYTE =8; //number of bits in a byte

	genvar i;
	
	generate
	for (i=0; i< N/BYTE; i=i+1)begin: eightbit
		Sbox8b sbox (
			.Clk(Clk),
			.Reset(Reset),
			.multi_cycle(Multi_Cycle_State),
			.Sbox_In_T(SubByte_In_T[i*BYTE+:BYTE]),
			.Sbox_In_F(SubByte_In_F[i*BYTE+:BYTE]),
			.flipflpoindicator(flipflpoindicator),
			.Sbox_Out_T(SubByte_Out_T[i*BYTE+:BYTE]),
			.Sbox_Out_F(SubByte_Out_F[i*BYTE+:BYTE])
		);
	
	
	end
	endgenerate
	
endmodule
