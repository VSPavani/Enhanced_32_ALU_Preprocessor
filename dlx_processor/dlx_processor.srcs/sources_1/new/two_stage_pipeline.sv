`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 13:55:47
// Design Name: 
// Module Name: two_stage_pipeline
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
interface proc_if;
    logic        clock_stage1;
    logic        reset_stage1;
    logic        clock_stage2;
    logic        reset_stage2;
    logic        enable_ex;
    logic [31:0] src1;
    logic [31:0] src2;
    logic [31:0] imm;
    logic [6:0]  control_in;
    logic [31:0] mem_data_read_in;
    
    // Outputs
    logic        mem_data_wr_en;
    logic [31:0] mem_data_write_out;
    logic [31:0] aluout;
    logic        carry;
    
    // Modports
    modport DUT (
        input  clock_stage1, reset_stage1, clock_stage2, reset_stage2,
        input  enable_ex, src1, src2, imm, control_in, mem_data_read_in,
        output mem_data_wr_en, mem_data_write_out, aluout, carry
    );
    
endinterface

module two_stage_pipeline (proc_if.DUT signal);

    // Internal connections between stages
    logic [31:0] aluin1;
    logic [31:0] aluin2;
    logic [2:0]  operation;
    logic [2:0]  opselect;
    logic [4:0]  shift_number;
    logic        enable_arith;
    logic        enable_shift;
    logic [2:0]  operation_out;
    logic [2:0]  opselect_out;

    // Instantiate the EXECUTE_PREPROCESSOR (Stage 1)
    execute_preprocessor stage1 (
        .clock(signal.clock_stage1),
        .reset(signal.reset_stage1),
        .enable_ex(signal.enable_ex),
        .src1(signal.src1),
        .src2(signal.src2),
        .imm(signal.imm),
        .control_in(signal.control_in),
        .mem_data_read_in(signal.mem_data_read_in),
        
        // Outputs
        .mem_data_wr_en(signal.mem_data_wr_en),
        .mem_data_write_out(signal.mem_data_write_out),
        .operation_out(operation_out),
        .opselect_out(opselect_out),
        .enable_arith(enable_arith),
        .enable_shift(enable_shift),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .shift_number(shift_number)
    );

    ALU stage2 (
        .clock(signal.clock_stage2),
        .reset(signal.reset_stage2),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .operation(operation_out),
        .opselect(opselect_out),
        .shift_number(shift_number),
        .enable_arith(enable_arith),
        .enable_shift(enable_shift),
        
        // Outputs
        .aluout(signal.aluout),
        .carry(signal.carry)
    );

endmodule