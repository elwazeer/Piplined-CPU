// file: RISCV_Datapath.v
// author: @ahmedfayed

`timescale 1ns/1ns

module RISCV_Datapath_2(
    input clk, 
    input rst, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output reg [15:0] leds, 
    output reg [12:0] ssd
); 

    wire [31:0] PC_out, IR_PC_out, ID_EX_PC_out, PCAdder_out, ID_EX_PCAdder_out, EX_PCAdder_out, ID_EX_PC_Imm, EX_MEM_PC_Imm, WB_ALU_out, BranchAdder_out, PC_in, 
        RegR1, ID_EX_RegR1, RegR2, RsRd, ID_EX_RegR2, ImmGen_out, ID_EX_ImmGen_out, Mux_out, LUI_Mux_Out,
        ALU_out, ALUMux_in, EX_ALU_out, WB_Mux, Mem_in, Mem_out, WB_Mem_out, Inst, ID_EX_Inst, ALUSrc1,
        ALUSrc2, ALUSrc_Mux1, ALUSrc_Mux2, EX_ALUSrc_Mux2, uncomp, decomp, decompressed;
    wire [15:0] ID_EX_Ctrl; 
    wire [4:0] RD1, RD2, RD3;
    wire [2:0] Branch_Signal, ID_EX_Branch_Signal, EX_MEM_Branch_Signal;
    wire [3:0]  ALUOp, ALU_Select, ID_EX_aluOp, WriteData, ID_EX_WriteData, WB_WriteData, funct3, ID_EX_funct3, EX_MEM_funct3;
    wire [1:0]  memSize, ID_EX_memSize, EX_MEM_memSize, EX_MEM_ALU, ID_EX_ALU, comparator_out, JAL, JALR;
    wire Branch, LUI, ID_EX_ALUSrc_Mux, PCSrc, PC_Write, ID_EX_PC_Write, memRead, MemToReg,ID_EX_MemToReg, EX_MemToReg, WB_MemToReg, 
         ID_EX_rWrite, EX_rWrite, WB_rWrite, MemWrite, ID_EX_MemWrite,
         RegWrite, clock_signal, ID_EX_clock_signal, ID_EX_Sign, EX_MEM_Sign, comp;
    wire z, s, v, c, ForwardA, ForwardB, co, excep;
   
   
  
  RegWLoad #(64) IR (clk,rst,1'b1,
                            {PC_out,Mem_out},
                            {ID_EX_PC_out,ID_EX_Inst}
                            );
                            
   RegWLoad #(183) ID_EX (~clk,rst,1'b1,
                            {    ID_EX_Ctrl, RegR1,
                                 RegR2, ImmGen_out, BranchAdder_out, PCAdder_out, ID_EX_Inst[30],ID_EX_Inst[14:12],ID_EX_Inst[11:7] },
                            {    ID_EX_memSize, ID_EX_MemWrite, ID_EX_rWrite, ID_EX_ALUSrc_Mux, ID_EX_ALU,
                                 ID_EX_Sign, ID_EX_Branch_Signal, ID_EX_ALU, ID_EX_MemToReg, 
                                 ID_EX_RegR1, ID_EX_RegR2, ID_EX_ImmGen_out, ID_EX_PC_Imm, ID_EX_PCAdder_out, ID_EX_funct3,RD1 }
                            );
                            
    RegWLoad #(148) EX_MEM (clk,rst,1'b1,
                            { memSize, ID_EX_MemWrite, ID_EX_rWrite, 
                              ID_EX_Sign, ID_EX_Branch_Signal, ID_EX_ALU, ID_EX_MemToReg, 
                              ID_EX_PC_Imm, ID_EX_PCAdder_out,RD1, ALU_out, funct3, ALUSrc_Mux2},
                            { EX_MEM_memSize, MemWrite, EX_rWrite, 
                              EX_MEM_Sign, EX_MEM_Branch_Signal, EX_MEM_ALU, EX_MemToReg, 
                              EX_MEM_PC_Imm, EX_PCAdder_out,RD2, EX_ALU_out, EX_MEM_funct3, EX_ALUSrc_Mux2}
                            );
  
   RegWLoad #(71) MEM_WB   (~clk,rst,1'b1,
                            {EX_rWrite, EX_MemToReg, RD2, Mux_out, Mem_out},
                            {WB_rWrite, WB_MemToReg, RD3, WB_ALU_out, WB_Mem_out}
                            );
   RegWLoad PC(~clk,rst,1'b1,PC_in,PC_out);
   Full_Adder PC4(IR_PC_out, 4, 1'b0, PCAdder_out,co);
   
   Mux2_1 #(32) Uni_in(clk,PC_out,EX_ALU_out, Mem_in);
   Memory  SinglePorted(clk, rst, EX_ALUSrc_Mux2, Mem_in, EX_MEM_Sign ,memSize,MemWrite,Mem_out);
   
   assign comp = ~(uncomp[1] & uncomp[0]);
    Mux2_1 #(32) comp_or_not (decomp, PCAdder_out, IR_PC_out, PC_out);
    Compressed compressionUnit (uncomp[15:0], decompressed);
    
    Mux2_1 #(32) compression_unit (comp, uncomp, decompressed, ID_EX_Inst);
   
   Mux2_1 #(32) RsRd_Mux(WB_rWrite,ID_EX_Inst[19:15],RD3,RsRd);
   Mux2_1 #(32) WriteBack(WB_MemToReg,WB_ALU_out,WB_Mem_out, WB_Mux);
   
   RegFile rf(clk, rst, WB_rWrite, RsRd, ID_EX_Inst[24:20], WB_Mux, RegR1, RegR2);
   
   rv32_ImmGen  immediate(ID_EX_Inst, ImmGen_out);
   forwarding_unit forwarded(ID_EX_rWrite, EX_rWrite, ID_EX_Inst[19:15], ID_EX_Inst[24:20], RD3, WB_rWrite, ForwardA, ForwardB);
   Mux2_1 #(32) Signals_Mux(LUI,IR_PC_out,32'b0,LUI_Mux_Out);
   Full_Adder Branch_Adder(LUI_Mux_Out,ImmGen_out,1'b0,BranchAdder_out, co);
 
   Mux2_1 #(32) ALU_Mux1(ForwardA,ID_EX_RegR1,WB_Mux,ALUSrc1);
   //Mux2_1 #(32) ALU Mux2(ForwardB,ID_EX_RegR2,WB_Mux,ALUMux_in);
   Mux2_1 #(32) ALU_Mux3(ID_EX_ALUSrc_Mux,ALUMux_in,ID_EX_ImmGen_out,ALUSrc_Mux2);
   Comparator compare_for_branch(z, s, v, c, EX_MEM_funct3, comparator_out);
   assign Branch = (EX_MEM_Branch_Signal && comparator_out)? 1:0;
   
   //ALUControl aluc(ID_EX_ALU, ID_EX_funct3[2:0],ID_EX_funct3[3], ALU_Select);
   ALU ALU1 (ALUSrc1, ALUSrc_Mux2, funct3, z, c, v, ALU_out);
   
   ControlUnit control_unit(ID_EX_Inst[4:0], Branch_Signal, memRead, MemToReg, ALUOp,
   MemWrite, ALU_Select, RegWrite, JAL, JALR);
   
   Mux2_1 #(16) Flush (Branch,{memSize,memRead, MemToReg, ALUOp,
   MemWrite, ALU_Select, RegWrite, JAL, JALR},16'b0,ID_EX_Ctrl);
   
   Mux4_1 #(32) ALUOutMux(EX_MEM_ALU, comparator_out, EX_MEM_PC_Imm, EX_ALU_out, EX_PCAdder_out, Mux_out);
   Mux4_1 #(32) PC_Input({JAL, Branch} , PCAdder_out, EX_MEM_PC_Imm, BranchAdder_out, excep, PC_in);
   
    always @(*) begin
        case(ledSel)
            0: leds <= Inst[15:0];
            1: leds <= Inst[31:16];
            2: leds <= {Branch, memRead, MemToReg, ALUOp, MemWrite, 
                        ALU_Select, RegWrite, funct3};
            default: leds <= 0;            
        endcase
        
        case(ssdSel)
            0: ssd <= PC_out[12:0];
            1: ssd <= PCAdder_out[12:0]; 
            2: ssd <= BranchAdder_out[12:0]; 
            3: ssd <= PC_in[12:0];
            4: ssd <= RegR1[12:0]; 
            5: ssd <= RegR2[12:0]; 
            6: ssd <= WB_Mux[12:0]; 
            7: ssd <= ImmGen_out[12:0]; 
            8: ssd <= RsRd[12:0]; 
            9: ssd <= ALUSrc_Mux2[12:0]; 
            10: ssd <= ALU_out[12:0]; 
            11: ssd <= Mem_out[12:0];
            default: ssd <= 0;
        endcase
    end
   
endmodule







