//`include "alu_defines.sv"



module ALU_gold
#(
    parameter N = 32
)
(
    input  operation_t op,
    input  logic [N-1:0]A,
    input  logic [N-1:0]B,
    output logic [N-1:0]Y
);
    always_comb begin
        case(op)
            `OP_ADD: Y = A + B; 
            `OP_SUB: Y = A - B; 
            `OP_SLL: Y = A << B[4:0]; 
            `OP_SRL: Y = A >> B[4:0]; 
            `OP_SRA: Y = $signed(A) >>> B[4:0];
            `OP_AND: Y = A & B;
            `OP_XOR: Y = A ^ B;
            `OP_OR:  Y = A | B;
            `OP_SLTU: Y = {31'b0, A < B};
            `OP_SLT:  Y = {31'b0, $signed(A) < $signed(B)};
            `OP_SEQ:  Y = {31'b0, A == B};
        endcase
    end
endmodule

module ALU_tb();

    logic [31:0] A;
    logic [31:0] B;
    logic [31:0] Y;
    logic [31:0] Y_gold;
    logic pass;
    operation_t op;

    ALU u_dut(
        .op(op),
        .A(A), .B(B),
        .Y(Y));

    ALU_gold u_gold(
        .op(op),
        .A(A), .B(B),
        .Y(Y_gold));
    
    assign pass = (Y == Y_gold);


    initial begin
        $dumpfile("iverilog/ALU_tb.vcd");
        $dumpvars(0);

        A = 32'h82345678;
        op = `OP_SLL;
        B = 1;
        #1; assert(pass);
        B = 2;
        #1; assert(pass);
        B = 3;
        #1; assert(pass);
        B = 7;
        #1; assert(pass);
        B = 15;
        #1; assert(pass);
        B = 16;
        #1; assert(pass);
        B = 31;
        #1; assert(pass); #1;
        
        op = `OP_SRL;
        B = 1;
        #1; assert(pass);
        B = 2;
        #1; assert(pass);
        B = 3;
        #1; assert(pass);
        B = 7;
        #1; assert(pass);
        B = 15;
        #1; assert(pass);
        B = 16;
        #1; assert(pass);
        B = 31;
        #1; assert(pass);

        op = `OP_SRA;
        B = 1;
        #1; assert(pass);
        B = 2;
        #1; assert(pass);
        B = 3;
        #1; assert(pass);
        B = 7;
        #1; assert(pass);
        B = 15;
        #1; assert(pass);
        B = 16;
        #1; assert(pass);
        B = 31;
        #1; assert(pass);
        
        op = `OP_AND;
        B = 32'hF0F0F0F0;
        #1; assert(pass);
        op = `OP_XOR;
        #1; assert(pass);
        op = `OP_OR;
        #1; assert(pass);
        
        op = `OP_ADD;
        A = 32'h12345678;
        B = 1;
        #1; assert(pass);
        A = 32'h12345679;
        #1; assert(pass);
        A = 32'h1234567B;
        #1; assert(pass);
        A = 32'h1234567F;
        #1; assert(pass);
        A = 32'h1234FFF0;
        #1; assert(pass);
        A = 32'h1234FFFF;
        #1; assert(pass);
        A = 32'hFFFFFFFF;
        #1; assert(pass);
        
        A = 32'h12345678;
        B = A;
        #1; assert(pass);
        
        op = `OP_SUB;
        B = 32'h00050000;
        #1; assert(pass);
          
        A = 0;
        B = 1;
        #1; assert(pass);        
          
          
        op = `OP_SLTU;
        A = 32'h1234; B = 32'h1235;
        #1; assert(pass);        
        A = 32'h1234; B = 32'h1234;
        #1; assert(pass);        
        A = 32'h1234; B = 32'h1233;
        #1; assert(pass);        
        A = 1; B = 32'hFFFFFFFF;
        #1; assert(pass);        
          
        op = `OP_SLT;
        A = 32'hFFFF1234; B = 32'hFFFF1235;
        #1; assert(pass);        
        A = 32'hFFFF1234; B = 32'hFFFF1234;
        #1; assert(pass);        
        A = 32'hFFFF1234; B = 32'hFFFF1233;
        #1; assert(pass);        
        A = 1; B = 32'hFFFFFFFF;
        #1; assert(pass);        

        op = `OP_SEQ;
        A = 32'hFFFF1234; B = 32'hFFFF1235;
        #1; assert(pass);        
        A = 32'hFFFF1234; B = 32'hFFFF1234;
        #1; assert(pass);        
        A = 32'hFFFF1234; B = 32'hFFFF1233;
        #1; assert(pass);        
    end
endmodule