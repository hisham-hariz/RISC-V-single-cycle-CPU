module decoder(
    input [31:0] instr, 
    input  [31:0] rdata2, 
    output reg [5:0] op,     // decoded operation code( contains all info for control unit)
    output reg [4:0] rs1,    // reg read address 1
    output reg [4:0] rs2,    // reg read address 2
    output reg [4:0] rd,     // reg destination address
    output reg [31:0] i2,    // second operand of ALU
    output reg [31:0] imm    // immediate value for each instruction case
);
    // Decoding each instructions of the RISC V arch
    always @(*) begin
        case(instr[6:0])
            7'b0000000 : begin
                op = 6'b0;  // nop
                rs1 = 32'bx; 
                rs2 = 32'bx;
                rd = 32'bx;
                imm = 32'bx;
                i2 = 32'bx;
            end
            7'b0110111 : begin
                op  = {6'b000110};
                rs1 = 32'bx;  
                rs2 = 32'bx;
                rd = instr[11:7];
                imm = {instr[31:12], 12'b0};
                i2 = 32'bx;
            end   // LUI
            7'b0010111 : begin
                op = {6'b000010};
                rs1 = 32'bx;  
                rs2 = 32'bx;
                rd = instr[11:7];
                imm = {instr[31:12], 12'b0};
                i2 = 32'bx;
            end  // AUIPC
            7'b1101111 : begin
                op = 6'b000101;
                rs1 = 32'bx; 
                rs2 = 32'bx;
                rd = instr[11:7];
                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
                i2 = 32'bx;
            end  // JAL
            7'b1100111 : begin
                op = 6'b000100;
                rs1 = instr[19:15];  
                rs2 = 32'bx;
                rd = instr[11:7];
                imm = 32'bx;
                i2 = {{20{instr[31]}}, instr[31:20]};
            end  // JALR
            7'b1100011 : begin
                op = {3'b100, instr[14:12]};
                rs1 = instr[19:15];  
                rs2 = instr[24:20];
                rd = 32'bx;
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                i2 = rdata2;
            end  // BRANCH
            7'b0000011 : begin
                op = {3'b010, instr[14:12]};
                rs1 = instr[19:15];  
                rs2 = 32'bx;
                rd = instr[11:7];
                imm = 32'bx;
                i2 = {{20{instr[31]}}, instr[31:20]};
            end  // LOAD
            7'b0100011 : begin
                op = {3'b110, instr[14:12]};
                rs1 = instr[19:15];  
                rs2 = instr[24:20];
                rd = 32'bx;
                imm = 32'bx;
                i2 = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end  // STORE
            7'b0010011 : begin
                if(instr[14:12] == 3'b101)  op = {1'b0, instr[30], 1'b1, 3'b101};
                else  op = {1'b0, 1'b0, 1'b1, instr[14:12]};
                rs1 = instr[19:15];  
                rs2 = 32'bx;
                rd = instr[11:7];
                imm = 32'bx;
                i2 = {{20{instr[31]}}, instr[31:20]};
            end  // OP- IMM
            7'b0110011 : begin
                if(instr[14:12] == 3'b000)  op = {1'b1, instr[30], 1'b1, 3'b000};
                else  op = {1'b1, 1'b0, 1'b1, instr[14:12]};
                rs1 = instr[19:15];  
                rs2 = instr[24:20];
                rd = instr[11:7];
                imm = 32'bx;
                i2 = rdata2;
            end  // OP - R type
            default : begin
                op = 6'bx;
                rs1 = 32'bx;
                rs2 = 32'bx;
                rd = 32'bx;
                imm = 32'bx;
                i2 = 32'bx;
            end
        endcase
    end
endmodule