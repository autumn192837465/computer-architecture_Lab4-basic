//0416221 âÂÊ• 0416251 Ê¢ÅÂπ∏Ä
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
	WB_o,
	M_o,
	EX_o,
	isORI
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output [1:0] WB_o;
output [2:0] M_o;
output [4:0] EX_o;
output		 isORI;

//Parameter
wire isORI = (instr_op_i == 13)? 1:0;
reg [1:0] WB_o;
reg [2:0] M_o;
reg [4:0] EX_o;

//Main function
always@(*) begin
	case(instr_op_i)
	//rtype
		0: begin
			WB_o = 2'b11; 
			M_o = 3'b000;
			EX_o = 5'b10100;
		end
	//branch on eqal
		4: begin 
			WB_o = 2'b00; 
			M_o = 3'b100;
			EX_o = 5'b00010;
		end
	//addi
		8: begin 
			WB_o = 2'b11; 
			M_o = 3'b000;
			EX_o = 5'b01011;
		end
	//load word
		35:begin
			WB_o = 2'b10; 
			M_o = 3'b010;
			EX_o = 5'b01011;
		end
	//save word
		43:begin
			WB_o = 2'b00; 
            M_o = 3'b001;
            EX_o = 5'b01011;
		end
	//or immediate
		13:begin 
			WB_o = 2'b11; 
            M_o = 3'b000;
            EX_o = 5'b01101;	
		end
	//load upper immediate
		15:begin 
			WB_o = 2'b10; 
            M_o = 3'b000;
            EX_o = 5'b01111;		
		end
		default :begin
			WB_o = 2'b00; 
            M_o = 3'b000;
            EX_o = 5'b00000;	
	  end
	endcase


end




endmodule





                    
                    