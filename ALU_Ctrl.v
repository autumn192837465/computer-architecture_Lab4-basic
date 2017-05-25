//0416221 ¼B¤t·¬, 0416251 ±ç©¯»ö
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(*) begin
	case(ALUOp_i)
		//lw sw
		3'b000: ALUCtrl_o<=4'b0001;
		//branch on eqal //branch less than //branch less than equal
		3'b001:ALUCtrl_o<=4'b0010; //do sub in ALU
		
		3'b010: case(funct_i)
			//add
			'd32: ALUCtrl_o<=4'b0001; //do add in ALU
			//sub
			'd34: ALUCtrl_o<=4'b0010;
			//and
			'd36: ALUCtrl_o<=4'b0011;
			//or
			'd37: ALUCtrl_o<=4'b0100;
			//set less than
			'd42: ALUCtrl_o<=4'b0101;
			//set on less than unsigned
			'd43: ALUCtrl_o<=4'b0110;
			//shift left logical
			'd0:	 ALUCtrl_o<=4'b0111;
			//shift left logical variable
			'd4:  ALUCtrl_o<=4'b1000;
			//mul
			'd24: ALUCtrl_o<=4'b1101;
		endcase
		//addi			
		3'b101:ALUCtrl_o<=4'b1010;
		//or immediate
		3'b110:ALUCtrl_o<=4'b1011;
		//branch  not equal //branch not equal zero
		3'b100:ALUCtrl_o<=4'b1001;
		//load immediate
		//3'b111:ALUCtrl_o<=4'b1100;
	endcase
end



endmodule     





                    
                    