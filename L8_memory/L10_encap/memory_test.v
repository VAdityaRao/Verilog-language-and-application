//`timescale 1ns/100ps

module memory
#(
  parameter integer AWIDTH = 5,
  parameter integer DWIDTH = 8
)
(
  input  wire              clk,
  input  wire              wr,
  input  wire              rd,
  input  wire [AWIDTH-1:0] addr,
  inout  wire [DWIDTH-1:0] data
);
  reg [DWIDTH-1:0] array [0:2**AWIDTH-1];

  always @(posedge clk)
    if (wr)
      array[addr] = data;

  assign data = rd ? array[addr] : 'bz;
endmodule


module memory_test;

  localparam integer AWIDTH = 5;
  localparam integer DWIDTH = 8;

  reg               clk;
  reg               wr;
  reg               rd;
  reg  [AWIDTH-1:0] addr;
  wire [DWIDTH-1:0] data;
  reg  [DWIDTH-1:0] rdata;

  assign data = rdata;

  memory #(
    .AWIDTH(AWIDTH),
    .DWIDTH(DWIDTH)
  ) memory_inst (
    .clk(clk),
    .wr(wr),
    .rd(rd),
    .addr(addr),
    .data(data)
  );

  task check_output;
    input [DWIDTH-1:0] exp_data;
    if (data !== exp_data) begin
      $display("TEST FAILED");
      $display("At time %0t addr=%b data=%b", $time, addr, data);
      $display("Expected data = %b", exp_data);
      $finish;
    end else begin
      $timeformat(-9, 0, "ns", 4);
      $display("%t addr=%b, exp_data=%b, data=%b", $time, addr, exp_data, data);
    end
  endtask

  // WRITE task
  task write;
    input [AWIDTH-1:0] waddr;
    input [DWIDTH-1:0] wdata;
    begin
      @(negedge clk);
      addr  = waddr;
      rdata = wdata;
      wr    = 1;
      rd    = 0;
      @(negedge clk);
      wr    = 0;
      rdata = 'bz;
    end
  endtask

  // READ task
  task read;
    input [AWIDTH-1:0] raddr;
    input [DWIDTH-1:0] exp_data;
    begin
      @(negedge clk);
      addr = raddr;
      wr   = 0;
      rd   = 1;
      @(negedge clk);
      check_output(exp_data);
      rd = 0;
    end
  endtask

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Test sequence
  initial begin : TEST
    reg [AWIDTH-1:0] addr_loop;
    reg [DWIDTH-1:0] data_loop;

    // Initialize signals
    wr = 0; rd = 0; addr = 0; rdata = 'bz;

    // Write loop
    addr_loop = -1;
    data_loop = 0;
    repeat (2**AWIDTH) begin
      write(addr_loop, data_loop);
      addr_loop = addr_loop - 1;
      data_loop = data_loop + 1;
    end

    // Read and verify
    addr_loop = -1;
    data_loop = 0;
    repeat (2**AWIDTH) begin
      read(addr_loop, data_loop);
      addr_loop = addr_loop - 1;
      data_loop = data_loop + 1;
    end

    $display("TEST PASSED");
    $finish;
  end

endmodule
