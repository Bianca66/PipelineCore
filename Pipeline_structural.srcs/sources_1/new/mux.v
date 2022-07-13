`timescale 1ns/1ps

module mux  #(parameter N = 32)
             (input  [N-1:0] in1, 
              input  [N-1:0] in2, 
              input          sel, 
              output [N-1:0] out);
            
    assign out = (~sel)? in1 : in2;
    
endmodule

module mux3  #(parameter N = 32)
              (input  [N-1:0] in1, 
               input  [N-1:0] in2,
               input  [N-1:0] in3,
               input          sel1,
               input          sel2, 
               output [N-1:0] out);
               
    assign out =  (( sel1)  && (~sel2))? in1:
                 (((~sel1)  && (~sel2))? in2:
                 (((~sel1)  && (sel2))?  in3: 0));
    
endmodule