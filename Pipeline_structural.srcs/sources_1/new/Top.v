`timescale 1ns / 1ps

module Top #(// General Parameters
             parameter D_SIZE = 32,
             parameter A_SIZE = 10)
            (// General
             input               clk,
             input               rst,
             // Program Memory
             input        [15:0] instruction,
             output [A_SIZE-1:0] pc_out
            );
    
    wire       [15:0] instr_ir;
    
    Fetch fetch (// General
                 .clk         (clk),
                 .rst         (rst),
                 // Input <- Program Memory 
                 .instruction (instruction),
                 // Input <- JUMP CONTROL
                 .jmpr_sel    (),
                 .jmp_sel     (),
                 .jmp_offset  (), 
                 .jmp         (),
                 // Input <- READ
                 .en_write_pc (en_write_pc), 
                 // Output -> READ
                 .instr_ir    (instr_ir),
                // Output -> Program_Memory
                 .pc_out      (pc_out)
                 );
                 
    IR  InstrReg (// General
                 .clk (clk),
                 .rst (rst),
                 // Input <- FETCH
                 .instr_ir (instr_ir),
                 // Output -> READ
                 .instr_rd (instr_rd)
                 );
                
                 
    Read read (// Input <- Instr_reg
               .instr_rd    (instr_rd),
               // Input <- REG SET
               .op1_0       (op1_0),
               .op2_0       (op2_0),
               // Output -> REG SET
               .adr_op1     (addr_op1),
               .adr_op2     (addr_op2),
               // Output -> FETCH:
               .en_write_pc (en_write_pc),
               // Output -> READ2EX:
               //   -control signals
               .control_rd  (control_rd2ex),
               .alu_cmd     (alu_cmd_rd2ex),
               //   -operands
               .op1         (op1_rd2ex),
               .op2         (op2_rd2ex),
               .dest_reg    (dest_reg_rd2ex)
               );
    
    RegSet regSet (.clk     (clk),
                   .rst     (rst),
                   // Input <- Write Back
                   .en_write(),
                   .dest    (),
                   .result  (),
                   // Input -> Read
                   .addr_op1(addr_op1),
                   .addr_op2(addr_op2),
                   // Output -> Control_rd
                   .op1_0   (op1_0),
                   .op2_0   (op2_0)
                   );
    
    RD2EX read2ex  (.clk        (clk),
                    .rst        (rst),
                    // Input <- READ:
                    .control_rd  (control_rd2ex),
                    .alu_cmd_rd  (alu_cmd_rd2ex),
                    //   -operands
                    .op1         (op1_rd2ex),
                    .op2         (op2_rd2ex),
                    .dest_reg    (dest_reg_rd2ex),
                    // Output -> EXECUTE:
                    //   -control signals
                    .control_ex  (control_ex),
                    .alu_cmd_ex  (alu_cmd_ex),
                    //   -operands
                    .op1_ex      (op1_ex),
                    .op2_ex      (op2_ex),
                    .dest_reg_ex (dest_reg_ex)
                    );
    
    Execute execute (// General 
                     .clk  (clk),
                     .rst  (rst),
                     // Input <- read2ex:
                     //   -control signals
                     .control_ex  (control_ex),
                     //   -operands
                     .op1_ex      (op1_ex),
                     .op2_ex      (op2_ex),
                     .dest_reg_ex (dest_reg_ex),
                     .alu_cmd_ex  (alu_cmd_ex),
                     // Output -> Ex2Wb
                     .reg_we      (reg_we),
                     .result      (result),
                     .dest_reg    (dest_reg)
                     );
                     
    
         
endmodule