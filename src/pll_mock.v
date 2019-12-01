`default_nettype none

module pll(
    input clk_in,
    output clk_out,
    output reg fast_clk_out = 1,
    output locked
);

assign clk_out = clk_in;
assign locked = 1;

always
begin
    // 4x faster than the main clock
    #5.2 fast_clk_out <= ~fast_clk_out;
end

endmodule
