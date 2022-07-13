`timescale 1ns/1ps

module RD2EX   #(// General Parameters
                 parameter D_SIZE = 32,
                 parameter A_SIZE = 10)
                 (// General
                 input               clk,
                 input               rst,
                 // Input <- READ:
                 input         [1:0] control_rd,
                 input         [6:0] alu_cmd_rd,
                 //   -operands
                 input  [D_SIZE-1:0] op1,
                 input  [D_SIZE-1:0] op2,
                 input         [2:0] dest_reg,
                 // Output -> EXECUTE:
                 //   -control signals
                 output        [1:0] control_ex,
                 output        [6:0] alu_cmd_ex,
                 //   -operands
                 output [D_SIZE-1:0] op1_ex,
                 output [D_SIZE-1:0] op2_ex,
                 output        [2:0] dest_reg_ex
                 );
    
    // Reg for control signals
    reg       [15:0] control_reg; 
                 
    // Reg for operands
    reg [D_SIZE-1:0] op1_reg;
    reg [D_SIZE-1:0] op2_reg;
    //
    reg        [2:0] dest_reg_reg;
 
    // Assignments for control signals
    assign control_ex = control_reg;
    assign alu_cmd_ex = alu_cmd_rd;
    
    // Assignments for operands
    assign op1_ex        = op1_reg;
    assign op2_ex        = op2_reg;
    assign dest_reg_ex   = dest_reg_reg;
                 
    always @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
        //Control Signals
            control_reg    <= 16'b0;
        // Operands
            op1_reg        <= 0;
            op2_reg        <= 0;
        //    
            dest_reg_reg   <= 0;
        end
        else
        begin
        //Control Signals
            control_reg <= control_rd;
        // Operands
            op1_reg        <= op1;
            op2_reg        <= op2;
        //    
            dest_reg_reg   <= dest_reg;
        end
    end
endmodule
              