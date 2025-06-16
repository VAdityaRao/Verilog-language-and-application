module multiplexor
#(
    parameter integer WIDTH = 5
)
(
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    input sel,
    output [WIDTH-1:0] mux_out
);

reg [WIDTH-1:0] mux_result;
assign mux_out = mux_result;

always @ (*) begin
    if (sel == 1'b0)
        mux_result = in0;
    else
        mux_result = in1;
end

endmodule