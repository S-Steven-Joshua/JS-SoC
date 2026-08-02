`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 18:13:26
// Design Name: 
// Module Name: i2c_master
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


module i2c_master(
    input logic clk,
    input logic scl,
    input logic scl_fall,
    input logic scl_rise,
    input logic rst,
    input logic write,
    input logic [31:0] data_in,
    output logic busy,
    output logic [7:0] data_out,
    output logic ready,
    output logic scl_enable,
    inout logic sda
    );
    logic [7:0] tx;
    logic [7:0] data;
    logic sda_drive_low;
    logic [2:0] add_counter;
    logic [2:0] data_counter; 
    logic [2:0] read_counter;
    logic write_enable;
    logic rw;
    typedef enum logic [4:0] {idle,start,send_add,address_ack,write_state,read_state,master_nack,slave_ack,stop,bus_free} state_t;
    state_t state;
    
    always_ff @ (posedge clk)
    begin
        if(rst)
        begin
            tx<='0;
            data<='0;
            sda_drive_low<=1'b0;
            add_counter<=3'b000;
            data_counter<=3'b000;
            write_enable<=1'b0;
            read_counter<=3'b000;
            rw<=1'b0;
            state<=idle;
            busy<=1'b0;
            data_out<='0;
            ready<=1'b0;
        end
        else
        begin
            if(write)
            begin
                tx<={data_in[31:25],data_in[24]};
                rw<=data_in[24];
                data<=data_in[23:16];
                write_enable<=1'b1;
                add_counter<=3'b000;
                read_counter<=3'b000;
                data_counter<=3'b000;
                //busy<=1'b1;
            end
            case(state)
                idle:
                begin
                //$display("Master received = %h at time %t", data_out, $time);
                //$display("Master:Idle");
                    sda_drive_low<=1'b0;
                    busy<=1'b0;
                    scl_enable<=1'b0;
                    if((write_enable||write))
                    begin
                            sda_drive_low<=1'b1;
                            busy<=1'b1;
                            state<=start;
                            write_enable<=1'b0;
                    end
                    else
                    begin
                        state<=idle;
                    end
                end
                start:
                begin
                    //$display("Start");
                    busy<=1'b1;
                    sda_drive_low<=1'b1;
                    scl_enable<=1'b0;
                    state<=send_add;
                end
                
                send_add:
                begin
                scl_enable<=1'b1;
                //$display("Master:send_addd");
                    if(scl_fall)
                    begin
                        if(tx[7])
                        begin
                            sda_drive_low<=1'b0;
                        end
                        else
                        begin
                            sda_drive_low<=1'b1;
                        end
                    end
                    else if(scl_rise)
                    begin
                        tx<=tx<<1;
                        if(add_counter==3'b111)
                        begin
                            add_counter<='0;
                            sda_drive_low<=1'b0;
                            state<=address_ack;
                        end
                        else
                        begin
                            add_counter<=add_counter+1'b1;
                        end
                    end
                    else
                    begin
                        state<=send_add;
                    end
                end
                address_ack:
                begin
                    if(scl_rise)
                    begin
                        //$display("MASTER samples SDA=%b at %0t", sda, $time);
                        if(!sda)
                        begin
                            if(rw)//1 master reads from slave //0 master writes slave
                            begin
                                state<=read_state;
                            end
                            else
                            begin
                                state<=write_state;
                            end
                        end
                        else
                        begin
                            state<=stop;
                        end
                    end
                end
                write_state:
                begin
                    if(scl_fall)
                    begin
                        if(data[7])
                        begin
                            sda_drive_low<=1'b0;
                        end
                        else
                        begin
                            sda_drive_low<=1'b1;
                        end
                    end
                    else if(scl_rise)
                    begin
                        data<=data<<1;
                        if(data_counter==3'b111)
                        begin
                            state<=slave_ack;
                            data_counter<='0;
                            sda_drive_low<=1'b0;
                        end
                        else
                        begin
                            data_counter<=data_counter+1'b1;
                        end
                    end
                    else
                    begin
                        state<=write_state;
                    end
                end
                read_state:
                begin
                    if(scl_rise)
                    begin
                        //$display("%0t SAMPLE cnt=%0d bit=%b",$time, read_counter, sda);
                        data_out<={data_out[6:0],sda};
                        if(read_counter==3'b111)
                        begin
                            state<=master_nack;
                            ready<=1'b1;
                        end
                        else
                        begin
                            read_counter<=read_counter+1'b1;
                        end
                    end
                    else
                    begin
                        state<=read_state;
                    end
                end
                master_nack: //so sda is pulled the master goes to the stop condition // if master wants another data then sda is 0 // single byte read
                begin
                ready<=1'b0;
                //$display("data_out=%h",data_out);
                    if(scl_fall)
                    begin
                        sda_drive_low<=1'b1;
                        state<=stop;
                    end
                end
                slave_ack:
                begin
                    if(scl_rise)
                    begin
                        if(!sda)
                        begin
                            state<=stop;
                        end
                        else
                        begin
                            state<=stop;
                        end
                    end
                end
                stop:
                begin
                    if(scl_rise)
                    begin
                    sda_drive_low<=1'b0;
                    //busy<=1'b1;
                    state<=bus_free;
                    end
                end
                bus_free:
                begin
                    if(scl && sda)
                    begin
                        state<=idle;
                        busy<=1'b0;
                    end
                end

                default:state<=idle;
            endcase
        end
    end

    assign sda=sda_drive_low ? 1'b0 : 1'bz;
endmodule:i2c_master
