//Modulo da Unidade Lógico artmética
module ULA (input logic signed [31:0] SrcA, SrcB,
            input logic [3:0] ULAControl,
				input logic UnSig,
            output logic [31:0] ULAResult,
            output logic Z);
  
	logic [63:0] aux;
  
  always_comb begin
	 aux = 0;
    case (ULAControl)
      4'b0000: ULAResult = SrcA + SrcB;          //ADD
      4'b0001: ULAResult = SrcA + ~SrcB + 8'h01; //SUBTRACT
      4'b0010: ULAResult = SrcA & SrcB;          //AND
      4'b0011: ULAResult = SrcA | SrcB;          //OR
      4'b0101: ULAResult = (!UnSig)? SrcA < SrcB: {1'b0, SrcA} < {1'b0, SrcB} ;  	 	    //SLT
		4'b0100: ULAResult = SrcA ^ SrcB;  	 	    //XOR
		4'b0110: ULAResult = SrcA << SrcB; 			 //SLL
		4'b0111: ULAResult = SrcA >> SrcB; 			 //SRL
		
		4'b1000: begin aux = (SrcA * SrcB); ULAResult = aux[31:0];  end	 //MUL
		4'b1001: begin aux = (SrcA * SrcB); ULAResult = aux[63:32]; end  //MULH
		
		4'b1100: ULAResult = SrcA / SrcB;		 //DIV
		4'b1110: ULAResult = SrcA % SrcB;		 //REM
		
      default: ULAResult = 0;
    endcase
    
    Z = (ULAResult == 0);
    
  end
endmodule
