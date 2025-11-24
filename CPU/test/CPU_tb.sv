
`timescale 1ns/1ns

module code_rom(
    input logic [31:2] addr,
    
    output logic [31:0] rdata
);
    logic [31:0] code[0:1023];
    
    initial begin
        $readmemh("code.hex", code);
    end
    
    always_comb begin
        rdata = code[addr];
    end
endmodule

module ram(
    input  logic [31:0] d_addr,
    output logic [31:0] d_rdata,
    input  logic [31:0] d_wdata,
    input  logic        d_read,
    input  logic        d_write
);
    logic [31:0] data[0:1023];
    
    initial begin
        integer i;
        for (i = 0; i < 1024; i++) begin
            data[i] = 0;
        end
    end
    
    always_comb begin
        if (d_read) begin
            d_rdata = data[d_addr - 32'h20000000];
        end
        if (d_write) begin
            data[d_addr - 32'h20000000] = d_wdata;
        end
    end
endmodule

module CPU_tb();

    logic clk;
    logic rst_n;
    logic [31:0] c_addr;
    logic [31:0] c_rdata;
    logic [31:0] d_addr;
    logic [31:0] d_rdata;
    logic [31:0] d_wdata;
    logic        d_read;
    logic        d_write;
    
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
        if ($time >= 3000000) begin
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
    
    code_rom u_code(
        .addr(c_addr[31:2]),
        .rdata(c_rdata)
    );
    
    ram u_ram(
        .d_addr(d_addr),
        .d_read(d_read),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );

    CPU u_cpu(
        .clk(clk),
        .rst_n(rst_n),
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .d_addr(d_addr),
        .d_read(d_read),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );
endmodule