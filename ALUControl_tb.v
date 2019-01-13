// file: ALUControl_tb.v
// author: @ahmedfayed
// Testbench for ALUControl

`timescale 1ns/1ns

module ALUControl_tb;

	reg [1:0] ALUOp;
    reg [2:0] func3;
    reg func7;
    wire [2:0] sel;
    
    ALUControl uut(ALUOp, func3, func7, sel);
    initial begin
    #100
    ALUOp = 2'b00;
    func7 = 1;
    #100
    ALUOp = 2'b01;
    #100
    ALUOp = 2'b10;
    func3 = 3'b000;
    #100 func3 = 3'b001;
    #100 func3 = 3'b010;
    #100 func3 = 3'b011;
    #100 func3 = 3'b100;
    #100 func3 = 3'b101;
    #100 func3 = 3'b111;
    #100
    ALUOp = 2'b11;
    func3 = 3'b000;
    func7 = 0;
    #100 func7 = 1;
    #100 func3 = 3'b001; func7 = 0;
    #100 func3 = 3'b010;
    #100 func3 = 3'b011;
    #100 func3 = 3'b100;
    #100 func3 = 3'b101;
    #100 func3 = 3'b101; func7 = 1;
    #100 func3 = 3'b110; func7 = 0;
    #100 func3 = 3'b111;
    
    end
endmodule
