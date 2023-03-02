module CTRL(
    input  [6:0]   opcode,
    input  [6:0]   funct7,
    input  [2:0]   funct3,
    output [2:0]  sext_op,
    output      alu_a_sel,
    output      alu_b_sel,
    output [3:0]   alu_op,
    output [1:0]   wd_sel,
    output          rf_we,
    output [1:0] store_op,
    output        dram_we,
    output         branch,
    output [1:0]   npc_op,
    output [2:0]  load_op
    );
    
    reg [2:0]  SEXT_OP;
    reg      ALU_A_SEL;
    reg      ALU_B_SEL;
    reg [3:0]   ALU_OP;
    reg [1:0]   WD_SEL;
    reg          RF_WE;
    reg [1:0] STORE_OP;
    reg        DRAM_WE;
    reg         BRANCH;
    reg [1:0]   NPC_OP;
    reg [2:0]  LOAD_OP;
    
    assign sext_op = SEXT_OP;
    assign alu_a_sel = ALU_A_SEL;
    assign alu_b_sel = ALU_B_SEL;
    assign alu_op = ALU_OP;
    assign wd_sel = WD_SEL;
    assign rf_we = RF_WE;
    assign store_op = STORE_OP;
    assign dram_we = DRAM_WE;
    assign branch = BRANCH;
    assign npc_op = NPC_OP;
    assign load_op = LOAD_OP;
    
    always@(*)
    begin
        case(opcode)
        
            // R��ָ��
            7'b0110011:
            begin
                ALU_A_SEL = 1'b0;
                ALU_B_SEL = 1'b0;
                WD_SEL = 2'b00;
                RF_WE = 1'b1;
                DRAM_WE = 1'b0;
                BRANCH = 1'b0;
                NPC_OP = 2'b00;
                case(funct3)
                    // andָ��
                    3'b111:ALU_OP = 4'b0010;
                    // orָ��
                    3'b110:ALU_OP = 4'b0011;
                    // xorָ��
                    3'b100:ALU_OP = 4'b0100;
                    // sllָ��
                    3'b001:ALU_OP = 4'b0101;
                    // sltָ��
                    3'b010:ALU_OP = 4'b1000;
                    // sltuָ��
                    3'b011:ALU_OP = 4'b1001;
                    // �Ӽ�ָ��
                    3'b000:
                    begin
                        // addָ��
                        if(funct7 == 7'b0000000)    ALU_OP = 4'b0000;
                        // subָ��
                        else if(funct7 == 7'b0100000)    ALU_OP = 4'b0001;
                    end
                    // ����ָ��
                    3'b101:
                    begin
                        // srlָ��
                        if(funct7 == 7'b0000000)    ALU_OP = 4'b0110;
                        // sraָ��
                        else if(funct7 == 7'b0100000)    ALU_OP = 4'b0111;
                    end
                    default:;
                endcase
            end
            
            // I��ָ��1
            7'b0010011:
            begin
                ALU_A_SEL = 1'b0;
                ALU_B_SEL = 1'b1;
                WD_SEL = 2'b00;
                RF_WE = 1'b1;
                DRAM_WE = 1'b0;
                BRANCH = 1'b0;
                NPC_OP = 2'b00;
                case(funct3)
                    // addiָ��
                    3'b000:
                    begin
                        SEXT_OP = 3'b000;
                        ALU_OP = 4'b0000;
                    end
                    
                    // andiָ��
                    3'b111:
                    begin
                        SEXT_OP = 3'b000;
                        ALU_OP = 4'b0010;
                    end
                    
                    // oriָ��
                    3'b110:
                    begin
                        SEXT_OP = 3'b000;
                        ALU_OP = 4'b0011;
                    end
                    
                    // xoriָ��
                    3'b100:
                    begin
                        SEXT_OP = 3'b000;
                        ALU_OP = 4'b0100;
                    end
                    
                    // sltiָ��
                    3'b010:
                    begin
                        SEXT_OP = 3'b000;
                        ALU_OP = 4'b1000;
                    end
                    
                    // sltiuָ��
                    3'b011:
                    begin
                        SEXT_OP = 3'b000;
                        ALU_OP = 4'b1001;
                    end
                    
                    // slliָ��
                    3'b001:
                    begin
                        SEXT_OP = 3'b001;
                        ALU_OP = 4'b0101;
                    end
                    
                    // ����ָ��
                    3'b101:
                    begin
                        SEXT_OP = 3'b001;
                        // srliָ��
                        if(funct7 == 7'b0000000)    ALU_OP = 4'b0110;
                        // sraiָ��
                        else if(funct7 == 7'b0100000)    ALU_OP = 4'b0111;
                    end
                    default:;
                endcase
            end
            
            // I��ָ��2
            7'b0000011:
            begin
                SEXT_OP = 3'b000;
                ALU_A_SEL = 1'b0;
                ALU_B_SEL = 1'b1;
                ALU_OP = 4'b0000;
                WD_SEL = 2'b01;
                RF_WE = 1'b1;
                DRAM_WE = 1'b0;
                BRANCH = 1'b0;
                NPC_OP = 2'b00;
                case(funct3)
                    // lbָ��
                    3'b000:LOAD_OP = 3'b000;
                    // lbuָ��
                    3'b100:LOAD_OP = 3'b001;
                    // lhָ��
                    3'b001:LOAD_OP = 3'b010;
                    // lhuָ��
                    3'b101:LOAD_OP = 3'b011;
                    // lwָ��
                    3'b010:LOAD_OP = 3'b100;
                    default:;
                endcase
            end
            
            // S��ָ��
            7'b0100011:
            begin
                SEXT_OP = 3'b010;
                ALU_A_SEL = 1'b0;
                ALU_B_SEL = 1'b1;
                ALU_OP = 4'b0000;
                RF_WE = 1'b0;
                case(funct3)
                    // sbָ��
                    3'b000:STORE_OP = 2'b00;
                    // shָ��
                    3'b001:STORE_OP= 2'b01;
                    // swָ��
                    3'b010:STORE_OP = 2'b10;
                    default:;
                endcase
                DRAM_WE = 1'b1;
                BRANCH = 1'b0;
                NPC_OP = 2'b00;
            end
            
            // B��ָ��
            7'b1100011:
            begin
                SEXT_OP = 3'b011;
                ALU_A_SEL = 1'b0;
                ALU_B_SEL = 1'b0;
                RF_WE = 1'b0;
                DRAM_WE = 1'b0;
                BRANCH = 1'b1;
                NPC_OP = 2'b10;
                case(funct3)
                    // beqָ��
                    3'b000:ALU_OP = 4'b1010;
                    // bneָ��
                    3'b001:ALU_OP = 4'b1011;
                    // bltָ��
                    3'b100:ALU_OP = 4'b1000;
                    // bltuָ��
                    3'b110:ALU_OP = 4'b1001;
                    // bgeָ��
                    3'b101:ALU_OP = 4'b1100;
                    // bgeuָ��
                    3'b111:ALU_OP = 4'b1101;
                    default:;
                endcase
            end
            
            // jalrָ��
            7'b1100111:
            begin
                if(funct3 == 3'b000)
                begin
                    SEXT_OP = 3'b000;
                    WD_SEL = 2'b10;
                    RF_WE = 1'b1;
                    DRAM_WE = 1'b0;
                    BRANCH = 1'b0;
                    NPC_OP = 2'b01;
                end
            end
            
            // luiָ��
            7'b0110111:
            begin
                SEXT_OP = 3'b100;
                ALU_B_SEL = 1'b1;
                ALU_OP = 4'b1110;
                WD_SEL = 2'b00;
                RF_WE = 1'b1;
                DRAM_WE = 1'b0;
                BRANCH = 1'b0;
                NPC_OP = 2'b00;
            end
            
            // auipcָ��
            7'b0010111:
            begin
                SEXT_OP = 3'b100;
                ALU_A_SEL = 1'b1;
                ALU_B_SEL = 1'b1;
                ALU_OP = 4'b0000;
                WD_SEL = 2'b00;
                RF_WE = 1'b1;
                DRAM_WE = 1'b0;
                BRANCH = 1'b0;
                NPC_OP = 2'b00;
            end
            
            // jalָ��
            7'b1101111:
            begin
                SEXT_OP = 3'b101;
                WD_SEL = 2'b10;
                RF_WE = 1'b1;
                DRAM_WE = 1'b0;
                BRANCH = 1'b0;
                NPC_OP = 2'b11;
            end

            default:NPC_OP = 2'b00;
        endcase
    end
endmodule
