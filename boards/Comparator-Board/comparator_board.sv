
(* blackbox *)
(* footprint="Capacitor_SMD:C_0402_1005Metric" *)
module CAP(
    (* num="1" *)
    inout pin1,
    (* num="2" *)
    inout pin2
);
endmodule


(* blackbox *)
(* footprint="Connector_PinHeader_2.54mm:PinHeader_1x20_P2.54mm_Vertical" *)
module PinHeader1x20(
    (* num="20:1" *)
    inout [20:1] pins
);
endmodule

(* blackbox *)
(* footprint="RV523_Common:FFC-SMD_FFC05021-20SBB123W5M" *)
module ConnectorFFC20(
    (* num="20:1" *)
    inout [20:1] pins
);
endmodule


(* blackbox *)
(* footprint="Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" *)
module PinHeader1x02(
    (* num="2:1" *)
    inout [2:1] pins
);
endmodule

module comparator_board
(
);
    wire [20:1] pins;
    wire [7:0] A;
    wire [7:0] B;
    wire U;
    wire EQ;
    wire LT;

    (* keep *)
    PinHeader1x20 JP2(.pins(pins));
    
    (* keep *)
    ConnectorFFC20 JP1(.pins(pins));

    comparator u_comp(
        .A(A), .B(B), .U(U), .EQ(EQ), .LT(LT)
    );
    
    genvar i;
    for (i = 0; i < 8; i++) begin
        assign A[i] = pins[2*i+1];
        assign B[i] = pins[2*i+2];
    
    end
    assign U = pins[18];
    assign pins[19] = EQ;
    assign pins[20] = LT;

    // One DECAP per row (16 rows)
    for (i = 0; i < 16; i++) begin
        (* keep *)
        DECAP u_decap();
    end


    // Board supply pins and decaps
    (* keep *)
    PinHeader1x02 JSupply1(
        .pins({VDD, GND})
    );
    (* keep *) (* value="10u" *)
    CAP DECAP1(VDD, GND);

endmodule