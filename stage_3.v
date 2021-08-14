`timescale 1ns / 100ps
/*
		stage 3: returning to GF(2^8) and affine transformation
		this is done by multiplying the 8-bit input with an Inverse DELTA matrix
		Inv DELTA = 	1 0 1 0 1 1 1 0
						0 0 0 0 1 1 0 0
						0 1 1 1 1 0 0 1 
						0 1 1 1 1 1 0 0 
						0 1 1 0 1 1 1 0
						0 1 0 0 0 1 1 0
						0 0 1 0 0 0 1 0 
						0 1 0 0 0 1 1 1
		and then applaying the affine transformation
		transformation = 	1 0 0 0 1 1 1 1		1
				     		1 1 0 0 0 1 1 1		1
							1 1 1 0 0 0 1 1		0
							1 1 1 1 0 0 0 1	 +	0
							1 1 1 1 1 0 0 0		0
							0 1 1 1 1 1 0 0		1
							0 0 1 1 1 1 1 0		1
							0 0 0 1 1 1 1 1		0
		to minimize the number of gates needed I calculated the matrix multiplication of transformation*Inv DELTA (the order is importent)
		the result matrix is:
		stage 3 =	 	1 1 1 0 0 0 1 1
						1 0 0 0 0 0 0 1
						1 0 1 1 1 1 1 0 
						1 1 1 0 0 0 0 0 
						1 1 0 0 1 0 0 1
						0 0 1 0 0 0 0 1
						0 0 0 0 1 1 1 1 
						0 0 1 1 0 0 0 1
		and then adding the constant vector of the transformation
		
		this stage has 15 F-modules in it
*/
module stage_3 (
	input 	[7:0] In_T,
	input 	[7:0] In_F,
	output	[7:0] Out_T,
	output	[7:0] Out_F
);
	//parameters
	parameter internal_route_bus_size = 30;
	
	//wires
	wire [internal_route_bus_size - 1 : 0] internal_route_T;
	wire [internal_route_bus_size - 1 : 0] internal_route_F;
	//output assignment
	assign Out_T = {internal_route_T[29], internal_route_T[27], internal_route_T[21], internal_route_T[19], internal_route_T[1], internal_route_T[13], internal_route_T[7], internal_route_T[5]};
	assign Out_F = {internal_route_F[29], internal_route_F[27], internal_route_F[21], internal_route_F[19], internal_route_F[1], internal_route_F[13], internal_route_F[7], internal_route_F[5]};
	//logic gates
	//first row - LSB - broken to 2 logic levels 
//	xor(internal_route_T[0], In[2], In[1], In[0]);//F_address: 155
	XOR_3_GATE XOR3_1(
		.A_t(In_T[0]),					//true data in #1 
		.A_f(In_F[0]),
		.B_t(In_T[1]),					//true data in #2 
		.B_f(In_F[1]),
		.C_t(In_T[2]),					//true data in #3 
		.C_f(In_F[2]),
		.O_t(internal_route_T[0]),		//true data out
	    .O_f(internal_route_F[0])
	);	
		
//	xor(internal_route_T[2], In[7], In[6], 1'b1);//the 1'b1 is the addition of the constant vector
	XOR_3_GATE XOR3_2(
		.A_t(1'b1),						//true data in #1 
		.A_f(1'b0),
		.B_t(In_T[6]),					//true data in #2 
		.B_f(In_F[6]),
		.C_t(In_T[7]),					//true data in #3 
		.C_f(In_F[7]),	
		.O_t(internal_route_T[2]),		//true data out
	    .O_f(internal_route_F[2])
	);	
	
//	xor(internal_route_T[4], internal_route_T[1], internal_route_T[3]);//F_address: 157
	XOR_GATE XOR_1(
		.A_t(internal_route_T[3]),
	    .A_f(internal_route_F[3]),
		.B_t(internal_route_T[1]),
		.B_f(internal_route_F[1]),
		.O_t(internal_route_T[4]),
		.O_f(internal_route_F[4])
	);
		
	//second row
//	xor(internal_route_T[6], In[7], In[0], 1'b1);//the 1'b1 is the addition of the constant vector //F_address: 158
	XOR_3_GATE XOR3_3(
		.A_t(1'b1),						//true data in #1 
		.A_f(1'b0),
		.B_t(In_T[0]),					//true data in #2 
		.B_f(In_F[0]),
		.C_t(In_T[7]),					//true data in #3 
		.C_f(In_F[7]),
		.O_t(internal_route_T[6]),		//true data out
	    .O_f(internal_route_F[6])
	);

	//third row - broken to 2 logic levels 
//	xor(internal_route_T[8], In[3], In[2], In[0]);//F_address: 159
	XOR_3_GATE XOR3_4(
		.A_t(In_T[0]),					//true data in #1 
		.A_f(In_F[0]),
		.B_t(In_T[2]),					//true data in #2 
		.B_f(In_F[2]),
		.C_t(In_T[3]),					//true data in #3 
		.C_f(In_F[3]),
		.O_t(internal_route_T[8]),		//true data out
	    .O_f(internal_route_F[8])
	);

//	xor(internal_route_T[10], In[6], In[5], In[4]);//F_address: 160
	XOR_3_GATE XOR3_5(
		.A_t(In_T[4]),					//true data in #1 
		.A_f(In_F[4]),
		.B_t(In_T[5]),					//true data in #2 
		.B_f(In_F[5]),
		.C_t(In_T[6]),					//true data in #3 
		.C_f(In_F[6]),
		.O_t(internal_route_T[10]),		//true data out
	    .O_f(internal_route_F[10])
	);
	
//	xor(internal_route_T[12], internal_route_T[11], internal_route_T[9]);//F_address: 161
	XOR_GATE XOR_2(
		.A_t(internal_route_T[9]),
		.A_f(internal_route_F[9]),
		.B_t(internal_route_T[11]),	
		.B_f(internal_route_F[11]),	
		.O_t(internal_route_T[12]),
		.O_f(internal_route_F[12])
	);
	
	//forth row - same as the first xor of the first row so coverd by internal_route_T[1]
	//fifth row -  broken to 2 logic levels 
//	xor(internal_route_T[14], In[1], In[0]);//F_address: 162
	XOR_GATE XOR_3(
		.A_t(In_T[0]),
		.A_f(In_F[0]),
		.B_t(In_T[1]),	
		.B_f(In_F[1]),
		.O_t(internal_route_T[14]),
		.O_f(internal_route_F[14])
	);

//	xor(internal_route_T[16], In[7], In[4]);//F_address: 163
	XOR_GATE XOR_4(
		.A_t(In_T[4]),
		.A_f(In_F[4]),
		.B_t(In_T[7]),
		.B_f(In_F[7]),
		.O_t(internal_route_T[16]),
		.O_f(internal_route_F[16])
	);

//	xor(internal_route_T[18], internal_route_T[15], internal_route_T[17]);//F_address: 164
	XOR_GATE XOR_5(
		.A_t(internal_route_T[17]),
		.A_f(internal_route_F[17]),
		.B_t(internal_route_T[15]),
		.B_f(internal_route_F[15]),
		.O_t(internal_route_T[18]),
		.O_f(internal_route_F[18])
	);
	
	//sixth row 
//	xor(internal_route_T[20], In[7], In[2], 1'b1);//the 1'b1 is the addition of the constant vector  //F_address: 165
	XOR_3_GATE XOR3_6(
		.A_t(1'b1),						//true data in #1 
		.A_f(1'b0),
		.B_t(In_T[2]),					//true data in #2 
		.B_f(In_F[2]),
		.C_t(In_T[7]),					//true data in #3 		
		.C_f(In_F[7]),
		.O_t(internal_route_T[20]),		//true data out
	    .O_f(internal_route_F[20])
	);
	
	//seventh row -  broken to 2 logic levels 
//	xor(internal_route_T[22], In[5], In[4]);//F_address: 166
	XOR_GATE XOR_6(
		.A_t(In_T[4]),
		.A_f(In_F[4]),
		.B_t(In_T[5]),
		.B_f(In_F[5]),
		.O_t(internal_route_T[22]),
		.O_f(internal_route_F[22])
	);
	
//	xor(internal_route_T[24], In[7], In[6], 1'b1);//the 1'b1 is the addition of the constant vector //F_address: 167
	XOR_3_GATE XOR3_7(
		.A_t(1'b1),						//true data in #1 
		.A_f(1'b0),
		.B_t(In_T[6]),					//true data in #2 
		.B_f(In_F[6]),
		.C_t(In_T[7]),					//true data in #3 	
		.C_f(In_F[7]),
		.O_t(internal_route_T[24]),		//true data out
	    .O_f(internal_route_F[24])
	);

//	xor(internal_route_T[26], internal_route_T[25], internal_route_T[23]);//F_address: 168
	XOR_GATE XOR_7(
		.A_t(internal_route_T[23]),
		.A_f(internal_route_F[23]),
		.B_t(internal_route_T[25]),
		.B_f(internal_route_F[25]),
		.O_t(internal_route_T[26]),
		.O_f(internal_route_F[26])
	);
	
	//eighth row - MSB
//	xor(internal_route_T[28], In[7], In[3], In[2]);//F_address: 169
	XOR_3_GATE XOR3_8(
		.A_t(In_T[2]),						//true data in #1 
		.A_f(In_F[2]),
		.B_t(In_T[3]),					//true data in #2 
		.B_f(In_F[3]),
		.C_t(In_T[7]),					//true data in #3 
		.C_f(In_F[7]),
		.O_t(internal_route_T[28]),		//true data out
        .O_f(internal_route_F[28])
);
	
	genvar i;
	generate
		for(i = 0; i < internal_route_bus_size/2 ; i = i+1)
		begin: Routing
			assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
		    assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];
		end
	endgenerate
endmodule

/*
module stage_3_TB ();
	//parameters
	parameter F_control_bus_size = 30;
	//ports list
	reg [7:0] In = 0;
	reg [F_control_bus_size-1 : 0] F_control = 0;
	wire [7:0] Out;
	
	reg [7:0] expectedResults[0:255];//a reg for the expected results of the claculation
	
	initial
			$readmemb("/u/e2012/bodnery/proj/stage3expectedResults.txt", expectedResults); // stage3expectedResults.txt is the memory initialization file
	
	stage_3 UUT(In, Out, F_control);//unit under test
	
	integer i, out_file;
	
	initial
		out_file = $fopen("/u/e2012/bodnery/proj/stage_3_TB.txt");//opening the output file
	
	initial
		begin
			for (i = 0 ; i < 256 ; i = i + 1 )
			begin
				if(Out == expectedResults[i])
					#1 $fdisplay(out_file,"in = %d, after conversion out = %d expected result = %d- SUCCESS", In, Out, expectedResults[i]);
				else
					#1 $fdisplay(out_file,"in = %d, after conversion out = %d expected result = %d- FAIL", In, Out, expectedResults[i]);
				#1 In = In + 1 ;
			end
			#1 $fclose(out_file);//close the output file
			$finish ;
		end
	
endmodule 
*/
