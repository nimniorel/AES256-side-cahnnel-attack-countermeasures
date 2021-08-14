/*
	sub modules for the gate level sub-byte 
*/
module mul2 (
	input [1:0] 	In1_T, 		//data TRUE input 1
	input [1:0] 	In1_F,
	input [1:0] 	In2_T,		//data TRUE input 2
	input [1:0] 	In2_F,
	output [1:0] 	Out_T,		//data TRUE output
    output [1:0] 	Out_F
);

	parameter NUM_OF_INTERNAL_ROUTES = 14;

	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_T;//internal routing
	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_F;
	//based on there order in the fig from left to right and from the top down
	
//	xor(internal_route_T[0], In1[1], In1[0]);
	XOR_GATE XOR_1 (
			.A_t(In1_T[0]),
			.A_f(In1_F[0]),
			.B_t(In1_T[1]),
			.B_f(In1_F[1]),
			.O_t(internal_route_T[0]),
			.O_f(internal_route_F[0])
	);

//	xor(internal_route_T[2], In2[1], In2[0]);
	XOR_GATE XOR_2 (
			.A_t(In2_T[0]),
			.A_f(In2_F[0]),
			.B_t(In2_T[1]),
			.B_f(In2_F[1]),
			.O_t(internal_route_T[2]),
			.O_f(internal_route_F[2])
	);


//	and(internal_route_T[4], In1[1], In2[1]);
	AND_GATE AND_1 (
			.A_t(In2_T[1]),
			.A_f(In2_F[1]),
			.B_t(In1_T[1]),
			.B_f(In1_F[1]),
			.O_t(internal_route_T[4]),
			.O_f(internal_route_F[4])
	);
	
	
//	and(internal_route_T[6], internal_route_T[1], internal_route_T[3]);
	AND_GATE AND_2 (
			.A_t(internal_route_T[3]),
			.A_f(internal_route_F[3]),
			.B_t(internal_route_T[1]),
			.B_f(internal_route_F[1]),
			.O_t(internal_route_T[6]),
			.O_f(internal_route_F[6])
	);	
	
		
//	and(internal_route_T[8], In1[0], In2[0]);
	AND_GATE AND_3 (
			.A_t(In2_T[0]),
			.A_f(In2_F[0]),
			.B_t(In1_T[0]),
			.B_f(In1_F[0]),
			.O_t(internal_route_T[8]),
			.O_f(internal_route_F[8])
	);
	
	
//	xor(internal_route_T[10], internal_route_T[7], internal_route_T[9]);
	XOR_GATE XOR_3 (
			.A_t(internal_route_T[9]),
			.A_f(internal_route_F[9]),
			.B_t(internal_route_T[7]),
			.B_f(internal_route_F[7]),
			.O_t(internal_route_T[10]),
			.O_f(internal_route_F[10])
	);
	
	
//	xor(internal_route_T[12], internal_route_T[5], internal_route_T[9]);
	XOR_GATE XOR_4 (
			.A_t(internal_route_T[9]),
			.A_f(internal_route_F[9]),
			.B_t(internal_route_T[5]),
			.B_f(internal_route_F[5]),
			.O_t(internal_route_T[12]),
			.O_f(internal_route_F[12])
	);	
	
	assign Out_T = {internal_route_T[11],internal_route_T[13]};
	assign Out_F = {internal_route_F[11],internal_route_F[13]};	
		
	genvar i;
	generate
		for(i = 0; i < NUM_OF_INTERNAL_ROUTES/2 ; i = i+1)
		begin: Routing
			assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
            assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];
		end
	endgenerate
endmodule



module mul4(
	
	input [3:0] In1_T,		//data TRUE input 1
	input [3:0] In1_F,		//data false input 1
	input [3:0] In2_T,		//data TRUE input 2
	input [3:0] In2_F,		//data false input 2
	output [3:0] Out_T,		//data TRUE output
	output [3:0] Out_F		//data false output

);
		
	parameter NUM_OF_INTERNAL_ROUTES = 30;

	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_T;//internal routing
	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_F;
	//based on there order in the fig from left to right and from the top down
	
