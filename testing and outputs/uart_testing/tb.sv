`timescale 1ns/1ps

module uart_tb;

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
    #15000;
    $finish;
end

always @(posedge clk) begin
    if(!rst) begin

        $display(
"T=%0t PC=%08h INSTR=%08h ADDR=%08h DATA=%08h MW=%b APB=%b",
        $time,
        top1.pc,
        top1.instr,
        data_add,
        write_data,
        mem_write,
        top1.bridge1.apb_write
        );

        // Print only when a complete 32-bit word has been received
        if(pr_data != 32'h00000000)
            $display(
"UART Received : \"%c%c%c%c\" (0x%08h)",
                pr_data[31:24],
                pr_data[23:16],
                pr_data[15:8],
                pr_data[7:0],
                pr_data
            );
    end
end

endmodule keep it clean
