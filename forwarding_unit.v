// file: forwarding_unit.v


`timescale 1ns/1ns

module forwarding_unit(input RegWrite_EX, input RegWrite_MEM,input [4:0] rs1,input [4:0] rs2,
input [4:0] rd_EX,input [4:0] rd_MEM, output reg [1:0] ForwardA,output reg [1:0] ForwardB );

always @ (*)
begin
if (RegWrite_EX && (rd_EX != 0) && (rd_EX == rs1))
ForwardA = 2'b10;
   
if (RegWrite_EX && (rd_EX != 0) && (rd_EX == rs2))
ForwardB = 2'b10;

if (RegWrite_MEM && (rd_MEM !=0) && (rd_MEM == rs1) && !(RegWrite_EX && (rd_EX != 0) && (rd_EX == rs1)))
ForwardA = 2'b01;
   
if (RegWrite_MEM && (rd_MEM !=0) && (rd_MEM == rs2) && !(RegWrite_EX && (rd_EX != 0) && (rd_EX == rs2)))
ForwardB=2'b01;
 
end
endmodule

