module instr_mem(
	input  logic [12:0] i_instr_addr,
	output logic [31:0] o_instr_data
);

	logic [31:0] instr_memory [2047:0];

	initial begin
		$readmemh("C:/milestone2/02_test/dump/mem.txt", instr_memory);
	end
	
	always_comb begin
		o_instr_data <= instr_memory[i_instr_addr[12:2]];
	end
endmodule : instr_mem