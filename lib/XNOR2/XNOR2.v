module XNOR2(
    output Y,
    input A,
    input B
);
    supply0 GND;
    supply1 VDD;

    // Copied and adapted from https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hd/blob/ac7fb61f06e6470b94e8afdf7c25268f62fbd7b1/cells/xnor2/sky130_fd_sc_hd__xnor2_1.cdl

    wire sndNA, inand, nmid, sndPA;
    
    RV523_NMOS N1(.S(GND), .G(A), .D(sndNA));
    RV523_NMOS N2(.S(sndNA), .G(B), .D(inand));
    RV523_NMOS N3(.S(GND), .G(A), .D(nmid));
    RV523_NMOS N4(.S(GND), .G(B), .D(nmid));
    RV523_NMOS N5(.S(nmid), .G(inand), .D(Y));

    RV523_PMOS P1(.S(VDD), .G(A), .D(inand));
    RV523_PMOS P2(.S(VDD), .G(B), .D(inand));
    RV523_PMOS P3(.S(VDD), .G(A), .D(sndPA));
    RV523_PMOS P4(.S(sndPA), .G(B), .D(Y));
    RV523_PMOS P5(.S(VDD), .G(inand), .D(Y));

    // wire nAandB;
    // NAND2 nand1(.A1(A), .A2(B), .Y(nAandB));
    // OAI21 oai21(.A(nAandB), .B1(A), .B2(B), .Y(Y));


endmodule