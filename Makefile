PROJ = glitcher
ADD_SRC = src/top.v src/cmd.v src/delay.v src/fifo.v src/fifo_sync_ram.v src/pattern.v src/pulse.v src/ram_sdp.v src/resetter.v src/trigger.v src/uart_defs.v src/uart_rx.v src/uart_tx.v

PIN_DEF = syn/icebreaker.pcf
DEVICE = up5k

include main.mk
