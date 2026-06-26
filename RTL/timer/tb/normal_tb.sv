`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 00:02:20
// Design Name: 
// Module Name: normal_tb
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

 
module normal_tb;
    logic clk;
    logic rst;
    logic write;
    logic [15:0] data_in;
    logic [7:0] count;
    logic wave;
    logic pready_p;
    
    normal #(.N(16)) normal1(
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(data_in),
        .count(count),
        .wave(wave),
        .pready_p(pready_p)
    );
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d wave=%b busy=%b counter=%b counter_1=%b write=%b data_in=%b mem=%b ",$time,wave,normal.busy,
        normal.counter,normal.counter_1,write,data_in,normal.mem
    );
    end
    
    initial begin
    rst=1;
    #10;
    rst=0;
    
    @(posedge clk);
    write=1'b1;
    data_in=16'b0000_0000_0000_0101;
    count=8'b0000_0100;
    @(posedge clk);
    write=0;
    #300;
    
//    @(posedge clk);
//    write=1;
//    data_in=4'b0000;
//    @(posedge clk);
//    write=0;
//    #200;
    
    @(posedge clk);
    write=1;
    data_in=16'b0000_0000_0001_0111;
    count=8'b0000_1010;
    @(posedge clk);
    write=0;
    #300;
    
    $finish;
    end
endmodule:normal_tb
