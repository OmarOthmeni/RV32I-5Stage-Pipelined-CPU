module mux_2_1(
    input [31:0] a,b,
    input sel,
    output reg [31:0] sel_out
    
    );
    always @(*) begin
        sel_out=sel? b:a;
    end
endmodule