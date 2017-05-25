//0416221 ¼B¤t·¬, 0416251 ±ç©¯»ö
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
   instr_op_i,
	function_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	isORI_o,
	isJal_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemToReg_o,
	BranchType_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] function_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   isORI_o;
output         isJal_o;
output [2-1:0] Jump_o;
output         MemRead_o;
output         MemWrite_o;
output [2-1:0] MemToReg_o;
output [2-1:0] BranchType_o;

         
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

reg		[1:0]	Jump_o;
reg				MemRead_o;
reg				MemWrite_o;
reg		[1:0]	MemToReg_o;
reg		[1:0]	BranchType_o;

//Parameter
wire isORI_o;
wire isJal_o;
assign isORI_o = (instr_op_i == 13)? 1:0;
assign isJal_o = (instr_op_i == 3)? 1:0;

//Main function
always@(*) begin
	case(instr_op_i)
	//rtype
		0: begin
			if(function_op_i!='d8) begin
				ALU_op_o<=3'b010; 
				ALUSrc_o<=0;
				RegWrite_o<=1;
				RegDst_o<=1;
				Branch_o<=0;
				
				Jump_o<=2'b01;
				MemRead_o<=0;
				MemWrite_o<=0;
				MemToReg_o<=2'b00;
				BranchType_o<=2'b00;
			end
			else	begin
			//jr
				ALU_op_o<=3'bx; 
				ALUSrc_o<=0;
				RegWrite_o<=0;
				RegDst_o<=0;
				Branch_o<=0;
				
				Jump_o<=2'b10;
				MemRead_o<=0;
				MemWrite_o<=0;
				MemToReg_o<=2'b00;
				BranchType_o<=2'b00;
			end
		end
	//addi
		8: begin 
			ALU_op_o<=3'b101; 		
			ALUSrc_o<=1;
			RegWrite_o<=1;
			RegDst_o<=0;
			Branch_o<=0;	
	
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;				
			BranchType_o<=2'b00;			
		end
	//or immediate
		13:begin 
			ALU_op_o<=3'b110; 
			ALUSrc_o<=1;
			RegWrite_o<=1;
			RegDst_o<=0;
			Branch_o<=0;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;				
			BranchType_o<=2'b00;			
		end
	//load word
		35:begin
			ALU_op_o<=3'b000; 
			ALUSrc_o<=1;
			RegWrite_o<=1;
			RegDst_o<=0;
			Branch_o<=0;	
			
			Jump_o<=2'b01;
			MemRead_o<=1;
			MemWrite_o<=0;
			MemToReg_o<=2'b01;	
			BranchType_o<=2'b00;			
		end
	//save word
		43:begin
			ALU_op_o<=3'b000; 
			ALUSrc_o<=1;
			RegWrite_o<=0;
			RegDst_o<=1'bx;
			Branch_o<=0;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=1;
			MemToReg_o<=2'b00;			
			BranchType_o<=2'b00;			
		end
	//jump
		2:begin
			ALU_op_o<=3'bx; 
			ALUSrc_o<=0;
			RegWrite_o<=0;
			RegDst_o<=0;
			Branch_o<=0;	
			
			Jump_o<=2'b00;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;				
			BranchType_o<=2'b00;	
		end
	//jal
		3:begin
			ALU_op_o<=3'bx; 
			ALUSrc_o<=0;
			RegWrite_o<=1;
			RegDst_o<=0;
			Branch_o<=0;	
			
			Jump_o<=2'b00;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00; //use PC+4, so this is don't care				
			BranchType_o<=2'b00;	
		end
	//branch on eqal
		4: begin 
			ALU_op_o<=3'b001; 
			ALUSrc_o<=0;
			RegWrite_o<=0;
			RegDst_o<=0;
			Branch_o<=1;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;	
			BranchType_o<=2'b00;
		end
	//branch less than equal
		7: begin 
			ALU_op_o<=3'b001; 
			ALUSrc_o<=0;
			RegWrite_o<=0;
			RegDst_o<=0;
			Branch_o<=1;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;				
			BranchType_o<=2'b01;			
		end	
	//branch less than
		6: begin 
			ALU_op_o<=3'b001;
			ALUSrc_o<=0;
			RegWrite_o<=0;
			RegDst_o<=0;
			Branch_o<=1;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;
			BranchType_o<=2'b10;			
		end
	//branch not eqal zero or branch not eqal
		5: begin 
			ALU_op_o<=3'b100; 
			ALUSrc_o<=0;
			RegWrite_o<=0;
			RegDst_o<=0;
			Branch_o<=1;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b00;				
			BranchType_o<=2'b11;			
		end		
	//load immediate
		15:begin 
			ALU_op_o<=3'bx;//3'b111; 
			ALUSrc_o<=1;
			RegWrite_o<=1;
			RegDst_o<=0;
			Branch_o<=0;	
			
			Jump_o<=2'b01;
			MemRead_o<=0;
			MemWrite_o<=0;
			MemToReg_o<=2'b10;			
			BranchType_o<=2'b00;			
		end
	endcase


end

endmodule





                    
                    