# icebreaker-glitcher

## FPGA-based glitcher for the Icebreaker board

The pinout on the board is as follows:
* PMOD 1A: Seven segment displaying pulse width
* PMOD 1B: Seven segment displaying delay
* PMOB 2: To target board
  * pin 1: o_board_rx - Target rx
  * pin 2: o_board_tx - Target tx
  * pin 3: o_board_rst - Target reset, connect to the JTAG reset pin
  * pin 4: vout - Voltage select signal

The python control script is in the scripts directory:
* scripts/glitch.py
