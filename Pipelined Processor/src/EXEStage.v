module EXEStage (
    input wire clk,
    input wire [15:0] Imm,
    input wire [15:0] Bus1, // value from the forwarded mux
    input wire [15:0] Bus2,	// value from the forwarded mux
    input wire ALUSrc1_signal,ALUSrc2_signal,
	input wire [2:0] ALUOp,
    output reg [15:0] ALUOut 
); 

	wire signed [15:0] ALUSrc1, ALUSrc2;

    assign ALUSrc1 = ALUSrc1_signal == 0 ? Bus1: 16'b1 ;

    assign ALUSrc2 = ALUSrc2_signal == 0 ? Bus2 : Imm ;

    ALU alu (
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .ALUOut(ALUOut),
        .ALUOp(ALUOp)
    );	  
	

endmodule