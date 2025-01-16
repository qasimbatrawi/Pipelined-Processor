module MainControlUnit(
	input wire [3:0] opcode,
	input wire [2:0] func,
	input wire stall, 
	output reg [14:0] ControlSignals
);		  


	always @(*) begin    
		
		// ControlSignals <= ALUOP(3) RegWr(1)  MemR(1) MemW(1) WB(1) ALUSrc1(1) Destination(1) Source1(1) Source2(1) ALUSrc2(1) ExtOp(1) CompSrc(1) J(1)
		if (stall == 0) begin
			case({opcode,func})
				7'b0000000: ControlSignals <= {3'b000, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx} ;  // AND
				7'b0000001: ControlSignals <= {3'b001, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx} ;  // ADD
				7'b0000010: ControlSignals <= {3'b010, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx} ;  // SUB
				7'b0000011: ControlSignals <= {3'b011, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx} ;  // SLL
				7'b0000100: ControlSignals <= {3'b100, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx} ;  // SRL
				7'b0001000:	ControlSignals <= {3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'b1} ;  // Jmp
				7'b0001001:	ControlSignals <= {3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'b1} ;  // Call
				7'b0001010:	ControlSignals <= {3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'b1} ;  // Ret
				default: begin
					case (opcode)
						4'b0010:	ControlSignals <= {3'b000, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'bx, 1'b1, 1'b0, 1'bx, 1'bx} ;  // ANDI
						4'b0011:	ControlSignals <= {3'b001, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'bx, 1'b1, 1'b1, 1'bx, 1'bx} ;  // ADDI
						4'b0100:	ControlSignals <= {3'b001, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'bx, 1'b1, 1'b1, 1'bx, 1'bx} ;  // LW
						4'b0101:	ControlSignals <= {3'b001, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'b1, 1'b1, 1'b1, 1'b1, 1'bx, 1'bx} ;  // SW
						4'b0110:	ControlSignals <= {3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'b1, 1'b1, 1'bx, 1'b1, 1'b0, 1'bx} ;  // BEQ  
						4'b0111:	ControlSignals <= {3'bxxx, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'bx, 1'b1, 1'b1, 1'bx, 1'b1, 1'b0, 1'bx} ;  // BNE
						4'b1000: 	ControlSignals <= {3'b101, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'bx, 1'b1, 1'bx} ; // FOR	    
						default:  ControlSignals <= 15'b0 ;	 
					endcase	
				end
			endcase	
		end
		else begin ControlSignals <= 15'b0 ; end
	
	end	  

endmodule  


module PCControlUnit(
	input wire [3:0] opcode,
	input wire [2:0] func,
	input wire comp_res,
	input wire J,
	output reg Kill,
	output reg [1:0] PCSrc,
	output reg JumpSrc,
	output reg RRWE
); 

	initial begin
		PCSrc = 0 ;
	 	Kill = 0 ;
	end

	always @(*) begin    
		
		// ControlSignals <= Kill(1) PCSrc(2) RRWE(1) JumpSrc(1) 
		
		if (opcode == 4'b0000) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end  // R-type
		else if (opcode == 4'b0010) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // ANDI
		else if (opcode == 4'b0011) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // ADDI	
		else if (opcode == 4'b0100) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // LW
		else if (opcode == 4'b0101) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // SW	
		else if (opcode == 4'b0110 && comp_res == 1'b0) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // BEQ (Branch not taken)
		else if (opcode == 4'b0110 && comp_res == 1'b1) begin Kill <= 1'b1; PCSrc <= 2'b01; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // BEQ (Branch taken)
		else if (opcode == 4'b0111 && comp_res == 1'b1)  begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // BNE (Branch not taken)
		else if (opcode == 4'b0111 && comp_res == 1'b0) begin Kill <= 1'b1; PCSrc <= 2'b01; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // BNE (Branch taken)
		else if (opcode == 4'b1000 && comp_res == 1'b0) begin Kill <= 1'b1; PCSrc <= 2'b11; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // FOR (Not finish)
		else if (opcode == 4'b1000 && comp_res == 1'b1) begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // FOR	(Finish)
		else if (opcode == 4'b0001 && func == 3'b000 && J == 1'b1) begin Kill <= 1'b1; PCSrc <= 2'b10; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // Jmp
		else if (opcode == 4'b0001 && func == 3'b001 && J == 1'b1) begin Kill <= 1'b1; PCSrc <= 2'b10; RRWE <= 1'b1; JumpSrc <= 1'b0 ; end // Call
		else if (opcode == 4'b0001 && func == 3'b010 && J == 1'b1) begin Kill <= 1'b1; PCSrc <= 2'b10; RRWE <= 1'b0; JumpSrc <= 1'b1 ; end // Ret
		else begin Kill <= 1'b0; PCSrc <= 2'b00; RRWE <= 1'b0; JumpSrc <= 1'b0 ; end // default
		
	end	  

endmodule


module ForwordingControlUnit(
	input wire [2:0] RS1, RS2, RD2, RD3, RD4,
	input wire Ex_MemR, Ex_RegWr, Mem_RegWr, WB_RegWr,
	output reg [1:0] ForwardA, ForwardB, 
	output reg stall
); 

	initial begin 
		stall = 0 ; 
	end

	always @(*) begin
	
		if (RS1 != 0 && RS1 == RD2 && Ex_RegWr == 1) 
			ForwardA = 1 ;
		else if (RS1 != 0 && RS1 == RD3 && Mem_RegWr == 1)
			ForwardA = 2 ;
		else if (RS1 != 0 && RS1 == RD4 && WB_RegWr == 1)
			ForwardA = 3 ;
		else
			ForwardA = 0 ;
			
			
		if (RS2 != 0 && RS2 == RD2 && Ex_RegWr == 1) 
			ForwardB = 1 ;
		else if (RS2 != 0 && RS2 == RD3 && Mem_RegWr == 1)
			ForwardB = 2 ;
		else if (RS2 != 0 && RS2 == RD4 && WB_RegWr == 1)
			ForwardB = 3 ;
		else
			ForwardB = 0 ;
			
		
		if (Ex_MemR == 1 && (ForwardA == 1 || ForwardB == 1))
			stall = 1 ;
		else
			stall = 0 ;	 
				
	end
	

endmodule



