
module ID(
    input logic clk,
    input logic rst_n,

    // Inputs from IF stage
    input logic [31:2]         id_instr,
    input logic [`PCWIDTH-1:2] id_pc,
    input logic [`PCWIDTH-1:2] id_npc 
);

    // TRACING
    always @(posedge clk) begin
        logic[`PCWIDTH-1:0] id_pc_full;
        logic[31:0] id_instr_full;
        id_pc_full = {id_pc, 2'b00};
        id_instr_full = {id_instr, 2'b11};
        $strobe("%.6f : [ID] pc=%X, instr=%X", $realtime, id_pc_full, id_instr_full);
    end

endmodule
