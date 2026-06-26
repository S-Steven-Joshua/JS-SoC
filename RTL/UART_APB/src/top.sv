`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2026 11:05:40
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
    input logic prstn,
    input logic [31:0] paddr,//from cpu
    input logic [31:0] data,//from cpu
    input logic  pready_p,//from peripheral
    input logic [31:0] peri_data,//from peripheral
    input logic master_ready,//from peripheral
    output logic [31:0] p_data,//from slave to peripheral write state
    output logic [31:0] pr_data,//from peripheral to slave read state
    output logic pready,
    output logic pwrite_en
    );
    
    logic psel;
    logic penable;
    logic pwrite;
    logic [31:0] pwdata;
    logic trans;
        
    apb_master apb_master1(
        .clk(clk),
        .prstn(prstn),
        .paddr(paddr),
        .data(data),
        .pready(pready),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .trans(trans)
        );
    apb_slave apb_slave1(
        .clk(clk),
        .prstn(prstn),
        .psel(psel),
        .trans(trans),
        .pready_p(pready_p),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .p_data(p_data),
        .pready(pready),
        .master_ready(master_ready),
        .pr_data(pr_data),
        .peri_data(peri_data),
        .pwrite_en(pwrite_en)
        ); 
       
endmodule:top
