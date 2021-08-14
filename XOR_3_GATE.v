module XOR_3_GATE(

	input A_t, input A_f, input B_t, input B_f, 		//true data in #1 
	
	input C_t, input C_f,
	output O_t,		//true data out
	output O_f		//false data out

    );
wire tmp_OT,tmp_OF;


XOR_GATE a0(.A_t(A_t), .A_f(A_f),.B_t(B_t), .B_f(B_f), 		//true data in #1 
	.O_t(tmp_OT),		//true data out
	.O_f(tmp_OF)		//false data out

    );
    
 XOR_GATE a1(.A_t(tmp_OT), .A_f(tmp_OF),.B_t(C_t), .B_f(C_f), 		//true data in #1 
	.O_t(O_t),		//true data out
	.O_f(O_f)		//false data out

    );   
endmodule