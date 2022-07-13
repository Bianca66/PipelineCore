`timescale 1ns/1ps

module RegSet  #(// General Parameters
                 parameter D_SIZE = 32,
                 parameter A_SIZE = 10)
                (// General 
                 input               clk,
                 input               rst,
                 // Input <- READ
                 input               en_write,
                 input         [2:0] dest,
                 input  [D_SIZE-1:0] result,
                 input         [2:0] addr_op1,
                 input         [2:0] addr_op2,
                 // Output -> Control_rd
                 output [D_SIZE-1:0] op1_0,
                 output [D_SIZE-1:0] op2_0
                 );
                 
    //Register Set
    reg [D_SIZE-1:0] R [0:7];
    
    // Iterator
    integer i;
    
    //
    reg [D_SIZE-1:0] op1;
    reg [D_SIZE-1:0] op2;

    assign op1_0 = op1;
    assign op2_0 = op2;
    
    always @(posedge clk or negedge rst)
    begin
        if(~rst)
        begin
            for(i = 0; i <= 7; i = i + 1)
                R[i] <= 0;
        end
        else if(en_write)
        begin
            R[dest] <= result;
        end
        else if(~en_write)
        begin
            op1 <= R[addr_op1];
            op2 <= R[addr_op2];
        end
    end 
endmodule