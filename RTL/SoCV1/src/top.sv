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
    input logic [7:0] data_in_slave,
    output logic [31:0] write_data,data_add,
    output logic mem_write,
    logic scl,
    inout sda,
    output logic [7:0] peri_data_i2c,
    output logic [7:0] data_out_slave,
    output logic [31:0] peri_data_uart,
    output logic wave,
    output logic wave1,
    output logic wave2
    );
    logic memwrite;
    logic [31:0] pc,instr,read_data;
    core core1(.clk(clk),.rst(rst),.instr(instr),.read_data(read_data),
               .pc(pc),.alu_result(data_add),.write_data(write_data),.mem_write(memwrite));
    imem imem1(.a(pc),.out(instr));
    bridge bridge1(.clk(clk),.rst(rst),.instr(instr),.addr(data_add),.data_in_slave(data_in_slave),.data(write_data),.memwrite(memwrite),.dmem_write(mem_write),.peri_data_uart(peri_data_uart),.wave(wave),
                   .wave1(wave1),.wave2(wave2),.scl(scl),.sda(sda),.data_out_slave(data_out_slave),.peri_data_i2c(peri_data_i2c));
    dmem dmem1(.clk(clk),.a(data_add),.write_data(write_data),.mem_write(mem_write),.out(read_data));
endmodule:top
