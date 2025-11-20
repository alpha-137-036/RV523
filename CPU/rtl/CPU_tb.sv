
`timescale 1ns/1ns

module CPU_tb();

    logic clk;
    logic rst_n;
    logic [`PCWIDTH-1:0]c_addr;
    logic [31:0]c_rdata;
    
    assign c_addr[1:0] = 2'b00;
    assign c_rdata[1:0] = 2'b11;
    
    initial begin
        clk = 1;
        rst_n = 0;
        #3200
        rst_n = 1;
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
        if ($time >= 100000) begin
            $stop;
        end
    end
    
    code_rom u_code(
        .addr(c_addr[`PCWIDTH-1:2]),
        .rdata(c_rdata[31:2])
    );

    CPU u_cpu(
        .clk(clk),
        .rst_n(rst_n),
        .c_addr(c_addr[`PCWIDTH-1:2]),
        .c_rdata(c_rdata[31:2])
    );
endmodule