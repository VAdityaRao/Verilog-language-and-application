module controller
(
    input zero,
    input [2:0]phase,
    input [2:0] opcode,

    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg inc_pc,
    output reg ld_ac,
    output reg ld_pc,
    output reg memory write,
    output reg data enable
);

reg nil = zero;
reg HALT = (opcode == 3'b000) ? 1'b1 : 1'b0;
reg ALUOP = (opcode == 3'b010 or 3'b011 or 3'b100 or 3'b101) ? 1'b1: 1'b0;
reg SKZ = (opcode == 3'b001) ? 1b'1 : 1'b0;
reg bz = (SKZ & nil);
reg JMP = (opcode == 3'b111) ? 1'b1 : 1'b0;
reg STO = (opcode == 3'b110) ? 1'b1 : 1'b0;

reg i = phase;

while (1){

case (i)
3'b000: sel = 1'b1, rd = 1'b0, ld_ir = 1'b0, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0; //INST_ADDR
3'b001: sel = 1'b1, rd = 1'b1, ld_ir = 1'b0, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0; //INST_FETCH
3'b010: sel = 1'b1, rd = 1'b1, ld_ir = 1'b1, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0; //INST_LOAD
3'b011: sel = 1'b1, rd = 1'b1, ld_ir = 1'b1, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0; //IDLE
3'b100: sel = 1'b0, rd = 1'b0, ld_ir = 1'b0, halt = HALT, inc_pc = 1'b1, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0; //OP_ADDR
3'b101: sel = 1'b0, rd = ALUOP, ld_ir = 1'b0, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0; //OP_FETCH
3'b110: sel = 1'b0, rd = ALUOP, ld_ir = 1'b0, halt = 1'b0, inc_pc = bz  , ld_ac = 1'b0, ld_pc = JMP, wr = 1'b0, data_e = STO; //ALU_OP
3'b111: sel = 1'b0, rd = ALUOP, ld_ir = 1'b0, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = JMP, wr = STO , data_e = STO; //STORE

default: sel = 1'b0, rd = 1'b0, ld_ir = 1'b0, halt = 1'b0, inc_pc = 1'b0, ld_ac = 1'b0, ld_pc = 1'b0, wr = 1'b0, data_e = 1'b0;


}