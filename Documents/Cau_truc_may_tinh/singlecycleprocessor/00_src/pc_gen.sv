module pc_gen(
	input  logic        i_clk     ,
	input  logic        i_rst   ,
	input  logic        i_pc_sel  ,
	input  logic        i_pc_en   ,
	input  logic [31:0] i_alu_data,
	output logic [31:0] o_pc
);

	logic [31:0] pc_q;
	logic [31:0] pc_d;

	always_comb begin : proc_next_pc
		if (i_pc_en) begin
			pc_d = i_pc_sel ? i_alu_data : pc_q + 32'h4;
		end
		else begin
			pc_d = pc_q;
		end
	end

	always_ff @(posedge i_clk) begin : proc_update_pc
		if (!i_rst) begin
			pc_q <= '0;
		end
		else begin
			pc_q <= pc_d;
		end
	end

	assign o_pc = pc_q;

endmodule : pc_gen
