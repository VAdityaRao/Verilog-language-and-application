module alu
#(
  parameter integer WIDTH = 8
)
(
  input  [WIDTH-1:0] in_a,
  input  [WIDTH-1:0] in_b,
  input  [2:0]       opcode,
  output reg [WIDTH-1:0] alu_out,
  output reg         a_is_zero
);

always @(*) begin
  case (opcode)
    3'b000, 3'b001, 3'b110, 3'b111: alu_out = in_a;       // PASS A
    3'b010: alu_out = in_a + in_b;                        // ADD
    3'b011: alu_out = in_a & in_b;                        // AND
    3'b100: alu_out = in_a ^ in_b;                        // XOR (fixed)
    3'b101: alu_out = in_b;                               // PASS B
    default: alu_out = {WIDTH{1'b0}};
  endcase

  a_is_zero = (in_a == 0);
end

endmodule
