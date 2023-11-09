/* ---> PC <--- */
module PC (input logic clk, rst,
			  input logic [31: 0] PCin,
			  output logic [31:0] PC);
	  
	  always_ff @ (posedge clk or negedge rst) begin
    if (!rst)
      PC = 32'h0;
    else
      PC = PCin;
  end
  
endmodule

/* ---> Control_Unit <--- */
module Control_Unit (input logic [6:0] OP,
                     input logic [2:0] Funct3,
                     input logic [6:0] Funct7,
                     input logic Zero,
                     output logic [3:0] ULAControl,
                     output logic [1:0] ImmSrc, ResultSrc, PCSrc, LSControl,
                     output logic ULASrc, RegWrite, MemWrite, UnSig);
  
  logic [15:0] exit;
  
  always_comb begin
    casex ({OP, Funct3, Funct7})
	  //    OP    |Funct3| |  Funct7 | 		   |ReWr | ImS | ULAS | ULAC | MeWr | ReSr | PCSr|  UnSig | LSControl | 
      //R TYPE
      {7'b0110011, 3'b000, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0000, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // ADD
      {7'b0110011, 3'b000, 7'b0100000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0001, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SUB
      {7'b0110011, 3'b111, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0010, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // AND
      {7'b0110011, 3'b110, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0011, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // OR
      {7'b0110011, 3'b010, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0101, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SLT
		{7'b0110011, 3'b011, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0101, 1'b0, 2'b00, 2'b00, 1'b1, 2'b00}; // SLTU*
		{7'b0110011, 3'b100, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0100, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // XOR*
		{7'b0110011, 3'b001, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0110, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SLL*
		{7'b0110011, 3'b101, 7'b0000000}: exit = {1'b1, 2'bxx, 1'b0, 4'b0111, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SRL*
		{7'b0110011, 3'b000, 7'b0000001}: exit = {1'b1, 2'bxx, 1'b0, 4'b1000, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // MUL*
		{7'b0110011, 3'b001, 7'b0000001}: exit = {1'b1, 2'bxx, 1'b0, 4'b1001, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // MULH*
		
		{7'b0110011, 3'b100, 7'b0000001}: exit = {1'b1, 2'bxx, 1'b0, 4'b1100, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // DIV*
		
		{7'b0110011, 3'b110, 7'b0000001}: exit = {1'b1, 2'bxx, 1'b0, 4'b1110, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // REM*
      
      //I TYPE
      {7'b0010011, 3'b000, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0000, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // ADDi
      {7'b0010011, 3'b111, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0010, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // ANDi*
      {7'b0010011, 3'b110, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0011, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // ORi*
      {7'b0010011, 3'b010, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0101, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SLTi*
		{7'b0010011, 3'b011, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0101, 1'b0, 2'b00, 2'b00, 1'b1, 2'b00}; // SLTIU*
      {7'b0010011, 3'b100, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0100, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // XORi*
		{7'b0010011, 3'b001, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0110, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SLLi*
		{7'b0010011, 3'b101, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0111, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00}; // SRLi*
		
      {7'b0000011, 3'b000, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0000, 1'b0, 2'b01, 2'b00, 1'b0, 2'b01}; // LB
      {7'b0000011, 3'b010, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0000, 1'b0, 2'b01, 2'b00, 1'b0, 2'b00}; // LW
		{7'b0000011, 3'b001, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0000, 1'b0, 2'b01, 2'b00, 1'b0, 2'b10}; // LH
		
      
      //S TYPE
      {7'b0100011, 3'b000, 7'bxxxxxxx}: exit = {1'b0, 2'b01, 1'b1, 4'b0000, 1'b1, 2'bxx, 2'b00, 1'b0, 2'b01}; // SB
      {7'b0100011, 3'b010, 7'bxxxxxxx}: exit = {1'b0, 2'b01, 1'b1, 4'b0000, 1'b1, 2'bxx, 2'b00, 1'b0, 2'b00}; // SW
      {7'b0100011, 3'b001, 7'bxxxxxxx}: exit = {1'b0, 2'b01, 1'b1, 4'b0000, 1'b1, 2'bxx, 2'b00, 1'b0, 2'b10}; // SH
		
      
      //B TYPE
      {7'b1100011, 3'b000, 7'bxxxxxxx}: exit = {1'b0, 2'b10, 1'b0, 4'b0001, 1'b0, 2'bxx, 2'b00, 1'b0, 2'b00}; // BEQ
      {7'b1100011, 3'b001, 7'bxxxxxxx}: exit = {1'b0, 2'b10, 1'b0, 4'b0001, 1'b0, 2'bxx, 2'b00, 1'b0, 2'b00}; // BNE*
      {7'b1100011, 3'b100, 7'bxxxxxxx}: exit = {1'b0, 2'b10, 1'b0, 4'b0101, 1'b0, 2'bxx, 2'b00, 1'b0, 2'b00}; // BLT*
		{7'b1100011, 3'b110, 7'bxxxxxxx}: exit = {1'b0, 2'b10, 1'b0, 4'b0101, 1'b0, 2'bxx, 2'b00, 1'b1, 2'b00}; // BLTU*
      {7'b1100011, 3'b101, 7'bxxxxxxx}: exit = {1'b0, 2'b10, 1'b0, 4'b0101, 1'b0, 2'bxx, 2'b00, 1'b0, 2'b00}; // BGE*
		{7'b1100011, 3'b111, 7'bxxxxxxx}: exit = {1'b0, 2'b10, 1'b0, 4'b0101, 1'b0, 2'bxx, 2'b00, 1'b1, 2'b00}; // BGEU*
      
      //J TYPE
      {7'b1101111, 3'bxxx, 7'bxxxxxxx}: exit = {1'b1, 2'b11, 1'bx, 4'bxxxx, 1'b0, 2'b10, 2'b01, 1'b0, 2'b00}; // JAL*
      {7'b1100111, 3'b000, 7'bxxxxxxx}: exit = {1'b1, 2'b00, 1'b1, 4'b0000, 1'b0, 2'b10, 2'b10, 1'b0, 2'b00}; // JALR*
		
		//U TYPE
		{7'b0110111, 3'bxxx, 7'bxxxxxxx}: exit = {1'b1, 2'bxx, 1'bx, 4'bxxxx, 1'b0, 2'b11, 2'b00, 1'bxx, 2'bxx}; // LUI*
		
      default : exit = 16'bxxxxxxxxxxxxxx;
    endcase
  	
    {RegWrite, ImmSrc, ULASrc, ULAControl, MemWrite, ResultSrc, PCSrc, UnSig, LSControl} = exit;
	 
	 
	 //Branchs Instructions
	 if(OP == 7'b1100011) begin
		case(Funct3)
          3'b000: PCSrc = (Zero)? 2'b01: 2'b00; // BEQ
          3'b001: PCSrc = (Zero)? 2'b00: 2'b01; // BNE
          3'b100: PCSrc = (Zero)? 2'b00: 2'b01; // BLT
			 3'b110: PCSrc = (Zero)? 2'b00: 2'b01; // BLTU
          3'b101: PCSrc = (Zero)? 2'b01: 2'b00; // BGE
			 3'b111: PCSrc = (Zero)? 2'b01: 2'b00; // BGEU
		  default: PCSrc = 2'b00; 
		endcase
	 end
    
  end
endmodule


/* ---> Instruction_memory <--- */
module Instruction_memory(input logic [7:0] Adress,
        output logic [31:0] RD);
  
  
  reg [31:0]Instructions[255:0];
  
  
  initial $readmemh("./Assembly/ProjetoLASD-EscritaAutomatica.txt", Instructions);
  //initial $readmemh("./Assembly/ProjetoLASD-EscritaManual.txt", Instructions);
  //initial $readmemh("./Assembly/teste.txt", Instructions);
  //initial $readmemh("./Assembly/ProjetoLASD-EscritaAutomatica.txt", Instructions);
  //initial $readmemh("./Assembly/Desafio.txt", Instructions);
  //initial $readmemh("./Assembly/InstructionData.txt", Instructions);
  
  
  always_comb begin
 
	RD = Instructions[Adress/4];
	
  end
endmodule


/*---> Adder <---*/
module My_Adder (input logic [31:0] In01, In02,
					  output logic [31:0] Out);
	
	always_comb
		Out = In01 + In02;
		
endmodule 