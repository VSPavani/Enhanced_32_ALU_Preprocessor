`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 11:37:35
// Design Name: 
// Module Name: execute_preprocessor
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
`define MEM_READ 3'b101
`define MEM_WRITE 3'b100
`define ARITH_LOGIC 3'b001
`define SHIFT_REG 3'b000

module execute_preprocessor (
    input logic clock,
    input logic reset,
    input logic enable_ex,
    input logic [31:0] src1,
    input logic [31:0] src2,
    input logic [31:0] imm,
    input logic [6:0] control_in,
    input logic [31:0] mem_data_read_in,
    
    output logic mem_data_wr_en,
    output logic [31:0] mem_data_write_out,
    output logic [31:0] aluin1,
    output logic [31:0] aluin2,
    output logic [2:0] operation_out,
    output logic [2:0] opselect_out,
    output logic [4:0]shift_number,
    output logic enable_arith,
    output logic enable_shift
);

logic [2:0] opselectx;
logic [2:0] opselecty;
always_comb begin
    opselectx = control_in[2:0];
    mem_data_wr_en = 1'b0;
    if ((opselectx == `MEM_WRITE) && (control_in[3] == 1)) begin
        mem_data_wr_en = 1'b1;
    end
    mem_data_write_out = src2;
end

always_ff @(posedge clock or posedge reset) begin
    opselecty = control_in[2:0];
    if (reset) begin
        operation_out = 3'b000;
        opselect_out = 3'b000;
        enable_arith = 0;
        enable_shift = 0;
        aluin1 = 32'b0;
        aluin2 = 32'b0;
        shift_number = 5'b0;
         end
         
    else begin
        if (!enable_ex) begin
            shift_number = 5'b0;
            enable_arith = 0;
            enable_shift = 0;
        end
        
        else begin
            opselecty = control_in[2:0];          
            aluin1=src1;
            
            operation_out = control_in[6:4];
            opselect_out = control_in[2:0];
            
            case (opselecty)
                `ARITH_LOGIC: begin
                    if(control_in[3]) begin
                        enable_arith = 1;
                        aluin2 = imm;
                    end 
                    else begin
                        enable_arith = 1;
                        aluin2 = src2;
                    end                 
                 end
                
                `MEM_READ: begin
                    if(control_in[3]) begin
                        enable_arith = 1;
                        aluin2 = mem_data_read_in;
                    end 
                    else begin
                        enable_arith = 0;
                        aluin2 <= aluin2;
                    end                 
                 end
                
                `SHIFT_REG: begin
                    enable_shift=1;
                    if (imm[2]) begin
                        shift_number = src2[4:0];
                    end 
                    else begin
                        shift_number = imm[10:6];
                    end                 
                 end
         
                default: begin
                    aluin2 <= aluin2;
                    enable_arith = 0;
                    enable_shift=0;
                    shift_number =0;
                end
        endcase            
        end
    end              
end
endmodule