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