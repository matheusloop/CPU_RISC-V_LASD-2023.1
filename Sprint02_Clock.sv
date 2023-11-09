//Divisivor de clock
module ClockDivider # (parameter OLD_FREQ = 10, WANTED_FREQ = 1) (input logic reset, oldCLK, output logic newCLK);
  
  logic [31:0] cont;
  
  always @ (posedge oldCLK or negedge reset) begin
    
    if (!reset) begin
      cont <= 0;
      newCLK <= 0;
    end
    
    else if (cont < (OLD_FREQ /(2 * WANTED_FREQ)) - 1) begin
      cont <= cont + 1;
    end
    
    else begin
      newCLK <= ~newCLK;
      cont <= 0;
    end
    
  end

endmodule

//Decodificador de hexa para 7 seg
module SevenSegDecoder(input logic [3:0] In, output logic [6:0] out);
  
  always_comb begin
    
    case (In)
		4'h0: out = 7'b0000001;
      4'h1: out = 7'b1001111;
      4'h2: out = 7'b0010010;
      4'h3: out = 7'b0000110;
      4'h4: out = 7'b1001100;
      4'h5: out = 7'b0100100;
      4'h6: out = 7'b0100000;
      4'h7: out = 7'b0001111;
      4'h8: out = 7'b0000000;
      4'h9: out = 7'b0000100;
      4'hA: out = 7'b0001000;
      4'hB: out = 7'b1100000;
      4'hC: out = 7'b0110001;
      4'hD: out = 7'b1000010;
      4'hE: out = 7'b0110000;
      4'hF: out = 7'b0111000;
      default: out = 7'hFF;
    endcase
    
  end
  
endmodule


//Contador Mod 10
module ContM_10 (input logic clk, reset, output logic [3:0] out);
	
	always @ (posedge clk or negedge reset) begin
	
		if(!reset) begin
			out = 4'h0;
		end
		
		else if (out >= 4'h9) begin
			out = 4'h0;
		end
		
		else begin
			out = out + 4'h1;
		end
		
	end
	
endmodule

/* --------------------------------------------- DESAFIO --------------------------------------------- */

//Animação no 7 seg
module SevenSegAnimation #(parameter LEN = 4'h1)(input logic clk, reset, direction, output logic [27:0]out);
  
  logic [11:0]temp;
  
  always @ (posedge clk or negedge reset) begin
	
	if(!reset) begin
		out = 28'hFFFFFFFF;
		temp = {(4'hF >> LEN),8'hFF};
	end
	
	else begin
		case(direction)
			1'b0: temp = {temp[0],temp[11:1]};
			1'b1: temp = {temp[10:0],temp[11]};
			default temp = 12'h7FF;
		endcase
		
	end
	
	{out[27], out[20], out[13], out[6], out[5], out[4], out[3], out[10], out[17], out[24], out[23], out[22]} = temp;
	
  end
  
endmodule














