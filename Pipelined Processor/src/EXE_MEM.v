module EXE_MEM(
	input wire clk,
	input wire [2:0] Rd3In, output reg [2:0] Rd3Out,
	input wire RegWrIn, output reg RegWrOut,
	input wire MemRIn, output reg MemROut,
	input wire MemWIn, output reg MemWOut,
	input wire WBIn, output reg WBOut,
	input wire [15:0] DataInIn, output reg [15:0] DataInOut,
	input wire [15:0] ALUOutIn, output reg [15:0] ALUOutOut
);


	always @(posedge clk) begin

        Rd3Out <= Rd3In;
        RegWrOut <= RegWrIn;
        MemROut <= MemRIn;
        MemWOut <= MemWIn;
        WBOut <= WBIn;
        DataInOut <= DataInIn;
        ALUOutOut <= ALUOutIn;

    end
	
endmodule