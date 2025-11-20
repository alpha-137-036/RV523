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