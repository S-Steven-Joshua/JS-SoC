`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 16:46:12
// Design Name: 
// Module Name: bridge
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


module bridge(
    input logic clk,
    input logic rst,
    input logic [31:0] instr,
    input logic [31:0] addr,//alu result from the sw instruction,
    input logic [31:0] data,//write data rd2
    input logic [7:0] data_in_slave,//for i2c
    input logic memwrite,
//    input logic read_en,//from ram
//    input logic [4:0] address_ram,
    output logic dmem_write,
//    output logic uart_ready,
//    output logic i2c_ready,
    output logic [31:0] peri_data_uart,
    output logic [7:0]  data_out_slave,
    output logic [7:0] peri_data_i2c,
    output logic [31:0] ram_data_out,
    output logic scl,
    inout logic sda,
    output logic wave,
    output logic wave1,
    output logic wave2
    );
    logic read_en;
    logic [4:0] address_ram;
    logic uart_ready;
    logic i2c_ready;
    logic apb_range;
    logic [63:0] data_in;
    logic full;
    logic apb_write;
    assign apb_range=(addr >=32'h4000_0000 && addr<=32'h4000_0018);
    always_comb
    begin
        dmem_write=0;
        apb_write=0;
        data_in='0;
        if(memwrite)
        begin
            if(apb_range && !full)
                begin
                apb_write=1'b1;
                data_in={addr,data};
                end
            else
                begin
                dmem_write=1'b1;
                end
        end
    end
    
    fifo_master fifo_master1(
                            .clk(clk),
                            .rst(rst),
                            .w_en(apb_write),
                            .data_in(data_in),
                            .data_in_slave(data_in_slave),
                            .full(full),
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
       
     peripherial_ram ram1(
                          .clk(clk),
                          .rst(rst),
                          .wr_en_i2c(i2c_ready),
                          .wr_en_uart(uart_ready),
                          .data_in_i2c(peri_data_i2c),
                          .data_in_uart(peri_data_uart),
                          .read_en(read_en),
                          .address(address_ram),
                          .data_out(ram_data_out)
                          );
           
endmodule:bridge
