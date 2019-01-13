// file: Count.v
// author: @ahmedfayed

`timescale 1ns/1ns

module Counter( 
    input clk,
    input rst, 
    input [31:0] data_in,
    output reg [31:0] data_out
);
    wire enable, load;
    always @ (posedge clk or posedge rst) 
    begin
    
        if (rst)
            data_out <= 32'd0;
        else if (enable)
                if (load)
                    data_out <= data_in;
                else 
                    data_out <= data_out + 32'b1;
        else
            data_out <= data_out; 
    end
    
endmodule