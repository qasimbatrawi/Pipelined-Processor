module MEM_WB(
	input wire clk,
	input wire [2:0] Rd4In, output reg [2:0] Rd4Out,
	input wire RegWrIn, output reg RegWrOut,
	input wire [15:0] WBDataIn, output reg [15:0] WBDataOut
);


	always @(posedge clk) begin
	
		Rd4Out <= Rd4In;
		RegWrOut <= RegWrIn;
		WBDataOut <= WBDataIn;
	
	end

endmodule