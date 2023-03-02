module BUS(
    input                     clk,
    input                   rst_n,
    input                   write, // 写使能信号
    input  [31:0]       writedata, // 从cpu写入到bus的数据
	input  [31:0]         address, // 地址
	output [31:0]        readdata  // 从设备读取到bus的数据
    );
    
    wire bus_en_0; // DRAM 
    wire bus_en_1;
    wire bus_en_2;
    wire bus_en_3;
    wire bus_en_4;
    wire bus_en_5;
    
    wire dram_write;
    wire [31:0] dram_address;
    wire [31:0] dram_readdata;
    
    assign bus_en_0 = address <= 32'h005F_FFFF ? 1 : 0 ;
    assign bus_en_1 = ( address >= 32'hFFFF_F000 && address <= 32'hFFFF_F00E) ? 1 : 0 ;
    assign bus_en_2 = ( address >= 32'hFFFF_F010 && address <= 32'hFFFF_F05E) ? 1 : 0 ;
    assign bus_en_3 = ( address >= 32'hFFFF_F060 && address <= 32'hFFFF_F06E) ? 1 : 0 ;
    assign bus_en_4 = ( address >= 32'hFFFF_F070 && address <= 32'hFFFF_F077) ? 1 : 0 ;
    assign bus_en_5 = address >= 32'hFFFF_F078 ? 1 : 0 ;
    
    assign readdata = bus_en_0 ? dram_readdata
    : 0 ;
    
    assign dram_write = bus_en_0 & write;
    assign dram_address = address;// - 16'h4000;
    
    
    
    // DRAM 0设备
    data_mem dmem(
        .clk                        (clk),    // input wire clk
        .we                  (dram_write),    // input wire wea (dram_write)
        .a           (dram_address[17:2]),    // input wire [15:0] addra (dram_address[17:2]) 
        .d                    (writedata),    // input wire [31:0] dina (writedata)
        .spo              (dram_readdata)     // output wire [31:0] douta (readdata)
    );
    
endmodule