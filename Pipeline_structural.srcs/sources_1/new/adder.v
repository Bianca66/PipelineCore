`timescale 1ns/1ps

module adder #(parameter D_SIZE = 32,
               parameter A_SIZE = 10)
              (input  [A_SIZE-1:0] in1, 
               input  [A_SIZE-1:0] in2, 
               output [A_SIZE-1:0] out
               );
               
    assign out = in1 + in2;
    
endmodule        