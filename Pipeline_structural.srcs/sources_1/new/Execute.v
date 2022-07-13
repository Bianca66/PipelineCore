`timescale 1ns/1ps

module Execute #(// General Parameters
                 parameter D_SIZE = 32,
                 parameter A_SIZE = 10)
                (// General 
                 input              clk,
                 input              rst,
                 // Input <- read2ex:
                 //   -control signals
                 input        [1:0] control_ex,
                 //   -operands
                 input [D_SIZE-1:0] op1_ex,
                 input [D_SIZE-1:0] op2_ex,
                 input        [2:0] dest_reg_ex,
                 input        [6:0] alu_cmd_ex,
                 // Output -> Ex2Wb
                 output              reg_we,
                 output [D_SIZE-1:0] result,
                 output        [2:0] dest_reg
                );
    
    // -> RegSet
    assign reg_we   = control_ex[1];
    assign dest_reg = dest_reg_ex;
    
    alu  alu (// General
              .clk   (clk),
              .rst   (rst),
              // Input
              .op1    (op1_ex),
              .op2    (op2_ex),
              .cmd    (alu_cmd_ex),
              .alu_en (control_ex[0]),
              // Output
              .alu_out(alu_out)
              );  
    
endmodule