`timescale 1ns / 1ps

module cmd_tb();

reg tb_clk = 1'b1;

wire tb_uart;

cmd tb_cmd (
    .clk(tb_clk),
    .din(tb_uart)
);

initial
begin
	$dumpfile("cmd_tb.vcd");
	$dumpvars(0, cmd_tb);
end

always
begin
    #41.6 tb_clk <= ~tb_clk;
end

reg [7:0] tx_data;
reg tx_en = 1'b0;
wire tx_rdy;

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
    // Reset
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
    // -- cmd reset
    tx_data <= 8'hff;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);

    // Check rst ok
    #1000
    @(posedge tb_clk);
    // -- 5 bytes of data
    tx_data <= 8'd5;
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
    tx_data <= 8'hff;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    tx_data <= 8'hf0;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);

    // Send data ok

    // Set pulse width
    #100000;
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
    // -- cmd pulse width
    tx_data <= 8'h10;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);
    // -- pulse width 0xAA
    tx_data <= 8'haa;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);

    // Set pattern ok

    #100000;
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
    // -- pulse count 0x55
    tx_data <= 8'h55;
    tx_en <= 1'b1;
    @(posedge tb_clk);
    tx_en <= 1'b0;
    wait(!tx_rdy);
    @(posedge tb_clk);
    wait(tx_rdy);
    @(posedge tb_clk);

    #80000 $finish;
end

endmodule
