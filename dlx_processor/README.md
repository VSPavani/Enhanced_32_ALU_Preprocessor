# Enhanced 32-Bit ALU and DLX-Style Execution Pipeline

This project implements a 32-bit DLX-inspired arithmetic and logic unit with an execution preprocessor and a two-stage pipeline. It is designed for RTL simulation in Xilinx Vivado and focuses on datapath operations used in a simplified processor execution stage.

## Project Overview

The design contains:

- A 32-bit ALU core
- An arithmetic/logic unit for ALU operations and memory-load behavior
- A shift ALU for logical and arithmetic shifting
- An execution preprocessor that decodes control fields and prepares operand values
- A two-stage pipeline wrapper combining the preprocessor and ALU stages

## Included Modules

### ALU
- Main top-level ALU module
- Combines arithmetic and shift operations
- Supports enable signals for arithmetic and shift execution
- Produces 32-bit output and carry flag

### ARITH_ALU
- Performs arithmetic and logic operations:
  - ADD
  - HALF-ADD
  - SUB
  - NOT
  - AND
  - OR
  - XOR
  - Load-halfword generic operation
- Also supports memory read/load operations:
  - LOADBYTE
  - LOADBYTEU
  - LOADHALF
  - LOADHALFU
  - LOADWORD

### SHIFT_ALU
- Performs:
  - logical left shift
  - arithmetic left shift
  - logical right shift
  - arithmetic right shift

### execute_preprocessor
- Decodes execution-stage control signals
- Selects source operands and immediate values
- Enables arithmetic or shift execution based on operation type
- Generates memory write enable and data output for stores

### two_stage_pipeline
- Connects the execution preprocessor and ALU in a two-stage pipeline structure
- Provides interface signals for testing and simulation

## Source Structure

- `dlx_processor.srcs/sources_1/new/ALU.sv`
- `dlx_processor.srcs/sources_1/new/ARITH_ALU.sv`
- `dlx_processor.srcs/sources_1/new/SHIFT_ALU.sv`
- `dlx_processor.srcs/sources_1/new/execute_preprocessor.sv`
- `dlx_processor.srcs/sources_1/new/two_stage_pipeline.sv`

## Testbenches

The project includes simulation testbenches for validation:

- `dlx_processor.srcs/sim_1/new/alu_tb.sv`
- `dlx_processor.srcs/sim_1/new/arith_alu_tb.sv`
- `dlx_processor.srcs/sim_1/new/two_stage_pipeline_tb.sv`

These testbenches exercise:

- arithmetic operations
- logical operations
- memory-load behavior
- shift operations
- pipeline execution flow

## Typical Workflow in Vivado

1. Open the project file `dlx_processor.xpr` in Vivado.
2. Add the `.sv` source files if they are not already included.
3. Set the top module for simulation as needed.
4. Run behavioral simulation.
5. Inspect waveforms and `$display` messages from the testbenches.

## Notes

- This repository includes generated Vivado project artifacts in the `dlx_processor.cache`, `dlx_processor.sim`, and `dlx_processor.ip_user_files` directories.
- For a cleaner Git history, these generated files can be excluded in a future `.gitignore` update.

## License

This project is provided for academic and learning purposes.
