`default_nettype none

`define SYSTEM_CLOCK    12_000_000
`define BAUD_RATE       115_200

// 115200 8N1
`define UART_FULL_ETU	(`SYSTEM_CLOCK/`BAUD_RATE)
`define UART_HALF_ETU	((`SYSTEM_CLOCK/`BAUD_RATE)/2)
