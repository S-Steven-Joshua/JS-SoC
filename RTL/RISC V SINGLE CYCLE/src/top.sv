`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2026 16:25:12
// Design Name: 
// Module Name: top
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


module top(
    input logic clk,
    input logic rst,
    output logic [31:0] write_data,data_add,
    output logic mem_write
    );
    logic [31:0] pc,instr,read_data;
    core core1(.clk(clk),.rst(rst),.instr(instr),.read_data(read_data),
               .pc(pc),.alu_result(data_add),.write_data(write_data),.mem_write(mem_write));
    imem imem1(.a(pc),.out(instr));
    dmem dmem1(.clk(clk),.a(data_add),.write_data(write_data),.mem_write(mem_write),.out(read_data));
endmodule:top
