`timescale 1ns / 1ps
`include "opcode.v"

module Fetch_tb #(parameter D_SIZE = 32,
                  parameter A_SIZE = 10);

    /*===========| General |===========*/
       reg              clk;
       reg              rst;
    /*=================================*/
    /*===| Input <- Program Memory |===*/
       reg       [15:0] instruction;
    /*=================================*/
    /*====| Input <- Jump Control |====*/
       reg              jmp_sel;         
       reg              jmpr_sel;
       reg [A_SIZE-1:0] jmp;
       reg [A_SIZE-1:0] jmp_offset;
    /*=================================*/
    /*=======| Input <- Read |=========*/
       reg              en_write_pc;
    /*=================================*/
    /*=======| Output -> Read |========*/
       wire      [15:0] instr_ir;
    /*=================================*/
    /*===| Output -> Program Memory |==*/
       wire [A_SIZE-1:0] pc_out;
    /*=================================*/
    
 
    /*=======| Program Memory |========*/
    reg [15:0] prog_mem [0:1023];
    /*=================================*/
    
    
    //  Instantiate Device Under Test
    
    Fetch uut( // General 
               .clk         (clk),
               .rst         (rst),
               // Input <- Program Memory 
               .instruction (instruction),
               // Input <- Jump Control ===*/
               .jmp_sel     (jmp_sel),
               .jmpr_sel    (jmpr_sel),
               .jmp         (jmp),
               .jmp_offset  (jmp_offset),
               // Input <- Read 
               .en_write_pc (en_write_pc),
               // Output -> Read 
               .instr_ir    (instr_ir),
               // Output -> Program Memory
               .pc_out      (pc_out)
              );
    
   // Generate clock
   initial
   begin
    forever
        #10 
        clk = ~ clk; 
   end
    
  // Apply inputs one at a time
   initial
   begin
        clk          = 0;
        rst          = 0;
        prog_mem[0]  = 0;
        jmp_sel      = 0;
        jmpr_sel     = 0;
        jmp          = 0;
        jmp_offset   = 0;
        en_write_pc  = 0;
        prog_mem[0]  = 0;
        
        // Initialize memory
        prog_mem[0]  = {`LOADC,   `R0, 8'b11111101};
        prog_mem[1]  = {`SHIFTL,  `R0, 6'b001000};
        prog_mem[2]  = {`LOADC,   `R0, 8'b11101011};
        prog_mem[3]  = {`LOADC,   `R1, 8'b10011011};
        prog_mem[4]  = {`SUB,     `R2, `R0, `R1};
        prog_mem[5]  = {`LOADC,   `R3, 8'b00000001};
        prog_mem[6]  = {`LOADC,   `R4, 8'b00000000};
        prog_mem[7]  = {`SUB,     `R2, `R2, `R1};
        prog_mem[8]  = {`ADD,     `R4, `R4, `R3};
        prog_mem[9]  = {`HALT, 9'b000000000};
        prog_mem[10]  = {`SUB,     `R2, `R2, `R1};
        prog_mem[11]  = {`ADD,     `R4, `R4, `R3};
        
   end
   
   
   initial
   begin
        #91
        rst         = 1;
        en_write_pc = 1;
        instruction = prog_mem[pc_out];
        while(instruction[15:9] != `HALT)
        begin
            @pc_out;
            instruction = prog_mem[pc_out];
            if(instruction[15:12] == `JMPRcond)
			begin
			    jmpr_sel   = 1;
			    jmp_offset = -6'd2;
			    jmp        = 0;
			    jmp_sel    = 0;
			end
			else
			begin
			    jmpr_sel   = 0;
			    jmp_offset = 0;
			    jmp        = 0;
			    jmp_sel    = 0;
			end
        end
        if (instruction[15:9] == `HALT)
        begin
            en_write_pc = 0;
        end
        #500 $stop;
    end 
           
endmodule