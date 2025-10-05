// Elementary D-LATCH with complementary CLK enable inputs
module D_LATCH(
    output Q,
    output nQ,
    input D,
    input CLK,
    input nCLK
);
    always_latch begin
        if (CLK && !nCLK) begin
            Q = D;
        end
    end
endmodule