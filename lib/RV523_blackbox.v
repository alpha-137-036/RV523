
(* blackbox *)
(* techmap_celltype = "BUF" *)
(* footprint = "RV523:BUF" *)
module BUF(
    output Y,
    input A
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NOT" *)
(* footprint = "RV523:NOT" *)
module NOT(
    output Y,
    input A
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "TINV" *)
(* footprint = "RV523:TINV" *)
module TINV (
    output Y, 
    input  A,
    input  EN,
    input  nEN);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NAND2" *)
(* footprint = "RV523:NAND2" *)
module NAND2(
    output Y,
    input A1,
    input A2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AND2" *)
(* footprint = "RV523:AND2" *)
module AND2(
    output Y,
    input A1,
    input A2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NAND3" *)
(* footprint = "RV523:NAND3" *)
module NAND3(
    output Y,
    input A1,
    input A2,
    input A3
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NAND4" *)
(* footprint = "RV523:NAND4" *)
module NAND4(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NOR2" *)
(* footprint = "RV523:NOR2" *)
module NOR2(
    output Y,
    input A1,
    input A2,
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NOR3" *)
(* footprint = "RV523:NOR3" *)
module NOR3(
    output Y,
    input A1,
    input A2,
    input A3
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "NOR4" *)
(* footprint = "RV523:NOR4" *)
module NOR4(
    output Y,
    input A1,
    input A2,
    input A3,
    input A4
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI21" *)
(* footprint = "RV523:AOI21" *)
module AOI21(
    output Y,
    input A,
    input B1,
    input B2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI22" *)
(* footprint = "RV523:AOI22" *)
module AOI22(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI211" *)
(* footprint = "RV523:AOI211" *)
module AOI211(
    output Y,
    input A,
    input B,
    input C1,
    input C2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI21" *)
(* footprint = "RV523:OAI21" *)
module OAI21(
    output Y,
    input A,
    input B1,
    input B2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI22" *)
(* footprint = "RV523:OAI22" *)
module OAI22(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI211" *)
(* footprint = "RV523:OAI211" *)
module OAI211(
    output Y,
    input A,
    input B,
    input C1,
    input C2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "XOR2" *)
(* footprint = "RV523:XOR2" *)
module XOR2(
    output Y,
    input A,
    input B
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "XNOR2" *)
(* footprint = "RV523:XNOR2" *)
module XNOR2(
    output Y,
    input A,
    input B
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "D_LATCH" *)
(* footprint = "RV523:D_LATCH" *)
module D_LATCH(
    output Q,
    output nQ,
    input D,
    input CLK,
    input nCLK
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "DECAP" *)
(* footprint = "RV523:DECAP" *)
module DECAP();
endmodule

                    
(* blackbox *)
(* techmap_celltype = "DECAP_LED" *)
(* footprint = "RV523:DECAP_LED" *)
module DECAP_LED(
    input A,
    input LED_GND
);
endmodule

                    