`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2026 09:49:49
// Design Name: 
// Module Name: extender
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


module extender(
    input logic [31:0] instr,
    input logic [1:0] imm_src,
    output logic [31:0] out
    );
    always_comb
    begin
        case(imm_src)
            2'b00:out={{20{instr[31]}},instr[31:20]};//I type
            2'b01:out={{20{instr[31]}},instr[31:25],instr[11:7]};// S type
            2'b10:out={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};//B type;
            2'b11:out={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};//J type
            default:out='x;
        endcase
    end 
endmodule:extender