//	xor (internal_route_T[0], In1[0], In1[2]);
	XOR_GATE XOR_1(	
		.A_t(In1_T[0]),
		.A_f(In1_F[0]),
		.B_t(In1_T[2]),
		.B_f(In1_F[2]),
		.O_t(internal_route_T[0]),
		.O_f(internal_route_F[0])
	);
	
//	xor (internal_route_T[2], In1[1], In1[3]);
	XOR_GATE XOR_2(	
		.A_t(In1_T[1]),
		.A_f(In1_F[1]),
		.B_t(In1_T[3]),
		.B_f(In1_F[3]),
		.O_t(internal_route_T[2]),
		.O_f(internal_route_F[2])
	);
	
//	xor (internal_route_T[4], In2[0], In2[2]);
	XOR_GATE XOR_3(	
		.A_t(In2_T[0]),
		.A_f(In2_F[0]),
		.B_t(In2_T[2]),
		.B_f(In2_F[2]),
		.O_t(internal_route_T[4]),
		.O_f(internal_route_F[4])
	);
	
	
//	xor (internal_route_T[6], In2[1], In2[3]);//in m3 F_address: 122 || in m2 F_address: 86 || in m1 F_address: 25
	XOR_GATE XOR_4(	
		.A_t(In2_T[1]),
		.A_f(In2_F[1]),
		.B_t(In2_T[3]),
		.B_f(In2_F[3]),
		.O_t(internal_route_T[6]),
		.O_f(internal_route_F[6])
	);
	
	
//	mul2 sub1(In1[3:2], In2[3:2], {internal_route_T[8],internal_route_T[10]});
	mul2 sub1(
		.In1_T(In1_T[3:2]),
		.In1_F(In1_F[3:2]),
		.In2_T(In2_T[3:2]),
		.In2_F(In2_F[3:2]),
		.Out_T({internal_route_T[8],internal_route_T[10]}),
		.Out_F({internal_route_F[8],internal_route_F[10]})
	);

	
//	mul2 sub2({internal_route_T[7],internal_route_T[5]}, {internal_route_T[3],internal_route_T[1]}, {internal_route_T[12],internal_route_T[14]});
	mul2 sub2(
		.In1_T({internal_route_T[7],internal_route_T[5]}),
		.In1_F({internal_route_F[7],internal_route_F[5]}),
		.In2_T({internal_route_T[3],internal_route_T[1]}),
		.In2_F({internal_route_F[3],internal_route_F[1]}),
		.Out_T({internal_route_T[12],internal_route_T[14]}),
		.Out_F({internal_route_F[12],internal_route_F[14]})
	);

	
//	mul2 sub3(In1[1:0], In2[1:0], {internal_route_T[16],internal_route_T[18]});
	mul2 sub3(
		.In1_T(In1_T[1:0]),
		.In1_F(In1_F[1:0]),
		.In2_T(In2_T[1:0]),
		.In2_F(In2_F[1:0]),
		.Out_T({internal_route_T[16],internal_route_T[18]}),
		.Out_F({internal_route_F[16],internal_route_F[18]})
	);
	
	
	
//	xor (internal_route_T[20], internal_route_T[11], internal_route_T[9]);//for the phi  //in m3 F_address: 150 || in m1 F_address: 53
	XOR_GATE XOR_5(	
		.A_t(internal_route_T[9]),
		.A_f(internal_route_F[9]),
		.B_t(internal_route_T[11]),
		.B_f(internal_route_F[11]),
		.O_t(internal_route_T[20]),
		.O_f(internal_route_F[20])
	);

	
//	xor (internal_route_T[22], internal_route_T[13], internal_route_T[17]);
	XOR_GATE XOR_6(	
		.A_t(internal_route_T[17]),
		.A_f(internal_route_F[17]),
		.B_t(internal_route_T[13]),
		.B_f(internal_route_F[13]),
		.O_t(internal_route_T[22]),
		.O_f(internal_route_F[22])
	);
	
//	xor (internal_route_T[24], internal_route_T[15], internal_route_T[19]);
	XOR_GATE XOR_7(	
		.A_t(internal_route_T[19]),
		.A_f(internal_route_F[19]),
		.B_t(internal_route_T[15]),
		.B_f(internal_route_F[15]),
		.O_t(internal_route_T[24]),
		.O_f(internal_route_F[24])
	);

	
