module counter
#(
  parameter integer WIDTH=5
 )
 (
  input  wire clk  ,
  input  wire rst  ,
  input  wire load ,
  input  wire enab ,
  input  wire [WIDTH-1:0] cnt_in ,
  output reg  [WIDTH-1:0] cnt_out 
 );

  
//////////////////////////////////////////////////////////////////////////////
//TO DO: DEFINE THE COUNTER COMBINATIONAL LOGIC using FUNCTION AS INSTRUCTED//
//////////////////////////////////////////////////////////////////////////////
function [WIDTH-1:0] cnt_func;
input  rst;
input  load;
input  enab;
input  [WIDTH-1:0] cnt_in;
input  [WIDTH-1:0] cnt_out;

reg [WIDTH-1:0] next_val;

begin
    if (rst)
    next_val = {WIDTH{1'b0}}; else
    if (load)
    next_val = cnt_in;else 
    if (enab)
    next_val = cnt_out + 1'b1;else

    next_val = cnt_out;

    cnt_func = next_val;
end
endfunction



  always @(posedge clk)
     cnt_out <= cnt_func (rst, load, enab ,cnt_in, cnt_out); //function call

endmodule
