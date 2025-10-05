module comparator
#(
	parameter N = 8
)
(
    input  [N-1:0]A,
    input  [N-1:0]B,
    input         U,
    output logic  EQ,
    output logic  LT
);
    always_comb begin
        EQ = A == B;
        if (U) begin
            LT = A < B;
        end else begin
            LT = $signed(A) < $signed(B);
        end
    end

endmodule