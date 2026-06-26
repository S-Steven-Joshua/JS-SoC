`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 10:30:44
// Design Name: 
// Module Name: timer_soc
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


module timer_soc(
    input logic clk,
    input logic rst,
    input logic [31:0] paddr,
    input logic [31:0] data,
    output logic wave1,
    output logic wave2
    );
    logic psel;
    logic trans;
    logic penable;
    logic pwrite;
    logic [31:0] pwdata;
    //logic trans;
    logic pready;
    apb_master apb_master_t(
                            .clk(clk),
                            .prstn(~rst),
                            .paddr(paddr),
                            .data(data),
                            .pready(pready),
                            .psel(psel),
                            .trans(trans),
                            .penable(penable),
                            .pwrite(pwrite),
                            .pwdata(pwdata)
                        );
    
    logic pready_p;
    logic [31:0] p_data;
    logic pwrite_en;
    apb_slave apb_slave_t(
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
                          .pwrite_en(pwrite_en)
                        );
     
     timer timer1(
                  .clk(clk),
                  .rst(rst),
                  .data_word(p_data),
                  .write(pwrite_en),
                  .master_ready(pready_p),
                  .wave1(wave1),
                  .wave2(wave2)
                );
endmodule:timer_soc
