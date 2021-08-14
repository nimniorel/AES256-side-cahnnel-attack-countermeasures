`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:42:53 03/14/2019
// Design Name:   WDDL_AES256_FSMSboxState
// Module Name:   /home/ise/Desktop/ISE_Projects/AES_256/AES256_TB.v
// Project Name:  AES_256
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: WDDL_AES256_FSMSboxState
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module AES256_TB;

	// Inputs
	reg Clk;
	reg [127:0] Plain_text_T;
	//reg [127:0] Plain_text_F;
	reg Reset;
	reg [255:0] In_Key_T;
	//reg [255:0] In_Key_F;

	// Outputs
	wire [127:0] Cipher_text_T;
    wire [127:0] Cipher_text_F;

	wire Done;
	wire trigger;
	wire flipflpoindicator;
	//wire [127:0] State_reg;

	// Instantiate the Unit Under Test (UUT)
	Regular_AES256_FSMSboxState uut (
		.Clk(Clk), 
		.Plain_text_T(Plain_text_T), 
		//.Plain_text_F(),
		.Reset(Reset), 
		.In_Key_T(In_Key_T),
		//.In_Key_F(),  
		.Cipher_text_T(Cipher_text_T), 
		.Cipher_text_F(Cipher_text_F), 
		.Done(Done), 
		.flipflpoindicator(flipflpoindicator),
		//.State_reg(State_reg),
		.trigger(trigger)
	);
	always #25
		Clk = ~Clk;

	initial begin
		// Initialize Inputs
		Clk = 0;
		//Plain_text_T = 0;
		//In_Key_T = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
       Plain_text_T = 128'h00000000000000000000000000000000;
	   In_Key_T = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
        //Plain_text_F = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		//In_Key_F = 256'hFFEEDDCCBBAA99887766554433221100FFEEDDCCBBAA99887766554433221100;
		Reset = 1;
		#130 Reset = 0;
		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

	end
      
endmodule

