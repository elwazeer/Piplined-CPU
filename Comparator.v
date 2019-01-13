// file: Comparator

`timescale 1ns/1ns

module Comparator (z, s, v, c, funct3, output_branch);

input z, s, v, c;
input [2:0] funct3;
output reg output_branch;

always @(*) begin 

    case (funct3)
    3'b000:  output_branch <=z; //BR_BEQ
    3'b001:  output_branch <=!z; //BR_BNE 
    3'b100:  output_branch <= s!= v; //BR_BLT
    3'b101:  output_branch <=s == v;  //BR_BGE
    3'b110:  output_branch <= !c; //BR_BLTU
    3'b111:  output_branch <= c;  //BR_BGEU
    default:  output_branch <= 1'b0;
    endcase


end
endmodule

