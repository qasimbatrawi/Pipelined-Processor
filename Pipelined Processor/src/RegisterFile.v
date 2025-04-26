module RegisterFile(
	input wire clk,
	input wire [2:0] Rs1, Rs2, Rd, //3 bit
	input wire RegWr, //enable
	input wire [15:0] WBbus,  //write back
	output reg [15:0] Bus1, Bus2
);

//8 16 bit gpr

    reg [15:0] registers [0:7];


    always @(posedge clk) begin
        if (RegWr) begin 	  // R0 hardwired to 0?
            registers[Rd] = WBbus;
        end
    end
	
	always @(*) begin
       	Bus1 = registers[Rs1];
       	Bus2 = registers[Rs2];
	 end

    initial begin
        registers[0] <= 16'h0000;
        registers[1] <= 16'h0001;
        registers[2] <= 16'h0002;
        registers[3] <= 16'h0003;
        registers[4] <= 16'h0004;
        registers[5] <= 16'h0005;
        registers[6] <= 16'h0006;
        registers[7] <= 16'h0007;
    end	 

endmodule 





module RegisterFile_TB;

    // Inputs
    reg clk;
    reg [2:0] Rs1;
    reg [2:0] Rs2;
    reg [2:0] Rd;
    reg RegWr;
    reg [15:0] WBbus;

    // Outputs
    wire [15:0] Bus1;
    wire [15:0] Bus2;

    // (UUT)
    RegisterFile uut (
        .clk(clk),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd(Rd),   
        .RegWr(RegWr),
        .WBbus(WBbus),
        .Bus1(Bus1),
        .Bus2(Bus2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin

		
        Rs1 = 0;
        Rs2 = 0;
        Rd = 0;
        RegWr = 0;
        WBbus = 0;


        #10;
        
        // Tests

        // Read initial values
        Rs1 = 3'b000; Rs2 = 3'b001; #10; // Read R0 and R1
        Rs1 = 3'b010; Rs2 = 3'b011; #10; // Read R2 and R3
        Rs1 = 3'b100; Rs2 = 3'b101; #10; // Read R4 and R5
        Rs1 = 3'b110; Rs2 = 3'b111; #10; // Read R6 and R7

        // Write to registers
        RegWr = 1;
        Rd = 3'b001; WBbus = 16'hAAAA; #10; // Write 0xAAAA to R1
        Rd = 3'b010; WBbus = 16'hBBBB; #10; // Write 0xBBBB to R2
        Rd = 3'b011; WBbus = 16'hCCCC; #10; // Write 0xCCCC to R3
        Rd = 3'b100; WBbus = 16'hDDDD; #10; // Write 0xDDDD to R4
        Rd = 3'b111; WBbus = 16'hEEEE; #10; // Write 0xEEEE to R7

        // Disable writing
        RegWr = 0;
        
        // Read back written values
        Rs1 = 3'b001; Rs2 = 3'b010; #10; // Read R1 and R2
        Rs1 = 3'b011; Rs2 = 3'b100; #10; // Read R3 and R4
        Rs1 = 3'b000; Rs2 = 3'b111; #10; // Read R0 and R7

        // End of simulation
        $finish;
    end

    // Display register file contents for debugging
    initial begin
        $monitor("At time %t, RA = %b, BusA = %h, RB = %b, BusB = %h", $time, Rs1, Bus1, Rs2, Bus2);
    end

endmodule
