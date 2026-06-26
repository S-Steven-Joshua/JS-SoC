`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2026 00:33:07
// Design Name: 
// Module Name: pwm_coretb
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


module pwm_coretb;
    logic clk;
    logic rst;
    logic [31:0] paddr;
    logic [31:0] data;
    logic wave;
    
    pwm_core pwm_core1(
        .clk(clk),
        .rst(rst),
        .paddr(paddr),
        .data(data),
        .wave(wave)
    );
    
    initial begin 
    clk=0;
    forever #5 clk =~clk;
    end
    initial begin
    $monitor(" psel=%b penable=%b trans=%b write=%b data=%h pready=%b p_data=%h pwdata=%h state=%d  enable=%b paddr=%x",pwm_core.apb_slave1.psel,
        pwm_core.apb_slave1.penable,pwm_core.apb_slave1.trans,pwm_core.apb_slave1.pwrite_en,data,
        pwm_core.apb_slave1.pready,pwm_core.apb_slave1.p_data,pwm_core.apb_slave1.pwdata,pwm_core.apb_master2.state,
        pwm_core.pwm1.enable,paddr
        );
    end
    initial begin
    rst=0;
    #5;
    rst=1;
    #20;
    rst=0;
    
    paddr=32'h4000_0008;
    data=32'h000A_0003;
    
    #50;
    paddr=32'h4000_0010;
    data=32'h0000_0000;
    #200;
    paddr=32'h4000_000C;
    data=32'h0000_0000;
    #200;
    
    paddr=32'h4000_0008;
    data=32'h000A_0003;
    
    #200;   
    
    $finish;
    end

endmodule:pwm_coretb
