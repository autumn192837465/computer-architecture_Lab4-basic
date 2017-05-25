//0416221 �B�t��, 0416251 �穯��
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o,
	shamt
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;
input [4:0] shamt;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;


wire signed [31:0]src1;
wire signed [31:0]src2;
reg signed [31:0]result;

assign src1 = src1_i;
assign src2 = src2_i;

assign zero_o=(!result)?1:0;
//Parameter

//Main function
always@(*) begin
	case(ctrl_i)
		'd0:  result<=result_o;
		//add
		'd1: result<=src1+src2;
		//sub //branch on eqal //branch less than //branch less than equal
		'd2: result<=src1-src2;
		//and
		'd3: result<=src1&src2;
		//or 
		'd4: result<=src1|src2;
		//set less than
		'd5: result<=(src1<src2)?1:0;
		//set on less than unsigned
		'd6: result<=(src1_i<src2_i)?1:0;
		//shift left logical
		'd7: result <= src1 << shamt;
		//shift left logical variable
		'd8: result <= src1_i << src2_i;
		//branch not equal //branch not equal zero
		'd9: result<= (src1==src2)?0:1;
		//addi		 
		'd10:result<= src1+src2;
		//or immediate 
		'd11:result<= src1_i|src2_i;
		//mul
		'd13:result<= src1*src2;
		//load immediate
		//'d12:result<= src2_i;
	endcase
	result_o <= result;
end

endmodule





                    
                    