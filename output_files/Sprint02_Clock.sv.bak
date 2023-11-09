//Divisivor de clock

module ClockDivider # (parameter OLDCLK_FREQ = 10) (input logic reset, oldCLK, output logic newCLK);
  
  logic [31:0] cont;
  
  always @ (posedge oldCLK or negedge reset) begin
    
    if (!reset) begin
      cont <= 0;
      newCLK <= 0;
    end
    
    else if (cont < (OLDCLK_FREQ/2) - 1) begin
      cont <= cont + 1;
    end
    
    else begin
      newCLK <= ~newCLK;
      cont <= 0;
    end
    
  end

endmodule