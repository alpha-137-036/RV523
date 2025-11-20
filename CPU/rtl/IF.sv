
module IF(
    input logic                 clk,
    input logic                 rst_n,

    // Input from control/hazard unit
    input logic                 branch,

    // ROM interface
    output logic [`PCWIDTH-1:2] c_addr,
    input  logic [31:2]         c_rdata,
    
    // input from MEM stage
    input logic [`PCWIDTH-1:2]  branch_target,

    // output to ID stage (registered)
    output logic [31:2]         id_instr,
    output logic [`PCWIDTH-1:2] id_pc,
    output logic [`PCWIDTH-1:2] id_npc 
);    
    logic [31:2]                if_instr;
    logic [`PCWIDTH-1:2]        if_pc;
    logic [`PCWIDTH-1:2]        if_npc;    
    
    always_comb begin 
        if_npc = if_pc + 1;
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            if_pc <= '0;
        end else begin
            if_pc <= branch ? branch_target : if_npc;
        end
    end

    // Fetch from ROM 
    assign c_addr   = if_pc[`PCWIDTH:2];
    assign if_instr = c_rdata;

    // flip-flops to ID stage
    always @(posedge clk) begin
        id_instr <= if_instr;
        id_pc    <= if_pc;
        id_npc   <= if_npc;
    end

    // TRACING
    always @(posedge clk) begin
        logic[`PCWIDTH-1:0] if_pc_full;
        logic[31:0] if_instr_full;
        if_pc_full = {if_pc, 2'b00};
        if_instr_full = {if_instr, 2'b11};
        $strobe("%.6f : [IF] pc=%X, instr=%X", $realtime, if_pc_full, if_instr_full);
    end
endmodule
