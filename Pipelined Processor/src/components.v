module mux_2 #(parameter integer LENGTH) (in1, in2, sel, out); 
	
  input wire [LENGTH-1:0] in1, in2;
  input wire sel;
  output reg [LENGTH-1:0] out;

  assign out = (sel == 0) ? in1 : in2;

endmodule

module mux_4 #(parameter integer LENGTH) (in1, in2, in3, in4, sel, out); 
	
  input wire [LENGTH-1:0] in1, in2, in3, in4;
  input wire [1:0] sel;
  output reg [LENGTH-1:0] out;

  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 :
               (sel == 2'd2) ? in3 : in4;
endmodule

module Extender (
    input wire [5:0] in,
    input wire ExtOp,
    output reg [15:0] out
);

    always @(*) begin
        
        if (ExtOp) begin
            // Signed extension
            out <= {{10{in[5]}}, in[5:0]};
        end 
		else begin
            // Unsigned extension
            out <= {10'b0, in[5:0]};
        end
        
    end
endmodule


module Compare(
    input wire signed [15:0] A, 
    input wire signed [15:0] B, 
    output reg comp_res
);

    always @(A, B) begin
        // Initialize all outputs to 0
		comp_res=0 ;

        // Compare A and B
        if (A == B) begin
            comp_res = 1;
		end
        else begin
            comp_res = 0;
        end
    end

endmodule	   

