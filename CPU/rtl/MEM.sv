module MEM(
    input logic clk,
    input logic rst_n,
    
    // Inputs from EX stage
    input logic[31:0] mem_alu_out,
    input logic[31:0] mem_wdata,
    input logic[31:0] mem_branch_target,
    input logic[31:0] mem_npc,
    input logic       mem_load,
    input logic       mem_store,
    input logic       mem_reg_write,
    
    // Data memory bus
    output logic[31:0] d_addr,
    output logic[31:0] d_wdata,
    input  logic[31:0] d_rdata,
    output logic       d_read,
    output logic       d_write,
    
    // Output to WB stage
    output logic[31:0] wb_reg_wdata,
    output logic       wb_reg_write
);

    logic [31:0] mem_reg_wdata;
    
    always @(*) begin
        d_addr = mem_alu_out;
        d_read = mem_load;
        d_write = mem_store;
        mem_reg_wdata = mem_load ? d_rdata : mem_alu_out; // TODO: JALR !
    end
    
    always @(posedge(clk)) begin
        wb_reg_wdata <= mem_reg_wdata;
        wb_reg_write <= mem_reg_write;
    end
    
    //
    // TRACING
    // 
    always @(posedge(clk)) begin
        $display("%.6f : [MEM] mem_npc=%X", $realtime, mem_npc);
        if (mem_load) begin
            $display("    load %X -> %X", d_addr, d_rdata); 
        end
        if (mem_store) begin
            $display("    store %X -> %X", d_wdata, d_addr);             
        end
    end
endmodule