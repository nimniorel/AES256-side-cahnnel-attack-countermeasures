`timescale 1ns / 1ps

module DFFwithPreCharge(input CLK, input Data_t, input Data_f,input reset_1,input flipflpoindicator, 
output reg Q_t, output reg Q_f );

reg tmp1_t;
reg tmp1_f;
// level 1 DFF. sampling the data
always@(posedge CLK,posedge reset_1) begin
    if (reset_1==1'b1) begin
        tmp1_t<=1'b0;
        tmp1_f<=1'b1;

end else begin
        tmp1_t<=Data_t;
        tmp1_f<=Data_f;
end
end
// level 2 DFF. sampling the right data or creating the precharge wave depending on the control line - "flipflpoindicator"
always@(posedge CLK,posedge reset_1) begin
       if (reset_1==1'b1) begin
        Q_t<=1'b0;
        Q_f<=1'b1;
        end else begin 
    if (flipflpoindicator) begin
        Q_t<=tmp1_t;
        Q_f<=tmp1_f;
end else begin
        Q_t<=1'b0;
        Q_f<=1'b0;

end
end
end

endmodule
