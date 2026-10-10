`timescale 1ns / 1ps

module alu_tb;

    // Signals
    logic        clock;
    logic        reset;
    logic [31:0] aluin1;
    logic [31:0] aluin2;
    logic [2:0]  operation;
    logic [2:0]  opselect;
    logic [4:0]  shift_number;
    logic        enable_arith;
    logic        enable_shift;
    logic [31:0] aluout;
    logic        carry;

    // Instantiate the DUT
    ALU dut (
        .clock(clock),
        .reset(reset),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .operation(operation),
        .opselect(opselect),
        .shift_number(shift_number),
        .enable_arith(enable_arith),
        .enable_shift(enable_shift),
        .aluout(aluout),
        .carry(carry)
    );

    // Clock Generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;    // 10 ns period
    end

    // Reset Logic
    initial begin
        reset = 1;
        #10 reset = 0;
    end

    // Main Test Sequence
    initial begin
        $display("Starting ALU Testbench...");
        
        // Apply Reset
        reset = 1;
        #10 reset = 0;

        // Test Arithmetic Operations
        enable_arith = 1;
        enable_shift = 0;

        // ADD Operation: 15 + 10 = 25
        aluin1 = 32'd15;
        aluin2 = 32'd10;
        operation = 3'b000;           // ADD
        opselect = 3'b001;            // Arithmetic select
        #10;
        $display("ADD: %0d + %0d = %0d, Carry = %0b", aluin1, aluin2, aluout, carry);

        // SUB Operation: 30 - 45 = -15 (carry should be 0)
        aluin1 = 32'd30;
        aluin2 = 32'd45;
        operation = 3'b010;           // SUB
        #10;
        $display("SUB: %0d - %0d = %0d, Carry = %0b", aluin1, aluin2, aluout, carry);

        // AND Operation
        aluin1 = 32'hFF00FF00;
        aluin2 = 32'h0F0F0F0F;
        operation = 3'b100;           // AND
        #10;
        $display("AND: %0h & %0h = %0h", aluin1, aluin2, aluout);

        // OR Operation
        operation = 3'b101;           // OR
        #10;
        $display("OR: %0h | %0h = %0h", aluin1, aluin2, aluout);

        // XOR Operation
        operation = 3'b110;           // XOR
        #10;
        $display("XOR: %0h ^ %0h = %0h", aluin1, aluin2, aluout);

        // NOT Operation (only uses second input)
        operation = 3'b011;           // NOT
        #10;
        $display("NOT: ~%0h = %0h", aluin2, aluout);

        // Test Shift Operations
        enable_arith = 0;
        enable_shift = 1;

        // Logical Left Shift by 2
        aluin1 = 32'h00000001;
        shift_number = 5'd2;
        opselect = 3'b000;            // Logical Left Shift
        #10;
        $display("Shift Left (Logical): %0h << %0d = %0h", aluin1, shift_number, aluout);

        // Arithmetic Right Shift by 3
        shift_number = 5'd3;
        opselect = 3'b011;            // Arithmetic Right Shift
        #10;
        $display("Shift Right (Arithmetic): %0h >>> %0d = %0h", aluin1, shift_number, aluout);

        // Logical Right Shift by 4
        shift_number = 5'd4;
        opselect = 3'b010;            // Logical Right Shift
        #10;
        $display("Shift Right (Logical): %0h >> %0d = %0h", aluin1, shift_number, aluout);

        // End Simulation
        $display("Testbench complete.");
        $finish;
    end

    // Waveform Generation


endmodule
