/* ---------> Bit Extender <--------- */
module ImmediateExtender(input logic [11:0] Imm_I, Imm_S,
                         input logic [12:0] Imm_B,
                         input logic [20:0] Imm_J,
                         input logic [1:0] ImmSrc,
                         output logic [31:0] Out);

  always_comb begin
    case(ImmSrc)
      2'd0: Out = (Imm_I[11]) ? {{20{1'b1}}, Imm_I} : {{20{1'b0}}, Imm_I};
      2'd1: Out = (Imm_S[11]) ? {{20{1'b1}}, Imm_S} : {{20{1'b0}}, Imm_S};
      2'd2: Out = (Imm_B[12]) ? {{19{1'b1}}, Imm_B} : {{19{1'b0}}, Imm_B};
      2'd3: Out = (Imm_J[20]) ? {{11{1'b1}}, Imm_J} : {{11{1'b0}}, Imm_J};
      default: Out = 32'hxxxxxxxx;
    endcase
  end
endmodule



/* ---------------> Load Controler <--------------- */
module LoadsControler (input logic [31:0] DataIn,
                       input logic [1:0] LControl,
                       input logic [7:0] Address,
                       output logic [31:0] DataOut);
  
  
  //Estende de 8 bits para 32 com sinal
  function [31:0] Extend8 (input logic [7:0] In);
    return In[7] ? {{24{1'b1}}, In}: {{24{1'b0}}, In};
  endfunction
  
  //Estende de 16 bits para 32 com sinal.
  function [31:0] Extend16 (input logic [15:0] In);
    return In[15] ? {{16{1'b1}}, In}: {{16{1'b0}}, In};
  endfunction
  
  
  always_comb begin
    case(LControl)
      2'd0: DataOut = DataIn; 							      //LW
      2'd1: DataOut = Extend8(DataIn >> 8*(Address%4));  //LB
      2'd2: DataOut = Extend16(DataIn >> 8*(Address%4)); //LH
      default: DataOut = 32'hxxxxxxxx;
    endcase
  end
    
endmodule




/* ------------------> Store Controler <------------------ */
module StoresControler(input logic [31:0] DataIn, MemData,
                       input logic [1:0] SControl,
                       input logic [7:0] Address,
                       output logic [31:0] DataOut);
   
  
  
  always_comb begin
    case(SControl)
      2'd0: DataOut = DataIn; 																															//SW
      2'd1: DataOut = (MemData & (32'hFFFFFFFF - (32'hFF << 8*(Address%4)))) + ((DataIn & 32'hFF) << 8*(Address%4));       //SB
      2'd2: DataOut = (MemData & (32'hFFFFFFFF - (32'hFFFF << 8*(Address%4)))) + ((DataIn & 32'hFFFF) << 8*(Address%4));   //SH
      default: DataOut = 32'hxxxxxxxx;
    endcase
  end
endmodule