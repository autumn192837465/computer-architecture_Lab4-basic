//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] pc_in, pc_out;
wire [31:0] PCadd4;
wire [31:0] instruction;
wire [63:0] IF_ID_REG;


/**** ID stage ****/
wire [31:0] instr;
wire [4:0] RSaddr, RTaddr, RDaddr;
wire [31:0] read_data1, read_data2;
wire [31:0] extended;
wire isORI;
wire [152:0] ID_EX_REG;
//control signal
wire [1:0] ID_WB;
wire [2:0] ID_M;
wire [4:0] ID_EXctrl; 

/**** EX stage ****/
wire [31:0] ALUsrc2;
wire [31:0] offset;
wire [31:0] branch_addr;
wire [31:0] ALUresult;
wire [4:0] destin_reg;
wire [106:0] EX_MEM_REG;

//control signal
wire ALUsrc;
wire RegDst;
wire [2:0] ALUop;
wire [3:0] ALUctrl;
wire zero;

/**** MEM stage ****/
wire [31:0] DM_read_data;
wire [70:0] MEM_WB_REG;
//control signal
wire MemRead, MemWrite, isbranch;
wire PCsrc;
reg take_branch;
/**** WB stage ****/
wire[31:0] write_data;
//control signal
wire MemToReg;
wire RegWrite;

/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux1(
	.data0_i(PCadd4),
    .data1_i(EX_MEM_REG[101:70]),
    .select_i(PCsrc),
    .data_o(pc_in)
	);

ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(pc_in) ,   
	.pc_out_o(pc_out) 
    );

Instr_Memory IM(
	.pc_addr_i(pc_out),  
	.instr_o(instruction)
	    );

Adder Add_pc(
	.src1_i(32'd4),     
	.src2_i(pc_out),     
	.sum_o(PCadd4)  
		);

Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({PCadd4, instruction}),
	.data_o(IF_ID_REG)
		);


//Instantiate the components in ID stage
assign instr = IF_ID_REG[31:0];
assign RSaddr = instr[25:21];
assign RTaddr = instr[20:16];
assign RDaddr = instr[15:11];
Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i) ,     
    .RSaddr_i(RSaddr),  
    .RTaddr_i(RTaddr),  
    .RDaddr_i(MEM_WB_REG[4:0]), //destin_reg
    .RDdata_i(write_data),
	.RegWrite_i(RegWrite),
    .RSdata_o(read_data1),  
    .RTdata_o(read_data2)
	);

Decoder Control(
	.instr_op_i(instr[31:26]),
	.WB_o(ID_WB),
	.M_o(ID_M),
	.EX_o(ID_EXctrl),
	.isORI(isORI)
	);

Sign_Extend Sign_Extend(
	.data_i(instr[15:0]),
	.isORI(isORI),
    .data_o(extended)
	);	

Pipe_Reg #(.size(153)) ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({ID_WB,ID_M,ID_EXctrl,instr[10:6],IF_ID_REG[63:32],read_data1, read_data2, extended, instr[20:16], instr[15:11]}),
	.data_o(ID_EX_REG)
		);

//Instantiate the components in EX stage	   
wire [4:0] shamt;
assign shamt = ID_EX_REG[142:138];
ALU ALU(
	.src1_i(ID_EX_REG[105:74]), //read_data1
	.src2_i(ALUsrc2),
	.ctrl_i(ALUctrl),
	.result_o(ALUresult),
	.zero_o(zero),
	.shamt(shamt)
	);

wire [5:0] funct_op;
assign ALUop = ID_EX_REG[146:144];
assign funct_op = ID_EX_REG[15:10];
ALU_Ctrl ALU_Ctrl(
	.funct_i(funct_op),   
    .ALUOp_i(ALUop),   
    .ALUCtrl_o(ALUctrl) 
	);

//max of alu src2
assign ALUsrc = ID_EX_REG[143];
MUX_2to1 #(.size(32)) Mux2(
	.data0_i(ID_EX_REG[73:42]),
    .data1_i(ID_EX_REG[41:10]),
    .select_i(ALUsrc),
    .data_o(ALUsrc2)
        );

//mux for destination reg address
assign RegDst = ID_EX_REG[147];
MUX_2to1 #(.size(5)) Mux3(
	.data0_i(ID_EX_REG[9:5]), //RTaddr
    .data1_i(ID_EX_REG[4:0]), //RDaddr
    .select_i(RegDst),
    .data_o(destin_reg)
        );
		
Adder Adder2(
        .src1_i(ID_EX_REG[137:106]),     
	    .src2_i(offset), //shift left 2 ans     
	    .sum_o(branch_addr)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(extended),
        .data_o(offset)
        ); 		

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({ID_EX_REG[152:148], branch_addr, zero, ALUresult, ID_EX_REG[73:42], destin_reg}),
	.data_o(EX_MEM_REG)
		);

//Instantiate the components in MEM stage
assign MemRead = EX_MEM_REG[103];
assign MemWrite = EX_MEM_REG[102];
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(EX_MEM_REG[68:37]),
	.data_i(EX_MEM_REG[36:5]),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(DM_read_data)
	    );

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({EX_MEM_REG[106:105], DM_read_data, EX_MEM_REG[68:37], EX_MEM_REG[4:0]}),
	.data_o(MEM_WB_REG)
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux4(
	.data0_i(MEM_WB_REG[68:37]), //DM_read_data
    .data1_i(MEM_WB_REG[36:5]), //ALUresult
    .select_i(MemToReg),
    .data_o(write_data)
        );

/****************************************
signal assignment
****************************************/	

assign PCsrc = EX_MEM_REG[104] & EX_MEM_REG[69]; //branch&zero
assign MemToReg = MEM_WB_REG[69];
assign RegWrite = MEM_WB_REG[70];
endmodule

