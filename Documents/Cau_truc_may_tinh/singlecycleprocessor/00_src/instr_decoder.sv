module instr_decoder (
	input logic [31:0] i_instr,
	output logic [4:0] o_rs1_addr,
	output logic [4:0] o_rs2_addr,
	output logic [4:0] o_rd_addr
);

	logic [31:0] instr;
	assign instr = i_instr;
	assign o_rs1_addr = instr[19:15];
	assign o_rs2_addr = instr[24:20];
	assign o_rd_addr  = instr[11:7];
	
endmodule: instr_decoder