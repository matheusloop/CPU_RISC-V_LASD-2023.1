//Banco de registradores
module RegisterFile (input logic clk, rst, we3,
                     input logic [4:0] wa3, ra1, ra2,
                     input logic [31:0] wd3,
                     output logic [31:0] rd1, rd2,
							output logic [31:0]  reg0,  reg1,  reg2,  reg3,  reg4,  reg5,  reg6,  reg7,
													   reg8,  reg9, reg10, reg11, reg12, reg13, reg14, reg15,
												     reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23,
												     reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31);
							  
  logic [31:0]registerBank[31:0];
  int cont;
  
  //Parte sequencial
  always@(posedge clk or negedge rst) begin
    
    if(!rst)
		for(cont = 0; cont <= 7; cont++)
			registerBank[cont] = 0;
    
    else if (we3 && (wa3 != 0))
      registerBank[wa3] = wd3;
    
    else
      registerBank = registerBank;
    
		reg0  <= registerBank[0];
		reg1  <= registerBank[1];
		reg2  <= registerBank[2];
		reg3  <= registerBank[3];
		reg4  <= registerBank[4];
		reg5  <= registerBank[5];
		reg6  <= registerBank[6];
		reg7  <= registerBank[7];
		reg8  <= registerBank[8];
		reg9  <= registerBank[9];
		reg10 <= registerBank[10];
		reg11 <= registerBank[11];
		reg12 <= registerBank[12];
		reg13 <= registerBank[13];
		reg14 <= registerBank[14];
		reg15 <= registerBank[15];
		reg16 <= registerBank[16];
		reg17 <= registerBank[17];
		reg18 <= registerBank[18];
		reg19 <= registerBank[19];
		reg20 <= registerBank[20];
		reg21 <= registerBank[21];
		reg22 <= registerBank[22];
		reg23 <= registerBank[23];
		reg24 <= registerBank[24];
		reg25 <= registerBank[25];
		reg26 <= registerBank[26];
		reg27 <= registerBank[27];
		reg28 <= registerBank[28];
		reg29 <= registerBank[29];
		reg30 <= registerBank[30];
		reg31 <= registerBank[31];
    
  end
  
  //Parte combinacional
  always_comb begin
    rd1 = registerBank[ra1];
    rd2 = registerBank[ra2];
  end

endmodule