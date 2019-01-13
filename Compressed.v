// file: Compressed.v
// author: @ahmedfayed

`timescale 1ns/1ns



module Compressed(input [15:0] instr, output reg [31:0] decomp);

//reg [4:0] rs1, rs2, rd;

always @(*) 
begin 
   case (instr [1:0])
   
   //Instruction listing for RVC, Quadrant 1.
   2'b01: 
        if (instr [6:5] == 2'b00 && instr [11:10] == 2'b11 && instr[15:13] == 3'b100 && instr [12] == 1'b0) //C.Sub 
        decomp <= {7'b0100000,{{2'b00,instr[4:2]}+5'd8},{{2'b00,instr[9:7]}+5'd8},3'b000,{{2'b00,instr[9:7]}+5'd8},7'b0110011};
        
          else if (instr [6:5] == 2'b01 & instr [11:10] == 2'b11 && instr[15:13] == 3'b100 && instr [12] == 1'b0)  //C.XOR 
        decomp <= {7'b0000000,{{2'b00,instr[4:2]}+5'd8},{{2'b00,instr[9:7]}+5'd8},3'b100,{{2'b00,instr[9:7]}+5'd8},7'b0110011};
                 
          else if (instr [6:5] == 2'b10 & instr [11:10] == 2'b11 && instr[15:13] == 3'b100 && instr [12] == 1'b0)   //C.OR
        decomp <= {7'b0000000,{{2'b00,instr[4:2]}+5'd8},{{2'b00,instr[9:7]}+5'd8},3'b110,{{2'b00,instr[9:7]}+5'd8},7'b0110011};
                 
          else if (instr [6:5] == 2'b11 & instr [11:10] == 2'b11 && instr[15:13] == 3'b100 && instr [12] == 1'b0)   //C.AND
        decomp <= {7'b0000000,{{2'b00,instr[4:2]}+5'd8},{{2'b00,instr[9:7]}+5'd8},3'b111,{{2'b00,instr[9:7]}+5'd8},7'b0110011};
          
          else if (instr [6:5] == 2'b11 & instr [11:10] == 2'b10 && instr[15:13] == 3'b100 && instr [12] == 1'b0)   //C.ANDI
        decomp <= { {7{instr[12]}}, instr[6:2], 2'b01, instr[9:7],3'b111, 2'b01, instr[9:7], 7'b0010011 };

        
         else if (instr[11:10] == 2'b01 && instr[15:13] == 3'b100 && instr[1])  //C.SRAI
        decomp <= {7'b0100000, instr[6:2], 2'b0, {{2'b00,instr[9:7]}+5'd8}, 3'b101,{{2'b00,instr[9:7]}+5'd8}, 7'b0010011};
        
         else if (instr[11:10] == 2'b00 && instr[15:13] == 3'b100 && instr[1])  //C.SRLI
        decomp <= {7'b0000000, instr[6:2], 2'b0, {{2'b00,instr[9:7]}+5'd8}, 3'b101,{{2'b00,instr[9:7]}+5'd8}, 7'b0010011};
        
         else if (instr[15:13] == 3'b011 && (instr[12] != 1'b0 || instr[6:2] != 5'b0) && instr[11:7] == 5'd2) //C.ADDI16SP
         decomp <= { {3{instr[12]}}, instr[4], instr[3], instr[5], instr[2], instr[6], 4'b0000, 5'd2, 3'b000, 5'd2, 7'b0010011};
         
         else if (instr[15:13] == 3'b011 && (instr[12] != 1'b0 || instr[6:2] != 5'b0) && instr[11:7] != 5'd2 || instr[11:7] != 5'd0) //C.LUI
         decomp <= { {15{instr[12]}}, instr[6:2], instr[11:7], 7'b0110111 };
         
         else if (instr[15:13] == 3'b000 && instr[12] != 1'b0 && instr[11:7] != 5'b0 || instr[6:2] != 5'h0) //C.ADDI
         decomp <= { {7{instr[12]}}, instr[6:2], instr[11:7], 3'b000, instr[11:7], 7'b0010011};
         
         else if (instr[15:13] == 3'b000 && instr[12] == 1'b0 && instr[6:2] == 5'b0) //C.NOP 
         decomp <= { 25'b0, 7'b0010011};
         
         else if (instr[15:13] == 3'b101) //C.J 
         decomp <= { instr[12], instr[8], instr[10:9], instr[6],instr[7], instr[2], instr[11], instr[5:3], instr[12],{8{instr[12]}}, 5'd0, 7'b1101111 };
         
         else if (instr[15:13] == 3'b110) //C.BEQZ 
         decomp <= { {4{instr[12]}}, instr[6], instr[5], instr[2], 5'd0, 2'b01, instr[9:7], 3'b000, instr[11], instr[10], instr[4], instr[3], instr[12], 7'b1100011 };
         
         else if (instr [15:13] == 3'b111) //C.BNEZ
         decomp <= { {4{instr[12]}}, instr[6], instr[5], instr[2], 5'd0, 2'b01, instr[9:7], 3'b001, instr[11], instr[10], instr[4], instr[3], instr[12], 7'b1100011 };
         
        
    //Instruction listing for RVC, Quadrant 0.
    2'b00: 
          if (instr[15:13] == 3'b010)  //C.LW
          decomp <= {5'b00000, instr[5], instr[12:10],instr[6], 2'b00, 2'b01, instr[9:7], 3'b010, 2'b01, instr[4:2], 7'b0000011};    
          
          else if (instr[15:13] == 3'b110)  //C.SW
          decomp <= { 5'b00000, instr[5], instr[12], 2'b01, instr[4:2], 2'b01, instr[9:7], 3'b010, instr[11:10], instr[6], 2'b00, 7'b0100011 };
          
          else if (instr[15:13] == 3'b000 && instr[12:2] != 11'b0 && instr[12:5] != 8'b0) //C.ADD14SPN
          decomp <= {2'b00, instr[10:7], instr[12:11], instr[5], instr[6], 2'b00, 5'd2, 3'b000, 2'b01, instr[4:2], 7'b0010011 };
    
    //Instruction listing for RVC, Quadrant 2.
    2'b10: 
          if (instr[15:13] == 3'b000 && instr[11:7] != 5'b0)  //C.SLLI
          decomp <= { 7'b0000000, instr[6:2], instr[11:7], 3'b001, instr[11:7], 7'b0010011};
          
          else if (instr[15:13] == 3'b010 && instr[11:7] != 5'b0)  //C.LWSP
          decomp <= { 4'b0000, instr[3:2], instr[12], instr[6:4], 2'b0, 5'd2, 3'b010, instr[11:7], 7'b0000011 };
          
          else if (instr[15:13] == 3'b100 && instr[12] ==1'b1 && instr [11:7] == 5'b0)  //C.EBREAK
          decomp<= { 11'b0, 1'b1, 13'b0, 7'b1110011 }; 
          
          else if (instr[15:13] == 3'b100 && instr [12] ==1 && instr[11:7] != 5'h0 && instr[6:2] == 5'd0) //C.JALR
          decomp<= { 12'b0, instr[11:7], 3'b000, 5'd1, 7'b1100111 }; 
          
          else if (instr[15:13] == 3'b100 && instr [12] ==0 && instr[11:7] != 5'h0 && instr[6:2] == 5'd0) //C.JR
          decomp<= { 12'b0, instr[11:7], 3'b000, 5'd0, 7'b1100111 }; 
          
          else if (instr[15:13] == 3'b100 && instr [12] ==1 && instr[11:7] != 5'b0 && instr[6:2] != 5'b0) //C.ADD
          decomp <= { 7'b0000000, instr[6:2], instr[11:7], 3'b000, instr[11:7], 7'b0110011 };
          
          else if (instr [15:13] == 3'b110) //C.SWSP
          decomp <= { 4'b0000, instr[8:7], instr[12], instr[6:2], 5'd2, 3'b010, instr[11:9], 2'b00, 7'b0100011 };
          
          else decomp <= { 7'b0000000, instr[6:2], 5'd0, 3'b000, instr[11:7], 7'b0110011 }; //C.MV

endcase
end
endmodule

