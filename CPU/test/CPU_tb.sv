
`timescale 1ns/1ns

`define CODE_ADDR_BITS 16 // 64KB of CODE

module code_rom(
    input logic [31:2] addr,
    
    output logic [31:0] rdata
);
    logic [31:0] code[0:(1 << (`CODE_ADDR_BITS-2))-1];
    
    initial begin    
        string hexfilename;
        if ($value$plusargs("CODEHEX=%s", hexfilename)) begin
            $display("Loading code memory from %s", hexfilename);
            $readmemh(hexfilename, code);
        end else begin
            $display("No CODEHEX plusarg provided");
            $stop;
        end
    end
    
    always @(*) begin
        rdata = code[addr];
    end
endmodule

`define RAM_ADDR_BITS 16 // 64KB of RAM

module ram(
    input  logic        clk,
    input  logic [`RAM_ADDR_BITS-1:2] d_addr,
    output tri   [31:0] d_rdata,
    input  logic [31:0] d_wdata,
    input  logic        d_sel,
    input  logic        d_write,
    input  logic [3:0]  d_byte_sel
);
    logic [31:0] data[0:(1 << (`RAM_ADDR_BITS-2))-1];
    
    initial begin
        integer i;
        for (i = 0; i < (1 << (`RAM_ADDR_BITS-2)); i++) begin
            data[i] = 0;
        end
    end
    
    assign d_rdata = d_sel && !d_write ? data[d_addr] : 'z;

    always @(posedge clk) begin
        if (d_sel && d_write) begin
            logic [31:0] mask;
            if (d_byte_sel[3]) begin
                data[d_addr][31:24] <= d_wdata[31:24];
            end
            if (d_byte_sel[2]) begin
                data[d_addr][23:16] <= d_wdata[23:16];
            end
            if (d_byte_sel[1]) begin
                data[d_addr][15:8] <= d_wdata[15:8];
            end
            if (d_byte_sel[0]) begin
                data[d_addr][7:0] <= d_wdata[7:0];
            end
        end
    end
endmodule


`define RODATA_ADDR_BITS 16 // 64KB of RODATA
module rodata(
    input  logic        clk,
    input  logic [`RODATA_ADDR_BITS-1:2] addr,
    output tri [31:0] rdata,
    input  logic        sel,
    input  logic        write
);
    logic [31:0] rodata[0:(1 << (`RODATA_ADDR_BITS-2))-1];

    initial begin
        string hexfilename;
        if ($value$plusargs("RODATAHEX=%s", hexfilename)) begin
            $display("Loading rodata memory from %s", hexfilename);
            $readmemh(hexfilename, rodata);
        end else begin
            $display("No RODATAHEX plusarg provided");
            $stop;
        end
    end

    assign rdata = sel && !write ? rodata[addr] : 'z;
endmodule


module out(
    input  logic        clk,
    input  logic [11:2] addr,
    output tri   [31:0] rdata,
    input  logic [31:0] wdata,
    input  logic        sel,
    input  logic        write,
    input  logic [3:0]  byte_sel
);
    integer outFD;
    initial begin
        string outfilename;
        if ($value$plusargs("OUTFILE=%s", outfilename)) begin
            $display("Writing output to %s", outfilename);
            outFD = $fopen(outfilename, "w");
        end else begin
            outFD = 0;
        end
    end
    always @(posedge(clk)) begin
        if (sel && {addr,2'b00} == 12'h000 && byte_sel[0]) begin
            // Write to output byte
            $display("[OUT] %X(%c)", wdata[7:0], wdata[7:0]);
            if (outFD != 0) begin
                $fwrite(outFD, "%c", wdata[7:0]);
            end
        end
    end    

endmodule

module CPU_tb();

    logic clk;
    logic rst_n;
    logic [31:0] c_addr;
    logic [31:0] c_rdata;
    logic [31:2] d_addr;
    tri   [31:0] d_rdata;
    logic [31:0] d_wdata;
    logic        d_sel;
    logic        d_write;
    logic [3:0]  d_byte_sel;

    logic        ram_sel;
    logic        out_sel;

    initial begin
        clk = 1;
        rst_n = 0;
        #4200
        rst_n = 1;
        // #5000
        // rst_n = 0;
    end
    
    always begin
       #500
       clk = ~clk;
    end
    
    initial begin 
        $dumpfile("CPU_tb.vcd");
        $dumpvars(0, CPU_tb);
    end
    
    always @(posedge clk) begin
        if ($time >= 10000000) begin
            $display("***** TIMEOUT");
            $stop;
        end
    end
    
    always @(posedge rst_n) begin
        $display("rst_n -> 1");
    end 
    always @(negedge rst_n) begin
        $display("rst_n -> 0");
    end 

    CPU u_cpu(
        .clk(clk),
        .rst_n(rst_n),
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .d_addr(d_addr),
        .d_sel(d_sel),
        .d_byte_sel(d_byte_sel),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );
    
    code_rom u_code(
        .addr(c_addr[31:2]),
        .rdata(c_rdata)
    );
    
    assign out_sel = d_sel && d_addr[31:12] == 20'h40000; 
    
    out u_out(
        .clk(clk),
        .addr(d_addr[11:2]),
        .sel(out_sel),
        .write(d_write),
        .byte_sel(d_byte_sel),
        .rdata(d_rdata),
        .wdata(d_wdata)        
    );

    assign ram_sel = d_sel && d_addr[31:20] == 12'h200; 

    ram u_ram(
        .clk(clk),
        .d_addr(d_addr[`RAM_ADDR_BITS-1:2]),
        .d_sel(ram_sel),
        .d_write(d_write),
        .d_byte_sel(d_byte_sel),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );

    assign rodata_sel = d_sel && d_addr[31:20] == 12'h100;
    rodata u_rodata(
        .clk(clk),
        .addr(d_addr[`RODATA_ADDR_BITS-1:2]),
        .sel(rodata_sel),
        .write(d_write),
        .rdata(d_rdata)
    );

endmodule