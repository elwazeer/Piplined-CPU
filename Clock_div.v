// file: Clock_div.v
// author: @ahmedfayed

`timescale 1ns/1ns

module Clock_div(input reset, input clock, output outclk);

reg[27:0] counter = 28'd0;
parameter divider = 28'd2;

   always @(posedge clock or posedge reset) begin
        if (reset == 1'b1) begin
            counter <= (divider-1);
        end
        else
        
        begin
         counter <= counter + 28'd1;
         if(counter >= (divider-1))
            counter <= 28'd0;
        end
    end
    
    assign outclk = (counter<divider/2)?1'b0:1'b1;
    
endmodule