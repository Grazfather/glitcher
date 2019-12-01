/**
 * PLL configuration
 *
 * This Verilog header file was generated automatically
 * using the icepll tool from the IceStorm project.
 * It is intended for use with FPGA primitives SB_PLL40_CORE,
 * SB_PLL40_PAD, SB_PLL40_2_PAD, SB_PLL40_2F_CORE or SB_PLL40_2F_PAD.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:   48.000 MHz
 * Achieved output frequency:    48.000 MHz
 */
`default_nettype none

module pll(
    input clk_in,
    output fast_clk_out,
    output clk_out,
    output locked
);

SB_PLL40_2_PAD #(
    .FEEDBACK_PATH("SIMPLE"),
    .DIVR(4'b0000),             // DIVR =  0
    .DIVF(7'b0111111),          // DIVF = 63
    .DIVQ(3'b100),              // DIVQ =  4
    .FILTER_RANGE(3'b001)       // FILTER_RANGE = 1
    ) uut (
    .LOCK(locked),
    .RESETB(1'b1),
    .BYPASS(1'b0),
    .PACKAGEPIN(clk_in),
    .PLLOUTCOREA(clk_out),
    .PLLOUTCOREB(fast_clk_out)
);


endmodule
