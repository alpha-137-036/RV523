(* blackbox *)
(* footprint="RV523:SOT523" *)
(* value="NMOS" *)
module RV523_NMOS(
    (* num="3" *)
    inout D,
    (* num="1" *)
    inout G, 
    (* num="2" *)
    inout S
);
endmodule

(* blackbox *)
(* footprint="RV523:SOT523" *)
(* value="PMOS" *)
module RV523_PMOS(
    (* num="3" *)
    inout D,
    (* num="1" *)
    inout G, 
    (* num="2" *)
    inout S
);
endmodule

(* blackbox *)
(* footprint="Resistor_SMD:R_0402_1005Metric" *)
module Resistor
#(
    parameter value
)(
    (* num="1" *)
    inout pin1,
    (* num="2" *)
    inout pin2
);
endmodule

(* blackbox *)
(* footprint="Capacitor_SMD:C_0402_1005Metric" *)
module Capacitor
#(
    parameter value
)(
    (* num="1" *)
    inout pin1,
    (* num="2" *)
    inout pin2
);
endmodule
