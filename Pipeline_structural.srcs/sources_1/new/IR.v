`timescale 1ns/1ps

module IR #(// General Parameters
            parameter D_SIZE = 32,
            parameter A_SIZE = 10)
           (// General
            input         clk,
            input         rst,
            // Input <- FETCH
            input  [15:0] instr_ir,
            // Output -> READ
            output [15:0] instr_rd
            );
    
    // 
    reg [15:0] instr_ir_reg;
    
    assign instr_rd = instr_ir_reg;
    
    always @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
            instr_ir_reg <= 0;
        end
        else
        begin
            instr_ir_reg <= instr_ir;
        end
    end
    
endmodule