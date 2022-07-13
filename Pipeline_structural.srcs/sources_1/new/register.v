`timescale 1ns/1ps

module register #(parameter D_SIZE = 32,
                  parameter A_SIZE = 10)
                 (input              clk,
                  input              rst,
                  input              en_write,
                  input [A_SIZE-1:0] data_in,
                  output[A_SIZE-1:0] data_out
                  );
    
    reg [D_SIZE-1:0] data_out_reg;
    
    assign data_out = data_out_reg;
    
    always @(posedge clk or negedge rst or en_write or en_write)
    begin
        if(~rst)
        begin
            data_out_reg <= 0;
        end
        else if(en_write)
        begin
            data_out_reg <= data_in;
        end
    end
endmodule