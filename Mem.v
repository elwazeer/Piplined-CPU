// file: DataMem.v
// author: @cherifsalama

/*******************************************************************
*
* Module: Mem.v
* Project: RV32IC
* Author: 
* Description: Memory includes 4 banks of data. The access to these banks can be not alligned. 
               Depending on the control signals of MemRead and MemWrite, the access to readability and writing 
               in the memory is granted respectively. Also, recieves the data address and data to be written.
               Memory also recieves the unsigned signal to return unsigned values from memory.
               Recieves the type(size) of the memory to be read or written.
*
* Change history: 28/10/2018 �" started
* 29/10/2018 �" Finished and validated
*
**********************************************************************/

`timescale 1ns/1ns

module Mem (    //big endian
    input clk,
    input rst,
    input MemWrite, 
    input [9:0] addr, //1024 byte
    input [31:0] data_in, 
    input u, //unsigned
    input [1:0] mem_inst_type, //00 w, 01 h, 10 b 
    output [31:0] data_out
);
//DataMem
    
    reg [7:0] mem1 [0:63];
    reg [7:0] mem2 [0:63];
    reg [7:0] mem3 [0:63];
    reg [7:0] mem4 [0:63];
    wire [7:0] word_address;
    assign word_address = addr[9:2];
    wire [7:0] word_address_inc;
    assign word_address_inc = addr[9:2] + 1;
    always @(posedge clk) 
    begin
        if (MemWrite)            
            case (mem_inst_type)
                3'b00: case (addr[1:0]) //sw
                    2'b00: {mem1[word_address], mem2[word_address], mem3[word_address], mem4[word_address]} <= data_in;
                    2'b01: {mem2[word_address], mem3[word_address], mem4[word_address], mem1[word_address_inc]} <= data_in;
                    2'b10: {mem3[word_address], mem4[word_address], mem1[word_address_inc], mem2[word_address_inc]} <= data_in;
                    2'b11: {mem4[word_address], mem1[word_address_inc], mem2[word_address_inc], mem3[word_address_inc]} <= data_in;
                endcase 
                3'b01: begin
                    case (addr[1:0]) //sh
                        2'b00: {mem1[word_address], mem2[word_address]} <= data_in;
                        2'b01: {mem2[word_address], mem3[word_address]} <= data_in;
                        2'b10: {mem3[word_address], mem4[word_address]} <= data_in;
                        2'b11: {mem4[word_address], mem1[word_address_inc]} <= data_in;
                    endcase 
                end
                3'b10: begin
                    case (addr[1:0]) //sb
                        2'b00: mem1[word_address] <= data_in;
                        2'b01: mem2[word_address] <= data_in;
                        2'b10: mem3[word_address] <= data_in;
                        2'b11: mem4[word_address] <= data_in;
                    endcase
                end
            endcase
        end
    assign data_out= (mem_inst_type==2'b00)?( (addr[1:0]==2'b00)?  {mem1[word_address], mem2[word_address], mem3[word_address], mem4[word_address]}:
              (addr[1:0]==2'b01)? {mem2[word_address], mem3[word_address], mem4[word_address], mem1[word_address_inc]} :  (addr[1:0]==2'b10)?
              {mem3[word_address], mem4[word_address], mem1[word_address_inc], mem2[word_address_inc]} : {mem4[word_address], mem1[word_address_inc], mem2[word_address_inc], mem3[word_address_inc]})
                :(mem_inst_type==2'b01)? ((addr[1:0]==2'b00)? {u? 16'b0:{16{data_out[15]}},mem1[word_address], mem2[word_address]}: (addr[1:0]==2'b01)?{u? 16'b0:{16{data_out[15]}},mem2[word_address], mem3[word_address]}:
                (addr[1:0]==2'b10)? {u? 16'b0:{16{data_out[15]}},mem3[word_address], mem4[word_address]} : {u? 16'b0:{16{data_out[15]}},mem4[word_address], mem1[word_address_inc]})
               :(mem_inst_type==2'b10)?((addr[1:0]==2'b00)? {u? 24'b0:{24{data_out[7]}},mem1[word_address]}:(addr[1:0]==2'b01)? {u? 24'b0:{24{data_out[7]}},mem2[word_address]}:(addr[1:0]==2'b10)? {u? 24'b0:{24{data_out[7]}},mem3[word_address]}:{u? 24'b0:{24{data_out[7]}},mem4[word_address]}):32'b0;
    /*integer i;
    always @(posedge rst)
     begin
        for (i=0;i<256;i=i+1) begin
            mem1[i] <= 0;
            mem2[i] <= 0;
            mem3[i] <= 0;
            mem4[i] <= 0; 
        end
    end*/
    
    initial begin
        $readmemh("D:/College/hello.hex" , mem4);
        $readmemh("D:/College/hello.hex" , mem3);
        $readmemh("D:/College/hello.hex" , mem2);
        $readmemh("D:/College/hello.hex" , mem1);
    end
endmodule

