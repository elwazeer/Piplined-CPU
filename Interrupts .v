// file: Interrupts .v
// author: @ahmedfayed

`timescale 1ns/1ns

module Interrupts (clk, rst, sign, interrupt, EX_interrupt, pc, waiting, inputmip, stop, address, address_new,
wCSRR, inputmie, inputmret, nointerrupts, interrupt_out, outmip, outmie, outpc, outcounter);

input [31:0] pc, address_new; 
input [11:0] address; 
input [2:0] inputmip;
input clk, rst, sign, interrupt, EX_interrupt, waiting, stop, wCSRR, inputmie, inputmret, nointerrupts; 

output reg [31:0] interrupt_out;
output [31:0] outpc; 
output [3:0] outmie;
output [2:0] outmip;
output reg outcounter;

wire [31:0] pcin, counter, outt1, outt2, outt3, outt4;
wire [3:0] miein;
wire [2:0] mipin; 
wire clock_div, pc2, mip2, mie2;

reg [31:0] counter2;
reg counter3, pc3, mip3, mie3;

assign pcin = interrupt ? pc : address_new;  
assign pc2 = interrupt || pc3;
assign mipin = waiting ? inputmip : address_new[2:0]; 
assign mip2 = waiting || mip3; 
assign mie2 = EX_interrupt || inputmret || mie3;
assign miein = (EX_interrupt || inputmret) ? {inputmie, outmie[2:0]} : address_new[3:0];

Clock_div #(4) div(clk, clock_div, rst); 
RegWLoad #(3) MIP(clk, rst, mip2, mipin, outmip);
RegWLoad #(32) PC(clk, rst, pc2, pcin, outpc);
Reg1_CSR MIE(clk, rst, mie2, miein, outmie);
Counter out1 (clk, rst, 32'd0, outt1); 
Counter out2 (clk, rst, 32'd0, outt2);
Counter out3 (clk, rst, 32'd0, outt3);
Reg2_CSR out4(clk, rst, counter3, address_new, outt4);
Counter Counterr ( clk, rst | counter3, 32'd0, counter);

always @ (*) 
    begin 
        if (rst)
            outcounter = 1'b0;
        else if ((counter >= (outt4 - 32'b1)) | nointerrupts) 
            outcounter = 1'b1;
        else
            outcounter = 1'b0;
    end
    
 always @ (*) begin  
        if (rst) begin
            mie3 = 1'b0;
            mip3 = 1'b0;
            pc3 = 1'b0;
            counter3 = 1'b0;
        end 
        else
        if (wCSRR)
            case (address)
                12'h341: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b0;
                    pc3 = 1'b1;
                    counter3 = 1'b0;
                end
                12'h304: begin 
                    mie3 = 1'b1;
                    mip3 = 1'b0;
                    pc3 = 1'b0;
                    counter3 = 1'b0;
                end
                12'h344: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b1;
                    pc3 = 1'b0;
                    counter3 = 1'b0;
                end
                12'hB00: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b0;
                    pc3 = 1'b0;
                    counter3 = 1'b0;
                end
                12'hB01: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b0;
                    pc3 = 1'b0;
                    counter3 = 1'b0;
                end
                12'hB03: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b0;
                    pc3 = 1'b0;
                    counter3 = 1'b1;
                end
                12'hB02: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b0;
                    pc3 = 1'b0;
                    counter3 = 1'b0;
                end
                
                default: begin 
                    mie3 = 1'b0;
                    mip3 = 1'b0;
                    pc3 = 1'b0;
                    counter3 = 1'b0;
                end
            endcase
            
        else begin 
            mie3 = 1'b0;
            mip3 = 1'b0;
            pc3 = 1'b0;
            counter3 = 1'b0;
        end
    end
    
      always @ (*) begin 
        if (rst)
            interrupt_out = 32'd0;
        else
        if (!wCSRR) begin 
            case (address)
                12'h341:    
                    interrupt_out = outpc;
                12'h304:    
                    interrupt_out = {28'b0, outmie};
                12'h344:    
                    interrupt_out = {29'b0, outmip};
                12'hB00:
                    interrupt_out = outt1;
                12'hB01:    
                    interrupt_out = outt2;
                12'hB03:    
                    interrupt_out = outt4;
                12'hB02: 
                    interrupt_out = outt3;
                default: 
                    interrupt_out = 32'b0;
            endcase
        end
        else begin
            interrupt_out = 32'd0;
        end
    end

endmodule

