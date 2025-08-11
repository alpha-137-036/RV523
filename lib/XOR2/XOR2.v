module XOR2(
    output Y,
    input A,
    input B
);

    // Copied and adapted from https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hd/blob/ac7fb61f06e6470b94e8afdf7c25268f62fbd7b1/cells/xor2/sky130_fd_sc_hd__xor2_1.cdl

    wire inor, sndNA, sndPA, pmid;

    RV523_NMOS N1(.S(GND), .D(inor), .G(A));
    RV523_NMOS N2(.S(GND), .D(inor), .G(B));

    RV523_PMOS P1(.S(VDD),   .D(sndPA), .G(A));
    RV523_PMOS P2(.S(sndPA), .D(inor),  .G(B));

    RV523_NMOS N3(.S(GND),   .D(sndNA), .G(A));
    RV523_NMOS N4(.S(sndNA), .D(Y),     .G(B));
    RV523_NMOS N5(.S(GND),   .D(Y),     .G(inor));

    RV523_PMOS P3(.S(VDD),   .D(pmid), .G(A));
    RV523_PMOS P4(.S(VDD),   .D(pmid), .G(B));
    RV523_PMOS P5(.S(pmid),  .D(Y),    .G(inor));
endmodule