//	xor (internal_route_T[26], internal_route_T[21], internal_route_T[17]);
	XOR_GATE XOR_8(	
		.A_t(internal_route_T[17]),
		.A_f(internal_route_F[17]),
		.B_t(internal_route_T[21]),
		.B_f(internal_route_F[21]),
		.O_t(internal_route_T[26]),
		.O_f(internal_route_F[26])
	);
	
//	xor (internal_route_T[28], internal_route_T[9], internal_route_T[19]);//in m1 F_address: 57
	XOR_GATE XOR_9(	
		.A_t(internal_route_T[19]),
		.A_f(internal_route_F[19]),
		.B_t(internal_route_T[9]),
		.B_f(internal_route_F[9]),
		.O_t(internal_route_T[28]),
		.O_f(internal_route_F[28])
	);

	
	assign Out_T[3] = internal_route_T[23];
	assign Out_F[3] = internal_route_F[23];
	assign Out_T[2] = internal_route_T[25];
	assign Out_F[2] = internal_route_F[25];
	assign Out_T[1] = internal_route_T[27];
	assign Out_F[1] = internal_route_F[27];
	assign Out_T[0] = internal_route_T[29];
	assign Out_F[0] = internal_route_F[29];


	genvar i;
	generate
		for(i = 0; i < NUM_OF_INTERNAL_ROUTES/2 ; i = i+1)
		begin: Routing
			if( i < 4) begin
				assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
                assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];
			end	
			else begin
				assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
			     assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];
			end

		end
	endgenerate
	
endmodule

module square(
		input [3:0] In_T,		//data TRUE input 
		input [3:0] In_F,		//data FALSE input 
		output [3:0] Out_T,		//data TRUE output
		output [3:0] Out_F		//data TRUE output

);
	
	parameter NUM_OF_INTERNAL_ROUTES = 8;

	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_T;//internal routing
    wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_F;//internal routing
	//based on there order in the fig from left to right and from the top down
	
//	xor (internal_route_T[0], In[0], In[1]);//F_address: 11
	XOR_GATE XOR_1(	
		.A_t(In_T[0]),
		.A_f(In_F[0]),
		.B_t(In_T[1]),
		.B_f(In_F[1]),
		.O_t(internal_route_T[0]),
		.O_f(internal_route_F[0])
	);
		
//	xor (internal_route_T[2], In[2], In[3]);
	XOR_GATE XOR_2(	
		.A_t(In_T[2]),
		.A_f(In_F[2]),
		.B_t(In_T[3]),
		.B_f(In_F[3]),
		.O_t(internal_route_T[2]),
		.O_f(internal_route_F[2])
	);
	
//	xor (internal_route_T[4], In[1], In[2]);
	XOR_GATE XOR_3(	
		.A_t(In_T[2]),
		.A_f(In_F[2]),
		.B_t(In_T[1]),
		.B_f(In_F[1]),
		.O_t(internal_route_T[4]),
		.O_f(internal_route_F[4])
	);
	
//	xor (internal_route_T[6], internal_route_T[1], In[3]);//F_address: 14
	XOR_GATE XOR_4(	
		.A_t(In_T[3]),
		.A_f(In_F[3]),
		.B_t(internal_route_T[1]),
		.B_f(internal_route_F[1]),
		.O_t(internal_route_T[6]),
		.O_f(internal_route_F[6])
	);	
	
	assign Out_T[3] = In_T[3];
	assign Out_F[3] = In_F[3];
	assign Out_T[2] = internal_route_T[3];
	assign Out_F[2] = internal_route_F[3];
	assign Out_T[1] = internal_route_T[5];
	assign Out_F[1] = internal_route_F[5];
	assign Out_T[0] = internal_route_T[7];
	assign Out_F[0] = internal_route_F[7];

		
	genvar i;
	generate
		for(i = 0; i < NUM_OF_INTERNAL_ROUTES/2 ; i = i+1)
		begin: Routing
			assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
            assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];

		end
	endgenerate
	
endmodule


