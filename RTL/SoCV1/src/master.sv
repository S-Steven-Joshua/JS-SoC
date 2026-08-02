`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 00:03:55
// Design Name: 
// Module Name: master
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


module master(
    input logic clk,
    input logic rst,
    //input logic apb_write,
    input logic [63:0] fifo_data,
    input logic fifo_empty,
    input logic  [7:0] data_in_slave,
    //for ram
    output logic        uart_ready,
    output logic        i2c_ready,
    //for peri
    output logic [31:0] peri_data_uart,
    output logic [7:0] data_out_slave,
    output logic [7:0] peri_data_i2c,
    output logic  scl,
    inout  logic  sda,
    output logic r_en,
    output logic wave,
    output logic wave1,
    output logic wave2
    );
    logic [2:0] psel;
    logic trans;
    logic pwrite;
    logic [31:0] pwdata;
    logic pready;
    //logic trans;
    logic penable;
    apb_master master_apb(
                          .clk(clk),
                          .prstn(~rst),
//                          .paddr(fifo_data[63:32]),
//                          .data(fifo_data[31:0]),
                          .fifo_data(fifo_data),
                          .fifo_empty(fifo_empty),
                          .pready(pready),
                          .r_en(r_en),
                          //.apb_write(fifo_data[64]),
                          .psel(psel),
                          .penable(penable),
                          .pwrite(pwrite),
                          .pwdata(pwdata),
                          .trans(trans)
                        );
    logic pready_uart;
    logic pready_pwm;
    logic pready_timer;
    logic pready_i2c;
//    logic uart_ready;
//    logic i2c_ready;
    apb_slave_uart  apb_slave_uart1(
                                   .clk(clk),
                                   .prstn(~rst),
                                   .psel(psel),
                                   .trans(trans),
                                   .penable(penable),
                                   .pwrite(pwrite),
                                   .pwdata(pwdata),
                                   .uart_ready(uart_ready),
                                   .peri_data_uart(peri_data_uart),
                                   .pready(pready_uart)
                                );
    
    apb_slave_pwm apb_slave_pwm1(
                                .clk(clk),
                                .prstn(~rst),
                                .psel(psel),
                                .trans(trans),
                                .penable(penable),
                                .pwrite(pwrite),
                                .pwdata(pwdata),
                                .wave(wave),
                                .pready(pready_pwm)
                            );
    apb_slave_timer apb_slave_timer1(
                                     .clk(clk),
                                     .prstn(~rst),
                                     .psel(psel),
                                     .trans(trans),
                                     .penable(penable),
                                     .pwrite(pwrite),
                                     .pwdata(pwdata),
                                     .wave1(wave1),
                                     .wave2(wave2),
                                     .pready(pready_timer)
                                );
    
    apb_slave_I2C apb_slave_i2c1(
                                 .clk(clk),
                                 .prstn(~rst),
                                 .psel(psel),
                                 .trans(trans),
                                 .penable(penable),
                                 .pwrite(pwrite),
                                 .pwdata(pwdata),
                                 .data_in_slave(data_in_slave),
                                 .pready(pready_i2c),
                                 .i2c_ready(i2c_ready),
                                 .scl(scl),
                                 .sda(sda),
                                 .data_out_slave(data_out_slave),
                                 .peri_data_i2c(peri_data_i2c)
                                 );
    
    
    
    
    
     
    always_comb
    begin
        case(psel)
            3'b001:pready=pready_uart;
            3'b010:pready=pready_pwm;
            3'b011:pready=pready_timer;
            3'b100:pready=pready_i2c;
            default:pready=1'b1;
        endcase
    end                     
endmodule:master

