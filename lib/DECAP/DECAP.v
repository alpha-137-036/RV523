module DECAP();
    supply1 VDD;
    supply0 GND;

    (* keep *)
    Capacitor #(.value("0.1u")) C(.pin1(GND), .pin2(VDD));
endmodule