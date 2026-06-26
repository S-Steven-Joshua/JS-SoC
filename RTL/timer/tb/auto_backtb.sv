`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 18:57:42
// Design Name: 
// Module Name: auto_backtb
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


module auto_backtb;
    logic clk;
    logic rst;
    logic write;
    logic [3:0] data_in;
    logic wave;
    logic pready_p;
    
    auto_back #(.N(4)) auto_back1(
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
    $monitor("Time=%d wave=%b busy=%b counter=%b  write=%b data_in=%b ",$time,wave,pready_p,
        auto_back.counter,write,data_in
    );
    end
    
    initial begin
    rst=1;
    #10;
    rst=0;
    
    @(posedge clk);
    write=1'b1;
    data_in=4'b1100;
    @(posedge clk);
    write=0;
    #500;
    
    @(posedge clk);
    write=1;
    data_in=4'b0000;
    @(posedge clk);
    write=0;
    #200;
    

    
    $finish;
    end
endmodule
