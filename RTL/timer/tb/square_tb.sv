`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 00:34:58
// Design Name: 
// Module Name: square_tb
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


module square_tb;
    logic clk;
    logic rst;
    logic write;
    logic [15:0] data_in;
    logic wave;
    logic pready_p;
    
    square #(.N(4)) square1(
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(data_in),
        .wave(wave),
        .pready_p(pready_p)
    );
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d write=%b wave=%b count=%b data_in=%b",$time,write,wave,square1.counter,data_in);
    end
    
    initial begin
    rst=1;
    #20;
    rst=0;
    @(posedge clk);
    write=1;
    data_in=16'b0000_0000_0001_0101;
    @(posedge clk);
    write=0;
    #400;
    
    @(posedge clk);
    write=1;
    data_in=16'b0000_0000_0000_0000;
    #200;
    $finish;
    end
endmodule:square_tb
