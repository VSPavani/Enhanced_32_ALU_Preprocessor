`timescale 1ns / 1ps

module ALU (
    input  logic        clock,         // Clock signal
    input  logic        reset,         // Reset signal
    input  logic [31:0] aluin1,        // ALU input 1
    input  logic [31:0] aluin2,        // ALU input 2
    input  logic [2:0]  operation,     // ALU operation select (arith)
    input  logic [2:0]  opselect,      // Shift operation select
    input  logic [4:0]  shift_number,  // Shift amount
    input  logic        enable_arith,  // Enable for arith ALU
    input  logic        enable_shift,  // Enable for shift ALU
    output logic [31:0] aluout,        // 32-bit ALU result
    output logic        carry          // Carry-out flag
);


    logic [32:0] arith_out;            // 33-bit output from ARITH_ALU (carry + result)
    logic [32:0] shift_out;            // 33-bit output from SHIFT_ALU (carry + result)


    ARITH_ALU arith_inst (
        .clock(clock),
        .reset(reset),
        .aluin1(aluin1),
        .aluin2(aluin2),
        .aluoperation(operation),
        .aluopselect(opselect),         // ALU op select (hardcoded based on diagram)
        .enable(enable_arith),
        .alu_out(arith_out)
    );
    

    SHIFT_ALU shift_inst (
        .clock(clock),
        .reset(reset),
        .in(aluin1),                  // Shift uses only one input
        .shift(shift_number),
        .shift_operation(opselect),
        .enable(enable_shift),
        .alout(shift_out)
    );


    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            aluout = 32'b0;
            carry  = 1'b0;
        end
        else begin
            if (enable_arith) begin
                aluout = arith_out[31:0];  // Lower 32 bits of ARITH_ALU output
                carry  = arith_out[32];    // Carry bit is MSB
            end
            else if (enable_shift) begin
                aluout = shift_out;        // SHIFT_ALU output
                carry = 1'b0;             // No carry from SHIFT_ALU
            end
            else begin
                aluout = 32'b0;            // Default case: zero output
                carry  = 1'b0;
            end
        end
    end

endmodule