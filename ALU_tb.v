`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2018 12:41:42 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] funct3;
    wire [0:0] z;
    wire c;
    wire v;
    wire [31:0] alu_out;
    
    ALU uut(a,b,funct3, z, c, v, alu_out);
    initial begin
        #100 a=32'd2000000000;
        b=32'd2000000000;
        #100 funct3 = 4'd0;
        #100 funct3 = 4'd1;
        #100 funct3 = 4'd2;
        #100 funct3 = 4'd3;
        #100 funct3 = 4'd4;
        #100 funct3 = 4'd5;
        #100 funct3 = 4'd6;
        #100 funct3 = 4'd7;
    end
endmodule


