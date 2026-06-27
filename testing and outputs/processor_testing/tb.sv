`timescale 1ns/1ps

module cpu_tb;

logic clk;
logic rst;

logic [31:0] write_data;
logic [31:0] data_add;
logic mem_write;
logic [31:0] pr_data;
logic wave;
logic wave1;
logic wave2;

top top1(
    .clk(clk),
    .rst(rst),
    .write_data(write_data),
    .data_add(data_add),
    .mem_write(mem_write),
    .pr_data(pr_data),
    .wave(wave),
    .wave1(wave1),
    .wave2(wave2)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    rst = 1;
    #10;
    rst = 0;
end

initial begin
    #300;
    $display("\n========================================");
    $display("CPU REGISTER FILE");
    $display("========================================");
    $display("x0  = %08h", top1.core1.data.r1.register[0]);
    $display("x1  = %08h", top1.core1.data.r1.register[1]);
    $display("x2  = %08h", top1.core1.data.r1.register[2]);
    $display("x3  = %08h", top1.core1.data.r1.register[3]);
    $display("x4  = %08h", top1.core1.data.r1.register[4]);
    $display("x5  = %08h", top1.core1.data.r1.register[5]);
    $display("x6  = %08h", top1.core1.data.r1.register[6]);
    $display("x7  = %08h", top1.core1.data.r1.register[7]);
    $display("========================================");
end

always @(posedge clk) begin
    if(!rst) begin
        $display("PC=%08h  INSTR=%08h",
                 top1.pc,
                 top1.instr);
    end
end

endmodule
