// Add your code here, or replace this file
module SingleCPU(
    input   clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
    );
    
    
    // 数据接线
    wire [31:0]            pc_pc;  // PC pc输出  
    wire [31:0] irom_instruction;  // IROM inst输出
    wire [31:0]         sext_ext;  // SEXT ext输出
    wire [31:0]            rf_wd;  // RF wd输入
    wire [31:0]           rf_rd1;  // RF rD1输出
    wire [31:0]           rf_rd2;  // RF rD2输出
    wire [31:0]            alu_a;  // ALu A输入
    wire [31:0]            alu_b;  // ALu B输入
    wire [31:0]          alu_cal;  // ALU cal输出
    wire           alu_if_branch;  // ALU if_branch输出
    wire [31:0]        dram_wdin;  // DRAM wdin输入
    wire [31:0]          dram_rd;  // DRAM rd输出
    wire [31:0]         load_ext;  // LOAD ext输出
    wire [31:0]          npc_npc;  // NPC npc输出
    wire [31:0]          npc_pc4;  // NPC pc4输出
    
    // CTRL指令
    wire [ 2:0]     sext_op;  // SEXT 操作
    wire          alu_a_sel;  // ALU A数据选择
    wire          alu_b_sel;  // ALU B数据选择
    wire [ 3:0]      alu_op;  // ALU 操作
    wire [ 1:0]      wd_sel;  // RegFile 写数据选择
    wire              rf_we;  // RegFile 写操作
    wire [ 1:0]    store_op;  // STORE 操作
    wire            dram_we;  // DRAM 写操作
    wire [ 2:0]     load_op;  // LOAD 操作
    wire             branch;  // 分支跳转指令
    wire [ 1:0]      npc_op;  // NPC 操作

    assign debug_wb_have_inst = 1;
    assign debug_wb_pc = pc_pc;
    assign debug_wb_ena = rf_we;
    assign debug_wb_reg = irom_instruction[11:7];
    assign debug_wb_value = rf_wd;
    
    // PC
    PC cpu_pc (
        .rst_n                    (rst_n),    // input wire reset
        .clk                        (clk),    // input wire clk
        .address_i              (npc_npc),    // input wire [31:0] npc_npc
        .address_o                (pc_pc)     // output wire [31:0] pc_pc
    );

    inst_mem imem(
        .a                  (pc_pc[17:2]),    // input wire [15:0] a ([17:2] pc_pc)
        .spo           (irom_instruction)     // output wire [31:0] spo (irom_instruction)
    );
    
    // CTRL
    CTRL cpu_ctrl (
        .opcode   (irom_instruction[6:0]),    // input wire [6:0] irom_instruction
        .funct3 (irom_instruction[14:12]),    // input wire [14:12] irom_instruction
        .funct7 (irom_instruction[31:25]),    // input wire [31:25] irom_instruction
        .sext_op                (sext_op),    // output wire [2:0] sext_op
        .alu_a_sel            (alu_a_sel),    // output wire alu_a_sel
        .alu_b_sel            (alu_b_sel),    // output wire alu_b_sel
        .alu_op                  (alu_op),    // output wire [3:0] alu_op
        .wd_sel                  (wd_sel),    // output wire [1:0] wd_sel
        .rf_we                    (rf_we),    // output wire rf_we
        .store_op              (store_op),    // output wire [1:0] dram_bit
        .dram_we                (dram_we),    // output wire dram_we
        .load_op                (load_op),    // output wire [2:0] load_op
        .branch                  (branch),    // output wire branch
        .npc_op                  (npc_op)     // output wire [1:0] npc_op
    );
    
    // SEXT
    SEXT cpu_sext (
        .op                     (sext_op),    // input wire [2:0] sext_op
        .din     (irom_instruction[31:7]),    // input wire [31:7] irom_instruction
        .ext                   (sext_ext)     // output wire [31:0] sext_ext
    );
    
    // WriteData sel
    assign rf_wd =  (wd_sel == 2'b00) ?  alu_cal:
                    (wd_sel == 2'b01) ? load_ext:
                    (wd_sel == 2'b10) ?  npc_pc4:
                    0;

    
    // RegFile
    RegFile cpu_regfile (
        .clk                        (clk),    // input wire clk
        .rst_n                    (rst_n),    // input wire rst_n
        .we                       (rf_we),    // input wire rf_we
        .rR1    (irom_instruction[19:15]),    // input wire [19:15] irom_instruction
        .rR2    (irom_instruction[24:20]),    // input wire [24:20] irom_instruction
        .wR      (irom_instruction[11:7]),    // input wire [11:7] irom_instruction
        .wD                       (rf_wd),    // input wire [31:0] rf_wd
        .rD1                     (rf_rd1),    // input wire [31:0] rf_wd1
        .rD2                     (rf_rd2)     // input wire [31:0] rf_wd2
     );   
     
     // ALU_A sel
     assign alu_a = (alu_a_sel) ? pc_pc : rf_rd1;
     
     // ALU_B sel
     assign alu_b = (alu_b_sel) ? sext_ext : rf_rd2;
     
     // ALU 
    ALU cpu_alu (
        .op                      (alu_op),    // input wire [3:0] alu_op
        .branch                  (branch),    // input wire branch
        .a                        (alu_a),    // input wire [31:0] alu_a
        .b                        (alu_b),    // input wire [31:0] alu_b
        .if_branch        (alu_if_branch),    // output wire alu_if_branch
        .cal                    (alu_cal)     // output wire [31:0] alu_cal
    );

    // STORE
    STORE cpu_store (
        .op                    (store_op),    // input wire[ 1:0] store_op
        .bite              (alu_cal[1:0]),    // input wire [1:0] ALU.cal[1:0]
        .din                     (rf_rd2),    // input wire [31:0] rf_rd2
        .rd                     (dram_rd),    // input wire [31:0] dram_rd
        .ext                  (dram_wdin)     // output wire [31:0] dram_wdin
    );   
    
    // LOAD
    LOAD cpu_load (
        .op                     (load_op),    // input wire [2:0] load_op
        .bite              (alu_cal[1:0]),    // input wire [1:0] ALU.cal[1:0]
        .din                    (dram_rd),    // input wire [31:0] alu_cal
        .ext                   (load_ext)     // output wire[31:0] load_ext
    );
    
    // NPC
    NPC cpu_npc (
        .op                      (npc_op),    // input wire [1:0] npc_op
        .if_branch        (alu_if_branch),    // input wire alu_if_branch
        .pc                       (pc_pc),    // input wire [31:0] pc_pc
        .ra                      (rf_rd1),    // input wire [31:0] rf_rd1
        .imm                   (sext_ext),    // input wire [31:0] sext_ext
        .npc                    (npc_npc),    // output wire [31:0] npc_npc
        .pc4                    (npc_pc4)     // output wire [31:0] npc_pc4
    );

    // BUS
    BUS bus(
        .clk                        (clk),
        .rst_n                    (rst_n),
        .write                  (dram_we),    // 写使能信号
        .writedata            (dram_wdin),    // 从cpu写入到bus的数据
        .address                (alu_cal),    // 地址
        .readdata               (dram_rd)     // 从设备读取到bus的数据
    );
    
    
endmodule