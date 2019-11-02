# icebreaker-glitcher

## FPGA-based glitcher for the Icebreaker board

Files required for building the bitstream:
* src/top.v
* src/cmd.v
* src/delay.v
* src/fifo.v
* src/pattern.v
* src/pulse.v
* src/resetter.v
* src/top_passthrough.v
* src/trigger.v
* src/uart_defs.v
* src/uart_rx.v
* src/uart_tx.v

The pinout on the board is as follows:
* `27`: board1_rx - UART rx
* `25`: board1_tx - UART tx
* `21`: board1_rst - target reset, connect to the JTAG reset pin
* `19`: vout voltage select signal

The python control script is in the scripts directory:
* scripts/glitch.py
