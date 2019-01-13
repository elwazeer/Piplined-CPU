// file: Memory.v
// author: @ahmedfayed

`timescale 1ns/1ns

module Memory(
	input clk,
	input rst,
	input [31: 0] mDi,
	input [9: 0] mAddr,
	input sign,
	input [1:0] mSize,	
	input mWr,
	output [31: 0] mDo);

    reg [7:0] mem1 [0:63];
    reg [7:0] mem2 [0:63];
    reg [7:0] mem3 [0:63];
    reg [7:0] mem4 [0:63];
    
    
    always @ (posedge clk) 
    begin
    
        if(mWr) begin 
        
            if(mSize==2'b00) 
            begin
                 if (mAddr[1:0] == 2'b00) {mem1[mAddr[9:2]], mem2[mAddr[9:2]], mem3[mAddr[9:2]], mem4[mAddr[9:2]]} <= mDi;
                 else if (mAddr[1:0] == 2'b01) {mem2[mAddr[9:2]], mem3[mAddr[9:2]], mem4[mAddr[9:2]], mem1[mAddr[9:2]+1]} <= mDi;
                 else if (mAddr[1:0] == 2'b10) {mem3[mAddr[9:2]], mem4[mAddr[9:2]], mem1[mAddr[9:2]], mem2[mAddr[9:2]+1]} <= mDi;
                 else if (mAddr[1:0] == 2'b11) {mem4[mAddr[9:2]], mem1[mAddr[9:2]+1], mem2[mAddr[9:2]+1], mem3[mAddr[9:2]+1]} <= mDi;
            end
            
            else if (mSize==2'b01)
            begin 
                 if (mAddr[1:0] == 2'b00) {mem1[mAddr[9:2]], mem2[mAddr[9:2]]} <= mDi;
                 else if (mAddr[1:0] == 2'b01) {mem2[mAddr[9:2]], mem3[mAddr[9:2]]} <= mDi;
                 else if (mAddr[1:0] == 2'b10) {mem3[mAddr[9:2]], mem4[mAddr[9:2]]} <= mDi;
                 else if (mAddr[1:0] == 2'b11) {mem4[mAddr[9:2]], mem1[mAddr[9:2]+1]} <= mDi;
            end
            
            else if (mSize==2'b10)
            begin 
                 if (mAddr[1:0] == 2'b00)  mem1[mAddr[9:2]] <= mDi;
                 else if (mAddr[1:0] == 2'b01) mem2[mAddr[9:2]] <= mDi;
                 else if (mAddr[1:0] == 2'b10) mem3[mAddr[9:2]]<= mDi;
                 else if (mAddr[1:0] == 2'b11) mem4[mAddr[9:2]] <= mDi;
            end
        end
        
        else  
        begin
            if(mSize==2'b00) 
            begin
                 if (mAddr[1:0] == 2'b00) mDo<= {mem1[mAddr[9:2]], mem2[mAddr[9:2]], mem3[mAddr[9:2]], mem4[mAddr[9:2]]};
                 else if (mAddr[1:0] == 2'b01) mDo<={mem2[mAddr[9:2]], mem3[mAddr[9:2]], mem4[mAddr[9:2]], mem1[mAddr[9:2]+1]};
                 else if (mAddr[1:0] == 2'b10) mDo<={mem3[mAddr[9:2]], mem4[mAddr[9:2]], mem1[mAddr[9:2]], mem2[mAddr[9:2]+1]};
                 else if (mAddr[1:0] == 2'b11) mDo<={mem4[mAddr[9:2]], mem1[mAddr[9:2]+1], mem2[mAddr[9:2]+1], mem3[mAddr[9:2]+1]};
            end
            
            else if (mSize==2'b01)
            begin 
                 if (mAddr[1:0] == 2'b00) mDo <= {mem1[mAddr[9:2]], mem2[mAddr[9:2]]};
                 else if (mAddr[1:0] == 2'b01) mDo <= {mem2[mAddr[9:2]], mem3[mAddr[9:2]]};
                 else if (mAddr[1:0] == 2'b10) mDo <= {mem3[mAddr[9:2]], mem4[mAddr[9:2]]};
                 else if (mAddr[1:0] == 2'b11) mDo <= {mem4[mAddr[9:2]], mem1[mAddr[9:2]+1]}; 
                 
                 //if (mDo[31:16] == sign) mDo [31:16] <= 16'b0 
                 //else mDo [31:16] <={16{mDo[15]}};
            end
            
            else if (mSize==2'b10)
            begin 
                 if (mAddr[1:0] == 2'b00)  mDo<= mem1[mAddr[9:2]];
                 else if (mAddr[1:0] == 2'b01) mDo<= mem2[mAddr[9:2]];
                 else if (mAddr[1:0] == 2'b10) mDo<= mem3[mAddr[9:2]];
                 else if (mAddr[1:0] == 2'b11) mDo<= mem4[mAddr[9:2]];
                 
                 mDo[31:8] = sign? 24'b0 : {24{mDo[7]}};
                 //if (mDo[31:8] == sign) mDo [31:8] <= 24'b0 
                 //else mDo [31:8] <={24{mDo[7]}};
            end
        end 
        
    end
            
        
            //$display("Mem: write 0x%x to 0x%x (%d)", mDo, mAddr, mSize);            
    

endmodule

