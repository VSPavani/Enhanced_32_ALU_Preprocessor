`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 19:47:12
// Design Name: 
// Module Name: arith_alu_tb
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
`define ADD       3'b000
`define HADD      3'b001
`define SUB       3'b010
`define NOT       3'b011
`define AND       3'b100
`define OR        3'b101
`define XOR       3'b110
`define LHG       3'b111

`define LOADBYTE   3'b000
`define LOADBYTEU  3'b100
`define LOADHALF   3'b001
`define LOADHALFU  3'b101
`define LOADWORD   3'b011

`define MEM_READ    3'b101
`define ARITH_LOGIC 3'b001
module arith_alu_tb;

    // Signals
    logic         clock;
    logic         reset;
    logic [31:0]  aluin1;
    logic [31:0]  aluin2;
    logic [2:0]   aluoperation;
    logic [2:0]   aluopselect;
    logic         enable;
    logic [32:0]  alu_out;

    // Instantiate the DUT
    ARITH_ALU dut (
        .clock(clock),
        .reset(reset),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .aluoperation(aluoperation),
        .aluopselect(aluopselect),
        .enable(enable),
        .alu_out(alu_out)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // 10 ns period
    end

    // Test Sequence
    initial begin

        // Reset the ALU
        reset = 1;
        enable = 0;
        #15;
        reset = 0;

        // ================================
        // ?? Test Arithmetic Operations
        // ================================

        enable = 1;

        // Test ADD
        aluin1 = 32'h0000_0005;
        aluin2 = 32'h0000_0003;
        aluoperation = `ADD;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("ADD: %h + %h = %h, Carry = %b", aluin1, aluin2, alu_out[31:0], alu_out[32]);

        // Test HADD
        aluin1 = 32'h0000_1111;
        aluin2 = 32'h0000_2222;
        aluoperation = `HADD;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("HADD: %h + %h (half) = %h, Carry = %b", aluin1, aluin2, alu_out[31:0], alu_out[32]);

        // Test SUB
        aluin1 = 32'h0000_000A;
        aluin2 = 32'h0000_0005;
        aluoperation = `SUB;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("SUB: %h - %h = %h, Carry = %b", aluin1, aluin2, alu_out[31:0], alu_out[32]);

        // Test NOT
        aluin1 = 32'h0;  // Not used in this op
        aluin2 = 32'hFFFFFF00;
        aluoperation = `NOT;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("NOT: ~%h = %h", aluin2, alu_out[31:0]);

        // Test AND
        aluin1 = 32'hF0F0_F0F0;
        aluin2 = 32'h0F0F_0F0F;
        aluoperation = `AND;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("AND: %h & %h = %h", aluin1, aluin2, alu_out[31:0]);

        // Test OR
        aluin1 = 32'hF0F0_0000;
        aluin2 = 32'h0000_0F0F;
        aluoperation = `OR;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("OR: %h | %h = %h", aluin1, aluin2, alu_out[31:0]);

        // Test XOR
        aluin1 = 32'hAAAA_AAAA;
        aluin2 = 32'h5555_5555;
        aluoperation = `XOR;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("XOR: %h ^ %h = %h", aluin1, aluin2, alu_out[31:0]);

        // Test LHG (Load Halfword into Upper 16 bits)
        aluin1 = 32'h0;  // Not used
        aluin2 = 32'h0000_1234;
        aluoperation = `LHG;
        aluopselect = `ARITH_LOGIC;
        #10;
        $display("LHG: Load Half %h into upper half = %h", aluin2, alu_out[31:0]);

        // ================================
        // ? Test Memory Read Operations
        // ================================

        // Test LOADBYTE (Sign-extend)
        aluin2 = 32'h87654321;  // Only lower 8 bits used
        aluoperation = `LOADBYTE;
        aluopselect = `MEM_READ;
        #10;
        $display("LOADBYTE: %h -> %h", aluin2, alu_out[31:0]);

        // Test LOADBYTEU (Zero-extend)
        aluin2 = 32'h87654321;  
        aluoperation = `LOADBYTEU;
        aluopselect = `MEM_READ;
        #10;
        $display("LOADBYTEU: %h -> %h", aluin2, alu_out[31:0]);

        // Test LOADHALF (Sign-extend)
        aluin2 = 32'h87654321;  
        aluoperation = `LOADHALF;
        aluopselect = `MEM_READ;
        #10;
        $display("LOADHALF: %h -> %h", aluin2, alu_out[31:0]);

        // Test LOADHALFU (Zero-extend)
        aluin2 = 32'h87654321;  
        aluoperation = `LOADHALFU;
        aluopselect = `MEM_READ;
        #10;
        $display("LOADHALFU: %h -> %h", aluin2, alu_out[31:0]);

        // Test LOADWORD
        aluin2 = 32'h12345678;  
        aluoperation = `LOADWORD;
        aluopselect = `MEM_READ;
        #10;
        $display("LOADWORD: %h -> %h", aluin2, alu_out[31:0]);

        // End simulation
        $finish;
    end

endmodule

