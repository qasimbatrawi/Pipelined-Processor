module InstructionMemory(
    input wire clk,	
	input wire stall, 
    input wire [15:0] Address, // PC 
    output reg [15:0] instruction
);

    reg [15:0] instMemory [0:65535]; // The size is 2^16 because the instruction and word size is 16 bits.

    always @(posedge clk) begin
		if (!stall)
        	instruction <= instMemory[Address];	 

    end 

    initial begin		  
		
		
		
//		//Alu instructions with data dependencies & Forwarding
//
//        instMemory[0] = {4'b0000, 3'b001, 3'b010, 3'b011, 3'b001}; // R1 = R2 + R3 = 2 + 3 = 5
  //      instMemory[1] = {4'b0000, 3'b111, 3'b001, 3'b011, 3'b001}; // R7 = R1 + R3 = 5 + 3 = 8
    //    instMemory[2] = {4'b0000, 3'b110, 3'b001, 3'b101, 3'b010}; // R6 = R1 - R5 = 5 - 5 = 0 
      //  instMemory[3] = {4'b0000, 3'b101, 3'b001, 3'b010, 3'b010}; // R5 = R1 - R2 = 5 - 2 = 3
        //instMemory[4] = {4'b0000, 3'b100, 3'b001, 3'b010, 3'b000}; // R4 = R1 & R2 = 101 & 010 = 0 	  



														   


	 //Control instructions [Branch if equal and jump], containing one kill for the BEQ , and one for the jump , and store
//	
		instMemory[0] = {4'b0110, 3'b001, 3'b001, 3'b000, 3'b010};  // BEQ: (taken) -> PC = 0 + 2 = 2
		instMemory[1] = {4'b0000, 3'b111, 3'b001, 3'b001, 3'b001};  // killed
		instMemory[2] = {4'b0000, 3'b001, 3'b010, 3'b110, 3'b011};  // R1 = R2 + R6 = 2 + 6 = 8 
		instMemory[3] = {4'b0001, 3'b000, 3'b001, 3'b100, 3'b000};  // jump to address 12 
		instMemory[2] = {4'b0000, 3'b001, 3'b010, 3'b110, 3'b011}; // killed
		instMemory[12] = {4'b0101, 3'b001, 3'b010, 3'b000, 3'b001}; // SW: Mem[Rs=R1=1 + Imm=1 = 2] = R2 = 2
//	
		




	// For instruction with data dependincies between load and alu instruction (1 stall cycle), (1 kill after for at each iteration except the last one)
//
		//instMemory[0] = {4'b0000, 3'b101, 3'b100, 3'b000, 3'b001}; // R5 = R4 + R0 = 4 + 0 = 4 
		//instMemory[1] = {4'b0100, 3'b010, 3'b110, 3'b000, 3'b011}; // R6 = Mem[Rs=R2=2 + Imm=3] = Mem[5] = 5
		//instMemory[2] = {4'b0000, 3'b111, 3'b110, 3'b100, 3'b001}; // R7 = R6 + R4 = 5 + 4 = 9
		//instMemory[3] = {4'b1000, 3'b001, 3'b010, 3'b011, 3'b001}; // For: Rs=R1=1, Rt=R2=2
		//instMemory[4] = {4'b0000, 3'b111, 3'b100, 3'b101, 3'b011}; // R7 = R4 - R5 = 4 - 5 = 1
			
			




	// Call and Return Instructions with kill 
//
		//instMemory[0] = {4'b0001, 3'b000, 3'b001, 3'b010, 3'b001};  // jump to 10 and link
		//instMemory[1] = {4'b0000, 3'b100, 3'b101, 3'b110, 3'b001};  // R4 = R5 + R6 = 5 + 6 = 11
	//	instMemory[10] = {4'b0000, 3'b001, 3'b010, 3'b011, 3'b001}; // R1 = R2 + R3 = 2 + 3 = 5		   
	//	instMemory[11] = {4'b0001, 3'b111, 3'b100, 3'b101, 3'b010};	// back to inst.1
	//	instMemory[12] = {4'b0000, 3'b011, 3'b100, 3'b101, 3'b010};		
		
	//	#140
		
		//instMemory[10] = 16'b0;
		//instMemory[11] = 16'b0;
		//instMemory[12] = 16'b0;
//		


    end	 

endmodule

module InstMemory_TB;

  
    reg clk;                        // Input
	reg stall;                      // Input
    reg [15:0] Address;             // Input
    wire [15:0] instruction;        // Output

    // Instantiate the Unit Under Test (UUT) 
	
    InstructionMemory uut ( .clk(clk), .Address(Address), .instruction(instruction), .stall(stall) );

    // here we do Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // here Clock signal alternates every 5 ns so that make -> 10 ns period
    end

    initial begin
        // Initialize Inputs
        Address = 0;
        // Wait for global reset to finish
        #10;

        // Test sequence
        Address = 16'h0000; #10; // Expecting first instruction
        Address = 16'h0002; #10; // Expecting second instruction
        Address = 16'h0004; #10; // Expecting third instruction
        Address = 16'h0006; #10; // Expecting fourth instruction

       
        $finish; // The end
    end

    // Display instruction output for debugging
    initial begin
        $monitor("At time %t, Address = %b, Instruction = %b", $time, Address, instruction);
    end

endmodule