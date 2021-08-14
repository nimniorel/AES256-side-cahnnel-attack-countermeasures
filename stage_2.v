`timescale 1ns / 100ps
/*
		stage 2: multiplicative inversion in GF((2^4)^2) (this stage has 144 F-modules in it)
*/

module stage_2 (
	input	[7:0]	In_T,
	input	[7:0]	In_F,
	output	[7:0]	Out_T,
	output	[7:0]	Out_F
);

	//wires
	wire [39:0] internal_route_T;
	wire [39:0] internal_route_F;
	//sub-modules
	square s(
		.In_T(In_T[7:4]),
		.In_F(In_F[7:4]),
		.Out_T(internal_route_T[3:0]),
		.Out_F(internal_route_F[3:0])
	);

	lamdaX lx(
		.In_T(internal_route_T[3:0]),
		.In_F(internal_route_F[3:0]),
		.Out_T(internal_route_T[7:4]),
		.Out_F(internal_route_F[7:4])
	);
	
	
	//first XOR (from the left)
//	xor(internal_route_T[8], In_T[0], In_T[4]);//LSB
	XOR_GATE XOR_1(	
		.A_t(In_T[4]),
		.A_f(In_F[4]),
		.B_t(In_T[0]),
		.B_f(In_F[0]),
		.O_t(internal_route_T[8]),
		.O_f(internal_route_F[8])
	);	
		
//	xor(internal_route_T[9], In_T[1], In_T[5]);
	XOR_GATE XOR_2(	
		.A_t(In_T[5]),
		.A_f(In_F[5]),
		.B_t(In_T[1]),
		.B_f(In_F[1]),
		.O_t(internal_route_T[9]),
		.O_f(internal_route_F[9])
	);		
	
//	xor(internal_route_T[10], In_T[2], In_T[6]);
	XOR_GATE XOR_3(	
		.A_t(In_T[6]),
		.A_f(In_F[6]),
		.B_t(In_T[2]),
		.B_f(In_F[2]),		
		.O_t(internal_route_T[10]),
		.O_f(internal_route_F[10])
	);
	
//	xor(internal_route_T[11], In_T[3], In_T[7]);//MSB  //F_address: 21
	XOR_GATE XOR_4(	
		.A_t(In_T[7]),
		.A_f(In_F[7]),
		.B_t(In_T[3]),
		.B_f(In_F[3]),
		.O_t(internal_route_T[11]),
		.O_f(internal_route_F[11])
	);
	
	mul4 m1(
		.In1_T(internal_route_T[15:12]),
		.In1_F(internal_route_F[15:12]),
		.In2_T(In_T[3:0]),
		.In2_F(In_F[3:0]),
		.Out_T(internal_route_T[19:16]),
		.Out_F(internal_route_F[19:16])
	);

	//second XOR (from the left)
//	xor(internal_route_T[20], internal_route_T[16], internal_route_T[4]);//LSB
	XOR_GATE XOR_5(	
		.A_t(internal_route_T[4]),
		.A_f(internal_route_F[4]),
		.B_t(internal_route_T[16]),
		.B_f(internal_route_F[16]),
		.O_t(internal_route_T[20]),
		.O_f(internal_route_F[20])
	);	
	
//	xor(internal_route_T[21], internal_route_T[17], internal_route_T[5]);
	XOR_GATE XOR_6(	
		.A_t(internal_route_T[5]),
		.A_f(internal_route_F[5]),
		.B_t(internal_route_T[17]),
		.B_f(internal_route_F[17]),
		.O_t(internal_route_T[21]),
		.O_f(internal_route_F[21])
	);		

//	xor(internal_route_T[22], internal_route_T[18], internal_route_T[6]);
	XOR_GATE XOR_7(	
		.A_t(internal_route_T[6]),
		.A_f(internal_route_F[6]),
		.B_t(internal_route_T[18]),
		.B_f(internal_route_F[18]),
		.O_t(internal_route_T[22]),
		.O_f(internal_route_F[22])
	);	
	
//	xor(internal_route_T[23], internal_route_T[19], internal_route_T[7]);//MSB  
	XOR_GATE XOR_8(	
		.A_t(internal_route_T[7]),
		.A_f(internal_route_F[7]),
		.B_t(internal_route_T[19]),
		.B_f(internal_route_F[19]),
		.O_t(internal_route_T[23]),
		.O_f(internal_route_F[23])
	);		
	//inverse
	inverseX invx(
		.In_T(internal_route_T[27:24]),
		.In_F(internal_route_F[27:24]),
		.Out_T(internal_route_T[31:28]),
		.Out_F(internal_route_F[31:28])
	);
	
	
	//mul4 m2 and m3
	mul4 m2(
		.In1_T(internal_route_T[31:28]),
		.In1_F(internal_route_F[31:28]),
		.In2_T(In_T[7:4]),
		.In2_F(In_F[7:4]),
		.Out_T(internal_route_T[39:36]),
		.Out_F(internal_route_F[39:36])
	);
	
	mul4 m3(
		.In1_T(internal_route_T[31:28]),
		.In1_F(internal_route_F[31:28]),
		.In2_T(internal_route_T[15:12]),
		.In2_F(internal_route_F[15:12]),
		.Out_T(internal_route_T[35:32]),
		.Out_F(internal_route_F[35:32])
	);//LSBs 
	
	assign Out_T = internal_route_T[39:32];
	assign Out_F = internal_route_F[39:32];
	genvar i;
	generate
		for(i = 8; i < 12 ; i = i+1)
		begin: F_module_tree
			assign internal_route_T[(i+4)] = internal_route_T[i];
            assign internal_route_F[(i+4)] = internal_route_F[i];

		end
		for(i = 20; i < 24 ; i = i+1)
		begin: F_module_tree_2
			assign internal_route_T[(i+4)] = internal_route_T[i];
            assign internal_route_F[(i+4)] = internal_route_F[i];
		end
	endgenerate
	
endmodule 

/*

module stage_2_TB ();
	//parameters
	parameter F_control_bus_size = 288;
	//ports list
	reg [7:0] In = 0;
	reg [F_control_bus_size-1 : 0] F_control = 0;
	wire [7:0] Out;
	
	stage_2 UUT(In, Out, F_control);//unit under test
	
	integer i, out_file;
	
	initial
		out_file = $fopen("/u/e2012/bodnery/proj/stage_2_TB.txt");//opening the output file
	
	initial
		begin
			for (i = 0 ; i < 256 ; i = i + 1 )
			begin
				#1 $fdisplay(out_file,"in1^-1 = %d^-1 = %d ", In, Out);
				#1 In = In + 1 ;
			end
			#1 $fclose(out_file);//close the output file
			$finish ;
		end
	
endmodule
*/