module AddRoundKey (		// module name and ports list.
	input		[N-1:0]	In_Data_T,
	input		[N-1:0]	In_key_T,
	input		[N-1:0]	In_Data_F,
	input		[N-1:0]	In_key_F,
	output     	[N-1:0]	Output_Key_T,
	output     	[N-1:0]	Output_Key_F
);		
	//parameters declaration
	parameter N=128; //input size

genvar c;
	
	generate
		for(c=0;c<N;c=c+1) begin: xoring
        XOR_GATE a0(.A_t(In_Data_T[c]), .A_f(In_Data_F[c]),.B_t(In_key_T[c]), .B_f(In_key_F[c]), 		//true data in #1 
	   .O_t(Output_Key_T[c]),		//true data out
	   .O_f(Output_Key_F[c])		//false data out

    );
        end 
	endgenerate	
endmodule

