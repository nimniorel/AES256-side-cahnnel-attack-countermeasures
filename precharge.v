`timescale 1ns / 1ps


// creating the complimentary logic for the input with the precharge wave
module precharge(input clk,input Reset, input A, output O_t, output O_f);
reg tempclk;
always@(posedge clk,posedge Reset) begin
if(Reset==1'b1) begin
tempclk<=1'b0;
end else begin
tempclk<=~tempclk;
end
end
assign O_t=~((~A) | tempclk);
assign O_f=~(A | tempclk);
endmodule
