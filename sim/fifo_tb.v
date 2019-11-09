`timescale 1ns / 1ps

module fifo_tb();

reg tb_clk = 1'b1;
reg tb_rst = 1'b0;
reg tb_wen = 1'b0;
reg tb_ren = 1'b0;
reg [7:0] tb_data = 8'haa;

fifo tb_fifo (
    .clk(tb_clk),
    .rst(tb_rst),
    .data_in(tb_data),
    .wen(tb_wen),
    .ren(tb_ren)
);

initial
begin
	$dumpfile("fifo_tb.vcd");
	$dumpvars(0, fifo_tb);
end

always
begin
    #41.6 tb_clk <= ~tb_clk;
end

initial
begin
    #800 ;
    @(posedge tb_clk);
    tb_rst <= 1'b1;
    @(posedge tb_clk);
    tb_rst <= 1'b0;
    #800 ;
    @(posedge tb_clk);
    tb_wen <= 1'b1;
    @(posedge tb_clk);
    tb_wen <= 1'b0;
    #800 ;
    @(posedge tb_clk);
    tb_ren <= 1'b1;
    @(posedge tb_clk);
    tb_ren <= 1'b0;

    #800 $finish;
end

endmodule
