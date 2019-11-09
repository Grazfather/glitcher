`timescale 1ns / 1ps

module top_tb();

reg tb_clk = 1'b1;

always
begin
    #41.6 tb_clk <= ~tb_clk;
end

wire tb_uart;

top tb_top (
    .clk(tb_clk),
    .ftdi_rx(tb_uart)
);

reg [7:0] tx_data;
reg tx_en = 1'b0;
wire tx_rdy;

initial
begin
	$dumpfile("top_tb.vcd");
	$dumpvars(0, top_tb);
end

uart_tx txi (
    .clk(tb_clk),
    .rst(1'b0),
    .dout(tb_uart),
    .data_in(tx_data),
    .en(tx_en),
    .rdy(tx_rdy)
);

initial
begin
    // Reset FPGA
    #1000;
    @(posedge tb_clk);
    // -- cmd
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- cmd rst
    tx_data <= 8'hff;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);

    // Configure width
    #1000
    @(posedge tb_clk);
    // -- cmd
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- cmd width
    tx_data <= 8'h10;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- width 0x22
    tx_data <= 8'h22;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);

    // Configure pulse count
    #1000
    @(posedge tb_clk);
    // -- cmd
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- cmd pulse count
    tx_data <= 8'h11;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- pulse count 0
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);

    // Configure delay count (We should set each byte irl)
    #1000
    @(posedge tb_clk);
    // -- cmd
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- cmd delay0
    tx_data <= 8'h20;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- delay 50
    tx_data <= 8'h32;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);

    // send 5 bytes through
    #1000
    @(posedge tb_clk);
    // -- length 5
    tx_data <= 8'd5;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    tx_data <= 8'hff;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    tx_data <= 8'h55;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    tx_data <= 8'haa;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);

    // Enable glitch
    @(posedge tb_clk);
    // -- cmd
    tx_data <= 8'h00;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- cmd glitch enable
     //-- cmd board reset
    tx_data <= 8'hfe;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);

    #8000 $finish;
end

endmodule
