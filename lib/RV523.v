(* techmap_celltype = "NOT" *)
(* blackbox *)
(* footprint = "RV523:NOT" *)
module NOT (output Y, input A);
    assign Y = ~A;
endmodule

(* techmap_celltype = "NAND2" *)
(* blackbox *)
(* footprint = "RV523:NAND2" *)
module NAND2 (output Y, input A1, input A2);
    assign Y = ~(A1 & A2);
endmodule

(* techmap_celltype = "AND2" *)
(* blackbox *)
(* footprint = "RV523:AND2" *)
module AND2 (output Y, input A1, input A2);
    assign Y = A1 & A2;
endmodule

(* techmap_celltype = "NOR2" *)
(* blackbox *)
(* footprint = "RV523:NOR2" *)
module NOR2 (output Y, input A1, input A2);
    assign Y = ~(A1 | A2);
endmodule

(* techmap_celltype = "OR2" *)
(* blackbox *)
(* footprint = "RV523:OR2" *)
module OR2 (output Y, input A1, input A2);
    assign Y = A1 | A2;
endmodule

(* techmap_celltype = "NAND3" *)
(* blackbox *)
(* footprint = "RV523:NAND3" *)
module NAND3 (output Y, input A1, input A2, input A3);
    assign Y = ~(A1 & A2 & A3);
endmodule

(* techmap_celltype = "AND3" *)
(* blackbox *)
(* footprint = "RV523:AND3" *)
module AND3 (output Y, input A1, input A2, input A3);
    assign Y = A1 & A2 & A3;
endmodule

(* techmap_celltype = "NOR3" *) 
(* blackbox *)
(* footprint = "RV523:NOR3" *)
module NOR3 (output Y, input A1, input A2, input A3);
    assign Y = ~(A1 | A2 | A3);
endmodule

(* techmap_celltype = "OR3" *)
(* blackbox *)
(* footprint = "RV523:OR3" *)
module OR3 (output Y, input A1, input A2, input A3);
    assign Y = A1 | A2 | A3;
endmodule

(* techmap_celltype = "NAND4" *)
(* blackbox *)
(* footprint = "RV523:NAND4" *)
module NAND4 (output Y, input A1, input A2, input A3, input A4);
    assign Y = ~(A1 & A2 & A3 & A4);
endmodule

(* techmap_celltype = "NOR4" *)
(* blackbox *)
(* footprint = "RV523:NOR4" *)
module NOR4 (output Y, input A1, input A2, input A3, input A4);
    assign Y = ~(A1 | A2 | A3 | A4);
endmodule

(* techmap_celltype = "AOI21" *)
(* blackbox *)
(* footprint = "RV523:AOI21" *)
module AOI21 (output Y, input A, input B1, input B2);
    assign Y = ~(A | (B1 & B2));
endmodule

(* techmap_celltype = "OAI21" *)
(* blackbox *)
(* footprint = "RV523:OAI21" *)
module OAI21 (output Y, input A, input B1, input B2);
    assign Y = ~(A & (B1 | B2));
endmodule

(* techmap_celltype = "AOI22" *)
(* blackbox *)
(* footprint = "RV523:AOI22" *)
module AOI22 (output Y, input A1, input A2, input B1, input B2);
    assign Y = ~((A1 & A2) | (B1 & B2));
endmodule

(* techmap_celltype = "OAI22" *) 
(* blackbox *)
(* footprint = "RV523:OAI22" *)
module OAI22 (output Y, input A1, input A2, input B1, input B2);
    assign Y = ~((A1 | A2) & (B1 | B2));
endmodule

(* techmap_celltype = "AOI211" *) 
(* blackbox *)
(* footprint = "RV523:AOI211" *)
module AOI211 (output Y, input A, input B, input C1, input C2);
    assign Y = ~(A | B | (C1 & C2));
endmodule

(* techmap_celltype = "OAI211" *) 
(* blackbox *)
(* footprint = "RV523:OAI211" *)
module OAI211 (output Y, input A, input B, input C1, input C2);
    assign Y = ~(A & B & (C1 | C2));
endmodule
