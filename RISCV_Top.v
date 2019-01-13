// file: RISCV_Top.v


`timescale 1ns/1ns

module RISCV_Datapath (
    input clk, 
    input rclk, 
    input rst, 
    input [1:0] ledSel, 
    input [3:0] ssdSel,
    output [15:0] led, 
    output [3:0] an, 
    output [6:0] seg
);

    wire [12:0] ssd;

    RISCV_Datapath_2 rv(rclk,rst,ledSel,ssdSel,led,ssd);
    //SSDDriver sd(clk,ssd,an,seg);
endmodule

