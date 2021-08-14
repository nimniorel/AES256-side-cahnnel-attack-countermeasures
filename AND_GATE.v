module AND_GATE(input A_t, input A_f, input B_t, input B_f, 		//true data in #1 
	output O_t,		//true data out
	output O_f		//false data out
);


wire I4,I5;

assign I5 = 1;
assign I4 = 0;


//LUT6_2 valid **ONLY** in Virtex-5, Virtex-6, Spartan-6

LUT6_2 #(
.INIT(64'h0000026000000400) // Specify LUT Contents acording to Truth Table for WDDL INVERSE GATE
) LUT6_2_inst (
.O6(O_f), // 6/5-LUT output (1-bit)
.O5(O_t), // 5-LUT output (1-bit)
.I0(B_f), // LUT input (1-bit)
.I1(B_t), // LUT input (1-bit)
.I2(A_f), // LUT input (1-bit)
.I3(A_t), // LUT input (1-bit)
.I4(I4), // LUT input (1-bit)
.I5(I5) // LUT input (1-bit)
);

    
endmodule
