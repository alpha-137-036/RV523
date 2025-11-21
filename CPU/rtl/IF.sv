
module IF(
    input logic         clk,
    input logic         rst_n,

    // Input from control/hazard unit
    input logic         branch,

    // ROM interface
    output logic [31:0] c_addr,
    input  logic [31:0] c_rdata,
    
    // input from MEM stage
    input logic [31:0]  branch_target,

    // output to ID stage (registered)
    output logic [31:0] id_instr,
    output logic [31:0] id_pc,
    output logic [31:0] id_npc 
);    
    logic [31:0]        if_instr;
    logic [31:0]        if_pc;
    logic [31:0]        if_npc;    
    
    always_comb begin 
        if_npc = if_pc + 4;
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            if_pc <= '0;
        end else begin
            if_pc <= branch ? branch_target : if_npc;
        end
    end

    // Fetch from ROM 
    assign c_addr   = if_pc;
    assign if_instr = c_rdata;

    // flip-flops to ID stage
    always @(posedge clk) begin
        id_instr <= if_instr;
        id_pc    <= if_pc;
        id_npc   <= if_npc;
    end
    
    // TRACING
    always @(posedge clk) begin
        $display("%.6f : [IF] if_pc=%X, if_npc=%X, if_instr=%X", $realtime, if_pc, if_npc, if_instr);
    end
endmodule
