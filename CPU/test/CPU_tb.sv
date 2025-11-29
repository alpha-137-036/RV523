
`timescale 1ns/1ns

module code_rom(
    input logic [31:2] addr,
    
    output logic [31:0] rdata
);
    logic [31:0] code[0:1023];
    
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
    
    always_comb begin
        rdata = code[addr];
    end
endmodule

module ram(
    input  logic        clk,
    input  logic [31:2] d_addr,
    output logic [31:0] d_rdata,
    input  logic [31:0] d_wdata,
    input  logic        d_read,
    input  logic        d_write,
    input  logic [3:0]  d_byte_sel
);
    logic [31:0] data[0:1023];
    
    initial begin
        integer i;
        for (i = 0; i < 1024; i++) begin
            data[i] = 0;
        end
    end
    
    always @(*) begin
        if (d_read) begin
            d_rdata = data[d_addr[11:2]];
        end
    end
    always @(posedge clk) begin
        if (d_write) begin
            logic [31:0] mask;
            if (d_byte_sel[3]) begin
                data[d_addr[11:2]][31:24] <= d_wdata[31:24];
            end
            if (d_byte_sel[2]) begin
                data[d_addr[11:2]][23:16] <= d_wdata[23:16];
            end
            if (d_byte_sel[1]) begin
                data[d_addr[11:2]][15:8] <= d_wdata[15:8];
            end
            if (d_byte_sel[0]) begin
                data[d_addr[11:2]][7:0] <= d_wdata[7:0];
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
    logic [31:0] d_rdata;
    logic [31:0] d_wdata;
    logic        d_read;
    logic        d_write;
    logic [3:0]  d_byte_sel;

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

    CPU u_cpu(
        .clk(clk),
        .rst_n(rst_n),
        .c_addr(c_addr),
        .c_rdata(c_rdata),
        .d_addr(d_addr),
        .d_read(d_read),
        .d_byte_sel(d_byte_sel),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );
    
    code_rom u_code(
        .addr(c_addr[31:2]),
        .rdata(c_rdata)
    );
    
    ram u_ram(
        .clk(clk),
        .d_addr(d_addr),
        .d_read(d_read),
        .d_byte_sel(d_byte_sel),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );
endmodule