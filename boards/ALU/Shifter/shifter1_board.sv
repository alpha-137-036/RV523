(* blackbox *)
(* footprint="RV523_Common:FPC-SMD_THD0518-80CL-GF" *)
module ConnectorFFC80(
    (* num="82:1" *)
    inout [82:1] pins
);
endmodule


(* blackbox *)
(* footprint="Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" *)
module PinHeader1x02(
    (* num="2:1" *)
    inout [2:1] pins
);
endmodule

(* blackbox *)
(* footprint="Capacitor_SMD:C_0402_1005Metric" *)
module CAP(
    (* num="1" *)
    inout pin1,
    (* num="2" *)
    inout pin2
);
endmodule


module shifter1_board
(
);
    localparam N = 32;
    wire [82:1] pins;
    wire [N-1:0] A;
    wire [1:0] B;
    wire [N-1:0] F;
    wire A0;
    wire rev1;
    wire rev1_n;
    
    supply1 VDD;
    supply0 GND;
    
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
    
    assign pins[81] = GND;
    assign pins[82] = GND;
    
    assign pins[75] = GND;
    assign pins[76] = VDD;
    assign pins[77] = GND;
    assign pins[78] = VDD;
    assign pins[79] = GND;
    assign pins[80] = VDD;
    
    assign pins[74] = A0;
    assign pins[73] = rev1;
    assign pins[72] = rev1_n;
    
    genvar i;
    for (i = 0; i < N; i++) begin
        assign pins[71-i*2] = A[i];
        assign pins[71-i*2-1] = F[i];
    end
    
    assign pins[7] = GND;
    assign pins[6] = VDD;
    assign pins[5] = GND;
    assign pins[4] = VDD;
    assign pins[3] = GND;
    assign pins[2] = VDD;
    assign pins[1] = GND;
    
    (* keep *)
    PinHeader1x02 j2(.pins({VDD,GND}));
    (* keep *)
    PinHeader1x02 j3(.pins({VDD,GND}));    

    (* keep *) (* value="10u" *)
    CAP C1(.pin1(GND), .pin2(VDD));
    (* keep *) (* value="10u" *)
    CAP C2(.pin1(GND), .pin2(VDD));
    (* keep *) (* value="10u" *)
    CAP C3(.pin1(GND), .pin2(VDD));
    (* keep *) (* value="10u" *)
    CAP C4(.pin1(GND), .pin2(VDD));
    
endmodule
