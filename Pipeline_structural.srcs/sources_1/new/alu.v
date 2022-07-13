`timescale 1ns/1ps

module alu #(// General Parameters
             parameter D_SIZE = 32,
             parameter A_SIZE = 10)
             (// General
              input                   clk,
              input                   rst,
              // Input
              input      [D_SIZE-1:0] op1,
              input      [D_SIZE-1:0] op2,
              input             [6:0] cmd,
              input                   alu_en,
              // Output
              output     [D_SIZE-1:0] alu_out
              );  
    
    reg [D_SIZE-1:0] out;
    
    assign alu_out = out;
    
    always @(*)
    begin
        if(~rst)
        begin
            out <= 0;
        end
        else if(alu_en)
        begin
            case(cmd)
                `ADD:  
                begin
                    out <= op1 + op2;
                end
                `ADDF:
                begin
                    out <= op1 + op2;
                end
                `SUB:
                begin
                    out <= op1 - op2;
                end
                `SUBF:
                begin
                    out <= op1 - op2;
                end
                `AND:
                begin
                    out <= op1 & op2;
                end
                `OR:
                begin
                    out <= op1 | op2;
                end
                `XOR:
                begin
                    out <= op1 ^ op2;
                end
                `NAND:
                begin
                    out <= ~(op1 & op2);
                end
                `NOR:
                begin
                    out <= ~(op1 | op2);
                end
                `NXOR:
                begin
                    out <= op1 ~^ op2;
                end
            endcase
        end
    end
endmodule