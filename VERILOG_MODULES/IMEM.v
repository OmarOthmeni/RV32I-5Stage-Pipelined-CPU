//////////////////////////////////////////////////////////////////////////////////
// Module:           IMEM (Instruction Memory)
// Architecture:     RISC-V 32I (RV32I)
// Description:      Implements the Read-Only Memory (ROM) used to store the 
//                   program's instruction code. It is the first stage of the 
//                   instruction fetch cycle.
// Author:           Omar Othmeni
// Creation Date:    28/10/2025
//////////////////////////////////////////////////////////////////////////////////

// --- Key IMEM Characteristics ---
// 1. ROM IMPLEMENTATION: Modeled as a combinatorial memory (read-only) for speed. 
//    It does not require clock (clk) or write enable (write) inputs.
// 2. INITIALIZATION: The program code is loaded from a file (mem_init.hex) 
//    using $readmemh during simulation startup.
// 3. ADDRESSING:    The IMEM is word-addressed (32-bit words). It uses the PC's 
//    byte address, but discards the two least significant bits (addr[1:0]) 
//    to calculate the word index.

// --- Interface Ports ---
// [INPUT] addr[31:0]:      The byte address supplied by the Program Counter (PC).
// [OUTPUT] instruction[31:0]: The 32-bit instruction word read from memory.

// --- Internal Logic ---
// - IMEM Array: A 1024-entry array of 32-bit words.
// - Word Index: IMEM[addr[11:2]] ensures the address is correctly scaled for word access.
// - $readmemh: Used to initialize the IMEM array from the program file (mem_init.hex).
//////////////////////////////////////////////////////////////////////////////////
module IMEM(
      input [31:0] addr,
      output  [31:0] instruction
);
//declaring memory 
reg [31:0] IMEM [0:1023];
// Initialize IMEM from a file (Crucial for Verilog ROM)
initial begin
    $readmemh("mem_init.hex", IMEM); 
end
assign instruction=IMEM[addr[11:2]];

endmodule