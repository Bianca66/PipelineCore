`timescale 1ns / 1ps

module control(// Input <- FETCH
               input [15:0] instr,
               // Output
               output [1:0] control,
               output       en_write_pc
              );
              
    // Reg
    reg alu_en_reg;
    reg reg_we_reg;
    reg en_write_pc_reg;
    
    assign  control[0] = alu_en_reg;
    assign  control[1] = reg_we_reg;
    assign en_write_pc = en_write_pc_reg;
    
    always @(*)
    begin
        case(instr[15:9])
            `NOP:
            begin
                alu_en_reg      <= 0;
                reg_we_reg      <= 0;
                en_write_pc_reg <= 1;
            end
            `HALT:
            begin
                en_write_pc_reg <= 0;
            end
            default:
            begin
                alu_en_reg      <= 1;
                reg_we_reg      <= 1;
                en_write_pc_reg <= 1;
            end
        endcase   
    end
    
endmodule
