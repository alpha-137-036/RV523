
(* blackbox *)
(* footprint="Resistor_SMD:R_0402_1005Metric" *)
(* value="330" *)
module Resistor_330(
    (* num="1" *)
    inout pin1,
    (* num="2" *)
    inout pin2
);
endmodule


(* blackbox *)
(* footprint="LED_SMD:LED_0402_1005Metric" *)
module LED(
    (* num="1" *)
    inout cathode,
    (* num="2" *)
    inout anode
);
endmodule


module DECAP_LED(
    input A,
    input LED_GND
);
    wire i;
    (* keep *)
    DECAP DECAP();
    (* keep *)
    Resistor_330 R(.pin1(i), .pin2(LED_GND));
    (* keep *)
    LED L(.cathode(i), .anode(A));
endmodule