//////////////////////////////////////////////////////////////////////////////////
// Module:           REG_FILE (Register File)
// Architecture:     RISC-V 32I (RV32I)
// Description:      Implements the 32 general-purpose registers (x0-x31) for the CPU.
//                   Serves as the high-speed data storage unit for instruction operands.
// Author:           Omar Othmeni
// Creation Date:    28/10/2025
//////////////////////////////////////////////////////////////////////////////////

// --- Key Register File Characteristics ---
// 1. DUAL-PORT READ: Supports reading two operands (rs1 and rs2) simultaneously 
//    in a single clock cycle to support R-Type instruction execution.
// 2. REGISTER X0:     Register x0 is hardwired to zero: writes to x0 are ignored, 
//    and reads from x0 always return 32'h0.
// 3. SYNCHRONICITY: 
//    - Write (rd):    Synchronous, occurs on the clock's rising edge (posedge clk).
//    - Read (rs1, rs2): Combinational (asynchronous) to provide operands instantly 
//    during the Decode stage.

// --- Interface Ports ---
// [INPUT] clk:      System clock for synchronous writing.
// [INPUT] rst:      Asynchronous, active-high Reset signal (for FPGA conventions).
// [INPUT] write:    Write enable signal (RegWrite).
// [INPUT] waddr[4:0]: Address of the destination register (rd).
// [INPUT] wdata[31:0]: Data to be written into rd (from ALU or Memory).
// [INPUT] raddr1[4:0]: Address of the first source register (rs1).
// [INPUT] raddr2[4:0]: Address of the second source register (rs2).
// [OUTPUT] rdata1[31:0]: Data read from rs1.
// [OUTPUT] rdata2[31:0]: Data read from rs2.

// --- Internal Logic ---
// - Internal Array: A 32-entry array of 32-bit registers.
// - x0 Handling: Implemented via conditional logic on waddr and raddrX.
//////////////////////////////////////////////////////////////////////////////////
module REG_FILE (
      input clk ,write,rst,
      input [4:0] raddr1,raddr2,waddr,
      input [31:0] wdata,
      output reg [31:0] rdata1,rdata2
);
reg [31:0] REG_FILE [31:0];
integer i ;
   always @(*) begin
      rdata1=(raddr1==5'b0)? 32'b0:REG_FILE[raddr1];
      rdata2=(raddr2==5'b0)? 32'b0:REG_FILE[raddr2];
      
   end   

   always @(posedge clk or posedge rst) begin
      if (rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            REG_FILE[i] <= 32'b0; 
        end
    end
      else if (write) begin
            if (waddr!=0) begin
               REG_FILE[waddr]<=wdata;   
            end   
      end      
   end

endmodule