/* AES CIPHER
   Filename: Regular_AES256_FSMSboxState.v 
 */


module Regular_AES256_FSMSboxState (
	input				Clk,
	//input				Clk_logic,
	input 		[N-1:0]	Plain_text_T,
	//input 		[N-1:0]	Plain_text_F,
	input 				Reset,
	input 		[K-1:0]	In_Key_T,
	//input 		[K-1:0]	In_Key_F,
	output reg	[N-1:0]	Cipher_text_T,
	output reg	[N-1:0]	Cipher_text_F,
	output reg 			Done,
	output reg 			trigger,
	output reg         flipflpoindicator
);

	parameter N = 128; // Size of Plain Text
	parameter K = 256;// Size of Key
	parameter ROUND = 4; //for using roundex counter	
	
	
	//wires
	wire [K-1:0] 	Next_Key_T ;
	wire [K-1:0] 	Next_Key_F ;
    wire [K-1:0] 	in_key_temp_T ;
    wire [K-1:0] 	in_key_temp_F ;
    wire  [K-1:0]   in_key_temp_PreAfterDFF_T;
    wire  [K-1:0]   in_key_temp_PreAfterDFF_F;
	wire [N-1:0]    Plain_text_tmp_T;
	wire [N-1:0]    Plain_text_tmp_F;
	wire  [N-1:0]   Plain_text_tmp_PreAfterDFF_T;
	wire  [N-1:0]   Plain_text_tmp_PreAfterDFF_F;
	wire [N-1:0]	Sliced_Key_T;
	wire [N-1:0]	Sliced_Key_F;	
	wire [N-1:0] 	RoundKey_Out_wire_T;
	wire [N-1:0] 	RoundKey_Out_wire_F;
	wire [N-1:0] 	Sbox_Out_wire_T;
	wire [N-1:0] 	Sbox_Out_wire_F;
	wire [N-1:0] 	Shift_Rows_wire_out_T;
	wire [N-1:0] 	Shift_Rows_wire_out_F;
	wire [N-1:0] 	Mix_Col_wire_In_T;
	wire [N-1:0] 	Mix_Col_wire_In_F;
	wire [N-1:0] 	Mix_Col_wire_out_T;
	wire [N-1:0] 	Mix_Col_wire_out_F;
	wire [N-1:0]    temp_Cipher_text_T;
	wire [N-1:0]    temp_Cipher_text_F;
	wire				clk_lgc1;
	wire 				clk_lgc2;
	wire 				clk_lgc3;
	wire				clk_lgc4;
	(* KEEP = "true" *)	wire [N-1:0] 	Sbox_In_wire_T;
	(* KEEP = "true" *)	wire [N-1:0]    Sbox_In_wire_F;
	(* dont_touch = "true" *)	wire [N-1:0]		State_reg_T;
	(* dont_touch = "true" *)	wire [N-1:0]		State_reg_F;
	(* KEEP = "true" *)	wire [ROUND-1:0]	RoundEx_in_wire_T ;
	(* KEEP = "true" *)	wire [ROUND-1:0]	RoundEx_in_wire_F ;
	(* KEEP = "true" *)	wire [ROUND-1:0]	RoundEx_in_reg_T ;
	(* KEEP = "true" *)	wire [ROUND-1:0]	RoundEx_in_reg_F ; 
	
	//registers
	
	reg [K-1:0] 	Current_Key_T;
	reg [K-1:0] 	Current_Key_F;
	reg [K-1:0]     Current_Key_T_Level_2;
	reg [K-1:0]     Current_Key_F_Level_2;
	reg [K-1:0]     Current_Key_T_Level_temp;
	reg [K-1:0]     Current_Key_F_Level_temp;
	reg [N-1:0] 	AddRoundIn_T;
	reg [N-1:0] 	AddRoundIn_F;
	reg [ROUND-1:0] Round_Wire;
	reg [2:0]		Multi_State_Ex;
	reg [1:0]	 	State, State_Wire;
	reg [1:0]		Multi_Cycle_Wire;
	reg [ROUND-1:0] Round;
	reg				Done_wire; 
	
	

	/////////////////////////////////
