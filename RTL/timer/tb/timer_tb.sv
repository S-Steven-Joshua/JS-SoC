`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 17:59:13
// Design Name: 
// Module Name: timer_tb
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


module timer_tb;
    logic clk;
    logic rst;
    logic [31:0] data_word;
    logic write;
    logic master_ready;
    logic wave1;
    logic wave2;
    
    timer timer1(
                .clk(clk),
                .rst(rst),
                .data_word(data_word),
                .write(write),
                .master_ready(master_ready),
                .wave1(wave1),
                .wave2(wave2)
    );
    
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d data_word=%x,write=%b 16_bit=%d write_normal=%b mem=%d ",$time,data_word,write,timer.control_logic1.bit_16,timer.decoder_logic1.write_normal,
            timer1.decoder_logic1.normal_time.mem
    );
    end
    
    initial begin 
    rst=1;
    data_word=0;
    write=0;
    #20;
    rst=0;
    
    @ (posedge clk);
    write=1;
    data_word=32'h1C0A000A;//normal mode  counter=10 counter1=10;
    @(posedge clk);
    write=0;
    #1000;
    
        
    @ (posedge clk);
    write=1;
    data_word=32'h06000003;//square mode  counter=3 ;
    @(posedge clk);
    write=0;
    #1000;
    
            
    @ (posedge clk);
    write=1;
    data_word=32'h06000000;//square mode  counter=0 ;
    @(posedge clk);
    write=0;
    #1000;
    
    $finish; 
    end

endmodule:timer_tb
