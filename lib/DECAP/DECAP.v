
(* blackbox *)
(* footprint="Capacitor_SMD:C_0402_1005Metric" *)
(* value="0.1u" *)
module CAP(
    (* num="1" *)
    inout pin1,
    (* num="2" *)
    inout pin2
);
endmodule

module DECAP();
    supply1 VDD;
    supply0 GND;

    (* keep *)
    CAP C(.pin1(GND), .pin2(VDD));
endmodule