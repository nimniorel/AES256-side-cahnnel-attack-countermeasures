/* AES CIPHER
   Filename: Sbox8b.v 
   */


   module Sbox8b(
		input					Clk,
		input                   Reset,
		input		[1:0]		multi_cycle,
		input 		[BYTE-1:0]	Sbox_In_T,
		input 		[BYTE-1:0]	Sbox_In_F,
		input                   flipflpoindicator,
		output		[BYTE-1:0]	Sbox_Out_T,
		output		[BYTE-1:0]	Sbox_Out_F
	);
	
	parameter BYTE = 8;
 // true dataPath
	wire [BYTE-1:0] state1_wire_out_T;
	wire [BYTE-1:0] state2_wire_out_T;
	wire [BYTE-1:0]	state3_wire_out_T;
		
	wire [BYTE-1:0]	state2_in_T;
	wire [BYTE-1:0]	state3_in_T;
	 // false dataPath
	wire [BYTE-1:0] state1_wire_out_F;
	wire [BYTE-1:0] state2_wire_out_F;
	wire [BYTE-1:0]	state3_wire_out_F;
	reg            rstflipflop;	
	wire [BYTE-1:0]	state2_in_F;
	wire [BYTE-1:0]	state3_in_F;

	stage_1 stage1(
		.In_T(Sbox_In_T),
		.In_F(Sbox_In_F),
		.Out_T(state1_wire_out_T),
		.Out_F(state1_wire_out_F)
	);
	
	stage_2 stage2(
		.In_T(state2_in_T),
		.In_F(state2_in_F),
		.Out_T(state2_wire_out_T),
		.Out_F(state2_wire_out_F)
	);

	stage_3 stage3(
		.In_T(state3_in_T),
		.In_F(state3_in_F),
		.Out_T(Sbox_Out_T),
		.Out_F(Sbox_Out_F)
	);	
	// reset control for the s-box flipflop	
//	always @(posedge Clk ) workin!!!!!!
//	begin
		
//		if (multi_cycle == 0) begin
//		    rstflipflop<=1'b1;
//		end
//		else begin
//		rstflipflop<=1'b0;

//		end
			

//	end
    genvar c;
	// new flip flop with the precharge wave
	generate
		for(c=0;c<BYTE;c=c+1) begin: prechargingflipflop
            DFFwithPreCharge b0(.reset_1(Reset), .CLK(Clk), .Data_t(state1_wire_out_T[c]), .Data_f(state1_wire_out_F[c]),.flipflpoindicator(flipflpoindicator),.Q_t(state2_in_T[c]),.Q_f(state2_in_F[c]));
            DFFwithPreCharge b1(.reset_1(Reset), .CLK(Clk), .Data_t(state2_wire_out_T[c]), .Data_f(state2_wire_out_F[c]),.flipflpoindicator(flipflpoindicator),.Q_t(state3_in_T[c]),.Q_f(state3_in_F[c]));
        end 
	endgenerate	
	
	
	endmodule
