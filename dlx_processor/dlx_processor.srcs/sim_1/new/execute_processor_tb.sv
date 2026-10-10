`timescale 1ns / 1ps

module execute_processor_tb;

    // Inputs
    logic clock;
    logic reset;
    logic enable_ex;
    logic [31:0] src1;
    logic [31:0] src2;
    logic [31:0] imm;
    logic [6:0] control_in;
    logic [31:0] mem_data_read_in;

    // Outputs
    logic mem_data_wr_en;
    logic [31:0] mem_data_write_out;
    logic [31:0] aluin1;
    logic [31:0] aluin2;
    logic [2:0] operation_out;
    logic [2:0] opselect_out;
    logic [4:0] shift_number;
    logic enable_arith;
    logic enable_shift;

    // Instantiate the Unit Under Test (UUT)
    execute_preprocessor uut (
        .clock(clock),
        .reset(reset),
        .enable_ex(enable_ex),
        .src1(src1),
        .src2(src2),
        .imm(imm),
        .control_in(control_in),
        .mem_data_read_in(mem_data_read_in),
        .mem_data_wr_en(mem_data_wr_en),
        .mem_data_write_out(mem_data_write_out),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .operation_out(operation_out),
        .opselect_out(opselect_out),
        .shift_number(shift_number),
        .enable_arith(enable_arith),
        .enable_shift(enable_shift)
    );

    // Clock generation
    always #5 clock = ~clock;

    // Test sequence
    initial begin
        $monitor("Time=%0t | enable_ex=%b | src1=%h | src2=%h | imm=%h | control_in=%b | aluin1=%h | aluin2=%h | operation_out=%b | enable_arith=%b | enable_shift=%b", 
                 $time, enable_ex, src1, src2, imm, control_in, aluin1, aluin2, operation_out, enable_arith, enable_shift);
        
        // Initialize inputs
        clock = 0;
        reset = 1;
        enable_ex = 0;
        src1 = 32'h00000010;
        src2 = 32'h00000020;
        imm = 32'h00000005;
        control_in = 7'b0000000;
        mem_data_read_in = 32'h00000030;
        #10;

        // Release reset
        reset = 0;

        // Test case 1: Arithmetic operation with immediate
        enable_ex = 1;
        control_in = 7'b0010001;  // Arithmetic with immediate
        #20;
        
        // Test case 2: Memory Read
        src1 = 32'h00000011;
        control_in = 7'b1010000;  // Memory read
        #10;
        
        // Test case 3: Memory Write
        control_in = 7'b1001000;  // Memory write
        #10;

        // Test case 4: Shift operation
        control_in = 7'b0000100;  // Shift operation
        imm = 32'h0000001F;  // Shift amount
        #10;

        // Test case 5: Disable execution
        enable_ex = 0;
        #10;

        // Finish simulation
        $stop;
    end

endmodule