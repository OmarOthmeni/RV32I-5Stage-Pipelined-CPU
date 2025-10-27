# RV32I-A7 — My First Pipelined RISC-V CPU Core

![Project badge](https://img.shields.io/badge/status-active-brightgreen)  
A synthesizable 32-bit RV32I CPU core implementing a classic 5-stage pipeline (IF, ID, EX, MEM, WB) with hazard detection and forwarding. Target FPGA: **Digilent Nexys A7-100T (Xilinx Artix-7)**.

## 🚀 Executive Summary
This is an educational, practical implementation of a RISC-V RV32I core aimed at demonstrating:
- 5-stage pipeline (IF, ID, EX, MEM, WB)
- Hazard Detection Unit (load-use stalling)
- Forwarding / Bypassing from EX/MEM and MEM/WB to EX
- Branch resolution in EX and pipeline flush on mispredict
- Runs small RV32I test programs 

## Repository layout
├── src/
│ ├── cpu_core.v # Top-level pipeline instantiation (top module)
│ ├── modules/ # ALU, register_file.v, imem.v, dmem.v, control unit
│ └── pipeline_logic/ # forwarding.v, hazard_detection.v, pipeline_regs.v
├── asm_tests/
│ ├── sample_fibonacci.s # RISC-V assembly test
│ └── mem_init.hex # Hex init for IMEM (word-per-line 32-bit LE)
├── constraints/
│ └── nexys_a7_rv32i.xdc # Pin and clock constraints for Digilent Nexys A7
├── testbench/
│ └── cpu_tb.v # Icarus/Verilog/VVP functional testbench
├── tools/
│ └── bin2hex.py # Small helper to convert ELF/bin -> mem_init.hex
├── Makefile # Convenience targets for sim/asm/synth
└── README.md