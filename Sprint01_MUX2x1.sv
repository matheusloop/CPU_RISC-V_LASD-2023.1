//Mux 2x1
module MUX2x1 #(parameter SIZE = 8)(input [SIZE-1:0] i0, i1, input sel, output reg [SIZE-1:0] out);
	always @ (*) out = (sel)? i1 : i0;
endmodule 


//Mux 4x1
module Mux4x1 #(parameter SIZE = 8)(input logic [SIZE-1:0] In0, In1, In2, In3,
												input logic [1:0] Sel,
												output logic[SIZE-1:0] Out);
	
	always_comb
		case (Sel)
			2'h0: Out = In0;
			2'h1: Out = In1;
			2'h2: Out = In2;
			2'h3: Out = In3;
			default: Out = 8'bxxxxxxxx;
		endcase
endmodule