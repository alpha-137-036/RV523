
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
    input  logic [31:0] d_addr,
    output logic [31:0] d_rdata,
    input  logic [31:0] d_wdata,
    input  logic        d_read,
    input  logic        d_write,
    input  logic [1:0]  d_size
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
            casex({d_size,d_addr[1:0]})
            4'b10xx:
                // Full word access (ignore low 2 address bits)
                d_rdata = data[d_addr[11:2]];
            4'b010x:
                // low half-word
                d_rdata = {16'bX, data[d_addr[11:2]][15:0]};
            4'b011x:
                // high half-word
                d_rdata = {16'bX, data[d_addr[11:2]][31:16]};
            4'b0000:
                // first byte
                d_rdata = {24'bX, data[d_addr[11:2]][7:0]};
            4'b0001:
                // second byte
                d_rdata = {24'bX, data[d_addr[11:2]][15:8]};
            4'b0010:
                // third byte
                d_rdata = {24'bX, data[d_addr[11:2]][23:16]};
            4'b0011:
                // fourth byte
                d_rdata = {24'bX, data[d_addr[11:2]][31:24]};
            endcase
        end
    end
    always @(posedge clk) begin
        if (d_write) begin
            casex({d_size,d_addr[1:0]})
            4'b10xx:
                // Full word access (ignore low 2 address bits)
                data[d_addr[11:2]] <= d_wdata;
            4'b010x:
                // low half-word
                data[d_addr[11:2]][15:0] <= d_wdata[15:0];
            4'b011x:
                // high half-word
                data[d_addr[11:2]][31:16] <= d_wdata[15:0];
            4'b0000:
                // first byte
                data[d_addr[11:2]][7:0] <= d_wdata[7:0];
            4'b0001:
                // second byte
                data[d_addr[11:2]][15:8] <= d_wdata[7:0];
            4'b0010:
                // third byte
                data[d_addr[11:2]][23:16] <= d_wdata[7:0];
            4'b0011:
                // fourth byte
                data[d_addr[11:2]][31:24] <= d_wdata[7:0];
            endcase
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
    logic [1:0]  d_size;

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
        .clk(clk),
        .d_addr(d_addr),
        .d_read(d_read),
        .d_size(d_size),
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
        .d_size(d_size),
        .d_write(d_write),
        .d_rdata(d_rdata),
        .d_wdata(d_wdata)
    );
endmodule