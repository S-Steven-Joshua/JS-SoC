`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2026 10:49:12
// Design Name: 
// Module Name: timer_soctb
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


module timer_soctb;
    logic clk;
    logic rst;
    logic [31:0] paddr;
    logic [31:0] data;
    logic wave1;
    logic wave2;
    
    timer_soc timer_soc1(
                         .clk(clk),
                         .rst(rst),
                         .paddr(paddr),
                         .data(data),
                         .wave1(wave1),
                         .wave2(wave2)
                        );
    initial  begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d paddr=%x data=%x",$time,paddr,data);
    end
    
    initial begin
    rst=1;
    paddr='0;
    data='0;
    #10;
    rst=0;
    
    @(posedge clk);
    paddr=32'h4000_0010;
    data=32'h1C0A000A;
    #200;
    
    @(posedge clk);
    paddr=32'h4000_000C;
    data=32'h06000003;
    #200;
    @(posedge clk);
    paddr=32'h4000_0014;
    data=32'h06000003;
    #200;
    @(posedge clk);
    paddr=32'h4000_0014;
    data=32'h06000000;
    #200;
    $finish;
    end
endmodule:timer_soctb
