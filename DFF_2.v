`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2020 11:28:26 AM
// Design Name: 
// Module Name: DFF_2
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

//DFF that samples the data or creating the precharge wave and extanding the signal data/precharge to full clock cycle. 
module DFF_2(input CLK,input Reset, input Data_t, input Data_f,input flipflpoindicator, 
output reg Q_t, output reg Q_f );
//reg state;
reg tmp1_t;
reg tmp1_f;
wire notrst;
//initial begin
//tmp1_t<=1'b0;
//tmp1_f<=1'b1;
//end
//assign notrst=~Reset;

// level 1 DFF. sampling the data
always@(posedge CLK,posedge Reset) begin // original neg clk
    if (Reset==1'b1) begin
      tmp1_t<=1'b0;
        tmp1_f<=1'b1;

    end else begin
        tmp1_t<=Data_t;
        tmp1_f<=Data_f;
end
end
// level 2 DFF. sampling the right data or creating the precharge wave depending on the control line - "flipflpoindicator"
always@(posedge CLK,posedge Reset) begin
    if(Reset==1'b1) begin
          Q_t<=1'b0;
           Q_f<=1'b0;
          end else begin
    if (!flipflpoindicator) begin
        Q_t<=tmp1_t;
        Q_f<=tmp1_f;

    end else begin
        Q_t<=1'b0;
        Q_f<=1'b0;
end
end
end

endmodule