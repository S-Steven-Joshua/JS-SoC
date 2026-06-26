`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 10:25:22
// Design Name: 
// Module Name: soc_tb
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


module soc_tb;

logic clk;
logic rst;
logic [31:0] paddr;
logic [31:0] data;
logic [31:0] pr_data;

soc soc1(
    .clk(clk),
    .rst(rst),
    .paddr(paddr),
    .data(data),
    .pr_data(pr_data)
);

//////////////////////////////////////
// Clock
//////////////////////////////////////

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//////////////////////////////////////
// Monitor
//////////////////////////////////////

initial begin
    $monitor(
    "t=%0t | TX_STATE=%0d | TX_IDX=%0d | TX=%b | TX_DATA=%h | TX_BUSY=%b | RX_STATE=%0d | RX_BYTE=%h | RX_RDY=%b | DES_CNT=%0d | DES_MEM=%h | DES_OUT=%h",
    $time,
    soc1.uart_soc1.uart_tx1.state,
    soc1.uart_soc1.uart_tx1.index,
    soc1.uart_soc1.tx,
    soc1.uart_soc1.uart_tx1.data,
    soc1.uart_soc1.uart_tx1.busy,

    soc1.uart_soc1.uart_rx1.state,
    soc1.uart_soc1.uart_rx1.data_out,
    soc1.uart_soc1.uart_rx1.rdy,

    soc1.uart_soc1.deserializer1.counter,
    soc1.uart_soc1.deserializer1.mem,
    soc1.uart_soc1.deserializer1.data_out
    );
end
//////////////////////////////////////
// APB WRITE TASK
//////////////////////////////////////

task automatic apb_write(
    input [31:0] addr,
    input [31:0] wr_data
);
begin

    @(posedge clk);

    paddr <= addr;
    data  <= wr_data;

    @(posedge clk);

    paddr <= 32'h0;
    data  <= 32'h0;

end
endtask

//////////////////////////////////////
// Stimulus
//////////////////////////////////////

initial begin

    //////////////////////////////////
    // Reset
    //////////////////////////////////

    rst   = 1;
    paddr = 0;
    data  = 0;

    repeat(5) @(posedge clk);

    rst = 0;

    //////////////////////////////////
    // TEST 1
    //////////////////////////////////

    $display("\n==========================");
    $display("TEST1 : 11223344");
    $display("==========================");

    apb_write(
        32'h4000_0000,
        32'h11223344
    );

    wait(soc1.master_ready);

    #20;

    $display(
    "EXPECTED = 11223344  RECEIVED = %h",
    pr_data
    );

    //////////////////////////////////
    // TEST 2
    //////////////////////////////////

    $display("\n==========================");
    $display("TEST2 : DEADBEEF");
    $display("==========================");

    apb_write(
        32'h4000_0000,
        32'hDEADBEEF
    );

    wait(soc1.master_ready);

    #20;

    $display(
    "EXPECTED = DEADBEEF  RECEIVED = %h",
    pr_data
    );

    //////////////////////////////////
    // TEST 3
    //////////////////////////////////

    $display("\n==========================");
    $display("TEST3 : CAFEBABE");
    $display("==========================");

    apb_write(
        32'h4000_0000,
        32'hCAFEBABE
    );

    wait(soc1.master_ready);

    #20;

    $display(
    "EXPECTED = CAFEBABE  RECEIVED = %h",
    pr_data
    );

    //////////////////////////////////
    // TEST 4
    //////////////////////////////////

    $display("\n==========================");
    $display("TEST4 : A5A55A5A");
    $display("==========================");

    apb_write(
        32'h4000_0000,
        32'hA5A55A5A
    );

    wait(soc1.master_ready);

    #20;

    $display(
    "EXPECTED = A5A55A5A  RECEIVED = %h",
    pr_data
    );

    //////////////////////////////////
    // PASS / FAIL
    //////////////////////////////////

    if(pr_data == 32'hA5A55A5A)
        $display("\nSOC UART LOOPBACK PASSED");
    else
        $display("\nSOC UART LOOPBACK FAILED");

    repeat(100) @(posedge clk);

    $finish;

end

endmodule