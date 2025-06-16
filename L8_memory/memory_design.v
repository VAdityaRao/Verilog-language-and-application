module memory #(
  parameter integer AWIDTH = 5,
  parameter integer DWIDTH = 8
)(
  input  wire                   clk,
  input  wire                   wr,
  input  wire                   rd,
  input  wire [AWIDTH-1:0]      addr,
  inout  wire [DWIDTH-1:0]      data
);

  // Memory array: 2^AWIDTH locations of DWIDTH bits
  reg [DWIDTH-1:0] mem [(2**AWIDTH)-1:0];

  // Internal register to drive the data bus during read
  reg [DWIDTH-1:0] data_out;
  reg              data_oe;

  // Tri-state output
  assign data = data_oe ? data_out : {DWIDTH{1'bz}};

  always @(posedge clk) begin
    if (wr && !rd) begin
      mem[addr] <= data; // Write data to memory
    end
    else if (rd && !wr) begin
      data_out <= mem[addr]; // Load data to be driven out
    end
  end

  // Output enable control
  always @(*) begin
    data_oe = (rd && !wr);
  end

endmodule
