`timescale 1ns / 1ps

module delay_tb();

reg tb_clk = 1'b1;
reg tb_en = 1'b0;

delay tb_delay (
    .clk(tb_clk),
    .rst(1'b0),
    .en(tb_en),
    .delay(64'd99)
);

initial
begin
	$dumpfile("delay_tb.vcd");
	$dumpvars(0, delay_tb);
end

always
begin
    #41.6 tb_clk <= ~tb_clk;
end

initial
begin
    #800 tb_en <= 1'b1;
    #80 tb_en <= 1'b0;

    #10000 $finish;
end

endmodule
