`timescale 1ns / 100ps
/*
		stage 1: mapping from GF(2^8) to GF((2^4)^2)
		this is done by multiplying the 8-bit input with a DELTA matrix
		DELTA = 	1 1 0 0 0 0 1 0
					0 1 0 0 1 0 1 0 
					0 1 1 1 1 0 0 1 
					0 1 1 0 0 0 1 1 
					0 1 1 1 0 1 0 1 
					0 0 1 1 0 1 0 1 
					0 1 1 1 1 0 1 1 
					0 0 0 0 0 1 0 1 
		this stage has 11 F-modules In_T it
*/

module stage_1(
	input	[BYTE-1:0]	In_T,		// TRUE input for the Sbox
	input	[BYTE-1:0]	In_F,        // FALSE input
	output 	[BYTE-1:0] 	Out_T,		// TRUE output
    output 	[BYTE-1:0] 	Out_F
);


	//parameters
	parameter internal_route_T_bus_size = 22;
	parameter internal_route_F_bus_size = 22;
	parameter BYTE = 8;
	
	
	wire [internal_route_T_bus_size-1:0] internal_route_T;
	wire [internal_route_F_bus_size-1:0] internal_route_F;
	//output assignment
	assign Out_T = {internal_route_T[21], internal_route_T[19], internal_route_T[17], internal_route_T[15], internal_route_T[11], internal_route_T[9], internal_route_T[3], internal_route_T[1]};
	assign Out_F = {internal_route_F[21], internal_route_F[19], internal_route_F[17], internal_route_F[15], internal_route_F[11], internal_route_F[9], internal_route_F[3], internal_route_F[1]};
	//logic gates
	//first row - LSB
	
//	xor(internal_route_T[0], In_T[6], In_T[1], In_T[0]);
	XOR_3_GATE XOR3_1(
		.A_t(In_T[0]),
		.A_f(In_F[0]),
		.B_t(In_T[1]),
		.B_f(In_F[1]),
		.C_t(In_T[6]),
		.C_f(In_F[6]),
		.O_t(internal_route_T[0]),
		.O_f(internal_route_F[0])
	);
	
	//second row
//	xor(internal_route_T[2], In_T[6], In_T[4], In_T[1]);
	XOR_3_GATE XOR3_2(
		.A_t(In_T[1]),
		.A_f(In_F[1]),
		.B_t(In_T[4]),
		.B_f(In_F[4]),
		.C_t(In_T[6]),
		.C_f(In_F[6]),
		.O_t(internal_route_T[2]),
		.O_f(internal_route_F[2])
	);

	//third row - broken to 2 logic levels
//	xor(internal_route_T[4], In_T[2], In_T[1]);//will be reused later	
	XOR_GATE XOR_1(
		.A_t(In_T[1]),
		.A_f(In_F[1]),
		.B_t(In_T[2]),
		.B_f(In_F[2]),
		.O_t(internal_route_T[4]),
		.O_f(internal_route_F[4])
	);
		
//	xor(internal_route_T[6], In_T[3], In_T[4]);	
	XOR_GATE XOR_2(
		.A_t(In_T[4]),
		.A_f(In_F[4]),
		.B_t(In_T[3]),
		.B_f(In_F[3]),
		.O_t(internal_route_T[6]),
		.O_f(internal_route_F[6])
	);
	
//	xor(internal_route_T[8], internal_route_T[5], internal_route_T[7], In_T[7]);//F_address: 4
	XOR_3_GATE XOR3_3(
		.A_t(In_T[7]),
		.A_f(In_F[7]),
		.B_t(internal_route_T[7]),
		.B_f(internal_route_F[7]),
		.C_t(internal_route_T[5]),
		.C_f(internal_route_F[5]),
		.O_t(internal_route_T[8]),
		.O_f(internal_route_F[8])
	);
		
	//forth row - broken to 2 logic levels (reuse of the xor from row 2)
//	xor(internal_route_T[10], internal_route_T[5], In_T[7], In_T[6]);	
	XOR_3_GATE XOR3_4(
		.A_t(In_T[6]),
		.A_f(In_F[6]),
		.B_t(In_T[7]),
		.B_f(In_F[7]),
		.C_t(internal_route_T[5]),
		.C_f(internal_route_F[5]),
		.O_t(internal_route_T[10]),
		.O_f(internal_route_F[10])
	);
		
	//fifth row - broken to 2 logic levels (reuse of the xor from row 2)
//	xor(internal_route_T[12], In_T[7], In_T[5], In_T[3]);//F_address: 6
	XOR_3_GATE XOR3_5(
		.A_t(In_T[3]),
		.A_f(In_F[3]),
		.B_t(In_T[5]),
		.B_f(In_F[5]),
		.C_t(In_T[7]),
		.C_f(In_F[7]),		
		.O_t(internal_route_T[12]),
		.O_f(internal_route_F[12])
	);

//	xor(internal_route_T[14], internal_route_T[13], internal_route_T[5]);	
	XOR_GATE XOR_3(
		.A_t(internal_route_T[5]),
		.A_f(internal_route_F[5]),
		.B_t(internal_route_T[13]),	
		.B_f(internal_route_F[13]),	
		.O_t(internal_route_T[14]),
		.O_f(internal_route_F[14])
	);
	
	//sixth row - broken to 2 logic levels (reuse of the xor from row 5)
//	xor(internal_route_T[16], internal_route_T[13], In_T[2]);
	XOR_GATE XOR_4(
		.A_t(In_T[2]),
		.A_f(In_F[2]),
		.B_t(internal_route_T[13]),
		.B_f(internal_route_F[13]),		
		.O_t(internal_route_T[16]),
		.O_f(internal_route_F[16])
	);
	
	//seventh row - broken to 2 logic levels (reuse of the xor from row 3)
//	xor(internal_route_T[18], internal_route_T[9], In_T[6]);	
	XOR_GATE XOR_5(
		.A_t(In_T[6]),
		.A_f(In_F[6]),
		.B_t(internal_route_T[9]),
		.B_f(internal_route_F[9]),
		.O_t(internal_route_T[18]),
		.O_f(internal_route_F[18])
	);
	
	//eighth row - MSB
//	xor(internal_route_T[20], In_T[7], In_T[5]);//F_address: 10	
	XOR_GATE XOR_6(
		.A_t(In_T[5]),
		.A_f(In_F[5]),
		.B_t(In_T[7]),
		.B_f(In_F[7]),
		.O_t(internal_route_T[20]),
		.O_f(internal_route_F[20])
	);
		
	genvar i;
	generate
		for(i = 0; i < internal_route_T_bus_size/2 ; i = i+1)
		begin: F_module_tree
			assign internal_route_T[((2*i)+1)] = internal_route_T[(2*i)];
		    assign internal_route_F[((2*i)+1)] = internal_route_F[(2*i)];
		end
			
	endgenerate	
		
		
		
endmodule

/*
module stage_1_TB ();
	//parameters
	parameter F_control_bus_size = 22;
	//ports list
	reg [7:0] In_T = 0;
	reg [F_control_bus_size-1 : 0] F_control = 0;
	wire [7:0] Out;
	
	reg [7:0] expectedResults[0:255];//a reg for the expected results of the claculation
	
	initial
			$readmemb("/u/e2012/bodnery/proj/DeltaEexpectedResults.txt", expectedResults); // DeltaEexpectedResults.txt is the memory initialization file
	
	stage_1 UUT(In_T, Out, F_control);//unit under test
	
	integer i, out_file;
	
	initial
		out_file = $fopen("/u/e2012/bodnery/proj/stage_1_TB.txt");//opening the output file
	
	initial
		begin
			for (i = 0 ; i < 256 ; i = i + 1 )
			begin
				if(Out == expectedResults[i])
					#1 $fdisplay(out_file,"In_T = %d, after conversion out = %d expected result = %d- SUCCESS", In_T, Out, expectedResults[i]);
				else
					#1 $fdisplay(out_file,"In_T = %d, after conversion out = %d expected result = %d- FAIL", In_T, Out, expectedResults[i]);
				#1 In_T = In_T + 1 ;
			end
			#1 $fclose(out_file);//close the output file
			$finish ;
		end
	
endmodule 
*/