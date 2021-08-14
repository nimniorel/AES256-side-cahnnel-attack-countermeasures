module MixColumns (
	input	[N-1:0] MixCol_In_T,
	input	[N-1:0] MixCol_In_F,
	output	[N-1:0] MixCol_Out_T,
	output	[N-1:0] MixCol_Out_F
);
	// module name and ports list.
	//parameters declaration
	parameter N=128; //inputs size
	parameter Nb=4; //number of columns
	parameter BYTE =8; //number of bits in a byte
	parameter WORD = 32; //number of bits in a word
	
	wire [N-1:0] c_mult_T; //c_mult holds the x_mult output for each byte
	wire [N-1:0] c_mult_F;
	genvar c;
	
	generate
		for(c=0;c<Nb;c=c+1) begin: xoring
			//calculating multipications by 02
			xmult mult0(
				.Input_Byte_T(MixCol_In_T[N-1-c*WORD-:BYTE]),
				.Input_Byte_F(MixCol_In_F[N-1-c*WORD-:BYTE]),
				.Output_Byte_T(c_mult_T[N-c*WORD-1-:BYTE]),
				.Output_Byte_F(c_mult_F[N-c*WORD-1-:BYTE])
			);
			
			xmult mult1(
				.Input_Byte_T(MixCol_In_T[N-c*WORD-BYTE-1-:BYTE]),
				.Input_Byte_F(MixCol_In_F[N-c*WORD-BYTE-1-:BYTE]),
				.Output_Byte_T(c_mult_T[N-c*WORD-1-BYTE-:BYTE]),
				.Output_Byte_F(c_mult_F[N-c*WORD-1-BYTE-:BYTE])

			);
			
			xmult mult2(
				.Input_Byte_T(MixCol_In_T[N-c*WORD-2*BYTE-1-:BYTE]),
				.Input_Byte_F(MixCol_In_F[N-c*WORD-2*BYTE-1-:BYTE]),
				.Output_Byte_T(c_mult_T[N-c*WORD-1-2*BYTE-:BYTE]),
				.Output_Byte_F(c_mult_F[N-c*WORD-1-2*BYTE-:BYTE])
			);
			
			xmult mult3(
				.Input_Byte_T(MixCol_In_T[N-c*WORD-3*BYTE-1-:BYTE]),
				.Input_Byte_F(MixCol_In_F[N-c*WORD-3*BYTE-1-:BYTE]),
				.Output_Byte_T(c_mult_T[N-c*WORD-1-3*BYTE-:BYTE]),
				.Output_Byte_F(c_mult_F[N-c*WORD-1-3*BYTE-:BYTE])			
			);
			
			//assigning each byte in the column c 
			//assign MixCol_Out_T[N-1-c*WORD-:BYTE]=c_mult_T[N-c*WORD-1-:BYTE]^c_mult_T[N-c*WORD-1-BYTE-:BYTE]^
	//				MixCol_In_T[N-c*WORD-BYTE-1-:BYTE]^MixCol_In_T[N-c*WORD-2*BYTE-1-:BYTE]^
		//			MixCol_In_T[N-c*WORD-3*BYTE-1-:BYTE];
						
			
			XOR5_BYTE Xor1(
				.In1_T(c_mult_T[N-c*WORD-1-:BYTE]),
				.In1_F(c_mult_F[N-c*WORD-1-:BYTE]),
				.In2_T(c_mult_T[N-c*WORD-1-BYTE-:BYTE]),
				.In2_F(c_mult_F[N-c*WORD-1-BYTE-:BYTE]),
				.In3_T(MixCol_In_T[N-c*WORD-BYTE-1-:BYTE]),
				.In3_F(MixCol_In_F[N-c*WORD-BYTE-1-:BYTE]),
				.In4_T(MixCol_In_T[N-c*WORD-2*BYTE-1-:BYTE]),
				.In4_F(MixCol_In_F[N-c*WORD-2*BYTE-1-:BYTE]),
				.In5_T(MixCol_In_T[N-c*WORD-3*BYTE-1-:BYTE]),
				.In5_F(MixCol_In_F[N-c*WORD-3*BYTE-1-:BYTE]),
				.Out_T(MixCol_Out_T[N-1-c*WORD-:BYTE]),
				.Out_F(MixCol_Out_F[N-1-c*WORD-:BYTE])
			);
				
				
			XOR5_BYTE Xor2(
				.In1_T(MixCol_In_T[N-1-c*WORD-:BYTE]),
				.In1_F(MixCol_In_F[N-1-c*WORD-:BYTE]),
				.In2_T(c_mult_T[N-c*WORD-1-BYTE-:BYTE]),
				.In2_F(c_mult_F[N-c*WORD-1-BYTE-:BYTE]),
				.In3_T(c_mult_T[N-c*WORD-1-2*BYTE-:BYTE]),
				.In3_F(c_mult_F[N-c*WORD-1-2*BYTE-:BYTE]),
				.In4_T(MixCol_In_T[N-c*WORD-2*BYTE-1-:BYTE]),
			    .In4_F(MixCol_In_F[N-c*WORD-2*BYTE-1-:BYTE]),
				.In5_T(MixCol_In_T[N-c*WORD-3*BYTE-1-:BYTE]),
				.In5_F(MixCol_In_F[N-c*WORD-3*BYTE-1-:BYTE]),
				.Out_T(MixCol_Out_T[N-c*WORD-BYTE-1-:BYTE]),
				.Out_F(MixCol_Out_F[N-c*WORD-BYTE-1-:BYTE])
			);


		//assign MixCol_Out[N-c*WORD-BYTE-1-:BYTE]=MixCol_In[N-1-c*WORD-:BYTE]^c_mult[N-c*WORD-1-BYTE-:BYTE]^
