
(* blackbox *)
(* footprint="Connector_PinHeader_2.54mm:PinHeader_2x32_P2.54mm_Vertical" *)
module PinHeader2x32(
    (* num="64:1" *)
    inout [64:1] pins
);
endmodule

module RV523_CellTestBoard();

    wire[64:1] J1pins;
    genvar i;

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

endmodule