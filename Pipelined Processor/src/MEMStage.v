module MEMStage (
    input wire clk,
    input wire [15:0] Address, // ALUOut
    input wire [15:0] DataIn,
    input wire MemR, 
    input wire MemW,
	input wire WB,

    output reg [15:0] MemoryOut, WBData
);	   

    // DataMemory instance
    DataMemory data_memory (
        .clk(clk),
        .MemW(MemW),
        .MemR(MemR),
        .Address(Address),
        .DataIn(DataIn),
        .MemoryOut(MemoryOut)
    );	 
	

	  mux_2 #(.LENGTH(16)) mux_WBData (
	    .in1(MemoryOut),
	    .in2(Address),
	    .sel(WB),
	    .out(WBData)
	  );  


endmodule