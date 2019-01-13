// file: ALUControl.v


`timescale 1ns/1ns

module ALUControl(
    input [1:0] ALUOp,
    input [2:0] func3,
    input func7,
    output reg [3:0] sel
);

    always @(*) begin
        case(ALUOp) 
            0: sel = 4'b0010;
            1: sel = 4'b0110;
            2:  if((func3==0)&&!func7) 
                    sel = 4'b0010;
                else if (func3==0)
                    sel = 4'b0110;
                else if(func3==7)
                    sel = 4'b0000;
                else if(func3==6)
                    sel = 4'b0001;
                else if(func3==1) 
                    sel=4'b0111;
                else if((func3==5) &&!func7 ) 
                    sel=4'b1000;
                else if((func3==5) &&func7 ) 
                    sel=4'b0011;
                else if(func3==3) 
                    sel=4'b0100;
                else if(func3==4) 
                    sel=4'b0101;
                else
                    sel = 4'b0000;
                
        default: sel = 4'b0000;        
        endcase
    end
    
endmodule

