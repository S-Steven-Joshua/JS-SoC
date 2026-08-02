`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 12:17:12
// Design Name: 
// Module Name: peripherial_ram
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


module peripherial_ram (
    input  logic        clk,
    input  logic        rst,
    input  logic        wr_en_i2c,
    input  logic        wr_en_uart,
    input  logic [7:0]  data_in_i2c,       
    input  logic [31:0] data_in_uart,
    input  logic        read_en,
    input  logic [4:0]  address,
    output logic [31:0] data_out
);

    logic [31:0] ram [31:0];

    logic [2:0] i2c_counter;
    logic [2:0] uart_counter;
    integer i;

    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            for (i = 0; i < 32; i = i + 1)
            begin
                ram[i] <= '0;
            end
            uart_counter <= '0;
            i2c_counter  <= '0;
        end
        else
        begin
            if (wr_en_i2c)
            begin
                ram[i2c_counter + 8] <= {24'b0,data_in_i2c[7:0]};
                i2c_counter <= i2c_counter + 1'b1;
            end
            if(wr_en_uart)
            begin
                ram[uart_counter] <= data_in_uart;
                uart_counter <=uart_counter+1'b1;
            end
        end
    end

    always_comb
    begin
        if (read_en)
            data_out = ram[address];
        else
            data_out = '0;
    end

endmodule : peripherial_ram
