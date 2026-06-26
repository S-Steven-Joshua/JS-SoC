`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 09:39:32
// Design Name: 
// Module Name: soc
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


module soc(
    input logic clk,
    input logic rst,
    input logic [31:0] paddr,
    input logic [31:0] data,
    output logic [31:0] pr_data//for peripherial read data
    );
    logic pready_p;
    logic master_ready;
    logic pready;
    logic [31:0] peri_data;
    logic [31:0] p_data;
    logic pwrite_en;
    
    top top1(
        .clk(clk),
        .prstn(~ rst),
        .paddr(paddr),
        .data(data),
        .pready_p(pready_p),
        .peri_data(peri_data),
        .master_ready(master_ready),
        .p_data(p_data),
        .pr_data(pr_data),
        .pready(pready),
        .pwrite_en(pwrite_en)
    );
    
    logic master_busy;
    assign pready_p= ~master_busy;
    
    uart_soc uart_soc1(
        .clk(clk),
        .rst(rst),
        .data_in(p_data),
        .wr_en(pwrite_en),
        .master_busy(master_busy),
        .data_out(peri_data),
        .master_ready(master_ready)
    );
        
endmodule
