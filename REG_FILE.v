module REG_FILE (
      input clk ,write,
      input [4:0] raddr1,raddr2,waddr,
      input [31:0] wdata,
      output reg [31:0] rdata1,rdata2
);
REG_FILE[0]<=32'b0;

   always @(*) begin
      rdata1=(raddr1==5'b0)? 32'b0:REG_FILE[raddr1];
      rdata2=(raddr2==5'b0)? 32'b0:REG_FILE[raddr2];
      
   end   

   always @(posedge clk) begin
      if (write) begin
            if (waddr!=0) begin
               REG_FILE[waddr]<=wdata;   
            end   
      end      
   end

endmodule