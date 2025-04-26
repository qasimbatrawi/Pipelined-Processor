module DataPath(  
	
	input clk,
	
	output reg [15:0] instruction_IF, instruction_ID, // instruction in fetch and decode stages
	output reg [15:0] PC_IF, PC_ID, // pc in fetch and decode stages

	output reg [1:0] PCSrc,
	output reg [15:0] Branch_TA, Jump_TA, For_TA,
	
	
	output reg [2:0] ALUOp_ID, ALUOp_EXE,
	output reg RegWr_ID, RegWr_EXE, RegWr_MEM, RegWr_WB,
	output reg MemR_ID, MemR_EXE, MemR_MEM,
	output reg MemW_ID, MemW_EXE, MemW_MEM,
	output reg WB_ID, WB_EXE, WB_MEM,
	output reg ALUSrc1_signal_ID, ALUSrc1_signal_EXE, ALUSrc2_signal_ID, ALUSrc2_signal_EXE,
	output reg Destination_ID ,
	output reg Source1_ID, Source2_ID,
	output reg CompSrc_ID ,
	output reg ExOp_ID ,
	output reg J_ID,
	
	output reg JumpSrc, RRWE,
	output reg [1:0] ForwardA, ForwardB,
	output reg [15:0] WBData_MEM, WBData_WB, ALUOut_EXE, ALUOut_MEM, MemoryOut, // ALUOut_MEM is the address of the memory
	
	output reg [14:0] controlsignals ,

	output reg comp_res,
	output reg [2:0] Rs1, Rs2, Rd, Rd2, Rd3, Rd4, func,
	output reg [3:0] opcode,
	output reg [15:0] Bus1_ID, Bus1_EXE, Bus2_ID, Bus2_EXE, Bus2_MEM, imm_ID, imm_EXE, // Bus2_MEM is DataIn
	output reg kill ,
	output reg stall ,   
	
	output reg [15:0] CurrentPC, New_PC_Plus_1_ID ,
	
	output reg [15:0] num_executed_instructions, num_lw, num_sw, num_alu, num_control, num_cycles, num_stall
	
);


	assign num_cycles = num_executed_instructions + 1 + num_stall + 4 ;


	// Control unit to generate control signals
	MainControlUnit control(
		.opcode(opcode),
		.func(func),
		.stall(stall),
		.ControlSignals(controlsignals)
	); 
	
	// PC control unit to choose the next pc 
	PCControlUnit control_pc(
		.opcode(opcode),
		.func(func),
		.comp_res(comp_res),
		.J(J_ID),
		.Kill(kill),
		.PCSrc(PCSrc),
		.JumpSrc(JumpSrc),
		.RRWE(RRWE)
	); 
	
	// to generate forwad signals and stall 
	ForwordingControlUnit forwardingUnit (
        .RS1(Rs1), 
        .RS2(Rs2), 
        .RD2(Rd2), 
        .RD3(Rd3), 
        .RD4(Rd4),
        .Ex_MemR(MemR_EXE),
        .Ex_RegWr(RegWr_EXE),
        .Mem_RegWr(RegWr_MEM),
        .WB_RegWr(RegWr_WB),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .stall(stall)
    ); 	
	
	// Fetch stage
	IFStage stage1(
		.clk(clk), 
		.PCSrc(PCSrc),		   
		.Branch_TA(Branch_TA),
		.Jump_TA(Jump_TA), 
		.For_TA(For_TA),
		.stall(stall),
		.kill(kill), 
		
		.num_stall(num_stall),
		.CurrentPC(CurrentPC),
		.New_PC(PC_IF),
		.Instruction(instruction_IF)
	);
		
	
	// buffers form IF -> ID
	IF_ID I_D(
		.clk(clk), .stall(stall), 
		.PCIn(CurrentPC), .PCOut(PC_ID),
		.nextPCIn(CurrentPC+1), .nextPCOut(New_PC_Plus_1_ID),
		.IRIn(instruction_IF), .IROut(instruction_ID)
	);
	
	// Decode Stage
	IDStage id_stage (
		.clk(clk),
		.controlsignals(controlsignals),
	    .ForwardA(ForwardA),
	    .ForwardB(ForwardB),
		.instruction(instruction_ID),
	    .PC(PC_ID),	
		.NextPC(New_PC_Plus_1_ID),
	    .WBData(WBData_WB),
	    .DestinationRegister_WB(Rd4),
	    .ALUOut(ALUOut_EXE),
	    .MemoryOut(WBData_MEM),
	    .RRWE(RRWE),
	    .JumpSrc(JumpSrc),
		.RegWr_WB(RegWr_WB),
		.kill(kill),
		.stall(stall),

		.ALUOp(ALUOp_ID),
	    .RegWr(RegWr_ID),
	    .MemR(MemR_ID),
		.MemW(MemW_ID),
	    .WB(WB_ID),
	    .ALUSrc1(ALUSrc1_signal_ID),
	    .Destination(Destination_ID),
	    .Source1(Source1_ID),
	    .Source2(Source2_ID),
	    .ALUSrc2(ALUSrc2_signal_ID),
		.ExOp(ExOp_ID),
	    .CompSrc(CompSrc_ID),
	    .J(J_ID),
	    .Rs1(Rs1),
	    .Rs2(Rs2),
	    .Rd(Rd),
	    .Bus1(Bus1_ID),
	    .Bus2(Bus2_ID),
	    .imm(imm_ID),
	    .comp_res(comp_res),
	    .Branch_TA(Branch_TA),
	    .Jump_TA(Jump_TA),
	    .For_TA(For_TA),
	    .func(func),
		.opcode(opcode),
		.num_lw(num_lw),
		.num_sw(num_sw),
		.num_alu(num_alu),
		.num_control(num_control),	 
		.num_executed_instructions(num_executed_instructions)
	);
	
	// Buffers from ID -> EXE
	ID_EXE id_exe (
        .clk(clk),
        .Rd2In(Rd), .Rd2Out(Rd2),
        .RegWrIn(RegWr_ID), .RegWrOut(RegWr_EXE),
        .ALUOpIn(ALUOp_ID), .ALUOpOut(ALUOp_EXE),
        .MemRIn(MemR_ID), .MemROut(MemR_EXE),
        .MemWIn(MemW_ID), .MemWOut(MemW_EXE),
        .WBIn(WB_ID), .WBOut(WB_EXE),
        .ALUSrc2_SignalIn(ALUSrc2_signal_ID), .ALUSrc2_SignalOut(ALUSrc2_signal_EXE),
        .ImmIn(imm_ID), .ImmOut(imm_EXE),
        .ALUSrc1_SignalIn(ALUSrc1_signal_ID), .ALUSrc1_SignalOut(ALUSrc1_signal_EXE),
        .Bus1In(Bus1_ID), .Bus1Out(Bus1_EXE),
        .Bus2In(Bus2_ID), .Bus2Out(Bus2_EXE)
    );
	
	// Execute stage
	EXEStage exe_stage (
        .clk(clk),
        .Imm(imm_EXE),
        .Bus1(Bus1_EXE),
        .Bus2(Bus2_EXE),
        .ALUSrc1_signal(ALUSrc1_signal_EXE),
        .ALUSrc2_signal(ALUSrc2_signal_EXE),
        .ALUOut(ALUOut_EXE),
		.ALUOp(ALUOp_EXE)
    );
	
	// Buffers from EXE -> MEM
	EXE_MEM exe_mem (
        .clk(clk),
        .Rd3In(Rd2), .Rd3Out(Rd3),
        .RegWrIn(RegWr_EXE), .RegWrOut(RegWr_MEM),
        .MemRIn(MemR_EXE), .MemROut(MemR_MEM),
        .MemWIn(MemW_EXE), .MemWOut(MemW_MEM),
        .WBIn(WB_EXE), .WBOut(WB_MEM),
        .DataInIn(Bus2_EXE), .DataInOut(Bus2_MEM),
        .ALUOutIn(ALUOut_EXE), .ALUOutOut(ALUOut_MEM)
    ); 
	
	// MEM stage
	MEMStage mem_stage (
        .clk(clk),
        .Address(ALUOut_MEM),       
        .DataIn(Bus2_MEM), 
        .MemR(MemR_MEM),   
        .MemW(MemW_MEM),       
        .WB(WB_MEM),              
        .MemoryOut(MemoryOut), 
		
        .WBData(WBData_MEM)         
    );	
	
	// Buffers MEM -> WB
	MEM_WB mem_wb (
        .clk(clk),
        .Rd4In(Rd3), .Rd4Out(Rd4),
        .RegWrIn(RegWr_MEM), .RegWrOut(RegWr_WB),
		
        .WBDataIn(WBData_MEM), .WBDataOut(WBData_WB)
    );
	

