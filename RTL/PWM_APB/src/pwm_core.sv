`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2026 23:54:22
// Design Name: 
// Module Name: pwm_core
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


module pwm_core(
    input logic clk,
    input logic rst,
    input logic [31:0] paddr,
    input logic [31:0] data,
    output logic wave
    );
    
    logic psel;
    logic trans;
    logic pready;
    logic pwrite;
    logic [31:0] pwdata;
    //logic stop;
    
    apb_master apb_master2(
        .clk(clk),
        .prstn(~rst),
        .paddr(paddr),
        .data(data),
        .pready(pready),//input from the slave 
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .trans(trans)
    );
    //logic busy;
    logic write;
    logic [31:0] p_data;
    logic pready_p;
    apb_slave apb_slave1(
        .clk(clk),
        .prstn(~rst),
        .psel(psel),
        .trans(trans),
        .pready_p(pready_p),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .p_data(p_data),
        .pready(pready),
        .pwrite_en(write)
    );
    
    pwm pwm1(
        .clk(clk),
        .rst(rst),
        .data(p_data),
        .write(write),
        .wave(wave),
        //.busy(busy),
        .pready_p(pready_p)
        
    );
endmodule:pwm_core
