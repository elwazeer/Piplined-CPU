// file: RippleAdder.v


`timescale 1ns/1ns

module RippleAdder (
    input[31:0] a, 
    input[31:0] b,
    input ci,
    output[31:0] s,
    output co,
    output overflow
);
    
    wire [32:0] cs;
    
    assign cs[0] = ci;
    assign co = cs[32];

    genvar i;
    generate
    for(i=0;i<32;i=i+1)
        Full_Adder a1(a[i],(b[i]^ci),cs[i],cs[i+1], s[i]);
    endgenerate
    
endmodule