endmodule 

module tb_DataPath() ;	
	
	reg clk ; // input
	
	
	// *************************************** OUTPUTS *************************************************
	
	wire [15:0] instruction_IF, instruction_ID ;
	wire [15:0] PC_IF, PC_ID ;

	wire [1:0] PCSrc ;
	wire [15:0] Branch_TA, Jump_TA, For_TA ; 
	
	wire [2:0] ALUOp_ID, ALUOp_EXE ;
	wire RegWr_ID, RegWr_EXE, RegWr_MEM, RegWr_WB ;
	wire MemR_ID, MemR_EXE, MemR_MEM ;
	wire MemW_ID, MemW_EXE, MemW_MEM ; 
	wire WB_ID, WB_EXE, WB_MEM ;
	wire ALUSrc1_signal_ID, ALUSrc1_signal_EXE, ALUSrc2_signal_ID, ALUSrc2_signal_EXE ;
	wire Destination_ID ;
	wire Source1_ID, Source2_ID ;
	wire CompSrc_ID ;	
	wire ExOp_ID ;
	wire J_ID ;
	
	wire JumpSrc, RRWE;
	wire [1:0] ForwardA, ForwardB;	
	wire [15:0] WBData_MEM, WBData_WB, ALUOut_EXE, ALUOut_MEM, MemoryOut ; // ALUOut_MEM is the address of the memory
	
	wire [14:0] controlsignals ;

	wire comp_res;
	wire [2:0] Rs1, Rs2, Rd, Rd2, Rd3, Rd4, func;
	wire [3:0] opcode;
	wire [15:0] Bus1_ID, Bus1_EXE, Bus2_ID, Bus2_EXE, Bus2_MEM, imm_ID, imm_EXE; // Bus2_MEM is DataIn
	wire kill ;
	wire stall ;   
	
	wire [15:0] CurrentPC, New_PC_Plus_1_ID ;
	
	wire [15:0] num_executed_instructions, num_lw, num_sw, num_alu, num_control, num_cycles, num_stall ; 
	
	// instance from the data path module
	DataPath uut(
	.clk(clk), .instruction_IF(instruction_IF), .instruction_ID(instruction_ID), .PC_IF(PC_IF),	 
	.PC_ID(PC_ID), .PCSrc(PCSrc), .Branch_TA(Branch_TA), .Jump_TA(Jump_TA), .For_TA(For_TA),
	.ALUOp_ID(ALUOp_ID), .ALUOp_EXE(ALUOp_EXE), .RegWr_ID(RegWr_ID), .RegWr_EXE(RegWr_EXE), .RegWr_MEM(RegWr_MEM), .RegWr_WB(RegWr_WB),
	.MemR_ID(MemR_ID), .MemR_EXE(MemR_EXE), .MemR_MEM(MemR_MEM), .MemW_ID(MemW_ID), .MemW_EXE(MemW_EXE), .MemW_MEM(MemR_MEM),
	.WB_ID(WB_ID), .WB_EXE(WB_EXE), .WB_MEM(WB_MEM), .ALUSrc1_signal_ID(ALUSrc1_signal_ID), .ALUSrc1_signal_EXE(ALUSrc1_signal_EXE),
	.ALUSrc2_signal_ID(ALUSrc2_signal_ID), .ALUSrc2_signal_EXE(ALUSrc2_signal_EXE),	.Destination_ID(Destination_ID), .Source1_ID(Source1_ID),
	.Source2_ID(Source2_ID), .CompSrc_ID(CompSrc_ID), .ExOp_ID(ExOp_ID), .J_ID(J_ID), .JumpSrc(JumpSrc), .RRWE(RRWE), .ForwardA(ForwardA),
	.ForwardB(ForwardB), .WBData_MEM(WBData_MEM), .WBData_WB(WBData_WB), .ALUOut_EXE(ALUOut_EXE), .ALUOut_MEM(ALUOut_MEM), .MemoryOut(MemoryOut),
	.controlsignals(controlsignals), .comp_res(comp_res), .Rs1(Rs1), .Rs2(Rs2), .Rd(Rd), .Rd2(Rd2), .Rd3(Rd3), .Rd4(Rd4), .func(func), .opcode(opcode),
	.CurrentPC(CurrentPC), .New_PC_Plus_1_ID(New_PC_Plus_1_ID) , .stall(stall), .kill(kill),
    .Bus1_ID(Bus1_ID), .Bus1_EXE(Bus1_EXE) ,.Bus2_ID(Bus2_ID) ,.Bus2_EXE(Bus2_EXE), .Bus2_MEM(Bus2_MEM) , .imm_ID(imm_ID), .imm_EXE(imm_EXE),
	.num_executed_instructions(num_executed_instructions), .num_lw(num_lw), .num_sw(num_sw), .num_alu(num_alu), .num_control(num_control), 
    .num_cycles(num_cycles), .num_stall(num_stall)
	) ;
	
	// generating the clock
	initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end		
	
	
	
	
	
	
    // results of performance registers
	initial begin
        #500 
		$display("Total number of executed instructions: %0d", num_executed_instructions + 1) ;
		$display("Total number of load instructions: %0d", num_lw) ;
		$display("Total number of store instructions: %0d", num_sw) ;
		$display("Total number of alu instructions: %0d", num_alu) ;
		$display("Total number of control instructions: %0d", num_control) ;
		$display("Total number of stall cycles: %0d", num_stall) ;
		$display("Total number of cycles: %0d", num_cycles) ;
		$finish;
    end
	
	
endmodule	


