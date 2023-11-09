`default_nettype none //Comando para desabilitar declaração automática de wires
module Mod_Teste (
//Clocks
input CLOCK_27, CLOCK_50,
//Chaves e Botoes
input [3:0] KEY,
input [17:0] SW,
//Displays de 7 seg e LEDs
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
output [8:0] LEDG,
output [17:0] LEDR,
//Serial
output UART_TXD,
input UART_RXD,
inout [7:0] LCD_DATA,
output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
//GPIO
inout [35:0] GPIO_0, GPIO_1
);
assign GPIO_1 = 36'hzzzzzzzzz;
assign GPIO_0 = 36'hzzzzzzzzz;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5, w_d0x6,  w_d0x7,
			  w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5, w_d1x6,  w_d1x7;
/*
LCD_TEST MyLCD (
.iCLK ( CLOCK_50 ),
.iRST_N ( KEY[0] ),
.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5),
.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
.LCD_DATA( LCD_DATA ),
.LCD_RW ( LCD_RW ),
.LCD_EN ( LCD_EN ),
.LCD_RS ( LCD_RS )
);
*/
/*
LCD_ShowReg (	//	Host Side
					.iCLK(CLOCK_50), .iRST_N(KEY[0]),
					.sel(SW[17:14]),
					  .reg0(w_reg0),   .reg1(w_reg1),   .reg2(w_reg2),   .reg3(w_reg3),   .reg4(w_reg4),   .reg5(w_reg5),   .reg6(w_reg6),   .reg7(w_reg7),
					  .reg8(w_reg8),   .reg9(w_reg9), .reg10(w_reg10), .reg11(w_reg11), .reg12(w_reg12), .reg13(w_reg13), .reg14(w_reg14), .reg15(w_reg15),
					.reg16(w_reg16), .reg17(w_reg17), .reg18(w_reg18), .reg19(w_reg19), .reg20(w_reg20), .reg21(w_reg21), .reg22(w_reg22), .reg23(w_reg23),
					.reg24(w_reg24), .reg25(w_reg25), .reg26(w_reg26), .reg27(w_reg27), .reg28(w_reg28), .reg29(w_reg29), .reg30(w_reg30), .reg31(w_reg31),
					//	LCD Side
					.LCD_DATA(LCD_DATA),.LCD_RW(LCD_RW),.LCD_EN(LCD_EN),.LCD_RS(LCD_RS));
*/

//---------- modifique a partir daqui --------


wire [31:0]  w_reg0,  w_reg1,  w_reg2,  w_reg3,  w_reg4,  w_reg5,  w_reg6,  w_reg7,
				 w_reg8,  w_reg9, w_reg10, w_reg11, w_reg12, w_reg13, w_reg14, w_reg15,
				w_reg16, w_reg17, w_reg18, w_reg19, w_reg20, w_reg21, w_reg22, w_reg23,
				w_reg24, w_reg25, w_reg26, w_reg27, w_reg28, w_reg29, w_reg30, w_reg31;

//Wires from Control Unit
wire w_ULASrc, w_RegWrite, w_MemWrite, w_Branch, w_Jump, w_UnSig;
wire [1:0] w_ImmSrc, w_ResultSrc, w_PCSrc, LSControl;
wire [3:0] w_ULAControl;

wire w_Zero; 

wire [31:0] w_PCp4, w_PC, w_rd1SrcA, w_rd2, w_SrcB, w_ULAResult, w_Wd3, w_Imm, w_RData;
wire [31:0] w_DataOut, w_DataIn, w_RegData, w_StoreData, w_LoadData;
wire [31:0] w_ImmPC, w_PCn;
wire [31:0] w_inst;

wire CLOCK_1;

wire [255:0] w_Symbols;

//------> Instâncias <------//


/*---------> Writing on LCD <---------*/
LCD_Write (.clk(CLOCK_1), .rst(KEY[0]), .next(w_DataOut[9]), .previous(w_DataOut[8]),
			  .AsciiIn(w_DataOut[7:0]),.Symbols(w_Symbols));

LCD_ShowAscII (.iCLK(CLOCK_50), .iRST_N(KEY[0]),
					.LCD_DATA(LCD_DATA),.LCD_RW(LCD_RW),.LCD_EN(LCD_EN),.LCD_RS(LCD_RS),
					.Symbols(w_Symbols));
						
						
						
//PC OK
PC PC01 (.clk(CLOCK_1), .rst(KEY[0]), .PCin(w_PCn), .PC(w_PC)); 


//Adder4 OK
My_Adder adder4 (.In01(w_PC), .In02(32'h4), .Out(w_PCp4));


//Adder Imm OK
My_Adder adder_Imm (.In01(w_Imm), .In02(w_PC), .Out(w_ImmPC));


//Instruction_memory OK
Instruction_memory IM (.Adress(w_PC), .RD(w_inst)); 


//Register_File OK
RegisterFile bank01 (.clk(CLOCK_1), .rst(KEY[0]), .we3(w_RegWrite), .wa3(w_inst[11:7]), .ra1(w_inst[19:15]), .ra2(w_inst[24:20]), .wd3(w_Wd3), .rd1(w_rd1SrcA), .rd2(w_rd2),
					   .reg0(w_reg0),   .reg1(w_reg1),   .reg2(w_reg2),   .reg3(w_reg3),   .reg4(w_reg4),   .reg5(w_reg5),   .reg6(w_reg6),   .reg7(w_reg7),
					   .reg8(w_reg8),   .reg9(w_reg9), .reg10(w_reg10), .reg11(w_reg11), .reg12(w_reg12), .reg13(w_reg13), .reg14(w_reg14), .reg15(w_reg15),
					 .reg16(w_reg16), .reg17(w_reg17), .reg18(w_reg18), .reg19(w_reg19), .reg20(w_reg20), .reg21(w_reg21), .reg22(w_reg22), .reg23(w_reg23),
					.reg24(w_reg24), .reg25(w_reg25), .reg26(w_reg26), .reg27(w_reg27), .reg28(w_reg28), .reg29(w_reg29), .reg30(w_reg30), .reg31(w_reg31)); 


//Control_Unit OK
Control_Unit unit01(.OP(w_inst[6:0]), .Funct3(w_inst[14:12]), .Funct7(w_inst[31:25]), .Zero(w_Zero),
						  .ResultSrc(w_ResultSrc), .MemWrite(w_MemWrite), .ULAControl(w_ULAControl), .ULASrc(w_ULASrc), .ImmSrc(w_ImmSrc), .RegWrite(w_RegWrite),
						  .PCSrc(w_PCSrc), .UnSig(w_UnSig), .LSControl(LSControl));

 
 
 
//Mux Imm Src
ImmediateExtender(.ImmSrc(w_ImmSrc),
						.Imm_I(w_inst[31:20]),
						.Imm_S({w_inst[31:25], w_inst[11:7]}),
                  .Imm_B({w_inst[31], w_inst[7], w_inst[30:25], w_inst[11:8], 1'b0}),
                  .Imm_J({w_inst[31], w_inst[19:12], w_inst[20], w_inst[30:21], 1'b0}),
                  .Out(w_Imm));


//MUX ULA Src OK
MUX2x1 #(.SIZE(32)) MuxULASrc(.i0(w_rd2), .i1(w_Imm), .sel(w_ULASrc), .out(w_SrcB)); 


//MUX MuxResSrc OK
Mux4x1 #(.SIZE(32)) MuxResSrc(.In0(w_ULAResult), .In1(w_RegData), .In2(w_PCp4), .In3({w_inst[31:12], 12'h000}), .Sel(w_ResultSrc), .Out(w_Wd3));


//MUX PCSrc OK
Mux4x1 #(.SIZE(32)) MuxPCSrc(.In0(w_PCp4), .In1(w_ImmPC), .In2(w_ULAResult), .In3(w_ULAResult), .Sel(w_PCSrc), .Out(w_PCn));
  

//ULA OK
ULA ula01 (.SrcA(w_rd1SrcA), .SrcB(w_SrcB), .ULAControl(w_ULAControl), .UnSig(w_UnSig), .ULAResult(w_ULAResult), .Z(w_Zero)); 


StoresControler SC (.SControl(LSControl),
						  .Address(w_ULAResult),
						  .DataIn(w_rd2), .MemData(w_RData),
						  .DataOut(w_StoreData));



//Data Memory OK
DataMemory DataMem (.clk(CLOCK_1), .we(w_MemWrite), .rst(KEY[0]), .Adress(w_ULAResult), .WD(w_StoreData), .RD(w_RData)); 


//LoadControl OK
LoadsControler LC (.LControl(LSControl),
						 .Address(w_ULAResult),
						 .DataIn(w_RData),
						 .DataOut(w_LoadData));


//Parallel OUT
ParallelOUT pOut (.EN(w_MemWrite), .clk(CLOCK_1), .rst(KEY[0]), .RegData(w_rd2), .Address(w_ULAResult), .DataOUT(w_DataOut));


//Parallel IN 
ParallelIN pIN(.Address(w_ULAResult), .MemData(w_LoadData), .DataIN(w_DataIn), .RegData(w_RegData));


/* ----------------> DEBUG <----------------*/

ClockDivider  # (.OLD_FREQ(50000000), .WANTED_FREQ(10)) clock1Hz (.reset(KEY[0]), .oldCLK(CLOCK_50), .newCLK(CLOCK_1));

assign w_d1x4 = w_DataOut;
assign w_DataIn = SW[9:0];
//assign w_DataIn = KEY[3];
assign LEDR[17] = w_d0x1;

assign LEDG[8] = CLOCK_1;
assign w_d0x4 = w_PC;
assign LEDR[8:0] = {w_RegWrite, w_ImmSrc, w_ULASrc, w_ULAControl, w_MemWrite, w_ResultSrc, w_Branch};

/*
wire [9:0]tempo;

assign tempo = 'h4 * w_DataOut;

SevenSegDecoder hex0 (.In(tempo[3:0]),   .out(HEX0));
SevenSegDecoder hex1 (.In(tempo[7:4]),   .out(HEX1));
SevenSegDecoder hex2 (.In(tempo[9:8]),   .out(HEX2));
*/






SevenSegDecoder hex0 (.In(w_inst[3:0]),   .out(HEX0));
SevenSegDecoder hex1 (.In(w_inst[7:4]),   .out(HEX1));
SevenSegDecoder hex2 (.In(w_inst[11:8]),  .out(HEX2));
SevenSegDecoder hex3 (.In(w_inst[15:12]), .out(HEX3));
SevenSegDecoder hex4 (.In(w_inst[19:16]), .out(HEX4));
SevenSegDecoder hex5 (.In(w_inst[23:20]), .out(HEX5));
SevenSegDecoder hex6 (.In(w_inst[27:24]), .out(HEX6));
SevenSegDecoder hex7 (.In(w_inst[31:28]), .out(HEX7));

endmodule


