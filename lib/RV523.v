(* techmap_celltype = "NOT" *)
(* blackbox *)
(* footprint = "RV523:NOT" *)
module NOT (output Y, input A);
    assign Y = ~A;
endmodule

(* techmap_celltype = "NAND" *) 
(* blackbox *)
(* footprint = "RV523:NAND" *)
module NAND (output Y, input A, input B);
    assign Y = A ~& B;
endmodule

// There is no advantage defining a primitive cell for AND: it will anyway be 
// just a NAND followed by a NOT...

module AND (output Y, input A, input B);
    wire nY;
    NAND u1(nY, A, B);
    NOT u2(Y, nY);
endmodule

(* techmap_celltype = "NOR" *) 
(* blackbox *)
(* footprint = "RV523:NOR" *)
module NOR (output Y, input A, input B);
    assign Y = A ~| B;
endmodule

(* techmap_celltype = "NAND3" *) 
(* blackbox *)
(* footprint = "RV523:NAND3" *)
module NAND3 (output Y, input A, input B, input C);
    assign Y = ~(A & B & C);
endmodule

(* techmap_celltype = "NOR3" *) 
(* blackbox *)
(* footprint = "RV523:NOR3" *)
module NOR3 (output Y, input A, input B, input C);
    assign Y = ~(A | B | C);
endmodule

(* techmap_celltype = "AOI21" *) (* blackbox *)
(* footprint = "RV523:AOI21" *)
module AOI21 (output Y, input A, input B, input C);
    assign Y = ~((A & B) | C);
endmodule

(* techmap_celltype = "OAI21" *) (* blackbox *)
(* footprint = "RV523:OAI21" *)
module OAI21 (output Y, input A, input B, input C);
    assign Y = ~((A | B) & C);
endmodule

(* techmap_celltype = "AOI22" *)
(* blackbox *)
(* footprint = "RV523:AOI22" *)
module AOI22 (output Y, input A, input B, input C, input D);
    assign Y = ~((A & B) | (C & D));
endmodule

(* techmap_celltype = "OAI22" *) (* blackbox *)
module OAI22 (output Y, input A, input B, input C, input D);
    assign Y = ~((A | B) & (C | D));
endmodule

(* techmap_celltype = "AOI221" *) (* blackbox *)
module AOI221 (output Y, input A, input B, input C, input D, input E);
    assign Y = ~((A & B) | (C & D) | E);
endmodule

(* techmap_celltype = "OAI221" *) (* blackbox *)
module OAI221 (output Y, input A, input B, input C, input D, input E);
    assign Y = ~((A | B) & (C | D) & E);
endmodule

(* techmap_celltype = "AOI222" *) (* blackbox *)
module AOI222 (output Y, input A, input B, input C, input D, input E, input F);
    assign Y = ~((A & B) | (C & D) | (E & F));
endmodule

(* techmap_celltype = "OAI222" *) (* blackbox *)
module OAI222 (output Y, input A, input B, input C, input D, input E, input F);
    assign Y = ~((A | B) & (C | D) & (E | F));
endmodule
