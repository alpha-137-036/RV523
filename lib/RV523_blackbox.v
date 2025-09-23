
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
(* techmap_celltype = "NAND2B" *)
(* footprint = "RV523:NAND2B" *)
module NAND2B(
    output Y,
    input A_N,
    input B
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
(* techmap_celltype = "AND3" *)
(* footprint = "RV523:AND3" *)
module AND3 (output Y, input A1, input A2, input A3);
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
(* techmap_celltype = "NAND4B" *)
(* footprint = "RV523:NAND4B" *)
module NAND4B(
    output Y,
    input A1_N,
    input A2,
    input A3,
    input A4
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AND4" *)
(* footprint = "RV523:AND4" *)
module AND4 (output Y, input A1, input A2, input A3, input A4);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AND4B" *)
(* footprint = "RV523:AND4B" *)
module AND4B(
    output Y,
    input A1_N,
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
(* techmap_celltype = "OR2" *)
(* footprint = "RV523:OR2" *)
module OR2 (output Y, input A1, input A2);
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
(* techmap_celltype = "NOR3B" *)
(* footprint = "RV523:NOR3B" *)
module NOR3B(
    output Y,
    input A1,
    input A2,
    input A3_N
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OR3" *)
(* footprint = "RV523:OR3" *)
module OR3 (output Y, input A1, input A2, input A3);
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
(* techmap_celltype = "OR4" *)
(* footprint = "RV523:OR4" *)
module OR4 (output Y, input A1, input A2, input A3, input A4);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI21" *)
(* footprint = "RV523:AOI21" *)
module AOI21(
    output Y,
    input A1,
    input A2,
    input B1
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
(* techmap_celltype = "AOI221" *)
(* footprint = "RV523:AOI221" *)
module AOI221(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI311" *)
(* footprint = "RV523:AOI311" *)
module AOI311(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input C1
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI2111" *)
(* footprint = "RV523:AOI2111" *)
module AOI2111(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "AOI222" *)
(* footprint = "RV523:AOI222" *)
module AOI222(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input C2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "MAJ3" *)
(* footprint = "RV523:MAJ3" *)
module MAJ3(
    output Y,
    input A1,
    input A2,
    input A3
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
(* techmap_celltype = "OA21" *)
(* footprint = "RV523:OA21" *)
module OA21(
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
(* techmap_celltype = "OAI221" *)
(* footprint = "RV523:OAI221" *)
module OAI221(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI222" *)
(* footprint = "RV523:OAI222" *)
module OAI222(
    output Y,
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input C2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI31" *)
(* footprint = "RV523:OAI31" *)
module OAI31(
    output Y,
    input A1,
    input A2,
    input A3,
    input B
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI32" *)
(* footprint = "RV523:OAI32" *)
module OAI32(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input B2
);
endmodule

                    
(* blackbox *)
(* techmap_celltype = "OAI33" *)
(* footprint = "RV523:OAI33" *)
module OAI33(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    input B3
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
(* techmap_celltype = "MUX2" *)
(* footprint = "RV523:MUX2" *)
module MUX2(
    output Y,
    input I0,
    input I1,
    input S
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

                    