module lamdaX(
	input [3:0] In_T,		//data TRUE input 
	input [3:0] In_F,
	output [3:0] Out_T,		//data TRUE output 
    output [3:0] Out_F
);
	
	parameter NUM_OF_INTERNAL_ROUTES = 6;
	
	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_T;//internal routing
	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_F;
	//based on there order in the fig from left to right and from the top down
	
//	xor (internal_route_T[0], In[1], In[3]);
	XOR_GATE XOR_1(	
		.A_t(In_T[3]),
		.A_f(In_F[3]),
		.B_t(In_T[1]),
		.B_f(In_F[1]),
		.O_t(internal_route_T[0]),
		.O_f(internal_route_F[0])
	);	
	
//	xor (internal_route_T[2], In[0], In[2]);
	XOR_GATE XOR_2(	
		.A_t(In_T[2]),
		.A_f(In_F[2]),
		.B_t(In_T[0]),
		.B_f(In_F[0]),
		.O_t(internal_route_T[2]),
		.O_f(internal_route_F[2])
	);	
	
	
//	xor (internal_route_T[4], internal_route_T[1], internal_route_T[3]);//F_address: 17
	XOR_GATE XOR_3(	
		.A_t(internal_route_T[3]),
		.A_f(internal_route_F[3]),
		.B_t(internal_route_T[1]),
		.B_f(internal_route_F[1]),
		.O_t(internal_route_T[4]),
		.O_f(internal_route_F[4])
	);	
	
	assign Out_T[3] = internal_route_T[3];
	assign Out_F[3] = internal_route_F[3];
	assign Out_T[2] = internal_route_T[5];
	assign Out_F[2] = internal_route_F[5];
	assign Out_T[1] = In_T[3];
	assign Out_F[1] = In_F[3];
	assign Out_T[0] = In_T[2];
	assign Out_F[0] = In_F[2];

	
	genvar i;
	generate
		for(i = 0; i < NUM_OF_INTERNAL_ROUTES/2 ; i = i+1)
		begin: Routing
			assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
            assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];

		end
	endgenerate
	
endmodule

module inverseX (
	input [3:0] In_T,		//  4-bit *TRUE* input
	input [3:0] In_F,
	output [3:0] Out_T,		//  4-bit *TRUE* output
	output [3:0] Out_F
); // has a total of 21 F-modules
	
	parameter NUM_OF_INTERNAL_ROUTES = 42;

	wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_T;//internal routing
    wire [NUM_OF_INTERNAL_ROUTES-1:0] internal_route_F;
	//based on the equations first the products and then the sums from the MSB to the LSB
	
//	and (internal_route_T[0], In[0], In[3]); // x3x0
	AND_GATE AND_1(

	.A_t(In_T[3]),
	.A_f(In_F[3]),		
	.B_t(In_T[0]),
	.B_f(In_F[0]),		
	.O_t(internal_route_T[0]),
	.O_f(internal_route_F[0])		
);
	
//	and (internal_route_T[2], In[2], In[1]); // x2x1
	AND_GATE AND_2(

	.A_t(In_T[1]),
	.A_f(In_F[1]),				
	.B_t(In_T[2]),	
	.B_f(In_F[2]),		
	.O_t(internal_route_T[2]),
	.O_f(internal_route_F[2])	
);	
	
//	and (internal_route_T[4], In[0], In[2]); // x2x0
	AND_GATE AND_3(

	.A_t(In_T[2]),	
	.A_f(In_F[2]),		
	.B_t(In_T[0]),
	.B_f(In_F[0]),		
	.O_t(internal_route_T[4]),
	.O_f(internal_route_F[4])	
);

//	and (internal_route_T[6], In[1], In[3]); // x3x1
	AND_GATE AND_4(

	.A_t(In_T[3]),
	.A_f(In_F[3]),			
	.B_t(In_T[1]),
	.B_f(In_F[1]),		
	.O_t(internal_route_T[6]),
	.O_f(internal_route_F[6])		
);

//	and (internal_route_T[8], In[3], In[2], In[1]); //x3x2x1
	AND_3_GATE AND3_1(

	.A_t(In_T[1]), 
	.A_f(In_F[1]), 
	.B_t(In_T[2]),
	.B_f(In_F[2]),		 
	.C_t(In_T[3]), 
	.C_f(In_F[3]),	
	.O_t(internal_route_T[8]),
	.O_f(internal_route_F[8])
);

