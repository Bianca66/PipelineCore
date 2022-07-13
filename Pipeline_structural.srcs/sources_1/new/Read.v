`timescale 1ns / 1ps

module Read#(// General Parameters
              parameter D_SIZE = 32,
              parameter A_SIZE = 10)
             (// Input <- Instr_reg
              input        [15:0] instr_rd,
              // Input <- REG SET
              input  [D_SIZE-1:0] op1_0,
              input  [D_SIZE-1:0] op2_0,
              // Output -> REG SET
              output        [2:0] adr_op1,
              output        [2:0] adr_op2,
              // Output -> FETCH:
              output              en_write_pc,
              // Output -> READ2EX:
              //   -control signals
              output        [1:0] control_rd,
              output        [6:0] alu_cmd,
              //   -operands
              output [D_SIZE-1:0] op1,
              output [D_SIZE-1:0] op2,
              output        [2:0] dest_reg
             );
     
    // Output -> REG SET    
    assign addr_op1 = instr_rd[ 5:3];
    assign addr_op2 = instr_rd[ 2:0];
    assign  alu_cmd = instr_rd[15:9];
    
    // Output -> READ2EX
    assign      op1 = op1_0;
    assign      op2 = op2_0;
    assign dest_reg = instr_rd[8:6];
    
    //
    control control_ (.instr       (instr_rd),
                      .control     (control_rd),
                      .en_write_pc (en_write_pc)
                     );
    
endmodule