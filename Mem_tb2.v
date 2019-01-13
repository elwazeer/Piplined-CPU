// file: Mem_tb.v
// author: @ahmedsharaf
// Testbench for Mem

`timescale 1ns/1ns

module Mem_tb;

	//Inputs
	reg clk;
	reg rst;
	reg MemWrite;
	reg [9: 0] addr;
	reg [31: 0] data_in;
	reg u;
	reg [1: 0] mem_inst_type;


	//Outputs
	wire [31: 0] data_out;


	//Instantiation of Unit Under Test
	Mem uut (
		.clk(clk),
		.rst(rst),
		.MemWrite(MemWrite),
		.addr(addr),
		.data_in(data_in),
		.u(u),
		.mem_inst_type(mem_inst_type),
		.data_out(data_out)
	);

    always #10 clk = ~clk;
	initial begin
	//Inputs initialization
		clk = 0;
        u = 0;
    
		
        MemWrite = 1;
        #100	
         MemWrite = 0;
         addr = 0;
        mem_inst_type = 0;
        #100    
        MemWrite = 0;
        addr = 4;
        #100
        MemWrite = 0;
        addr = 8;
        #100
        addr = 12;
        #100
        addr = 16;
        #100
        addr = 20;
        #100
        addr = 24;
	end

endmodule