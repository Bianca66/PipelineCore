// Instructions
`define NOP      7'b1111110
`define HALT     7'b1111100

`define ADD      7'b1101100
`define ADDF     7'b1101011
`define SUB      7'b1101010
`define SUBF     7'b1101001
`define AND      7'b1101000
`define OR       7'b1100111
`define XOR      7'b1100110
`define NAND     7'b1100101
`define NOR      7'b1100100
`define NXOR     7'b1100011

`define SHIFTR   7'b1100010
`define SHIFTRA  7'b1100001
`define SHIFTL   7'b1100000

`define LOAD     5'b10010
`define LOADC    5'b10001
`define STORE    5'b10000

`define JMP      4'b0111
`define JMPR     4'b0110
`define JMPcond  4'b0101
`define JMPRcond 4'b0100

`define NZ       3'b011
`define Z        3'b010
`define NN       3'b001
`define N        3'b000

//Register number
`define R0 3'b000
`define R1 3'b001
`define R2 3'b010
`define R3 3'b011
`define R4 3'b100
`define R5 3'b101
`define R6 3'b110
`define R7 3'b111