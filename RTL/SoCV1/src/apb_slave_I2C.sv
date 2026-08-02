`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 17:46:17
// Design Name: 
// Module Name: apb_slave
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

module apb_slave_I2C(
    input  logic        clk,
    input  logic        prstn,
    input  logic [2:0]  psel,
    input  logic        trans,
    //input  logic        pready_p, // Input from the external peripheral
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] pwdata,//from master to slave
    input  logic [7:0]  data_in_slave,
    output logic        pready, //from peripherial to slave
    output logic        i2c_ready,
    output logic        scl,
    inout  logic        sda,
    output logic [7:0] data_out_slave,
    output logic [7:0] peri_data_i2c 
);
    logic pwrite_en;
    logic pready_p;
    logic [31:0] p_data;
    logic write_pending;
    always_ff @ (posedge clk)
    begin
        if(!prstn)
        begin
        p_data<=32'b0;
        write_pending<=1'b0;
        pwrite_en<=1'b0;
        end
        else 
            begin
            //$display("psel=%b penable=%b trans=%b pready=%b pwdata=%h",psel,penable,trans,pready,pwdata);
            pwrite_en<=1'b0;
            if(psel==3'b100 && penable && trans && pwrite && pready_p)
                begin
                p_data<=pwdata;
                write_pending<=1'b1;
                end
            if(write_pending)
                begin
                write_pending<=1'b0;
                pwrite_en<=1'b1;
                end
            end

    end
    //assign stop=(pwdata==32'b0);
    logic busy;
    assign pready_p=~busy;
    assign pready=pready_p;
    
    i2c_top i2c_top1(
                     .clk(clk),
                     .rst(~prstn),
                     .write(pwrite_en),
                     .data_in(p_data),//input for the i2c top
                     .busy(busy),
                     .data_in_slave(data_in_slave),
                     .scl(scl),
                     .sda(sda),
                     .ready(i2c_ready),
                     .data_master(peri_data_i2c),
                     .data_slave(data_out_slave)
                     );
endmodule: apb_slave_I2C

