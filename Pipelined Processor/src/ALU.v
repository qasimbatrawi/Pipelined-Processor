module ALU(
    input wire [15:0] ALUSrc1, ALUSrc2, 
    input wire [2:0] ALUOp, 
    output reg [15:0] ALUOut
);

    // Define ALU operation codes as parameters
    parameter ALU_OP_AND = 3'b000;
    parameter ALU_OP_ADD = 3'b001;
    parameter ALU_OP_SUB = 3'b010;
    parameter ALU_OP_SLL = 3'b011;
    parameter ALU_OP_SRL = 3'b100;
    parameter ALU_OP_FOR = 3'b101;


    always @(*) begin
        case (ALUOp)
            ALU_OP_AND:  ALUOut <= ALUSrc1 & ALUSrc2;
            ALU_OP_ADD:  ALUOut <= ALUSrc1 + ALUSrc2;
            ALU_OP_SUB:  ALUOut <= ALUSrc1 - ALUSrc2;
            ALU_OP_SLL:  ALUOut <= ALUSrc1 << ALUSrc2;
            ALU_OP_SRL:  ALUOut <= ALUSrc1 >> ALUSrc2;
            ALU_OP_FOR:  ALUOut <= ALUSrc2 - ALUSrc1;
            
            default:     ALUOut <= 16'b0;
        endcase
    end


endmodule


module ALU_TB;

    reg [15:0] ALUSrc1, ALUSrc2; // Declare testbench registers as signed
    wire [15:0] ALUOut; // Declare output wire as signed
    reg [2:0] ALUop;


 // Define ALU operation codes as parameters
    parameter ALU_OP_AND = 3'b00;
    parameter ALU_OP_ADD = 3'b01;
    parameter ALU_OP_SUB = 3'b10;
    parameter ALU_OP_SLL = 3'b011;
    parameter ALU_OP_SRL = 3'b100;
    parameter ALU_OP_FOR = 3'b101;

    // Instantiate the ALU
    ALU alu(ALUSrc1, ALUSrc2, ALUop , ALUOut);

    initial begin
        // Unsigned test cases
        #0
        ALUSrc1 <= 16'd5;
        ALUSrc2 <= 16'd4;
        ALUop <= ALU_OP_AND;
        #10;                               //this is delay eq 10 that Each test case waits before applying new inputs.

        ALUSrc1 <= 16'd44;
        ALUSrc2 <= 16'd40;
        ALUop <= ALU_OP_SUB;
        #10;

        ALUSrc1 <= 16'd22;
        ALUSrc2 <= 16'd22;
        ALUop <= ALU_OP_ADD;
        #10; 

        // Signed test cases
        ALUSrc1 <= 16'sd14;
        ALUSrc2 <= 16'sd12;
        ALUop <= ALU_OP_ADD;
        #10;

        ALUSrc1 <= 16'sd24;
        ALUSrc2 <= 16'sd10;
        ALUop <= ALU_OP_SUB;
        #10;

        ALUSrc1 <= 16'sd11;
        ALUSrc2 <= 16'sd7;
        ALUop <= ALU_OP_AND;
        #10;


        ALUSrc1 <= 16'd3;      
        ALUSrc2 <= 16'd2;      
        ALUop <= ALU_OP_SLL;   
        #10;

        
        ALUSrc1 <= 16'd16;     
        ALUSrc2 <= 16'd2;      
        ALUop <= ALU_OP_SRL;  
        #10;
        
        
        ALUSrc1 <= 16'd2;     
        ALUSrc2 <= 16'd16;      
        ALUop <= ALU_OP_FOR;  
        #10;


        $finish;
    end
    
    
    initial begin
     $monitor("At time %t, Source1 = %d, Source2 = %d, ALUop = %b, Output = %d",
                 $time, ALUSrc1, ALUSrc2, ALUop, ALUOut);
    end
    
endmodule