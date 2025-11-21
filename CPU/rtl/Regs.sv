module Regs(
    input clk,
    
    input logic [4:0] rs1_idx,
    input logic [4:0] rs2_idx,
    input logic [4:0] rd_idx,
    
    input logic [31:0] rd,
    input logic write,
    
    output logic [31:0] rs1,
    output logic [31:0] rs2
);
    logic [31:0] x[1:31];
    
    always @(*) begin
        rs1 = rs1_idx == 0 ? 0 : x[rs1_idx];
        rs2 = rs2_idx == 0 ? 0 : x[rs2_idx];
    end
    
    always @(posedge(clk)) begin
        if (write && rd_idx != 0) begin
            x[rd_idx] = rd;
        end
    end

endmodule