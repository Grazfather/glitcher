PROJ = glitcher
ADD_SRC = src/top.v src/cmd.v src/delay.v src/fifo.v src/fifo_sync_ram.v src/pattern.v src/pulse.v src/ram_sdp.v src/resetter.v src/trigger.v src/uart_defs.v src/uart_rx.v src/uart_tx.v src/seven_seg_hex.v src/seven_seg_mux.v
ADD_BOARD_SRC = src/pll.v
ADD_TB_SRC = src/pll_mock.v
ADD_CLEAN = *.vcd *_tb base.log

PIN_DEF = syn/icebreaker.pcf
DEVICE = up5k

include main.mk
