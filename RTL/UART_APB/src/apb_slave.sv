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


module apb_slave(
    input  logic        clk,
    input  logic        prstn,
    input  logic        psel,
    input  logic        trans,
    input  logic        pready_p, // Input from the external peripheral
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] pwdata,//data from apb master to write slave 
    input logic master_ready,//from peripheral to ensure read is enabled
    input logic [31:0] peri_data,//input for the peripheral data
    output logic [31:0] p_data,//output for slave for write state
    output logic [31:0] pr_data,//output for the peripheral data
    output logic pwrite_en,
    output logic        pready
        
);
logic write_pending;

always_ff @(posedge clk or negedge prstn)
begin
    if(!prstn) begin
        p_data        <= 32'b0;
        pwrite_en     <= 1'b0;
        write_pending <= 1'b0;
    end
    else begin
        pwrite_en <= 1'b0;

        if(psel && penable && pwrite && trans) begin
            p_data        <= pwdata;
            write_pending <= 1'b1;
        end

        if(write_pending) begin
            pwrite_en     <= 1'b1;
            write_pending <= 1'b0;
        end
        if(master_ready) begin
            pr_data <= peri_data;
        end
    end
end
    assign pready=pready_p;
    //assign pwrite_en= trans && psel && pwrite && penable;
endmodule: apb_slave

