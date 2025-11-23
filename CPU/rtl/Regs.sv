module Regs(
    input clk,
    
    input logic [4:0] rs1_idx,
    input logic [4:0] rs2_idx,
    input logic [4:0] rd_idx,
    
    input logic [31:0] rd,
    
    output logic [31:0] rs1,
    output logic [31:0] rs2
);
    logic [31:0] x[1:31];
    
    always @(*) begin
        if (rs1_idx == 5'b0) begin
            rs1 = 32'b0;
        end else if (rs1_idx == rd_idx) begin
            // Write-before-read !
            rs1 = rd;
        end else begin
            rs1 = x[rs1_idx];
        end
        if (rs2_idx == 5'b0) begin
            rs2 = 32'b0;
        end else if (rs2_idx == rd_idx) begin
            // Write-before-read !
            rs2 = rd;
        end else begin
            rs2 = x[rs2_idx];
        end
    end
    
    always @(posedge(clk)) begin
        if (rd_idx != 5'b0) begin
            x[rd_idx] <= rd;
        end
    end

endmodule