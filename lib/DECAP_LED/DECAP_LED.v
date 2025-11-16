`include "../DECAP/DECAP.v"

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
    Resistor #(.value("330")) R(.pin1(i), .pin2(LED_GND));
    (* keep *)
    LED L(.cathode(i), .anode(A));
endmodule