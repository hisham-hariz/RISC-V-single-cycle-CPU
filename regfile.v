module regfile(
    input [4:0] rs1,     
    input [4:0] rs2,     
    input [4:0] rd,      
    input RegWrite, 
    input clk,
    input [31:0] rwdata,  
    output [31:0] i1,   //always goes into ALU
    output [31:0] rdata2  
);
    reg [31:0] regfile [0:31];  // 32 32bit registers
    
    integer i;
    initial begin       // Initail values in registers
        for(i=0; i<32; i=i+1) begin
            regfile[i] <= 32'b0;
    end
    end
    //Synchronous Write to reg
    always @(posedge clk) begin
        if(RegWrite) begin
            if(rd == 5'b0)  regfile[0] <= 32'b0;
            else  regfile[rd] <= rwdata;
        end
    end
    //Async read
    assign i1 = regfile[rs1];
    assign rdata2 = regfile[rs2];
endmodule

