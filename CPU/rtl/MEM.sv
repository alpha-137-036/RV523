module MEM(
    input  logic clk,
    input  logic rst_n,
    
    // Inputs from EX stage
    input  logic[31:0] mem_addr,
    input  logic[31:0] mem_wdata,
    input  logic       mem_load,
    input  logic       mem_store,
    input  logic[2:0]  mem_size,
    input  logic       mem_jalr,
    input  logic       mem_jalx,
    input  logic       mem_ebreak,
    input  logic[4:0]  mem_rd_idx,
    
    // Data memory bus
    output logic[31:2] d_addr,
    output logic[31:0] d_wdata,
    input  logic[31:0] d_rdata,
    output logic       d_sel,
    output logic       d_write,
    output logic[3:0]  d_byte_sel,

    // Output to WB stage
    output logic       wb_ebreak,
    output logic       wb_load,
    output logic[1:0]  wb_addr,
    output logic[2:0]  wb_size,
    output logic[31:0] wb_mem_rdata,
    output logic[31:0] wb_wdata,
    output logic[4:0]  wb_rd_idx,

    input  logic       mem_trc_bubble,
    input  logic[31:0] mem_trc_pc,
    input  logic[31:0] mem_trc_instr,
    output logic       wb_trc_bubble,
    output logic[31:0] wb_trc_pc,
    output logic[31:0] wb_trc_instr
);
    always @(*) begin
        d_addr = mem_addr[31:2];
        d_sel = mem_load || mem_store;
        d_write = mem_store;
        
        casex ({mem_size[1:0],mem_addr[1:0]})
        4'b10xx: begin
            // word access
            d_byte_sel = 4'b1111;
            d_wdata = mem_wdata;
        end
        4'b010x: begin
            // low half-word access
            d_byte_sel = 4'b0011;
            d_wdata = {16'bx, mem_wdata[15:0]};
        end
        4'b011x: begin
            // high half-word access
            d_byte_sel = 4'b1100;
            d_wdata = {mem_wdata[15:0], 16'bx};
        end
        4'b0000: begin
            // byte 0
            d_byte_sel = 4'b0001;
            d_wdata = {24'bx, mem_wdata[7:0]};
        end
        4'b0001: begin
            // byte 1
            d_byte_sel = 4'b0010;
            d_wdata = {16'bx, mem_wdata[7:0],8'bx};
        end
        4'b0010: begin
            // byte 2
            d_byte_sel = 4'b0100;
            d_wdata = {8'bx, mem_wdata[7:0],16'bx};
        end
        4'b0011: begin
            // byte 3
            d_byte_sel = 4'b1000;
            d_wdata = {mem_wdata[7:0],24'bx};
        end
        default: begin
            d_byte_sel = 4'bxxxx;
            d_wdata = 32'bx;
        end
        endcase
    end
    
    always @(posedge(clk)) begin
        wb_ebreak       <= mem_ebreak;
        wb_load         <= mem_load;
        wb_addr         <= mem_addr[1:0];
        wb_size         <= mem_size;
        wb_mem_rdata    <= d_rdata;
        wb_wdata        <= mem_wdata;
        wb_rd_idx       <= mem_rd_idx;
        wb_trc_bubble   <= mem_trc_bubble;
        wb_trc_pc       <= mem_trc_pc;
        wb_trc_instr    <= mem_trc_instr;
    end
    
    //
    // TRACING
    // 
    always @(posedge(clk)) begin
        disassemble("MEM", mem_trc_pc, mem_trc_instr, mem_trc_bubble);
        if (mem_load) begin
            $display("[MEM]     load %X -> %X", mem_addr, d_rdata);
        end
        if (mem_store) begin
            case (mem_size[1:0])
                2'b10: $display("[MEM]     store %X -> %X", mem_wdata      , mem_addr);
                2'b01: $display("[MEM]     store %X -> %X", mem_wdata[15:0], mem_addr);
                2'b00: $display("[MEM]     store %X -> %X", mem_wdata [7:0], mem_addr);
            endcase
        end
    end
endmodule