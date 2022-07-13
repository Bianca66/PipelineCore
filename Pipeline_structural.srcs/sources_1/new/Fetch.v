`timescale 1ns/1ps

module Fetch #(// General Parameters
               parameter D_SIZE = 32,
               parameter A_SIZE = 10)
              (// General
               input               clk,
               input               rst,
               // Input <- Program Memory 
               input        [15:0] instruction,
               // Input <- JUMP CONTROL
               input               jmpr_sel,
               input               jmp_sel,
               input  [A_SIZE-1:0] jmp_offset, 
               input  [A_SIZE-1:0] jmp,
               // Input <- READ
               input               en_write_pc, //freeze
               // Output -> READ
               output       [15:0] instr_ir,
               // Output -> Program_Memory
               output [A_SIZE-1:0] pc_out
               );
               
    wire [A_SIZE-1:0] adder_in1;
    wire [A_SIZE-1:0] adder_in2;
    wire [A_SIZE-1:0] pc_in;
    wire [A_SIZE-1:0] adder_out;
    
    assign pc_out   = adder_in2;
    assign instr_ir = instruction;
 
    mux   #(.N(A_SIZE)) mux_adder_input(.in1({{A_SIZE-1{0}},1}),
                                        .in2(jmp_offset),
                                        .sel(jmpr_sel),
                                        .out(adder_in1)
                                        );
                       
    adder   adder_pc (.in1(adder_in1),
                      .in2(adder_in2),
                      .out(adder_out)
                      );
                       
    mux #(.N(A_SIZE)) mux_pc_input (.in1(adder_out),
                                    .in2(jmp),
                                    .sel(jmp_sel),
                                    .out(pc_in)
                                    );
    
    register  pc (.clk(clk),
                  .rst(rst),
                  .en_write(en_write_pc),
                  .data_in(pc_in),
                  .data_out(adder_in2)
                  );                                              
    
endmodule