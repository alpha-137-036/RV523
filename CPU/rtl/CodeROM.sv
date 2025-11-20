module code_rom(
    input logic [`PCWIDTH-1:2] addr,
    
    output logic [31:2] rdata
);
    logic [31:0] code[0:1023];
    
    initial begin
        $readmemh("code.hex", code);
        $display("code[0] = %X", code[0]); 
    end
    
    always_comb begin
        logic [31:0] rdata_full;
        rdata_full = code[{addr[9:2]}];
        rdata = rdata_full[31:2];
    end
endmodule