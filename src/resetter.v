module resetter (
    input wire clk,
    input wire rst,
    output reg rst_out
);
// 120 cycles at 12MHz = 10uS
parameter cycles = 120;

reg [31:0] cnt = 0;
reg counting = 1'b0;

always @(posedge clk)
begin
    rst_out <= 1;

    if (rst)
    begin
        // reset
        cnt <= 0;
        counting <= 1;
    end

    if (counting)
    begin
        cnt <= cnt + 1;
        rst_out <= 0;
        if (cnt == cycles)
        begin
            cnt <= 0;
            counting <= 0;
        end
    end
end

endmodule
