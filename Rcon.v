module Rcon(
	input	[ROUND-1:0]	Round_number_T,
	input	[ROUND-1:0]	Round_number_F,
	output reg	[WORD-1:0]	Out_word_T,
	output reg	[WORD-1:0]	Out_word_F
);		// module name and ports list.
	
	//parameters declaration
	parameter ROUND = 4; //number of rounds in bits
	parameter WORD = 32; //number of bits in a word
	
	always @(*)
	begin
		case(Round_number_T)
			4'd1:begin
			 Out_word_T = {8'h01,24'h0};
			 Out_word_F={8'hFE,24'hFFFFFF};
			 end
			4'd2:begin
			 Out_word_T = {8'h02,24'h0};
			 Out_word_F={8'hFD,24'hFFFFFF};
			 end
 			4'd3:begin
 			 Out_word_T = {8'h04,24'h0};
 			 Out_word_F={8'hFB,24'hFFFFFF};
 			 end
			4'd4:begin
			 Out_word_T = {8'h08,24'h0};
			 Out_word_F={8'hF7,24'hFFFFFF};
			 end
			4'd5:begin
			 Out_word_T = {8'h10,24'h0};
			 Out_word_F = {8'hEF,24'hFFFFFF};
			 end
			4'd6:begin
			 Out_word_T = {8'h20,24'h0};
			 Out_word_F = {8'hDF,24'hFFFFFF};
			 end
			4'd7:begin
			 Out_word_T = {8'h40,24'h0};
			 Out_word_F = {8'hBF,24'hFFFFFF};
			 end
			4'd8:begin
			 Out_word_T = {8'h80,24'h0};
			 Out_word_F = {8'h7F,24'hFFFFFF};
			 end
			4'd9:begin
			 Out_word_T = {8'h1b,24'h0};
			 Out_word_F = {8'hB4,24'hFFFFFF};
			 end
			4'd10:begin
			 Out_word_T = {8'h36,24'h0};
			 Out_word_F = {8'hC9,24'hFFFFFF};
			 end					
			4'd11:begin
			 Out_word_T = {8'h6c,24'h0};
			 Out_word_F = {8'h93,24'hFFFFFF};	
			 end		
			4'd12:begin
			 Out_word_T = {8'hd8,24'h0};
			  Out_word_F = {8'h27,24'hFFFFFF};		
			 end		
			4'd13:begin
			 Out_word_T = {8'hab,24'h0};
			  Out_word_F = {8'h54,24'hFFFFFF};	
			 end			
			4'd14:begin
			 Out_word_T = {8'h4d,24'h0};
			  Out_word_F = {8'hB2,24'hFFFFFF};	
			 end			
			4'd15:begin
			 Out_word_T = {8'h9a,24'h0};
			  Out_word_F = {8'h65,24'hFFFFFF};	
			 end		
			
			default:begin
			 Out_word_T = {8'h00,24'h0};
			  Out_word_F = {8'hFF,24'hFFFFFF};
			 end
		endcase
		
		
		
	end
endmodule

