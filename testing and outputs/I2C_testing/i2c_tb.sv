`timescale 1ns/1ps

module i2c_tb;

logic clk;
logic rst;

logic [7:0] data_in_slave;
logic scl;
wire sda;
pullup(sda);

logic [7:0] peri_data_i2c;
logic [7:0] data_out_slave;

logic [31:0] write_data;
logic [31:0] data_add;
logic mem_write;
logic [31:0] peri_data_uart;

logic wave;
logic wave1;
logic wave2;

top top1(
    .clk(clk),
    .rst(rst),
    .data_in_slave(data_in_slave),
    .scl(scl),
    .sda(sda),
    .write_data(write_data),
    .data_add(data_add),
    .mem_write(mem_write),
    .peri_data_uart(peri_data_uart),
    .peri_data_i2c(peri_data_i2c),
    .data_out_slave(data_out_slave),
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
    data_in_slave = 8'hA5;
    #10;
    rst = 0;
end

always @(posedge clk) begin
    if(!rst)
        $display("PC=%08h  INSTR=%08h",
                 top1.pc,
                 top1.instr);
end

initial begin
    #5000;

    $display("\n========================================");
    $display("        I2C INTEGRATION TEST");
    $display("========================================");
    $display("Slave Address  : 0x40");
    $display("Slave Received : %02h", data_out_slave);
    $display("Master Received: %02h", peri_data_i2c);
    $display("----------------------------------------");
    $display("CPU Registers");
    $display("x10 = %08h", top1.core1.data.r1.register[10]);
    $display("x11 = %08h", top1.core1.data.r1.register[11]);
    $display("========================================");

    $finish;
end

endmodule
