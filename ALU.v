/*********************************************************
 *
 *
 *********************************************************/
`timescale 1ns/1ns

module ALU(input [31:0] a, input [31:0] b, input [3:0] funct3, output reg [0:0] z, output c, 
output v, output reg [31:0] alu_out);

wire [31:0] adder_out; 
   
    RippleAdder rca(a, b, funct3[0], adder_out, c, v);
    
    always @ (*) begin

        case(funct3)
            4'b00_00    : alu_out = adder_out;
            4'b00_01    : alu_out = adder_out;
            4'b01_01    : alu_out = a & b;
            4'b01_00     : alu_out = a | b;
            4'b01_11   : alu_out = a ^ b;
            4'b10_01   : alu_out = a << b; 
            4'b10_00    : alu_out = a >> b;
            4'b10_10    : alu_out = $signed(a) >>> b;
            4'b1101   : alu_out = b;
            4'b1111   : alu_out = $signed(a) >>> b[4:0];
            default : alu_out = 32'd0;
        endcase
        
        if (alu_out == 0)
            z = 1;
        else 
            z = 0;
        
    end
    
endmodule







