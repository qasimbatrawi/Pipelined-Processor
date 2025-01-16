module IDStage(
	input wire clk,
	input wire [14:0] controlsignals,
	input wire [1:0] ForwardA, ForwardB,
	input wire [15:0] instruction, PC, NextPC,
	input wire [2:0] DestinationRegister_WB,
	input wire [15:0] ALUOut, MemoryOut, WBData, // this is the forwarded data
	input wire RRWE, JumpSrc, RegWr_WB, kill, stall,
		
	output reg [2:0] ALUOp,
	output reg RegWr,MemR, MemW, WB, ALUSrc1, Destination, Source1, Source2, ALUSrc2, ExOp, CompSrc, J,
	output reg [2:0] Rs1, Rs2, Rd,
	output reg [15:0] Bus1, Bus2, // output from forward mux
	output reg [15:0] imm,
	output reg comp_res,
	output reg [15:0] Branch_TA, Jump_TA, For_TA,
	output reg [2:0] func,
	output reg [3:0] opcode,
	output reg [15:0] num_lw, num_sw, num_alu, num_control
); 	


	wire [9:0] offset ;	
	wire [15:0] Data1, Data2; // output from reg file 
	wire [15:0] extended_imm ;
	wire [15:0] concat ;
	
	wire [15:0] comp_input ;
	
	reg [15:0] RR ;
	reg [15:0] numlw, numsw, numalu, numcontrol ;
	
	initial begin
		numlw = 0; num_lw = 0 ;
		numalu = 0 ; num_sw = 0 ;
		numsw = 0 ;	 num_alu = 0 ;
		numcontrol = 0 ;  num_control = 0 ;
	end
	
	
	assign ALUOp = controlsignals[14:12] ;
	assign RegWr = controlsignals[11] ;
	assign MemR = controlsignals[10] ;
	assign MemW = controlsignals[9] ;
	assign WB = controlsignals[8] ;
	assign ALUSrc1 = controlsignals[7] ;
	assign Destination = controlsignals[6] ;
	assign Source1 = controlsignals[5] ;
	assign Source2 = controlsignals[4] ;
	assign ALUSrc2 = controlsignals[3] ;
	assign ExOp = controlsignals[2] ;
	assign CompSrc = controlsignals[1] ;
	assign J = controlsignals[0] ;
	

	assign Rs1 = (Source1 == 0) ? instruction[8:6] : 
	             (Source1 == 1) ? instruction[11:9] : 3'b0;
	
	assign Rs2 = (Source2 == 0) ? instruction[5:3] : 
	             (Source2 == 1) ? instruction[8:6] : 3'b0;
	
	assign Rd = (Destination == 0) ? instruction[11:9] : 
				(Destination == 1) ? instruction[8:6] : 3'b0;
	
	assign offset = instruction[11:3] ;
	
	assign opcode = instruction[15:12] ;
	assign func = instruction[2:0] ; 
	
	always @(posedge clk) begin
		if (instruction !== 16'bx && instruction != 16'b0) begin
			case (opcode) 
				4'b0000: if (stall == 0) begin numalu <= numalu + 1 ; num_alu <= numalu + 1 ; end 
				4'b0010: if (stall == 0) begin numalu <= numalu + 1 ; num_alu <= numalu + 1 ; end 
				4'b0011: if (stall == 0) begin numalu <= numalu + 1 ; num_alu <= numalu + 1 ; end 
				4'b0100: if (stall == 0) begin numlw <= numlw + 1 ; num_lw <= numlw + 1 ; end
				4'b0101: if (stall == 0) begin numsw <= numsw + 1 ; num_sw <= numsw + 1 ; end
				4'b0001: begin numcontrol <= numcontrol + 1 ; num_control <= numcontrol + 1 ; end
				4'b0110: begin numcontrol <= numcontrol + 1 ; num_control <= numcontrol + 1 ; end
				4'b0111: begin numcontrol <= numcontrol + 1 ; num_control <= numcontrol + 1 ; end
			endcase		
		end		

	end
	
	always @(posedge clk) begin
		if (RRWE) begin RR <= NextPC; end
	end
	
	Extender extend(
		.in(instruction[5:0]),
        .ExtOp(ExOp),
        .out(extended_imm)
	);
	

	RegisterFile reg_file (
        .clk(clk),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd(DestinationRegister_WB),
        .RegWr(RegWr_WB), 
        .WBbus(WBData),
        .Bus1(Data1),
        .Bus2(Data2)
    );
	
	assign  Branch_TA = extended_imm + PC  ;
	assign  Jump_TA = (JumpSrc == 0) ? {PC[15:9],offset} : RR ;
    assign  For_TA = Bus1;
    assign  imm = extended_imm;	

	 mux_4 #(.LENGTH(16)) mux_ForwardA (
	    .in1(Data1),
	    .in2(ALUOut),
	    .in3(MemoryOut),
	    .in4(WBData),
	    .sel(ForwardA),
	    .out(Bus1)
	  );
	  
	  mux_4 #(.LENGTH(16)) mux_ForwardB (
	    .in1(Data2),
	    .in2(ALUOut),
	    .in3(MemoryOut),
	    .in4(WBData),
	    .sel(ForwardB),
	    .out(Bus2)
	  );
	  
	  mux_2 #(.LENGTH(16)) mux_comp_input (
	    .in1(Bus1),
	    .in2(16'b0),
	    .sel(CompSrc),
	    .out(comp_input)
	  );
	  
	   Compare comp (
        .A(Bus2),
        .B(comp_input),
        .comp_res(comp_res)
    );
	
	

endmodule  	
