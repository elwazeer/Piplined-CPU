// file: Comparator_tb.v
// author: @ahmedfayed
// Testbench for Comparator

`timescale 1ns/1ns

module Comparator_tb;

	//Inputs
	reg z;
	reg s;
	reg v;
	reg c;
	reg [2: 0] funct3;


	//Outputs
	wire output_branch;


	//Instantiation of Unit Under Test
	Comparator uut (
		.z(z),
		.s(s),
		.v(v),
		.c(c),
		.funct3(funct3),
		.output_branch(output_branch)
	);


	initial begin
	//Inputs initialization
		z = 0;
		s = 0;
		v = 0;
		c = 0;
		funct3 = 3'b000;
	//Wait for the reset
		#100
		
		#100 funct3 = 3'b001;
    #100 funct3 = 3'b010;
    #100 funct3 = 3'b011;
    #100 funct3 = 3'b100;
    #100 funct3 = 3'b101;
    #100 funct3 = 3'b111;

	end

endmodule

