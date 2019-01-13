// file: Reg1_CSR.v
// author: @ahmedfayed

`timescale 1ns/1ns

module Reg1_CSR(
    clk,
    rst,
    load,
    data_in, 
    data_out 
);

    input clk, rst, load;
    input   [3:0] data_in;
    output  reg [3:0] data_out;
    
    always @ (posedge clk or posedge rst) begin
    
        if(rst)
            data_out <= 4'd15;
        else if (load)
                data_out <= data_in;
            else 
                data_out <= data_out;
    end

endmodule