//	and (internal_route_T[10], In[2], In[3], In[0]); //x3x2x0
	AND_3_GATE AND3_2(

	.A_t(In_T[0]),
	.A_f(In_F[0]), 
	.B_t(In_T[3]),
	.B_f(In_F[3]),		 
	.C_t(In_T[2]),
	.C_f(In_F[2]), 	
	.O_t(internal_route_T[10]),
	.O_f(internal_route_F[10])
);

//	and (internal_route_T[12], In[1], In[3], In[0]); //x3x1x0
	AND_3_GATE AND3_3(

	.A_t(In_T[0]),
	.A_f(In_F[0]), 
	.B_t(In_T[3]),
	.B_f(In_F[3]),		 
	.C_t(In_T[1]), 
	.C_f(In_F[1]),	
	.O_t(internal_route_T[12]),
	.O_f(internal_route_F[12])
);
	
//	and (internal_route_T[14], In[1], In[2], In[0]); //x2x1x0  //F_address: 69
	AND_3_GATE AND3_4(

	.A_t(In_T[0]), 
	.A_f(In_F[0]),
	.B_t(In_T[2]),
	.B_f(In_F[2]),			 
	.C_t(In_T[1]), 
	.C_f(In_F[1]),	
	.O_t(internal_route_T[14]),
	.O_f(internal_route_F[14])
);


	//first output (MSB)
//	xor (internal_route_T[16], In[3], In[2]);//x3 XOR x2
	XOR_GATE XOR_1(	
		.A_t(In_T[2]),
		.A_f(In_F[2]),
		.B_t(In_T[3]),
		.B_f(In_F[3]),
		.O_t(internal_route_T[16]),
		.O_f(internal_route_F[16])
	);	
	
//	xor (internal_route_T[18], internal_route_T[9], internal_route_T[1]);//x3x2x1 XOR x3x0  //F_address: 71
	XOR_GATE XOR_2(	
		.A_t(internal_route_T[1]),
		.A_f(internal_route_F[1]),
		.B_t(internal_route_T[9]),
		.B_f(internal_route_F[9]),
		.O_t(internal_route_T[18]),
		.O_f(internal_route_F[18])
	);	

//	xor (internal_route_T[20], internal_route_T[17], internal_route_T[19]);//(x3 XOR x2) XOR (x3x2x1 XOR x3x0) //F_address: 72
	XOR_GATE XOR_3(	
		.A_t(internal_route_T[19]),
		.A_f(internal_route_F[19]),
		.B_t(internal_route_T[17]),
		.B_f(internal_route_F[17]),
		.O_t(internal_route_T[20]),
		.O_f(internal_route_F[20])
	);

	//second output
//	xor (internal_route_T[22], internal_route_T[11], internal_route_T[3], In[2]);//x3x2x0 XOR x2x1 XOR x2
	XOR_3_GATE XOR3_1 (
			.A_t(In_T[2]),
			.A_f(In_F[2]),
			.B_t(internal_route_T[3]),
			.B_f(internal_route_F[3]),
			.C_t(internal_route_T[11]),
			.C_f(internal_route_F[11]),
			.O_t(internal_route_T[22]),
			.O_f(internal_route_F[22])
	);

//	xor (internal_route_T[24], internal_route_T[19], internal_route_T[23]);//(x3x2x1 XOR x3x0) XOR (x3x2x0 XOR x2x1 XOR x2)
	XOR_GATE XOR_4(	
		.A_t(internal_route_T[23]),
		.A_f(internal_route_F[23]),
		.B_t(internal_route_T[19]),
		.B_f(internal_route_F[19]),
		.O_t(internal_route_T[24]),
		.O_f(internal_route_F[24])
	);	
	//third output

//	xor (internal_route_T[26], internal_route_T[9], internal_route_T[13]);//x3x2x1 XOR x3x1x0
	XOR_GATE XOR_5(	
		.A_t(internal_route_T[13]),
		.A_f(internal_route_F[13]),
		.B_t(internal_route_T[9]),
		.B_f(internal_route_F[9]),
		.O_t(internal_route_T[26]),
		.O_f(internal_route_F[26])
	);

