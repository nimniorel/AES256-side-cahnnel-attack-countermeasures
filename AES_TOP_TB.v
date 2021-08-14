`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2020 10:17:26 AM
// Design Name: 
// Module Name: AES_TOP_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AES_TOP_TB();
reg		TOP_ResetAll;
reg		TOP_Clk;
wire	CompareFlag_p;
wire	trigger;
AES_TOP a1(
			.TOP_ResetAll(TOP_ResetAll),
			.TOP_Clk(TOP_Clk),
		    .CompareFlag_p(CompareFlag_p),
		    .trigger(trigger)
);
always #1
		TOP_Clk = ~TOP_Clk;

	initial begin
		// Initialize Inputs
		TOP_Clk = 0;
		TOP_ResetAll = 1;
		#130 ;
		// Wait 100 ns for global reset to finish
		TOP_ResetAll = 0;
		//#70000 ;
		
        
		end

endmodule
