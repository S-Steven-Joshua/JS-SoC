`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 12:56:36
// Design Name: 
// Module Name: fifo_master_tb
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


module fifo_master_tb;
    logic clk;
    logic rst;
    logic w_en;
    logic [63:0] data_in;
    logic full;
    logic [31:0] pr_data;
    logic wave;
    logic wave1;
    logic wave2;
    
    fifo_master fifo_master1(
                                .clk(clk),
                                .rst(rst),
                                .w_en(w_en),
                                .data_in(data_in),
                                .full(full),
                                .pr_data(pr_data),
                                .wave(wave),
                                .wave1(wave1),
                                .wave2(wave2)
                                );
   initial begin
   clk=0;
   forever #5 clk=~clk;
   end
   
   initial begin
        $monitor(
            "t=%0t w_en=%b data_in=%h full=%b wave=%b wave1=%b wave2=%b",
            $time,w_en,data_in,full,wave,wave1,wave2
        );
    end

    // Stimulus
    initial begin

        rst     = 1'b1;
        w_en    = 1'b0;
        data_in = 64'd0;

        #20;
        rst = 1'b0;

        // UART
        @(negedge clk);
        w_en    <= 1'b1;
        data_in <= {32'h4000_0000,32'h0000_0041};

        @(negedge clk);
        w_en <= 1'b0;

        // PWM
        @(negedge clk);
        w_en    <= 1'b1;
        data_in <= {32'h4000_0008,32'h000A_0003};

        @(negedge clk);
        w_en <= 1'b0;

        // TIMER
        @(negedge clk);
        w_en    <= 1'b1;
        data_in <= {32'h4000_000C,32'h1C0A_000A};

        @(negedge clk);
        w_en <= 1'b0;

        // Back-to-back test
        @(negedge clk);
        w_en    <= 1'b1;
        data_in <= {32'h4000_0000,32'h0000_0042};

        @(negedge clk);
        data_in <= {32'h4000_0008,32'h000F_0005};

        @(negedge clk);
        data_in <= {32'h4000_000C,32'h0000_0010};

        @(negedge clk);
        w_en <= 1'b0;

        repeat(200) @(posedge clk);

        $finish;
    end

   
endmodule:fifo_master_tb
