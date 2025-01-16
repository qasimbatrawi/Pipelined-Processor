module IFStage (
    input wire clk,
	input kill, stall,
    input wire [1:0] PCSrc,
    input wire [15:0] Branch_TA, Jump_TA, For_TA, 
    output reg [15:0] CurrentPC, New_PC, Instruction,
	output reg [15:0] num_executed_instructions, num_stall
);

    reg [15:0] PC ;
    wire [15:0] instruction_wire; 
	reg [15:0] num_inst, numstall ;	 
	
    InstructionMemory instruction(
        .clk(clk),
        .Address(PC),
		.stall(stall),
        .instruction(instruction_wire)
    );
	
	mux_2 #(.LENGTH(16)) mux_kill (
	    .in1(instruction_wire),
	    .in2(16'b0),
	    .sel(kill),
	    .out(Instruction)
	);
	
	always @(posedge clk) begin
		if (!stall) begin 
			CurrentPC <= PC ;
			PC <= PC + 16'b1 ;
			New_PC <= PC + 16'b1 ;
		end	
		
		if (Instruction !== 16'bx  && Instruction != 16'b0) begin
            num_inst <= num_inst + 1;
            num_executed_instructions <= num_inst + 1; 
        end
		if (stall == 1) begin
			numstall <= numstall + 1;
            num_stall <= numstall + 1;
		end		
	end
	

    always @(*) begin 
		#0.5ps
		if (!stall)
	        case (PCSrc) 
	            2'b01: begin PC = Branch_TA; New_PC = Branch_TA; end
	            2'b10: begin PC = Jump_TA; New_PC = Jump_TA; end
	            2'b11: begin PC = For_TA; New_PC = For_TA; end 
	        endcase
    end
	
	initial begin
		num_executed_instructions = 0 ;
		num_inst = 16'b0 ;
		numstall = 0 ;
		num_stall = 0 ;
        PC = 16'b0;
        New_PC = 16'b0;	
		CurrentPC = 16'b0 ;

    end


endmodule