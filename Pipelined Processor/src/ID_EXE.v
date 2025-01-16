module ID_EXE(	
	input wire clk,
	input wire [2:0] Rd2In, output reg [2:0] Rd2Out, 
	input wire  RegWrIn, output reg RegWrOut,
	input wire [2:0] ALUOpIn, output reg [2:0] ALUOpOut,
	input wire MemRIn, output reg MemROut,
	input wire MemWIn, output reg MemWOut,
	input wire WBIn, output reg WBOut,
	input wire ALUSrc2_SignalIn, output reg ALUSrc2_SignalOut,
	input wire [15:0] ImmIn, output reg [15:0] ImmOut, 
	input wire ALUSrc1_SignalIn, output reg ALUSrc1_SignalOut, 
	input wire [15:0] Bus1In, output reg [15:0] Bus1Out,
	input wire [15:0] Bus2In, output reg [15:0] Bus2Out
);		 

	always @ (posedge clk) begin
	
		Rd2Out <= Rd2In;
		RegWrOut <= RegWrIn;
		ALUOpOut <= ALUOpIn;
		MemROut <= MemRIn;
		MemWOut <= MemWIn;
		WBOut <= WBIn;
		ALUSrc2_SignalOut <= ALUSrc2_SignalIn;
		ImmOut <= ImmIn;
		ALUSrc1_SignalOut <= ALUSrc1_SignalIn;
		Bus1Out <= Bus1In;
		Bus2Out <= Bus2In;
	  
	end 


endmodule