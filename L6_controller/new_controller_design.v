module controller (
  input  logic [2:0] opcode,
  input  logic [2:0] phase,
  input  logic       zero,
  output logic       sel,
  output logic       rd,
  output logic       ld_ir,
  output logic       inc_pc,
  output logic       halt,
  output logic       ld_pc,
  output logic       data_e,
  output logic       ld_ac,
  output logic       wr
);

  // decoded instruction types
  logic HLT, SKZ, ADD, AND_, XOR_, LDA, STO, JMP;
  assign HLT  = (opcode == 3'b000);
  assign SKZ  = (opcode == 3'b001);
  assign ADD  = (opcode == 3'b010);
  assign AND_ = (opcode == 3'b011);
  assign XOR_ = (opcode == 3'b100);
  assign LDA  = (opcode == 3'b101);
  assign STO  = (opcode == 3'b110);
  assign JMP  = (opcode == 3'b111);

  logic ALUOP;
  assign ALUOP = ADD | AND_ | XOR_ | LDA;

  logic bz;
  assign bz = SKZ & zero;

  always @* begin
    // Default all outputs to 0
    sel    = 0;
    rd     = 0;
    ld_ir  = 0;
    inc_pc = 0;
    halt   = 0;
    ld_pc  = 0;
    data_e = 0;
    ld_ac  = 0;
    wr     = 0;

    case (phase)
      3'b000: begin
        sel = 1;
      end
      3'b001: begin
        sel = 1;
        rd = 1;
      end
      3'b010: begin
        sel = 1;
        rd = 1;
        ld_ir = 1;
      end
      3'b011: begin
        sel = 1;
        rd = 1;
        ld_ir = 1;
      end
      3'b100: begin
        halt = HLT;
        inc_pc = 1;
      end
      3'b101: begin
        rd = ALUOP;
      end
      3'b110: begin
        rd = ALUOP;
        inc_pc = bz;
        ld_pc = JMP;
        data_e = STO;
      end
      3'b111: begin
        rd = ALUOP;
        ld_pc = JMP;
        wr = STO;
        data_e = STO;
        ld_ac = ALUOP; //  FIX: now properly sets ld_ac in phase 7 for ALU ops
      end
    endcase
  end

endmodule
