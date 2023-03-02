
module BUS(
    input                   write, // дʹ���ź�
    input  [31:0]      IOreaddata, // ���豸��ȡ��bus������
    input  [31:0]       writedata, // ��cpuд�뵽bus������
	input  [31:0]         address, // ��ַ
	output [31:0]     IOwritedata, // ��busд�뵽�豸������
	output [31:0]        readdata, // ��bus��ȡ��cp������
	output                IOwrite, // �豸дʹ���ź�
	output [31:0]       IOaddress, // �豸��ַ
	output               bus_en_0, // DRAM 
    output               bus_en_1,
    output               bus_en_2,
    output               bus_en_3,
    output               bus_en_4,
    output               bus_en_5
    );
    
    assign bus_en_0 = address <= 32'h001F_FFFF ? 1 : 0 ;
    assign bus_en_1 = (address >= 32'hFFFF_F000 && address <= 32'hFFFF_F00E) ? 1 : 0 ;
    assign bus_en_2 = (address >= 32'hFFFF_F010 && address <= 32'hFFFF_F05E) ? 1 : 0 ;
    assign bus_en_3 = (address >= 32'hFFFF_F060 && address <= 32'hFFFF_F06E) ? 1 : 0 ;
    assign bus_en_4 = (address >= 32'hFFFF_F070 && address <= 32'hFFFF_F077) ? 1 : 0 ;
    assign bus_en_5 = address >= 32'hFFFF_F078 ? 1 : 0 ;
    
    assign IOwrite = write;
    assign IOwritedata = writedata;
    assign readdata = IOreaddata;
    assign IOaddress = address;
    
endmodule