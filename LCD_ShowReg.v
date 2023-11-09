module	LCD_ShowReg (	//	Host Side
					iCLK,iRST_N,
					sel,
					reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7,
					reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15,
					reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23,
					reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31,
					//	LCD Side
					LCD_DATA,LCD_RW,LCD_EN,LCD_RS	);
//	Host Side
input			iCLK,iRST_N;
// Data test
input  [3:0] sel;
input  [31:0] 	reg0,   reg1,  reg2, reg3, reg4, reg5, reg6, reg7,
					reg8,   reg9,  reg10, reg11, reg12, reg13, reg14, reg15,
					reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23,
					reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
//	LCD Side
output	[7:0]	LCD_DATA;
output			LCD_RW,LCD_EN,LCD_RS;
//	Internal Wires/Registers
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;
wire		mLCD_Done;

parameter	LCD_INTIAL	=	0;
parameter	LCD_RESTART	=	4;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	LCD_LINE2+16-1;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					if(LUT_INDEX<LUT_SIZE)
						LUT_INDEX	<=	LUT_INDEX+1;
					else
						LUT_INDEX	<=	LCD_RESTART;
					mLCD_ST	<=	0;
				end
			endcase
		end
	end
end

function [8:0] hex2char;
	input [3:0] h;
	hex2char = (h>9 ? 9'h137 : 9'h130) + h;	
endfunction



reg [31:0] linha1, linha2;

always
begin

	case(sel)
		4'd0:  begin linha1 = reg0;  linha2 = reg1;  end
		4'd1:  begin linha1 = reg2;  linha2 = reg3;  end
		4'd2:  begin linha1 = reg4;  linha2 = reg5;  end
		4'd3:  begin linha1 = reg6;  linha2 = reg7;  end
		4'd4:  begin linha1 = reg8;  linha2 = reg9;  end
		4'd5:  begin linha1 = reg10; linha2 = reg11; end
		4'd6:  begin linha1 = reg12; linha2 = reg13; end
		4'd7:  begin linha1 = reg14; linha2 = reg15; end
		4'd8:  begin linha1 = reg16; linha2 = reg17; end
		4'd9:  begin linha1 = reg18; linha2 = reg19; end
		4'd10: begin linha1 = reg20; linha2 = reg21; end
		4'd11: begin linha1 = reg22; linha2 = reg23; end
		4'd12: begin linha1 = reg24; linha2 = reg25; end
		4'd13: begin linha1 = reg26; linha2 = reg27; end
		4'd14: begin linha1 = reg28; linha2 = reg29; end
		4'd15: begin linha1 = reg30; linha2 = reg31; end
		default: begin linha1 = 0; linha2 = 0; end
	endcase


	case(LUT_INDEX)
	//	Initial
	LCD_INTIAL+0:	LUT_DATA	<=	9'h038;
	LCD_INTIAL+1:	LUT_DATA	<=	9'h00C;
	LCD_INTIAL+2:	LUT_DATA	<=	9'h001;
	LCD_INTIAL+3:	LUT_DATA	<=	9'h006;
	LCD_INTIAL+4:	LUT_DATA	<=	9'h080;
	//	Line 1	
	LCD_LINE1+0:	LUT_DATA	<=	9'h120;
	LCD_LINE1+1:	LUT_DATA	<=	9'h120;
	LCD_LINE1+2:	LUT_DATA	<=	9'h120;
	LCD_LINE1+3:	LUT_DATA	<=	9'h120;    
	LCD_LINE1+4:	LUT_DATA	<=	hex2char(linha1[31:28]);
	LCD_LINE1+5:	LUT_DATA	<=	hex2char(linha1[27:24]);
	LCD_LINE1+6:	LUT_DATA	<=	hex2char(linha1[23:20]);     
	LCD_LINE1+7:	LUT_DATA	<=	hex2char(linha1[19:16]);
	LCD_LINE1+8:	LUT_DATA	<=	hex2char(linha1[15:12]);
	LCD_LINE1+9:	LUT_DATA	<=	hex2char(linha1[11: 8]); 
	LCD_LINE1+10:	LUT_DATA	<=	hex2char(linha1[ 7: 4]);
	LCD_LINE1+11:	LUT_DATA	<=	hex2char(linha1[ 3: 0]);
	LCD_LINE1+12:	LUT_DATA	<=	9'h120;     
	LCD_LINE1+13:	LUT_DATA	<=	9'h120;
	LCD_LINE1+14:	LUT_DATA	<=	hex2char((sel*2)/10);
	LCD_LINE1+15:	LUT_DATA	<=	hex2char((sel*2)%10);
	//	Change Line               
	LCD_CH_LINE:	LUT_DATA	<=  9'h0C0;	                    
	//	Line 2                    
	LCD_LINE2+0:	LUT_DATA	<=	9'h120;
	LCD_LINE2+1:	LUT_DATA	<=	9'h120;
	LCD_LINE2+2:	LUT_DATA	<=	9'h120;
	LCD_LINE2+3:	LUT_DATA	<=	9'h120;    
	LCD_LINE2+4:	LUT_DATA	<=	hex2char(linha2[31:28]);
	LCD_LINE2+5:	LUT_DATA	<=	hex2char(linha2[27:24]);
	LCD_LINE2+6:	LUT_DATA	<=	hex2char(linha2[23:20]);     
	LCD_LINE2+7:	LUT_DATA	<=	hex2char(linha2[19:16]);
	LCD_LINE2+8:	LUT_DATA	<=	hex2char(linha2[15:12]);
	LCD_LINE2+9:	LUT_DATA	<=	hex2char(linha2[11: 8]); 
	LCD_LINE2+10:	LUT_DATA	<=	hex2char(linha2[ 7: 4]);
	LCD_LINE2+11:	LUT_DATA	<=	hex2char(linha2[ 3: 0]);
	LCD_LINE2+12:	LUT_DATA	<=	9'h120;     
	LCD_LINE2+13:	LUT_DATA	<=	9'h120;
	LCD_LINE2+14:	LUT_DATA	<=	hex2char((sel*2+1)/10);
	LCD_LINE2+15:	LUT_DATA	<=	hex2char((sel*2+1)%10);
	default:	    LUT_DATA	<=	9'h120;     
	endcase
end

LCD_Controller 		u0	(	//	Host Side
							.iDATA(mLCD_DATA),
							.iRS(mLCD_RS),
							.iStart(mLCD_Start),
							.oDone(mLCD_Done),
							.iCLK(iCLK),
							.iRST_N(iRST_N),
							//	LCD Interface
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS)	);

endmodule
