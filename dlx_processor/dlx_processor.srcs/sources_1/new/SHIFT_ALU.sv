`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 02:43:04
// Design Name: 
// Module Name: shift_alu
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
`define SHLEFTLOG  3'b000
`define SHLEFTART  3'b001
`define SHRGHTLOG  3'b010
`define SHRGHTART  3'b011

module SHIFT_ALU (
    input  logic        clock,       // Clock signal
    input  logic        reset,       // Clock signal
    input  logic [31:0] in,        // Input data
    input  logic [4:0]  shift,     // Shift amount (5-bit for 32-bit shift)
    input  logic [3:0]  shift_operation, // Shift operation select
    input  logic        enable,    // Enable signal
    output logic [32:0] alout      // Output data
);

logic [31:0] shift_result;   // Intermediate result
logic carry;   

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        shift_result = 32'b0;
        carry        = 1'b0;
    end
    else if (enable) begin
        case (shift_operation)
            `SHLEFTLOG: begin
                shift_result = in << shift;    // Logical left shift
                carry = 1'b0;           // No carry
            end
            `SHLEFTART: begin
                shift_result = in << shift;    // Arithmetic left shift
                // Set carry only for negative numbers
                carry = (in[31] == 1) ? 1'b1 : 1'b0;  
            end
            `SHRGHTLOG: begin
                shift_result = in >> shift;    // Logical right shift
                carry = 1'b0;           // No carry
            end
            `SHRGHTART: begin
                shift_result = $signed(in) >>> shift;  // Arithmetic right shift (sign-extended)
                carry = 1'b0;                   // No carry
            end
            default: begin
                shift_result = shift_result;   // Hold value
                carry = carry;          // Hold carry
            end
        endcase
    end
end

assign alout = {carry, shift_result};
 
endmodule