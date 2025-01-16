module IF_ID(
	input wire clk, stall,
	input wire [15:0] PCIn, nextPCIn, IRIn, 
	output reg [15:0] IROut, PCOut, nextPCOut
) ;
	
	
	always @ (posedge clk) begin
		if (!stall)	begin
			IROut <= IRIn;
			PCOut <= PCIn;
			nextPCOut <= nextPCIn; 
		end			  
	end  
	
endmodule	