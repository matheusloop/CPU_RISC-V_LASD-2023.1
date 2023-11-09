/*----> SAIDA <----*/
module ParallelOUT (input logic EN, clk, rst,
						  input logic [7:0] Address,
						  input logic [31:0] RegData,
						  output logic [31:0] DataOUT);

	always_ff @(posedge clk or negedge rst) begin
		
		if(!rst)
			DataOUT = 8'h00;
		else if ((Address == 8'hFC) && EN)
			DataOUT = RegData;
	end
endmodule


/*----> ENTRADA <----*/
module ParallelIN (input logic [7:0] Address,
						 input logic [31:0] MemData, DataIN,
						 output logic[31:0] RegData);

	always_comb begin
		case(Address == 8'hFC)
			1'b0: RegData = MemData;
			1'b1: RegData = DataIN;
			default: RegData = 8'bxxxxxxxx;
		endcase
	end			 
endmodule
