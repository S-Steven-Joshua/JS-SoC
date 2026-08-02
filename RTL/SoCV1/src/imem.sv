`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2026 23:12:53
// Design Name: 
// Module Name: imem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module imem(
    input logic [31:0] a,
    output logic [31:0] out
    );
    logic [31:0] ram [63:0];
    initial 
    $readmemh("D:\\RISC\\risc.txt",ram);
    assign out=ram[a[31:2]];
endmodule:imem
