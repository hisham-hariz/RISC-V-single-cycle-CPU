module cpu (
    input clk,
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
    reg [31:0] iaddr;
    reg [31:0] daddr;
    reg [31:0] dwdata;
    reg [3:0]  dwe;
    wire [5:0] op;
    wire [5:0] ALUop;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] rdata2;
    wire [31:0] i1, i2, ALUres;
    wire [31:0] rwdata;
    wire RegWrite;
    wire [31:0] imm;
    wire [31:0] PC_next;
    reg [31:0] PC_curr;
    
    // connecting each units
    
    alu ALU_unit (
        .ALUop(ALUop),    
        .i1(i1),   
        .i2(i2),  
        .ALUres(ALUres)  
    );

    decoder DECODE_unit (
        .instr(idata), 
        .op(op),     
        .rs1(rs1),    
        .rs2(rs2),   
        .rd(rd),    
        .rdata2(rdata2),   
        .i2(i2),     
        .imm(imm)   
    );

    regfile REG_unit(
        .rs1(rs1),     
        .rs2(rs2),     
        .rd(rd),      
        .RegWrite(RegWrite & !reset),      
        .rwdata(rwdata), 
        .i1(i1),  
        .rdata2(rdata2),   
        .clk(clk)
    );

    control CONTROL_unit(
        .op(op), 
        .rdata2(rdata2), 
        .drdata(drdata),  
        .ALUres(ALUres), 
        .imm(imm),   
        .PC_curr(iaddr),     
        .ALUop(ALUop),  
        .RegWrite(RegWrite),  
        .rwdata(rwdata),     
        .PC_next(PC_next)  
    );

    
    always @(*) begin
        daddr = ALUres;
        case(op)
            6'b110000 : begin
                case(daddr[1:0])
                    2'b00: dwe = {4'b0001}; 
                    2'b01: dwe = {4'b0010};
                    2'b10: dwe = {4'b0100};
                    2'b11: dwe = {4'b1000};
                    default : dwe = 4'b0;
                endcase
            end    
            6'b110001 : begin
                case(daddr[1:0])
                    2'b00: dwe = {4'b0011};
                    2'b10: dwe = {4'b1100};
                    default : dwe = 4'b0;
                endcase
            end 
            6'b110010 : begin
                case(daddr[1:0])
                    2'b00: dwe = {4'b1111};
                    default dwe = 32'b0;
                endcase
            end
            default : dwe = 32'b0;
        endcase
        case(dwe)
            4'b0001 : dwdata = rdata2;
            4'b0010 : dwdata = rdata2 << 8;
            4'b0100 : dwdata = rdata2 << 16;
            4'b1000 : dwdata = rdata2 << 24;
            4'b0011 : dwdata = rdata2;
            4'b1100 : dwdata = rdata2 << 16;
            4'b1111 : dwdata = rdata2;
            default : dwdata = 32'b0;
        endcase
    end
    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
        end else begin
            iaddr <= PC_next; 
        end
    end    
endmodule