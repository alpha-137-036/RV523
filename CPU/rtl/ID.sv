/** Decoder of immediate values */
module ImmediateDecoder(
    input logic[31:0] instr  
);

endmodule


module ID(
    input logic clk,
    input logic rst_n,

    // Inputs from IF stage
    input logic [31:0] id_instr,
    input logic [31:0] id_pc,
    input logic [31:0] id_npc 
);

    // TRACING
    always @(posedge clk) begin
        $strobe("%.6f : [ID] id_pc=%X, id_npc=%X, id_instr=%X", $realtime, id_pc, id_npc, id_instr);
    end

endmodule
