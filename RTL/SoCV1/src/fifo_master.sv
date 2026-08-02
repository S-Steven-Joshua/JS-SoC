`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 12:41:42
// Design Name: 
// Module Name: fifo_master
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


module fifo_master(
    input logic clk,
    input logic rst,
    input logic w_en,
    input logic [63:0] data_in,
    input logic [7:0]  data_in_slave,
    output logic full,
    output logic uart_ready,
    output logic i2c_ready,
    output logic [31:0] peri_data_uart,
    output logic [7:0]  data_out_slave,
    output logic [7:0]  peri_data_i2c,
    output logic scl,
    inout  logic sda,
    output logic wave,
    output logic wave1,
    output logic wave2
    );
    
    logic [63:0] data_out;
    logic r_en;
    logic empty;
    fifo #(.depth(4),.width(64)) fifo1(
                                     .clk(clk),
                                     .rst(rst),
                                     .w_en(w_en),
                                     .r_en(r_en),
                                     .data_in(data_in),
                                     .data_out(data_out),
                                     .full(full),
                                     .empty(empty)
                                );
    master master1 (
                    .clk(clk),
                    .rst(rst),
                    .fifo_data(data_out),
                    .fifo_empty(empty),
                    .r_en(r_en),
                    .data_in_slave(data_in_slave),
                    .uart_ready(uart_ready),
                    .i2c_ready(i2c_ready),
                    .peri_data_uart(peri_data_uart),
                    .data_out_slave(data_out_slave),
                    .peri_data_i2c(peri_data_i2c),
                    .scl(scl),
                    .sda(sda),
                    .wave(wave),
                    .wave1(wave1),
                    .wave2(wave2)
                    );
                    
                    
endmodule