//	BUFG clk_logic2
//   (.O (clk_lgc2),
//   .I (Clk));
//	BUFG clk_logic3
//   (.O (clk_lgc3),
//   .I (Clk));
//	BUFG clk_logic4
//   (.O (clk_lgc4),
//   .I (Clk));
//	BUFG clk_logic1
//   (.O (clk_lgc1),
//   .I (Clk));
	/////////////////////////////////
	assign RoundEx_in_wire_T = (Reset) ? 4'h0 : (Round_Wire[0] == 1'b1) ? (Round>>1) : RoundEx_in_reg_T;
	assign RoundEx_in_wire_F = (Reset) ? 4'hF : (Round_Wire[0] == 1'b1) ? {1'b1,Round[3:1]} : RoundEx_in_reg_F;
	assign Sliced_Key_T = (Round[0] == 1'b1) ? Current_Key_T_Level_2[N-1:0] : Current_Key_T_Level_2[K-1:N]; //for the key expantion process
    assign Sliced_Key_F = (Round[0] == 1'b1) ? Current_Key_F_Level_2[N-1:0] : Current_Key_F_Level_2[K-1:N]; //for the key expantion process
	assign Mix_Col_wire_In_T = Shift_Rows_wire_out_T;
	assign Mix_Col_wire_In_F = Shift_Rows_wire_out_F;
	
	assign Sbox_In_wire_T = RoundKey_Out_wire_T;
	assign Sbox_In_wire_F = RoundKey_Out_wire_F;
	
	genvar c;
	
	generate
	   //precharge with nor and then 2 dff to extand the pulse length for 1 clock
		for(c=0;c<K;c=c+1) begin: prechargingKey
        precharge pc1 (.clk(Clk),.Reset(Reset),.A(In_Key_T[c]),.O_t(in_key_temp_PreAfterDFF_T[c]),.O_f(in_key_temp_PreAfterDFF_F[c]));
	   // DFF_2 pc2(.flipflpoindicator(flipflpoindicator),.CLK(Clk),.Reset(Reset), .Data_t(in_key_temp_T[c]), .Data_f(in_key_temp_F[c]),.Q_t(in_key_temp_PreAfterDFF_T[c]),.Q_f(in_key_temp_PreAfterDFF_F[c]));
        
        end 
	endgenerate	
	genvar i;
	
	generate
	  //precharge with nor and then 2 dff to extand the pulse length for 1 clock
		for(i=0;i<N;i=i+1) begin: precharging2CipherText
        precharge pc3 (.clk(Clk),.Reset(Reset),.A(Plain_text_T[i]),.O_t(Plain_text_tmp_PreAfterDFF_T[i]),.O_f(Plain_text_tmp_PreAfterDFF_F[i]));
       // DFF_2 pc4(.flipflpoindicator(flipflpoindicator),.CLK(Clk),.Reset(Reset), .Data_t(Plain_text_tmp_T[i]), .Data_f(Plain_text_tmp_F[i]),.Q_t(Plain_text_tmp_PreAfterDFF_T[i]),.Q_f(Plain_text_tmp_PreAfterDFF_F[i]));
        end 
	endgenerate	
	genvar r;
	
	generate
	 //xoring last round between the output of shiftrows and the key and it sampled only in the last round
		for(r=0;r<N;r=r+1) begin: xoring2 
        XOR_GATE a4(.A_t(Shift_Rows_wire_out_T[r]), .A_f(Shift_Rows_wire_out_F[r]),.B_t(Sliced_Key_T[r]), .B_f(Sliced_Key_F[r]), 		//true data in #1 
	   .O_t(temp_Cipher_text_T[r]),		//true data out
	   .O_f(temp_Cipher_text_F[r]));		//false data out
        end
    
    endgenerate
	
	 genvar x;
	
	generate
	// new flip flop with the precharge wave
		for(x=0;x<N;x=x+1) begin: statereg_flipflop
        DFFwithPreCharge b0(.flipflpoindicator(flipflpoindicator),.reset_1(Reset), .CLK(Clk), .Data_t(Sbox_Out_wire_T[x]), .Data_f(Sbox_Out_wire_F[x]),.Q_t(State_reg_T[x]),.Q_f(State_reg_F[x]));

        end 
	endgenerate	
    genvar z;
	
	generate
	// new flip flop with the precharge wave
		for(z=0;z<ROUND;z=z+1) begin: roundex_flipflop
        DFFwithPreCharge b0(.flipflpoindicator(flipflpoindicator),.reset_1(Reset), .CLK(Clk), .Data_t(RoundEx_in_wire_T[z]), .Data_f(RoundEx_in_wire_F[z]),.Q_t(RoundEx_in_reg_T[z]),.Q_f(RoundEx_in_reg_F[z]));

        end 
	endgenerate	
	
	
	//component conections
	
	KeyExpantion_256 KeyEx(
		.Clk(Clk),
		.Reset(Reset),
		.Multi_State(Multi_State_Ex),
		.In_Key_T(Current_Key_T_Level_2),
		.In_Key_F(Current_Key_F_Level_2),
		.Round_Number_T(RoundEx_in_wire_T),
		.Round_Number_F(RoundEx_in_wire_F),
		.flipflpoindicator(flipflpoindicator),
		.Out_Key_T(Next_Key_T),
		.Out_Key_F(Next_Key_F)
	);

	AddRoundKey key(
		.In_Data_T(AddRoundIn_T),
		.In_Data_F(AddRoundIn_F),
		.In_key_T(Sliced_Key_T),
		.In_key_F(Sliced_Key_F),
		.Output_Key_T(RoundKey_Out_wire_T),
		.Output_Key_F(RoundKey_Out_wire_F)
	);	
	
	SubBytes Sub(
		.Clk(Clk),
		.Reset(Reset),
		.Multi_Cycle_State(Multi_Cycle_Wire),
		.SubByte_In_T(Sbox_In_wire_T),
		.SubByte_In_F(Sbox_In_wire_F),
		.flipflpoindicator(flipflpoindicator),
		.SubByte_Out_T(Sbox_Out_wire_T),
		.SubByte_Out_F(Sbox_Out_wire_F)
	);
		
	ShiftRows shft(
		.Text_In_T(State_reg_T),
		.Text_In_F(State_reg_F),
		.Out_Text_T(Shift_Rows_wire_out_T),
		.Out_Text_F(Shift_Rows_wire_out_F)
	);
	
	MixColumns MxCl(
		.MixCol_In_T(Mix_Col_wire_In_T),
		.MixCol_In_F(Mix_Col_wire_In_F),
		.MixCol_Out_T(Mix_Col_wire_out_T),
		.MixCol_Out_F(Mix_Col_wire_out_F)
	);
	

	
	//State Machine:
	//State 0: initial the variables.
	//State 1: Start Enc, cycle No.1
	//State 2: cycle No.2
	//State 3: cycle No.3 - Round 2 Until the End of the Encryption
	// ****************** //
	always @(*)
	begin
	 
	case (State)
	 
	2'd0:begin
		Round_Wire = 0;
		State_Wire = 2'd1;
		Multi_Cycle_Wire = 2'd0;
		Cipher_text_T = 0;
		Cipher_text_F =128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		Multi_State_Ex = 3'd0;
		Done_wire = 0;
		trigger = 0;
		AddRoundIn_T = 0;
        AddRoundIn_F = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		end
	 
	2'd1:begin

		Multi_Cycle_Wire = 2'd1;
		Cipher_text_T = 0;
		Cipher_text_F =128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		Done_wire = 1'd0;
		Round_Wire = Round;
		trigger = 0;
		
		if (Round == 0) begin
			AddRoundIn_T = Plain_text_tmp_PreAfterDFF_T;
			AddRoundIn_F = Plain_text_tmp_PreAfterDFF_F;
		end
		else begin
			AddRoundIn_T = Mix_Col_wire_out_T;
			AddRoundIn_F = Mix_Col_wire_out_F;
		end
		
		if (Round[0] == 0) begin 
			Multi_State_Ex = 3'd1;
		end
		else begin
			Multi_State_Ex = 3'd4;	
		
		end
		if (Round == 4'd14) begin 
			Cipher_text_T=temp_Cipher_text_T;
			Cipher_text_F=temp_Cipher_text_F;
			State_Wire = 2'd0;
		end
		else begin
			State_Wire = 2'd2;
			Cipher_text_T = 0;
		Cipher_text_F =128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		end		
		
		end
	
	2'd2:begin
		Multi_Cycle_Wire = 2'd2;
		State_Wire = 2'd3;
		Cipher_text_T = 0;
		Cipher_text_F =128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		AddRoundIn_T = Mix_Col_wire_out_T;
		AddRoundIn_F = Mix_Col_wire_out_F;
		Done_wire = 0;
		Round_Wire = Round;
		
		if (Round[0] == 0) begin 
			Multi_State_Ex = 3'd2;	
		end
		else begin
			Multi_State_Ex = 3'd5;		
		
		end
		
		
		if (Round == 4'd1)
			trigger = 1'd1;
		else
			trigger = 0;

		 
		end
		
	2'd3:begin
		Multi_Cycle_Wire = 2'd3;
		AddRoundIn_T = Mix_Col_wire_out_T;
		AddRoundIn_F = Mix_Col_wire_out_F;
		State_Wire = 2'd1;
		Round_Wire = Round + 4'd1;		
		Cipher_text_T = 0;
		Cipher_text_F =128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		trigger = 0;

		
		if (Round[0] == 0) begin 
			Multi_State_Ex = 3'd3;	

		end
		else begin
			Multi_State_Ex = 3'd7;		
		
		end
					
		if (Round == 4'd13)
			Done_wire = 1'd1;
		else
			Done_wire = 0;
		
		end

	endcase
	end
	 
	 
	always @(posedge Clk,posedge Reset)
	begin
		
	
		if (Reset) begin
			State <= 0;	
			Round <= 0;
			Done<=0;
	
		end
		else begin 
		      Done <= Done_wire;
		    if (!flipflpoindicator) begin  //sync the signals to match the right sample
			State <= State_Wire;	
			Round <= Round_Wire;
			end
			
		
		end

	end
	// level 1 DFF without precharge
	always @(posedge Clk,posedge Reset) 
	begin
		if (Reset) begin
		Current_Key_T <= in_key_temp_PreAfterDFF_T;
         Current_Key_F <= in_key_temp_PreAfterDFF_F;
      //  Current_Key_T<=256'h0000000000000000000000000000000000000000000000000000000000000000;
       // Current_Key_F<=256'h0000000000000000000000000000000000000000000000000000000000000000;
			//flipflpoindicator<=1'b1;
		end
		
		else begin 
		      //Current_Key_T <= in_key_temp_PreAfterDFF_T;
	          // Current_Key_F <= in_key_temp_PreAfterDFF_F;
			if ((Round[0] == 1'd1) && (State == 2'd3)) begin
				Current_Key_T <= Next_Key_T; 
				Current_Key_F <= Next_Key_F; 
			end
		
		end

	end
	//level 2 DFF with precharge and cotrol for the syncing indicator
	always @(posedge Clk,posedge Reset) begin
		if (Reset) begin
		flipflpoindicator<=1'b0;
            Current_Key_T_Level_2<=256'h0000000000000000000000000000000000000000000000000000000000000000;
	        Current_Key_F_Level_2<=256'h0000000000000000000000000000000000000000000000000000000000000000;
		end
		else begin
			if (flipflpoindicator) begin
	// sampling data    
             flipflpoindicator<=1'b0;
//             Current_Key_T_Level_temp<=Current_Key_T;
//             Current_Key_F_Level_temp<=Current_Key_F;
             Current_Key_T_Level_2<=Current_Key_T;
	         Current_Key_F_Level_2<=Current_Key_F;
			end else begin
	// precharge wave    
	         Current_Key_T_Level_2<=256'h0000000000000000000000000000000000000000000000000000000000000000;
	         Current_Key_F_Level_2<=256'h0000000000000000000000000000000000000000000000000000000000000000;
	         flipflpoindicator<=1'b1;
				end
			end
			end
		
endmodule