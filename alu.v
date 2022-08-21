module alu(
    input [5:0] ALUop,      
    input [31:0] i1,   // rdata1(from regfile) always 
    input [31:0] i2,    // depends on instruction
    output reg [31:0] ALUres  
);
    always @(*)  begin
        case (ALUop[4:0])
            5'b01000 : ALUres = i1 + i2;          // ADD, ADDI
            5'b11000 : ALUres = i1 - i2;          // SUB
            5'b01001 : ALUres = {i1 << {i2[4:0]}};  // SLL, SLLI
            5'b01010 : ALUres = ($signed(i1) < $signed(i2)) ? 32'b1 : 32'b0;
            5'b01011 : ALUres = {31'b0, (i1 < i2)}; // SLTU, SLTIU
            5'b01100 : ALUres = i1 ^ i2;          // XOR, XORI
            5'b01101 : ALUres = {i1 >> {i2[4:0]}};   // SRL, SRLI
            5'b11101 : ALUres = {i1 >>> {i2[4:0]}};  // SRA, SRAI
            5'b01110 : ALUres = i1 | i2;             // OR, ORI
            5'b01111 : ALUres = i1 & i2;             // AND, ANDI
            default : ALUres = 32'bx;                 // invalid op => output goes to unknown state
        endcase
    end
endmodule