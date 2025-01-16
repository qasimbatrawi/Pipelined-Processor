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
        
        Rs1 = 3'b000; Rs2 = 3'b001; #10; 
        Rs1 = 3'b010; Rs2 = 3'b011; #10; 
        Rs1 = 3'b100; Rs2 = 3'b101; #10;
        Rs1 = 3'b110; Rs2 = 3'b111; #10; 

        RegWr = 1;
        Rd = 3'b001; WBbus = 16'hAAAA; #10; 
        Rd = 3'b010; WBbus = 16'hBBBB; #10; 
        Rd = 3'b011; WBbus = 16'hCCCC; #10; 
        Rd = 3'b100; WBbus = 16'hDDDD; #10;
        Rd = 3'b111; WBbus = 16'hEEEE; #10;


        RegWr = 0;
        
        Rs1 = 3'b001; Rs2 = 3'b010; #10;
        Rs1 = 3'b011; Rs2 = 3'b100; #10; 
        Rs1 = 3'b000; Rs2 = 3'b111; #10;

        $finish;
    end

    initial begin
        $monitor("At time %t, RA = %b, BusA = %h, RB = %b, BusB = %h", $time, Rs1, Bus1, Rs2, Bus2);
    end

endmodule
