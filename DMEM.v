//////////////////////////////////////////////////////////////////////////////////
// Module:           DMEM (Data Memory)
// Architecture:     RISC-V 32I (RV32I)
// Description:      Implementation of the data memory for the RISC-V CPU.
//                   Handles memory accesses for LOAD and STORE instructions.
// Author:           Omar Othmeni
// Creation Date:    28/10/2025
//////////////////////////////////////////////////////////////////////////////////

// --- Key Memory Characteristics ---
// 1. ADDRESSING:    Uses byte-addressing, but is stored internally as an array
//                   of words (32-bit words).
// 2. ENDIANNESS:    Implements the Little-Endian format for byte (SB) and halfword (SH) 
//                   accesses, requiring Read-Modify-Write (RMW) logic.
// 3. SYNCHRONICITY: 
//    - Write (Store): Synchronous, occurs on the clock's rising edge (posedge clk).
//    - Read (Load):   Combinational (instantaneous) to minimize latency in the MEM phase.

// --- Interface Ports ---
// [INPUT] write:         Write enable signal (MemWrite).
// [INPUT] clk:           System clock for synchronous writing.
// [INPUT] addr[31:0]:    Target byte memory address.
// [INPUT] data_in[31:0]: Data to be written (for STORE instructions).
// [INPUT] data_size[2:0]:Access size (0=Byte, 1=Halfword, 2=Word).
// [INPUT] unsigned_load: Signal to distinguish extension (0=Signed, 1=Zero) for LOADs.
// [OUTPUT] data_out[31:0]: Data read (for LOAD instructions).

// --- Internal Addressing Logic ---
// - word_addr: word_addr = addr[11:2] -> Word index in the array (division by 4).
// - byte_addr: byte_addr = addr[1:0]   -> Byte/halfword offset within the word.
// - shamt:     shamt = byte_addr * 8   -> Shift amount for Little-Endian alignment.
//////////////////////////////////////////////////////////////////////////////////

module DMEM (
      input write,
      input clk,
      input unsigned_load,//insigned load input
      input [31:0] addr,
      input [31:0] data_in,
      input [2:0]  data_size,
      output reg [31:0] data_out
);

//declaring memory 
reg [31:0] DMEM [0:1023];

// Word index (10 bits for 1024 words)
wire [9:0] word_addr= addr[11:2]; 
// Byte offset within the word (0, 1, 2, or 3)
wire [1:0] byte_addr= addr[1:0];
// Shift Amount (0, 8, 16, or 24)
wire [4:0] shamt = {byte_addr, 3'b000};

 // read entire word from memory
 reg [31:0] read_data;
 // extracted data and shifted right
reg [31:0] extracted_data;
    
// --- SYNCHRONOUS WRITE BLOCK ---
always @(posedge clk) begin
    if (write) begin 
        case (data_size)
            // Store Byte (SB): R-M-W logic
            3'b000: DMEM[word_addr] <= (DMEM[word_addr] & ~ (32'hFF << shamt)) | ({{24{1'b0}}, data_in[7:0]} << shamt);

            // Store Halfword (SH): R-M-W logic 
            3'b001: DMEM[word_addr] <= 
                (DMEM[word_addr] & ~ (32'hFFFF << shamt)) | ({{16{1'b0}}, data_in[15:0]} << shamt); 
                
            // Store Word (SW): Direct 32-bit assignment (Assuming alignment check is done elsewhere)
            3'b010: DMEM[word_addr] <= data_in;
            
            // Default: Do nothing (no write operation for unknown size)
            default: ; 
        endcase
    end
end

// --- COMBINATIONAL READ BLOCK ---
always @(*) begin

    read_data = DMEM[word_addr];

    // extraction and extension depends on data_size
    case (data_size)
        // Load Byte (LB / LBU)
        3'b000: begin
            //  Extraction : shift and mask
            extracted_data = (read_data >> shamt) & 32'hFF; 
            
            //  Extension: sign-extenstion or zero-extension
            if (unsigned_load) begin 
                data_out = extracted_data; 
            end else begin               
                data_out = {{24{extracted_data[7]}}, extracted_data[7:0]}; 
            end
        end

        // Load Halfword (LH / LHU)
        3'b001: begin
            //  Extraction : shift and mask
            extracted_data = (read_data >> shamt) & 32'hFFFF;
            
            //  Extension: sign-extenstion or zero-extension
            if (unsigned_load) begin 
                data_out = extracted_data;
            end else begin              
                data_out = {{16{extracted_data[15]}}, extracted_data[15:0]};
            end
        end

        // Load Word (LW / Default)
        3'b010: begin
            data_out = read_data;
        end
        
        default: ;
    endcase
end
endmodule