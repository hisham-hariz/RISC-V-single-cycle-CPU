module control(
    input [5:0] op,            
    input [31:0] rdata2,         
    input [31:0] drdata,       
    input [31:0] ALUres,         
    input [31:0] imm,   
    input [31:0] PC_curr,       
    output reg RegWrite,    // register write enable                
    output reg [31:0] rwdata,   // reg write data 
    output reg [5:0] ALUop,     // ALU operation code   
    output reg [31:0] PC_next       
);
    always @(*) begin
       PC_next = PC_curr + 4;   // default cases
       ALUop = 6'b001000;
       rwdata = ALUres; 
       RegWrite = 0;
        
       // LUI, AUIPC, JAL and JALR
        
       if (op[5:3] == 3'b0) begin    
           RegWrite = 1;
           case(op[2:0])
               3'b100 : begin
                   ALUop = 6'b001000;   
                   rwdata = PC_curr + 4;                
                   PC_next = {ALUres[31:1], 1'b0};   
               end   // JALR
               3'b101 : begin
                   rwdata = PC_curr + 4;
                   PC_next = PC_curr + imm;
               end // JAL
               3'b010 : rwdata = PC_curr + imm;  // AUIPC
               3'b110 : rwdata = imm;  // LUI
           endcase
       end
   

      // CONDITIONAL BRANCHES   
        
       else if (op[5:3] == 3'b100) begin   
           case (op[2:0])
               3'b000 : begin
                   ALUop = 6'b111000; 
                   if (ALUres == 0)  PC_next = PC_curr + imm;
               end   //BEQ
               3'b001 : begin
                   ALUop = 6'b111000; 
                   if (ALUres != 0) PC_next = PC_curr + imm;
               end    //BNE
               3'b100 : begin
                   ALUop = 6'b101010; 
                   if (ALUres[0] == 1)  PC_next = PC_curr + imm;
               end    //BLT
               3'b101 : begin
                   ALUop = 6'b101010; 
                   if (ALUres[0] != 1) PC_next = PC_curr + imm;
               end    //BGE
               3'b110 : begin
                   ALUop = 6'b101011; 
                    if (ALUres[0])  PC_next = PC_curr + imm;
               end    //BLTU
               3'b111 : begin
                   ALUop = 6'b101011; 
                   if (ALUres[0] != 0) PC_next = PC_curr + imm;
               end //BGEU
           endcase
       end


      // LOAD  
       
       else if (op[4:3] == 2'b10) begin    
           ALUop = 6'b001000;   
           case(op)
               6'b010000 : begin
                   RegWrite = 1;
                   case(ALUres[1:0])    // which 8 bits of the 32 to take
                       2'b00:  rwdata = {{24{drdata[7]}}, drdata[7:0]};   
                       2'b01:  rwdata = {{24{drdata[15]}}, drdata[15:8]}; 
                       2'b10:  rwdata = {{24{drdata[23]}}, drdata[23:16]};
                       2'b11:  rwdata = {{24{drdata[31]}}, drdata[31:24]};
                   endcase
               end     //LB
               6'b010001 : begin
                   RegWrite = 1;
                   case(ALUres[1:0])    // which 16 of 31 to take
                       2'b00:  rwdata = {{16{drdata[15]}}, drdata[15:0]}; 
                       2'b10:  rwdata = {{16{drdata[31]}}, drdata[31:16]};
                   endcase
               end      //LH
               6'b010010 : begin
                   RegWrite = 1;
                   case(ALUres[1:0])    
                       2'b00:  rwdata = drdata;
                   endcase
               end      //LW
               6'b010100 : begin
                   RegWrite = 1;
                   case(ALUres[1:0])    // byte loading - unsigned case
                       2'b00:  rwdata = {24'b0, drdata[7:0]};   
                       2'b01:  rwdata = {24'b0, drdata[15:8]};  
                       2'b10:  rwdata = {24'b0, drdata[23:16]}; 
                       2'b11:  rwdata = {24'b0, drdata[31:24]}; 
                   endcase
               end       //LBU
               6'b010101 : begin
                   RegWrite = 1;
                   case(ALUres[1:0])    // half word loading - unsigned case
                       2'b00:  rwdata = {16'b0, drdata[15:0]}; 
                       2'b10:  rwdata = {16'b0, drdata[31:16]};
                   endcase
               end      //LHU
               default : begin
                   RegWrite = 0;
                   rwdata = 32'bx;
               end
           endcase
       end
 

    // ALU-IMM and ALU
        
       else if(op[3] == 1'b1) begin   
           ALUop = op;
           rwdata = ALUres;
           RegWrite = 1;
       end    
    end 
endmodule