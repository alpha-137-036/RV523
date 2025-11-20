
module CPU(
    input logic clk,
    input logic rst_n,
    
    // ROM interface
    output logic [`PCWIDTH-1:2] c_addr,
    input  logic [31:2]         c_rdata
);
    logic [`PCWIDTH-1:2] id_pc;
    logic [`PCWIDTH-1:2] id_npc;
    logic [31:2]         id_instr;
    IF u_if(
        .clk(clk),
        .rst_n(rst_n),
        
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .branch(1'b0),
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr)
    );
    ID u_id(
        .clk(clk),
        .rst_n(rst_n),
        
        .id_pc(id_pc),
        .id_npc(id_npc),
        .id_instr(id_instr)
    );

endmodule
