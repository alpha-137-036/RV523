(* blackbox *)
(* footprint="RV523_Common:FPC-SMD_THD0518-80CL-GF" *)
module ConnectorFFC80(
    (* num="80:1" *)
    inout [80:1] pins
);
endmodule


module shifter1_board
(
);
    localparam N = 32;
    wire [80:1] pins;
    wire [N-1:0] A;
    wire [1:0] B;
    wire [N-1:0] F;
    wire A0;
    wire rev1;
    wire rev1_n;
    
    shifter1 sh1(
        .A(A),
        .B(B),
        .A0(A0),
        .rev1(rev1),
        .rev1_n(rev1_n),
        .F(F)
    );
    
    ConnectorFFC80 j1(
        .pins(pins)
    );
    
    assign pins[74] = A0;
    assign pins[73] = rev1;
    assign pins[72] = rev1_n;
    
    genvar i;
    for (i = 0; i < N; i++) begin
        assign pins[71-i*2] = A[i];
        assign pins[71-i*2-1] = F[i];
    end
    
    
endmodule
