module DataMemory (
    input wire clk,
    input wire MemW,
    input wire MemR,
    input wire [15:0] Address,
    input wire [15:0] DataIn,
    output reg [15:0] MemoryOut,
);

  reg [15:0] memory [0:65535]; // 2^16
    
    initial begin	
		memory[0] = 16'd0;
		memory[1] = 16'd1;
        memory[2] = 16'd2;
        memory[3] = 16'd3; 
		memory[4] = 16'd4;
		memory[5] = 16'd5;
		memory[6] = 16'd6;
		memory[7] = 16'd7;	  
		memory[8] = 16'd8;
		memory[9] = 16'd9;
		memory[10] = 16'd10;
    end

    always @(posedge clk) begin
	   #1
        if (MemW) begin  
			memory[Address] = DataIn[15:0];
        end
    end	
	
	
	always @(posedge clk) begin
		 #1	
 	 	if (MemR)	
     		begin
            MemoryOut =  memory[Address];
    	end
		
    end		  
	
endmodule	



module DataMemory_TB;
    // Inputs
    reg clk;
    reg MemW;
    reg MemR;
    reg [15:0] Address;
    reg [15:0] DataIn;

    // Outputs
    wire [15:0] MemoryOut;

    //DataMemory module
    DataMemory uut (
        .clk(clk),
        .MemW(MemW),
        .MemR(MemR),
        .Address(Address),
        .DataIn(DataIn),
        .MemoryOut(MemoryOut)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

		//tests
    initial begin  
		#10
        MemW = 0;
        MemR = 0;
        Address = 16'd0;
        DataIn = 16'd0;


        #10;
        
        
        // Test writing 
        Address = 16'd2;
        DataIn = 16'h3333; 
        #10;
        
        // Disable write enable
        MemW = 0;

        // Test reading 16-bit data
        MemR = 1;
        Address = 16'd2;
        #10;
        

        // Disable read enable
        MemR = 0;
        
        #10;
        $finish;
    end
    
    // Monitor output and memory content
    initial begin
        $monitor("Time: %0t | address = %h | in = %h | out = %h | wrEnable = %b | rdEnable = %b",$time, Address, DataIn, MemoryOut, MemW, MemR);
    end
endmodule