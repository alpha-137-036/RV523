task automatic disassemble(
    input[23:0] stage,
    input[31:0] pc,
    input[31:0] instr,
    input       bubble
);
    logic[128*8-1:0] disassembly;
    
    logic [4:0] opcode, rs1_idx, rs2_idx, rd_idx;
    logic [31:0]    imm;
    opcode  = instr[6:2];
    rs1_idx = instr[19:15];
    rs2_idx = instr[24:20];
    rd_idx  = instr[11: 7];
    
    casex (opcode)
        default:
            // no immediate. imm is dont-care
            imm = 'X;
        `OPCODE_AUIPC,
        `OPCODE_LUI:
            // U format
            imm = {instr[31:12],12'b0};
        `OPCODE_LOAD,
        `OPCODE_OP_IMM,
        `OPCODE_JALR,
        `OPCODE_SYSTEM:
            // I format
            imm = {{20{instr[31]}},instr[31:20]};
        `OPCODE_STORE:
            // S format
            imm = {{20{instr[31]}},instr[31:25],instr[11:7]};
        `OPCODE_BRANCH:
            // B format
            imm = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
        `OPCODE_JAL:
            // J format
            imm = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};      
        endcase

    case (opcode)
    `OPCODE_AUIPC:
        $swrite(disassembly, "auipc x%0d, 0x%0X", rd_idx, imm);
    `OPCODE_LUI:
        $swrite(disassembly, "lui x%0d, 0x%0X", rd_idx, imm);
    `OPCODE_OP_IMM,
    `OPCODE_OP: begin
        string op;
        case (instr[14:12])
            3'd0: op = opcode == `OPCODE_OP && instr[30] ? "sub" : "add";
            3'd4: op = "xor";
            3'd6: op = "or";
            3'd7: op = "and";
            3'd1: op = "sll";
            3'd5: op = instr[30] ? "sra" : "srl";
            3'd2: op = "slt";
            3'd3: op = "sltu";
        endcase
        if (opcode == `OPCODE_OP) begin
            $swrite(disassembly, "%0s x%0d, x%0d, x%0d", op, rd_idx, rs1_idx, rs2_idx);
        end else begin
            $swrite(disassembly, "%0si x%0d, x%0d, 0x%0X", op, rd_idx, rs1_idx, imm);
        end
    end
    `OPCODE_LOAD: begin
        string op;
        case (instr[14:12])
            3'd0: op = "lb";
            3'd1: op = "lh";
            3'd2: op = "lw";
            3'd4: op = "lbu";
            3'd5: op = "lhu";
            default: op = "l??";
        endcase
        $swrite(disassembly, "%s x%0d, 0x%0X(x%0d)", op, rd_idx, imm, rs1_idx);
    end
    `OPCODE_STORE: begin
        string op;
        case (instr[14:12])
            3'd0: op = "sb";
            3'd1: op = "sh";
            3'd2: op = "sw";
            default: op = "s??";
        endcase
        $swrite(disassembly, "%s x%0d, 0x%0X(x%0d)", op, rs2_idx, imm, rs1_idx);
    end
    `OPCODE_BRANCH: begin
        string op;
        case (instr[14:12])
            3'd0: op = "beq";
            3'd1: op = "bne";
            3'd4: op = "blt";
            3'd5: op = "bge";
            3'd6: op = "bltu";
            3'd7: op = "bgeu";
            default: op = "b??";
        endcase
        $swrite(disassembly, "%s x%0d, x%0d, 0x%0X", op, rs1_idx, rs2_idx, pc + imm);
    end
    `OPCODE_JAL:
        $swrite(disassembly, "jal x%0d, 0x%0X", rd_idx, pc + imm);
    `OPCODE_JALR:
        $swrite(disassembly, "jalr x%0d, 0x%0X(x%0d)", rd_idx, imm, rs1_idx);
    `OPCODE_SYSTEM: begin
        string op;
        case (instr[31:20])
            12'd0: op = "ecall";
            12'd1: op = "ebreak";
            default: op = "system-??";
        endcase
        $swrite(disassembly, "%0s", op);
    end
    default:
        $swrite(disassembly, "???");
    endcase

    $display("[%s] %0s%X %X %0s", stage, bubble ? "<bubble> " : "", pc, instr, disassembly);

endtask