module IF(
    input logic         clk,
    input logic         rst_n,

    // ROM interface
    output logic [31:0] c_addr,
    input  logic [31:0] c_rdata,
    output logic        c_stb,
    input  logic        c_ack,
    input  logic        c_stall,

    // output to ID stage (registered)
    output logic [31:0] id_instr,
    output logic [31:0] id_pc,
    output logic [31:0] id_npc,
    output logic        id_bubble,

    // input from ID stage
    input  logic        id_stall,

    // input from EX stage: TODO: rename with ex_ prefix
    input  logic [31:0] if_branch_target,
    input  logic        if_take_branch
);

    logic [31:0]        if_pc;
    wire  [31:0]        if_pc4;
    logic [3:0]         state;
    wire  [3:0]         next_state;
    wire                if_instr_valid;
    wire  [1:0]         next_pc;
    wire  [1:0]         next_request;
    logic [1:0]         c_request;
    
    wire  [31:0]        if_npc;
    
    assign if_pc4 = if_pc + 4;

    IF_transitions u_transitions(
        .state(state),
        .c_ack(c_ack),
        .c_stall(c_stall),
        .id_stall(id_stall),
        .ex_take_branch(if_take_branch),
        
        .if_instr_valid(if_instr_valid),
        .next_state(next_state),
        .next_pc(next_pc),
        .next_request(next_request)
    );
    
    assign if_npc = 
        next_pc == `NEXT_PC_PC ? if_pc :
        next_pc == `NEXT_PC_PC_PLUS_4 ? if_pc4 :
        next_pc == `NEXT_PC_BTA ? if_branch_target :
        'X;
        
    assign c_stb = c_request[0];
    // Not great: add delay of adder and mux to the memory access...
    // Alternative is to add 32 latches :(
    assign c_addr = c_request[1] ? if_pc4 : if_pc;
        
    // flip-flops to ID stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_pc <= 0;
            state <= 0;
            c_request <= `REQUEST_NONE;
            id_bubble <= 1;
        end else begin
            state <= next_state;
            if_pc <= if_npc;
            c_request <= next_request;
            if (!id_stall) begin
                id_bubble <= !if_instr_valid;
                id_instr <= c_rdata;
                id_pc <= if_pc;
                id_npc <= if_pc4;
            end
        end
    end

`ifdef TRACING
    // TRACING
    always @(posedge clk) begin
        disassemble("IF", if_pc, c_rdata, !if_instr_valid);
        if (if_take_branch) begin
            $display("[ IF]     branch to %X", if_branch_target);
        end
    end
`endif
endmodule
