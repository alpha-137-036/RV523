
module CPU(
    input logic clk,
    input logic rst_n,
    
    // ROM interface
    output logic [31:0] c_addr,
    input  logic [31:0] c_rdata
);
    logic [31:0] id_pc;
    logic [31:0] id_npc;
    logic [31:0] id_instr;
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