//	xor (internal_route_T[28], internal_route_T[5], In[1], internal_route_T[17]);//x2x0 XOR x1 XOR (x3 XOR x2)
	XOR_3_GATE XOR3_2 (
			.A_t(internal_route_T[17]),
			.A_f(internal_route_F[17]),
			.B_t(In_T[1]),
			.B_f(In_F[1]),
			.C_t(internal_route_T[5]),
			.C_f(internal_route_F[5]),
			.O_t(internal_route_T[28]),
			.O_f(internal_route_F[28])
	);
	
//	xor (internal_route_T[30], internal_route_T[29], internal_route_T[27]);//(x2x0 XOR x1 XOR (x3 XOR x2)) XOR (x3x2x1 XOR x3x1x0)
	XOR_GATE XOR_6(	
		.A_t(internal_route_T[27]),
		.A_f(internal_route_F[27]),
		.B_t(internal_route_T[29]),
		.B_f(internal_route_F[29]),
		.O_t(internal_route_T[30]),
		.O_f(internal_route_F[30])
	);

	//last output (LSB)
//	xor (internal_route_T[32], internal_route_T[19], internal_route_T[23]);//(x3x2x1 XOR x3x0) XOR (x3x2x0 XOR x2x1 XOR x2)
	XOR_GATE XOR_7(	
		.A_t(internal_route_T[23]),
		.A_f(internal_route_F[23]),
		.B_t(internal_route_T[19]),
		.B_f(internal_route_F[19]),
		.O_t(internal_route_T[32]),
		.O_f(internal_route_F[32])
	);

//	xor (internal_route_T[34], internal_route_T[15], internal_route_T[13]);//x2x1x0 XOR x3x1x0
	XOR_GATE XOR_8(	
		.A_t(internal_route_T[13]),
		.A_f(internal_route_F[13]),
		.B_t(internal_route_T[15]),
		.B_f(internal_route_F[15]),
		.O_t(internal_route_T[34]),
		.O_f(internal_route_F[34])
	);
	
//	xor (internal_route_T[36], In[1], In[0]);//x1 XOR x0
	XOR_GATE XOR_9(	
		.A_t(In_T[0]),
		.A_f(In_F[0]),
		.B_t(In_T[1]),
		.B_f(In_F[1]),
		.O_t(internal_route_T[36]),
		.O_f(internal_route_F[36])
	);

//	xor (internal_route_T[38], internal_route_T[7], internal_route_T[37]);//x3x1 XOR (x1 XOR x0)  //F_address: 81
	XOR_GATE XOR_10(	
		.A_t(internal_route_T[37]),
		.A_f(internal_route_F[37]),
		.B_t(internal_route_T[7]),
		.B_f(internal_route_F[7]),
		.O_t(internal_route_T[38]),
		.O_f(internal_route_F[38])
	);

//	xor (internal_route_T[40], internal_route_T[33], internal_route_T[35], internal_route_T[39]);//((x3x2x1 XOR x3x0) XOR (x3x2x0 XOR x2x1 XOR x2)) XOR (x2x1x0 XOR x3x1x0) XOR (x3x1 XOR (x1 XOR x0))
	XOR_3_GATE XOR3_3 (
			.A_t(internal_route_T[39]),
			.A_f(internal_route_F[39]),
			.B_t(internal_route_T[35]),
			.B_f(internal_route_F[35]),
			.C_t(internal_route_T[33]),
			.C_f(internal_route_F[33]),
			.O_t(internal_route_T[40]),
			.O_f(internal_route_F[40])
	);

	
	assign Out_T[3] = internal_route_T[21];
	assign Out_F[3] = internal_route_F[21];
	assign Out_T[2] = internal_route_T[25];
	assign Out_F[2] = internal_route_F[25];
	assign Out_T[1] = internal_route_T[31];
	assign Out_F[1] = internal_route_F[31];
	assign Out_T[0] = internal_route_T[41];
	assign Out_F[0] = internal_route_F[41];


	genvar i;
	generate
		for(i = 0; i < NUM_OF_INTERNAL_ROUTES/2 ; i = i+1)
		begin: Routing
			assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
            assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];
		end
	endgenerate
	
endmodule

