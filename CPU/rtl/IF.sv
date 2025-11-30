// A bubble doesn't need to be a full NOP instruction as this requires 32 gates just to set up...
// Instead we just use the opcode xx111 (reserved) as bubble. The ID stage will interpret it
// as a harmless operation
`define INSTR_BUBBLE {25'bx,7'bxx111xx}

module IF(
    input logic         clk,
    input logic         rst_n,

    // ROM interface
    output logic [31:0] c_addr,
    input  logic [31:0] c_rdata,

    // output to ID stage (registered)
    output logic [31:0] id_instr,
    output logic [31:0] id_pc,
    output logic [31:0] id_npc,

    // input from ID stage
    input  logic        id_stall,

    // input from MEM stage
    input  logic [31:0] if_branch_target,
    input  logic        if_take_branch,
    
    // tracing
    output logic        id_trc_bubble
);    
    logic [31:0]        if_instr;
    logic [31:0]        if_pc;
    logic [31:0]        if_npc;    
    
    always_comb begin
        if (!rst_n) begin
            if_npc = 0;
        end else if (if_take_branch) begin
            if_npc = if_branch_target;
        end else if (id_stall) begin
            if_npc = if_pc;
        end else begin
            if_npc = if_pc + 4;
        end
    end
    
    // Fetch from ROM 
    assign c_addr   = if_pc;
    assign if_instr = c_rdata;

    // flip-flops to ID stage
    always @(posedge clk) begin
        if_pc <= if_npc;

        if (!rst_n || !id_stall) begin
            if (!rst_n || if_take_branch) begin
                id_instr <= `INSTR_BUBBLE;
                id_trc_bubble <= 1;
            end else begin
                id_instr <= if_instr;
                id_trc_bubble <= 0;
            end
            id_pc    <= if_pc;
            id_npc   <= if_npc;
        end
    end
    
    // TRACING
    always @(posedge clk) begin
        disassemble("IF", if_pc, if_instr, 0);
        if (if_take_branch) begin
            $display("[ IF]     branch to %X", if_branch_target);
        end
    end
endmodule
