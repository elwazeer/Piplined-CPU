// file: Mem_tb.v
// Testbench for Mem
	
`timescale 1ns/1ns

module Mem_tb;

	//Inputs
	reg clk;
	reg rst;
	reg mWr;
	reg [9: 0] mAddr;
	reg [31: 0] mDi;
	reg sign;
	reg [1: 0] mSize;


	//Outputs
	wire [31: 0] mDo;


	Memory test (
		.clk(clk),
		.rst(rst),
		.mWr(mWr),
		.mAddr(mAddr),
		.mDi(mDi),
		.sign,
		.mSize(mSize),
		.mDo(mDo)
	);

    always #10 clk = ~clk;
	initial begin
	//Inputs initialization
		clk = 0;
        sign = 0;
        #10 rst = 0;
        #10 rst = 1;
        #10 rst = 0;
		
        mWr = 1;
        mAddr = 0;
        mDi = 15;
        sign = 0;
        #100		
        
        mAddr = 7;
        mDi = 31;
        sign = 1;
        #100
        
        mAddr = 9;
        mDi = 8095;
        sign = 2;
        
        #100
        mAddr = 0;
        sign = 0;
        mWr = 0;
        
        #100
        sign = 1;
        mAddr = 7;
        

        #100
        sign = 2;
        mAddr = 9;

        

	end

endmodule

