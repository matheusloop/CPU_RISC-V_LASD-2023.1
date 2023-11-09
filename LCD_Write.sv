/*-------------> LCD_Write <-------------*/
module LCD_Write (input logic clk, rst, next, previous,
                  input logic [7:0] AsciiIn,
						output logic [255:0] Symbols);
  
  logic [4:0] pos = 0;
  logic [7:0] Sym [31:0];
  
  
  always_ff@(posedge previous or posedge next or negedge rst) begin
		if (!rst) pos = 5'b0;
		
		else begin
			if (previous) pos--;
			else if (next) pos++;
		end
  end

  
  always_ff@(posedge clk or negedge rst) begin
      if(!rst) begin
  
			for(int i = 0; i < 32; i++)
			  Sym[i] = 8'd32;
    
    end
    
    else begin
      Sym[pos] = AsciiIn;
      Symbols = { Sym[0],  Sym[1],  Sym[2],  Sym[3],   Sym[4],  Sym[5],  Sym[6],  Sym[7],
					   Sym[8],  Sym[9],  Sym[10], Sym[11], Sym[12], Sym[13], Sym[14], Sym[15],
					  Sym[16], Sym[17],  Sym[18], Sym[19], Sym[20], Sym[21], Sym[22], Sym[23],
					  Sym[24], Sym[25],  Sym[26], Sym[27], Sym[28], Sym[29], Sym[30], Sym[31]};
      
    end
      
  end
  
endmodule