//					c_mult[N-c*WORD-1-2*BYTE-:BYTE]^MixCol_In[N-c*WORD-2*BYTE-1-:BYTE]^MixCol_In[N-c*WORD-3*BYTE-1-:BYTE];
					


//		assign MixCol_Out[N-c*WORD-2*BYTE-1-:BYTE]=MixCol_In[N-1-c*WORD-:BYTE]^MixCol_In[N-c*WORD-BYTE-1-:BYTE]^
//					c_mult[N-c*WORD-1-2*BYTE-:BYTE]^c_mult[N-c*WORD-1-3*BYTE-:BYTE]^MixCol_In[N-c*WORD-3*BYTE-1-:BYTE];
			
			XOR5_BYTE Xor3(
				.In1_T(MixCol_In_T[N-1-c*WORD-:BYTE]),
			    .In1_F(MixCol_In_F[N-1-c*WORD-:BYTE]),
				.In2_T(MixCol_In_T[N-c*WORD-BYTE-1-:BYTE]),
				.In2_F(MixCol_In_F[N-c*WORD-BYTE-1-:BYTE]),
				.In3_T(c_mult_T[N-c*WORD-1-2*BYTE-:BYTE]),
				.In3_F(c_mult_F[N-c*WORD-1-2*BYTE-:BYTE]),
				.In4_T(c_mult_T[N-c*WORD-1-3*BYTE-:BYTE]),
			    .In4_F(c_mult_F[N-c*WORD-1-3*BYTE-:BYTE]),
				.In5_T(MixCol_In_T[N-c*WORD-3*BYTE-1-:BYTE]),
				.In5_F(MixCol_In_F[N-c*WORD-3*BYTE-1-:BYTE]),
				.Out_T(MixCol_Out_T[N-c*WORD-2*BYTE-1-:BYTE]),
				.Out_F(MixCol_Out_F[N-c*WORD-2*BYTE-1-:BYTE])
			);


			
//			assign MixCol_Out[N-c*WORD-3*BYTE-1-:BYTE]=c_mult[N-c*WORD-1-:BYTE]^MixCol_In[N-1-c*WORD-:BYTE]^
//					MixCol_In[N-c*WORD-BYTE-1-:BYTE]^MixCol_In[N-c*WORD-2*BYTE-1-:BYTE]^c_mult[N-c*WORD-1-3*BYTE-:BYTE];
		
		
			XOR5_BYTE Xor4(
				.In1_T(c_mult_T[N-c*WORD-1-:BYTE]),
				.In1_F(c_mult_F[N-c*WORD-1-:BYTE]),
				.In2_T(MixCol_In_T[N-1-c*WORD-:BYTE]),
				.In2_F(MixCol_In_F[N-1-c*WORD-:BYTE]),
				.In3_T(MixCol_In_T[N-c*WORD-BYTE-1-:BYTE]),
				.In3_F(MixCol_In_F[N-c*WORD-BYTE-1-:BYTE]),
				.In4_T(MixCol_In_T[N-c*WORD-2*BYTE-1-:BYTE]),
				.In4_F(MixCol_In_F[N-c*WORD-2*BYTE-1-:BYTE]),
				.In5_T(c_mult_T[N-c*WORD-1-3*BYTE-:BYTE]),
				.In5_F(c_mult_F[N-c*WORD-1-3*BYTE-:BYTE]),
				.Out_T(MixCol_Out_T[N-c*WORD-3*BYTE-1-:BYTE]),
			    .Out_F(MixCol_Out_F[N-c*WORD-3*BYTE-1-:BYTE])
			);		
		
		
		
		end
	endgenerate

endmodule

