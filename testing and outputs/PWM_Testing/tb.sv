`timescale 1ns/1ps

module pwm_tb;

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
    #100;
    $finish;
end

always @(posedge clk) begin
    if(!rst && mem_write) begin
        $display("[%0t] CPU WRITE  Addr = %08h  Data = %08h",
                 $time, data_add, write_data);
    end
end

always @(posedge clk) begin
    if(!rst && top1.bridge1.apb_write) begin
        $display("[%0t] APB WRITE  PWM Data = %08h",
                 $time, write_data);
    end
end

always @(posedge wave) begin
    $display("[%0t] PWM Rising Edge", $time);
end

always @(negedge wave) begin
    $display("[%0t] PWM Falling Edge", $time);
end

endmodule
