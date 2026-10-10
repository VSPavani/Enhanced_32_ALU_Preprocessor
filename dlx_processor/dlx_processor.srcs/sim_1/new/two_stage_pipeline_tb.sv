`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 15:19:37
// Design Name: 
// Module Name: tb
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

`timescale 1ns / 1ps

// Interface definition for the processor
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

// Operation types - constants
package op_package;
    // Operation type parameters
    parameter OP_ADD      = 3'b000;
    parameter OP_HADD     = 3'b001;
    parameter OP_SUB      = 3'b010;
    parameter OP_NOT      = 3'b011;
    parameter OP_AND      = 3'b100;
    parameter OP_OR       = 3'b101;
    parameter OP_XOR      = 3'b110;
    parameter OP_LHG      = 3'b111;
    
    // Shift operation parameters
    parameter OP_SHLEFTLOG = 3'b000;
    parameter OP_SHLEFTART = 3'b001;
    parameter OP_SHRGHTLOG = 3'b010;
    parameter OP_SHRGHTART = 3'b011;
    
    // Memory operation parameters
    parameter OP_LOADBYTE     = 3'b000;
    parameter OP_LOADBYTEU = 3'b001;
    parameter OP_LOADHALF  = 3'b010;
    parameter OP_LOADHALFU = 3'b011;
    parameter OP_LOADWORD  = 3'b100;
    
    // OpSelect parameters
    parameter SEL_SHIFT    = 3'b000;
    parameter SEL_ARITH    = 3'b001;
    parameter SEL_MEM_READ = 3'b101;
    parameter SEL_MEM_WRITE = 3'b100;
    
endpackage

import op_package::*;

module two_stage_pipeline_tb( );
    
proc_if signal();
two_stage_pipeline uut (signal);

initial begin
   signal.clock_stage1 = 0;
   forever #5 signal.clock_stage1 = ~signal.clock_stage1; // 10ns period
end

initial begin
    signal.clock_stage2 = 0;
    forever #5 signal.clock_stage2 = ~signal.clock_stage2; // 14ns period
end
  
     
class Test;
   virtual  proc_if signal; // Declare a handle to the proc_signals instance
    
    function new(virtual proc_if pi);
        this.signal = pi; // Assign the instance
    endfunction

    function void run_test(input logic [31:0] src1, input logic [31:0] src2,
    input logic [31:0] imm, input logic [6:0]  control_in,
    input logic [31:0] mem_data_read_in);
    
        signal.src1               = src1;
        signal.src2               = src2;
        signal.imm                = imm;
        signal.control_in         = control_in;
        signal.mem_data_read_in   = mem_data_read_in;
        $display("Time=%0t | enable_ex=%d | Src1=%d | Src2=%d | Imm=%d | Control=%b | ALUOut=%d | Carry=%b", 
               $time,signal.enable_ex,signal.src1, signal.src2, signal.imm, signal.control_in, signal.aluout, signal.carry);
   endfunction
endclass

Test tb = new(signal);

initial begin
    signal.reset_stage1 = 1;
    signal.reset_stage2 = 1;
    signal.enable_ex = 0;
    #20;
    signal.reset_stage1 = 0;
    signal.reset_stage2 = 0;
    signal.enable_ex = 1;
    #10;
     
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_ADD, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_HADD, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SUB, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_NOT, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_AND, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_OR, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_XOR, 1'b0, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_LHG, 1'b0, SEL_ARITH}, 32'd15); #20;
    
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_ADD, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_HADD, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_SUB, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_NOT, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_AND, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_OR, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_XOR, 1'b1, SEL_ARITH}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd8, {OP_LHG, 1'b1, SEL_ARITH}, 32'd15); #20;
    
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADBYTE, 1'b0, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADBYTEU, 1'b0, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADHALF, 1'b0, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADHALFU, 1'b0, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADWORD, 1'b0, SEL_MEM_READ}, 32'd15); #20;
    
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADBYTE, 1'b1, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADBYTEU, 1'b1, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADHALF, 1'b1, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADHALFU, 1'b1, SEL_MEM_READ}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_LOADWORD, 1'b1, SEL_MEM_READ}, 32'd15); #20;
    
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_SHLEFTLOG, 1'b0, SEL_SHIFT}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_SHLEFTART, 1'b0, SEL_SHIFT}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_SHRGHTLOG, 1'b0, SEL_SHIFT}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd0, {OP_SHRGHTART, 1'b0, SEL_SHIFT}, 32'd15); #20;

    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SHLEFTLOG, 1'b0, SEL_SHIFT}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SHLEFTART, 1'b0, SEL_SHIFT}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SHRGHTLOG, 1'b0, SEL_SHIFT}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SHRGHTART, 1'b0, SEL_SHIFT}, 32'd15); #20;
    
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SHLEFTLOG, 1'b0, SEL_MEM_WRITE}, 32'd15); #20;
    tb.run_test(32'd10, 32'd5, 32'd4, {OP_SHLEFTLOG, 1'b1, SEL_MEM_WRITE}, 32'd15); #20;

    $finish;
end  
endmodule