`timescale 1ns/1ps

module soc_tb;

logic clk;
logic rst;

logic [7:0] data_in_slave;

logic scl;
wire sda;
pullup(sda);


//logic mem_write;

logic [7:0] peri_data_i2c;
logic [7:0] data_out_slave;

logic tx;

logic wave;
logic wave1;
logic wave2;

top top1(
    .clk(clk),
    .rst(rst),
    .data_in_slave(data_in_slave),

//    .write_data(write_data),
//    .data_add(data_add),
//    .mem_write(mem_write),

    .scl(scl),
    .sda(sda),
    .tx(tx),
    .peri_data_i2c(peri_data_i2c),
    .data_out_slave(data_out_slave),
//    .peri_data_uart(peri_data_uart),
//    .ram_data_out(ram_data_out),

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

//----------------------------------------
// CPU Trace
//----------------------------------------
always @(posedge clk) begin
    if(!rst)
        $display("PC=%08h INSTR=%08h",
                 top1.pc,
                 top1.instr);
end

//----------------------------------------
// CPU Writes
//----------------------------------------

//----------------------------------------
// Peripheral RAM Reads
//----------------------------------------
always @(posedge clk) begin
    if(!rst && top1.bridge1.read_en)
        $display("[%0t] RAM_READ=%08h",
                 $time,
                 top.ram_data_out);
end

//----------------------------------------
// Final Report
//----------------------------------------
initial begin

    #12000;

    $display("");
    $display("========================================");
    $display("      FINAL SoC INTEGRATION TEST");
    $display("========================================");

    $display("UART");
    $display("----------------------------------------");
    $display("UART RX   : %08h",top.peri_data_uart);
    $display("RAM[0]    : %08h",top1.bridge1.ram1.ram[0]);

    $display("");

    $display("I2C");
    $display("----------------------------------------");
    $display("Slave TX  : %02h",data_in_slave);
    $display("Master RX : %02h",peri_data_i2c);
    $display("RAM[8]    : %08h",top1.bridge1.ram1.ram[8]);
    $display("STATUS    : %08h",top1.bridge1.ram1.ram[31]);

    $display("");

    $display("CPU Registers");
    $display("----------------------------------------");
    $display("x1  = %08h",top1.core1.data.r1.register[1]);
    $display("x2  = %08h",top1.core1.data.r1.register[2]);
    $display("x3  = %08h",top1.core1.data.r1.register[3]);
    $display("x4  = %08h",top1.core1.data.r1.register[4]);
    $display("x5  = %08h",top1.core1.data.r1.register[5]);
    $display("x12 = %08h",top1.core1.data.r1.register[12]);

    $display("");

    $display("PWM");
    $display("----------------------------------------");
    $display("wave  = %b",wave);
    $display("wave1 = %b",wave1);
    $display("wave2 = %b",wave2);

    $display("");

    $display("========================================");
    $display("Simulation Complete");
    $display("========================================");

    $finish;

end

endmodule
