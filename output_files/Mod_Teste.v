module MUX2x1 #(parameter SIZE = 8)(input [SIZE-1:0] i0, i1, input sel, output reg [SIZE-1:0] out);
	
	always @ (*) out = (sel)? i1 : i0;

endmodule
