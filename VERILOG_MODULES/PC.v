//////////////////////////////////////////////////////////////////////////////////
// Module:           PC (Program Counter)
// Architecture:     RISC-V 32I (RV32I)
// Description:      Implements the 32-bit register that holds the address of 
//                   the instruction to be fetched in the current cycle.
// Author:           Omar Othmeni
// Creation Date:    28/10/2025
//////////////////////////////////////////////////////////////////////////////////

// --- Key PC Characteristics ---
// 1. STATE REGISTER: Stores the CPU's current execution state (the address).
// 2. FLOW CONTROL:  Selects the next address from three sources: PC + 4 (sequential),
//    Jump/Branch Target (New_Address), or PC_out (Stall/Hold).
// 3. SYNCHRONICITY: 
//    - Update Logic: Synchronous, occurs on the clock's rising edge (posedge clk).
//    - Reset:        Asynchronous, active-high Reset (posedge rst) for immediate startup.

// --- Interface Ports ---
// [INPUT] clk:           System clock for synchronous updates.
// [INPUT] rst:           Asynchronous, active-high Reset signal (prioritized).
// [INPUT] PCEn:          PC Write Enable signal (controls stalling in a pipeline).
// [INPUT] PCSrc:         PC Source Select (0=Sequential, 1=Jump/Branch Target).
// [INPUT] New_Address[31:0]: Target address calculated by Jump/Branch instructions.
// [OUTPUT] PC_out[31:0]:  The current instruction address (PC value).

// --- Internal Logic ---
// - PC_reg: The internal 32-bit register holding the address value.
// - Update: PC_reg is updated based on the MUX selection logic (PCSrc).
//////////////////////////////////////////////////////////////////////////////////
module PC (
    input clk,
    input rst,
    input PCEn,         
    input PCSrc,        
    input [31:0] new_address, 
    
    output reg [31:0] PC_out
);
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        PC_out <= 32'b0;
    end
    else if(PCEn) begin 
        PC_out <= PCSrc ? new_address : PC_out + 32'd4;
    end
end

endmodule