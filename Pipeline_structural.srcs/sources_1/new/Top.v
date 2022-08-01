`timescale 1ns / 1ps

module top #(// General Parameters
            parameter D_SIZE = 32,
            parameter A_SIZE = 10)
           (
            input               clk,
            input               rst,
            input        [15:0] instruction,
            output [A_SIZE-1:0] pc_out
            );
            
    // Instruction Register
    reg [15:0] instr_reg;
    // Read to Execute Register
    reg [90:0] rd2ex_reg;
    // Execute to Write Back Register
    reg [36:0] ex2wb_reg;  
    // Register Set
    reg [D_SIZE-1:0] R [7:0];    
    // Memory
    reg [D_SIZE-1:0] mem [10:0];
    
    // Iterator
    integer i;
    
    // Intermediate Variables
    reg [D_SIZE-1:0] op1_rd;
    reg [D_SIZE-1:0] op2_rd;
    reg [D_SIZE-1:0] data_in_mem;
   

    // Read
    wire              en_write_pc;
    wire              reg_re_en_rs;
    wire              alu_en_rd2ex;
    wire              reg_we_en_rd2ex;
    wire              mem_re_rd2ex;
    wire              mem_we_rd2ex;
    wire              loadc_en_rd2ex;
    wire              jmp_sel_rd2ex;
    wire              jmpr_sel_rd2ex;
    wire [A_SIZE-1:0] jmp_offset_rd2ex;
    wire [D_SIZE-1:0] op1_rd2ex;
    wire [D_SIZE-1:0] op2_rd2ex;
    wire        [2:0] dest_reg_rd2ex;
    wire        [6:0] alu_cmd_rd2ex;
    wire        [2:0] addr_op2_rd2ex;
    wire        [2:0] addr_op1_rd2ex;
    
    // Execute
    wire              jmp_sel_f;
    wire              jmpr_sel_f;
    wire [A_SIZE-1:0] jmp_f;
    wire [A_SIZE-1:0] jmp_offset_f;
    wire              mem_re;
    wire              mem_we;
    wire [A_SIZE-1:0] addr_mem;
    wire [D_SIZE-1:0] dout_mem;
    wire              reg_we_ex2wb;
    wire              load_en_ex2wb;
    wire [D_SIZE-1:0] result_ex2wb;
    wire        [2:0] dest_reg_ex2wb;
    
   
    // Write Back
    wire [D_SIZE-1:0] result_rs;
    wire        [2:0] dest_rs;
    wire              reg_we_rs;
        
    wire        [2:0] addr_op2_rs;
    wire        [2:0] addr_op1_rs;
    
    //Data Forwarding
    wire              df1;
    wire              df2;
    
    always @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
            instr_reg <= 0;
            rd2ex_reg <= 0;
            ex2wb_reg <= 0;
        end
        else if(clear_rd)
        begin
           instr_reg <= {`NOP,    9'b000000000};
           rd2ex_reg <= 0;
           //ex2wb_reg <= 0;
        end
        else if(clear_df)
        begin
           instr_reg <= {`NOP,    9'b000000000};
           rd2ex_reg <= 0;
           ex2wb_reg <= 0;
        end
        else
        begin
            instr_reg <= instruction;
            rd2ex_reg <= {alu_en_rd2ex, 
                          reg_we_en_rd2ex, 
                          mem_we_rd2ex, 
                          mem_re_rd2ex, 
                          loadc_en_rd2ex, 
                          jmp_sel_rd2ex, 
                          jmpr_sel_rd2ex, 
                          jmp_offset_rd2ex, 
                          op1_rd2ex, 
                          op2_rd2ex, 
                          alu_cmd_rd2ex,
                          dest_reg_rd2ex 
                          };
                          
            ex2wb_reg <= {reg_we_ex2wb, load_en_ex2wb, result_ex2wb, dest_reg_ex2wb};
        end
    end
    
    always@(*)
    begin
        if(~rst)
        begin
            for (i = 0; i <= 7; i = i + 1)
                begin
                    R[i] <= 0;
                end 
            op1_rd <= 0;
            op2_rd <= 0;
        end
        else 
        begin
            if(reg_we_rs)
            begin
                R[dest_rs] <= result_rs;
            end
            if(reg_re_en_rs)
            begin
                op1_rd <= R[addr_op1_rs];
                op2_rd <= R[addr_op2_rs];
            end
            if(mem_re_rs)
                data_in_mem <= mem[addr_mem];
            if(mem_we_rs)
                mem[addr_mem] <= dout_mem;
        end
    end
    
    fetch  Fetch(// General
               .clk(clk),
               .rst(rst),
               // Inputs <- Program Memory
               //.instruction(instruction),
               // Input <- EXECUTE
               .jmp_sel     (jmp_sel_f),
               .jmpr_sel    (jmpr_sel_f),
               .jmp         (jmp_f),
               .jmp_offset  (jmp_offset_f),
               // Input <- Read
               .en_write_pc (en_write_pc),
               // Input <- Data Forwarding
               .freeze      (clear_rd),
               // Output -> Instruction Register
               //.instr_ir    (instr_ir),
               // Output -> Program Memory
               .pc_out      (pc_out)
               );
               
    read Read (// General
               .clk        (clk),
               .rst        (rst),
              // Input <- Instruction Register
              .instr_rd    (instr_reg),
              // Input Reg Set
              .op1_rs      (op1_rd),
              .op2_rs      (op2_rd),
              .reg_re_en   (reg_re_en_rs),
              // Input <- Data Forwarding + Jump Control
              .clear       (clear_rd),
              // Input <- DataForwarding
              .df1         (df1),
              .df2         (df2),
              .result_ex   (result_ex2wb),
              // Output -> Fetch
              .en_write_pc (en_write_pc),
              // Output -> Reg Set
              .addr_op1    (addr_op1_rs),
              .addr_op2    (addr_op2_rs),
              // Output -> Read2EX
              //  - control signals
              .alu_en      (alu_en_rd2ex),
              .reg_we_en   (reg_we_en_rd2ex),
              .mem_re      (mem_re_rd2ex),
              .mem_we      (mem_we_rd2ex),
              .loadc_en    (loadc_en_rd2ex),
              .jmp_sel     (jmp_sel_rd2ex),
              .jmpr_sel    (jmpr_sel_rd2ex),
              //  -operands
              .jmp_offset  (jmp_offset_rd2ex),
              .op1         (op1_rd2ex),
              .op2         (op2_rd2ex),
              //  - destination
              .dest_reg    (dest_reg_rd2ex),
              //  -alu_operation
              .alu_cmd     (alu_cmd_rd2ex)     
              );
   
   execute Execute (// General
                    .clk          (clk),
                    .rst          (rst),
                    // Input -> Rd2Ex
                    //     - control signals
                    .alu_en_ex      (rd2ex_reg [90:90]),
                    .reg_we_ex      (rd2ex_reg [89:89]),
                    .mem_we_ex      (rd2ex_reg [88:88]),
                    .mem_re_ex      (rd2ex_reg [87:87]),
                    .loadc_en_ex    (rd2ex_reg [86:86]),
                    .jmp_sel_ex     (rd2ex_reg [85:85]),
                    .jmpr_sel_ex    (rd2ex_reg [84:84]),
                    //     - operands
                    .jmp_offset_ex  (rd2ex_reg [83:74]),
                    .op1_ex         (rd2ex_reg [73:42]),
                    .op2_ex         (rd2ex_reg [41:10]),
                    .alu_cmd_ex     (rd2ex_reg [ 9: 3]),
                    .dest_reg_ex    (rd2ex_reg [ 2: 0]),
                    
                    // Input <- Data Forwarding
                    //.clear(),
                    // Ouput -> Fetch
                    .jmp_sel        (jmp_sel_f),
                    .jmpr_sel       (jmpr_sel_f),
                    .jmp            (jmp_f),
                    .jmp_offset     (jmp_offset_f),
                    // Output -> Memory
                    .mem_re         (mem_re_rs),
                    .mem_we         (mem_we_rs),
                    .addr_mem       (addr_mem),
                    .dout_mem       (dout_mem),
                    // Output -> Ex2wb Register
                    .reg_we         (reg_we_ex2wb),
                    .load_en        (load_en_ex2wb),
                    .result         (result_ex2wb),
                    .dest_reg       (dest_reg_ex2wb),
                    .clear          (clear_rd)
                    );
    
    //or(clear, clear_rd, clear_df);
    
    write_back Write_Back (// General
                            .clk         (clk),
                            .rst         (rst),
                            // Input <- Execute
                            .reg_we_wb   (ex2wb_reg[36:36]),
                            .load_en_wb  (ex2wb_reg[35:35]),
                            .result_wb   (ex2wb_reg[34:3]),
                            .dest_reg_wb (ex2wb_reg[ 2:0]),
                            // Input <- Memory 
                            .data_in     (data_in_mem),
                            // Output -> Register Set
                            .result_rs   (result_rs),
                            .dest_rs     (dest_rs),
                            .reg_we_rs   (reg_we_rs)
                            );
                            
    data_forwarding Data_Forwarding (// General 
                                     .clk           (clk),
                                     .rst           (rst),  
                                     // Input <- Read
                                     .addr_op1_rd2ex(addr_op1_rs),
                                     .addr_op2_rd2ex(addr_op2_rs),
                                     .dest_rd2ex    (dest_reg_rd2ex),
                                     .reg_re_en     (reg_re_en_rs),
                                     // Input <- Execute
                                     .dest_reg_wb   (dest_reg_ex2wb),
                                     .reg_we_wb     (reg_we_rs),
                                     .loadc_en      (load_en_ex2wb),
                                     .mem_re_en     (mem_re_rs),
                                     // Output -> READ
                                     .clear         (clear_df),
                                     .freeze        (freeze_df),
                                     // Output -> Read
                                     .df1           (df1),
                                     .df2           (df2)
                                     //.df_dest     (df_dest)
                                     );
    
endmodule
