//DataMemory
module DataMemory (input logic clk, we, rst,
                   input logic [7:0] Adress,
						 input logic [31:0] WD,
                   output logic[31:0] RD);
  
  logic [31:0] memory [255:0];
  int i;

  //Escrita (Sequencial)
  always_ff@(posedge clk or negedge rst) begin
    
    if(!rst)
      for (i = 0; i < 256; i++)
        memory[i] = 8'h0;
    
    else if (we)
      memory[Adress/4] = WD;
    
    else
      memory[Adress/4] = memory[Adress/4];
    
  end
  
  //Leitura (Combinacional)
  always_comb
    RD = memory[Adress/4];
  
endmodule