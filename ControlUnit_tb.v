// file: ControlUnit_tb.v
// author: @ahmedfayed
// Testbench for ControlUnit

`timescale 1ns/1ns

module ControlUnit_tb;

	//Inputs
	reg [4: 0] opcode;


	//Outputs
	wire Branch;
	wire MemRead;
	wire MemToReg;
	wire [1: 0] ALUOp;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	wire JAL;
	wire JALR;


	//Instantiation of Unit Under Test
	ControlUnit uut (
		.opcode(opcode),
		.Branch(Branch),
		.MemRead(MemRead),
		.MemToReg(MemToReg),
		.ALUOp(ALUOp),
		.MemWrite(MemWrite),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.JAL(JAL),
		.JALR(JALR)
	);


	initial begin
	//Inputs initialization
	#100;
		opcode = 5'b00110;
		#100;
		
		opcode = 5'b11_011;
		#100;
		opcode = 5'b11_001;


	end

endmodule

