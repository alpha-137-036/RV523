module TINV (
    output Y, 
    input  A,
    input  EN,
    input  nEN);

    always_comb begin
        if (EN && !nEN) begin
            Y <= !A;
        end
        if (EN && nEN) begin
            Y <= 'X;
        end
    end
endmodule
