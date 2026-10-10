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

module ARITH_ALU (
    input  logic         clock,
    input  logic         reset,
    input  logic [31:0]  aluin1,
    input  logic [31:0]  aluin2,
    input  logic [2:0]   aluoperation,
    input  logic [2:0]   aluopselect,           // MEM_READ or ARITH_LOGIC
    input  logic         enable,
    output logic [32:0]  alu_out
);

logic [31:0] aluout;     // 32-bit ALU result
logic carry;             

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        alu_out = 33'b0;
    end 
    else if (enable) begin
        carry = 1'b0;   // Default carry = 0 for all operations unless specified

        case (aluopselect)
            `ARITH_LOGIC: begin
                case (aluoperation)
                    `ADD: begin
                        {carry, aluout} = $signed(aluin1) + $signed(aluin2);
                    end                   
                    `HADD: begin
                        logic [31:0] h_add;
                        logic h_carry;
                        {h_carry, h_add[15:0]} = aluin1[15:0] + aluin2[15:0];
                        aluout = {{16{h_add[15]}}, h_add[15:0]};
                        carry = h_carry;
                    end
                    `SUB: begin
                        {carry, aluout} = $signed(aluin1) - $signed(aluin2);
                    end
                    `NOT: begin
                        aluout = ~aluin2;
                    end
                    `AND: begin
                        aluout = aluin1 & aluin2;
                    end
                    `OR: begin
                        aluout = aluin1 | aluin2;
                    end
                    `XOR: begin
                        aluout = aluin1 ^ aluin2;
                    end
                    `LHG: begin
                        aluout = {aluin2[15:0], 16'b0};  
                    end
                endcase
            end

            // MEMORY READ OPERATIONS
            `MEM_READ: begin
                case (aluoperation)  // Use aluoperation here, not aluopselect
                    `LOADBYTE:    aluout = {{24{aluin2[7]}}, aluin2[7:0]};    // Sign extend
                    `LOADBYTEU:   aluout = {24'b0, aluin2[7:0]};              // Zero extend
                    `LOADHALF:    aluout = {{16{aluin2[15]}}, aluin2[15:0]};  // Sign extend
                    `LOADHALFU:   aluout = {16'b0, aluin2[15:0]};             // Zero extend
                    `LOADWORD:    aluout = aluin2;
                    default:      aluout = aluin2;  
                endcase
            end

            default: begin
                aluout = 32'b0;
            end
        endcase


        alu_out = {carry, aluout};
    end
end

endmodule