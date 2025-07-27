
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
(* footprint="Connector_PinHeader_2.54mm:PinHeader_2x32_P2.54mm_Vertical" *)
module PinHeader2x32(
    (* num="64:1" *)
    inout [64:1] pins
);
endmodule

(* blackbox *)
(* footprint="Connector_PinHeader_2.54mm:PinHeader_1x16_P2.54mm_Vertical" *)
module PinHeader1x16(
    (* num="16:1" *)
    inout [16:1] pins
);
endmodule


(* blackbox *)
(* footprint="Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" *)
module PinHeader1x02(
    (* num="2:1" *)
    inout [2:1] pins
);
endmodule

module RV523_CellTestBoard();

    // Row 0
    // Raw transistors
    wire[16:1] PVDD;
    wire[16:1] PSources;
    wire[16:1] PGates;
    wire[16:1] PDrains;
    wire[16:1] NDrains;
    wire[16:1] NGates;
    wire[16:1] NSources;
    wire[16:1] NGND;

    (* keep *)
    PinHeader1x16 JP1(.pins(PVDD));
    (* keep *)
    PinHeader1x16 JPS(.pins(PSources));
    (* keep *)
    PinHeader1x16 JPG(.pins(PGates));
    (* keep *)
    PinHeader1x16 JPD(.pins(PDrains));
    (* keep *)
    PinHeader1x16 JND(.pins(NDrains));
    (* keep *)
    PinHeader1x16 JNG(.pins(NGates));
    (* keep *)
    PinHeader1x16 JNS(.pins(NSources));
    (* keep *)
    PinHeader1x16 JN0(.pins(NGND));

    genvar i;
    supply1 VDD;
    supply0 GND;
    generate
        for (i = 1; i <= 16; i++) begin
            assign PVDD[i] = VDD;
            RV523_PMOS P(
                .S(PSources[i]),
                .G(PGates[i]),
                .D(PDrains[i])
            );
            RV523_NMOS N(
                .D(NDrains[i]),
                .G(NGates[i]),
                .S(NSources[i])
            );
            assign NGND[i] = GND;            
        end
    endgenerate

    // ----
    // Row 1
    // ----
    wire[64:1] J1pins;
    (* keep *)
    PinHeader2x32 J1(.pins(J1pins));

    (* keep *)
    DECAP DECAP_1();
    NOT NOT_1(
        .A(J1pins[1]),
        .Y(J1pins[2]), 
    );
    NOT NOT_2(
        .A(J1pins[3]),
        .Y(J1pins[4]), 
    );
    NOT NOT_3(
        .A(J1pins[5]),
        .Y(J1pins[6]), 
    );
    NOT NOT_4(
        .A(J1pins[7]),
        .Y(J1pins[8]), 
    );

    (* keep *)
    DECAP DECAP_2();
    NAND2 NAND2_1(
        .A1(J1pins[9]),
        .A2(J1pins[10]),
        .Y(J1pins[11]), 
    );
    NAND2 NAND2_2(
        .A1(J1pins[12]),
        .A2(J1pins[13]),
        .Y(J1pins[14]), 
    );
    (* keep *)
    DECAP DECAP_3();
    NAND2 NAND2_3(
        .A1(J1pins[15]),
        .A2(J1pins[16]),
        .Y(J1pins[17]), 
    );
    NAND2 NAND2_4(
        .A1(J1pins[18]),
        .A2(J1pins[19]),
        .Y(J1pins[20]), 
    );
    (* keep *)
    DECAP DECAP_4();
    NOR2 NOR2_1(
        .A1(J1pins[21]),
        .A2(J1pins[22]),
        .Y(J1pins[23]), 
    );
    NOR2 NOR2_2(
        .A1(J1pins[24]),
        .A2(J1pins[25]),
        .Y(J1pins[26]), 
    );
    (* keep *)
    DECAP DECAP_5();
    NOR2 NOR2_3(
        .A1(J1pins[27]),
        .A2(J1pins[28]),
        .Y(J1pins[29]), 
    );
    NOR2 NOR2_4(
        .A1(J1pins[30]),
        .A2(J1pins[31]),
        .Y(J1pins[32]), 
    );
    (* keep *)
    DECAP DECAP_6();
    NAND3 NAND3_1(
        .A1(J1pins[33]),
        .A2(J1pins[34]),
        .A3(J1pins[35]),
        .Y(J1pins[36]), 
    );
    NAND3 NAND3_2(
        .A1(J1pins[37]),
        .A2(J1pins[38]),
        .A3(J1pins[39]),
        .Y(J1pins[40]), 
    );
    (* keep *)
    DECAP DECAP_7();
    NOR3 NOR3_1(
        .A1(J1pins[41]),
        .A2(J1pins[42]),
        .A3(J1pins[43]),
        .Y(J1pins[44]), 
    );
    NOR3 NOR3_2(
        .A1(J1pins[45]),
        .A2(J1pins[46]),
        .A3(J1pins[47]),
        .Y(J1pins[48]), 
    );
    (* keep *)
    DECAP DECAP_8();
    NAND4 NAND4_1(
        .A1(J1pins[49]),
        .A2(J1pins[50]),
        .A3(J1pins[51]),
        .A4(J1pins[52]),
        .Y(J1pins[53]), 
    );

    // ----
    // Row 2
    // ----
    wire[64:1] J2pins;
    (* keep *)
    PinHeader2x32 J2(.pins(J2pins));

    (* keep *)
    DECAP DECAP_10();
    TINV TINV_1(
        .A(J2pins[1]),
        .EN(J2pins[2]),
        .nEN(J2pins[3]),
        .Y(J2pins[4])
    );
    TINV TINV_2(
        .A(J2pins[5]),
        .EN(J2pins[6]),
        .nEN(J2pins[7]),
        .Y(J2pins[8])
    );
    (* keep *)
    DECAP DECAP_11();
    TINV TINV_3(
        .A(J2pins[9]),
        .EN(J2pins[10]),
        .nEN(J2pins[11]),
        .Y(J2pins[12])
    );
    TINV TINV_4(
        .A(J2pins[13]),
        .EN(J2pins[14]),
        .nEN(J2pins[15]),
        .Y(J2pins[16])
    );
    (* keep *)
    DECAP_LED DECAP_LED_12(
        .A(J2pins[17]),
        .LED_GND(J2pins[18])
    );
    AOI21 AOI21_1(
        .A(J2pins[19]),
        .B1(J2pins[20]),
        .B2(J2pins[21]),
        .Y(J2pins[22])
    );
    (* keep *)
    DECAP DECAP_13();
    OAI21 OAI21_1(
        .A(J2pins[23]),
        .B1(J2pins[24]),
        .B2(J2pins[25]),
        .Y(J2pins[26])
    );
    (* keep *)
    DECAP DECAP_14();
    AOI22 AOI22_1(
        .A1(J2pins[27]),
        .A2(J2pins[28]),
        .B1(J2pins[29]),
        .B2(J2pins[30]),
        .Y(J2pins[31])
    );
    (* keep *)
    DECAP DECAP_15();
    OAI22 OAI22_1(
        .A1(J2pins[32]),
        .A2(J2pins[33]),
        .B1(J2pins[34]),
        .B2(J2pins[35]),
        .Y(J2pins[36])
    );
    (* keep *)
    DECAP DECAP_16();
    AOI211 AOI211_1(
        .A(J2pins[37]),
        .B(J2pins[38]),
        .C1(J2pins[39]),
        .C2(J2pins[40]),
        .Y(J2pins[41])
    );
    (* keep *)
    DECAP DECAP_17();
    OAI211 OAI211_1(
        .A(J2pins[42]),
        .B(J2pins[43]),
        .C1(J2pins[44]),
        .C2(J2pins[45]),
        .Y(J2pins[46])
    );
    (* keep *)
    DECAP DECAP_18();
    NOR4 NOR4_1(
        .A1(J2pins[47]),
        .A2(J2pins[48]),
        .A3(J2pins[49]),
        .A4(J2pins[50]),
        .Y(J2pins[51])
    );
    (* keep *)
    DECAP_LED DECAP_LED_19(
        .A(J2pins[52]),
        .LED_GND(J2pins[53])
    );

    /// ----
    /// Test latches with 4 registers of 4 bits
    /// ----
    wire[64:1] J3pins;
    (* keep *)
    PinHeader2x32 J3(.pins(J3pins));

    genvar x;
    genvar i;
    // 1-5: input word
    // 6-13: write select clk
    // 14-21: read 1 select
    // 22-29: read 2 select
    // 30-33: read 1 data
    // 34-37: read 2 data
    // 61-64: LED GND's 
    generate
        for (x = 0; x < 4; x++) begin
            for (i = 0; i < 4; i++) begin
                wire nQ, Q;
                D_LATCH L(
                    .D(J3pins[1+i]),
                    .CLK(J3pins[x == 0 ? 5 : 3 + 16 * x]),
                    .nCLK(J3pins[x == 0 ? 6 : 3 + 16 * x + 1]),
                    .nQ(nQ),
                    .Q(Q)
                );
                DECAP_LED D(
                    .A(Q),
                    .LED_GND(J3pins[64 - i])
                );
                TINV R1(
                    .A(nQ),
                    .EN(J3pins[x == 3 ? 56 : 11 + 16 * x]),
                    .nEN(J3pins[x == 3 ? 55 : 12 + 16 * x]),
                    .Y(J3pins[24 - i])
                );
                TINV R2(
                    .A(nQ),
                    .EN(J3pins[x == 3 ? 58 : 15 + 16 * x]),
                    .nEN(J3pins[x == 3 ? 57 : 16 + 16 * x]),
                    .Y(J3pins[40 - i])
                );
            end
        end
    endgenerate

    // Board supply pins and decaps
    (* keep *)
    PinHeader1x02 JSupply1(
        .pins({VDD, GND})
    );
    (* keep *) (* value="10u" *)
    CAP DECAP1(VDD, GND);
    (* keep *)
    PinHeader1x02 JSupply2(
        .pins({VDD, GND})
    );
    (* keep *) (* value="10u" *)
    CAP DECAP2(VDD, GND);
    (* keep *)
    PinHeader1x02 JSupply3(
        .pins({VDD, GND})
    );
    (* keep *) (* value="10u" *)
    CAP DECAP3(VDD, GND);
    (* keep *)
    PinHeader1x02 JSupply4(
        .pins({VDD, GND})
    );
    (* keep *) (* value="10u" *)
    CAP DECAP4(VDD, GND);

endmodule