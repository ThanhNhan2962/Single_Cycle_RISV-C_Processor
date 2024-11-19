module singlecycle (
	input	 logic		  i_clk,
	input  logic 		  i_rst_n,
	input  logic [31:0] i_io_sw,
	input  logic [31:0]  i_io_btn,
	output logic [31:0] o_io_ledr,
	output logic [31:0] o_io_ledg,
	output logic [6:0]  o_io_hex0,
	output logic [6:0]  o_io_hex1,
	output logic [6:0]  o_io_hex2,
	output logic [6:0]  o_io_hex3,
	output logic [6:0]  o_io_hex4,
	output logic [6:0]  o_io_hex5,
	output logic [6:0]  o_io_hex6,
	output logic [6:0]  o_io_hex7,
	output logic [31:0] o_io_lcd
);
	
	//Khai bao cac ket noi module
	logic [31:0] alu_data;
	logic        pc_sel;
	logic [31:0] pc_next;
	logic			 pc_en;
	logic [31:0] pc;
	logic [31:0] pc_four;
	logic [31:0] instr;
	logic [4:0]  rs1_addr;
	logic [4:0]  rs2_addr;
	logic [4:0]  rd_addr;
	logic        rd_wren;
	logic [31:0] wb_data;
	logic [31:0] rs1_data;
	logic [31:0] rs2_data;
	logic [31:0] imm_data;
	logic        br_un;
	logic        br_less;
	logic        br_equal;
	logic        opa_sel;
	logic [31:0] operand_a;
	logic        opb_sel;
	logic [31:0] operand_b;
	logic [3:0]  alu_op;
	logic        mem_wren;
	logic        mem_rden;
	logic	[3:0]  mask;
	logic        mem_un;
	logic [1:0]  wb_sel;	
	logic [31:0] ld_data;
	logic [31:0] pc_debug;	
	logic        insn_vld;
	logic [31:0] ledr;
	logic [31:0] ledg;
	logic			 insn_vld_ledg7;
	
	
	
	always_comb begin
		o_io_ledr = (insn_vld_ledg7) ? ledr : pc_debug;
		o_io_ledg = {ledg [31:8], insn_vld_ledg7, ledg [6:0]};
	end
	
	// 1. alu
	alu u1 (
		.i_operand_a (operand_a),
		.i_operand_b (operand_b),
		.i_alu_op    (alu_op),
		.o_alu_data  (alu_data)
	);

	// 2. brc
	brc u2 (
		.i_rs1_data (rs1_data),
		.i_rs2_data (rs2_data),
		.i_br_un    (br_un),
		.o_br_less  (br_less),
		.o_br_equal (br_equal)
	);
	
	// 3. regfile
	regfile u3 (
		.i_clk      (i_clk),
		.i_rst      (i_rst_n),
		.i_rd_wren  (rd_wren),
		.i_rd_addr  (rd_addr),
		.i_rs1_addr (rs1_addr),
		.i_rs2_addr (rs2_addr),
		.i_rd_data  (wb_data),
		.o_rs1_data (rs1_data),
		.o_rs2_data (rs2_data)
	);
	
	// 4. lsu
	lsu u4 (
		.i_clk       (i_clk),
		.i_rst       (i_rst_n),
		.i_lsu_un    (mem_un),
		.i_lsu_addr  (alu_data),
		.i_mask      (mask),
		.i_lsu_wren  (mem_wren),
		.i_lsu_rden  (mem_rden),
		.i_st_data   (rs2_data),
		.o_ld_data   (ld_data),		
		.i_io_sw     (i_io_sw),
		.i_io_btn    (i_io_btn),
		.o_io_ledr   (ledr),
		.o_io_ledg   (ledg),
		.o_io_hex7   (o_io_hex7),
		.o_io_hex6   (o_io_hex6),
		.o_io_hex5   (o_io_hex5),
		.o_io_hex4   (o_io_hex4),
		.o_io_hex3   (o_io_hex3),
		.o_io_hex2   (o_io_hex2),
		.o_io_hex1   (o_io_hex1),
		.o_io_hex0   (o_io_hex0),
		.o_io_lcd    (o_io_lcd)
	);

	// 5. ctrlu
	ctrlu u5 (
		.i_instr    (instr),
		.i_br_less  (br_less),
		.i_br_equal	(br_equal),
		.o_pc_sel	(pc_sel),
		.o_pc_en 	(pc_en),
		.o_rd_wren 	(rd_wren),
		.o_insn_vld (insn_vld),
		.o_br_un		(br_un),
		.o_opa_sel 	(opa_sel),
		.o_opb_sel	(opb_sel),
		.o_alu_op 	(alu_op),
		.o_mem_wren (mem_wren),
		.o_mask     (mask),
		.o_mem_un   (mem_un),
		.o_wb_sel 	(wb_sel)
	);
	
	// 6. imm_gen
	imm_gen u6 (
		.i_instr		(instr),
		.o_imm_data (imm_data)
	);
	
	// 7. instr_mem
	instr_mem u7 (
		.i_instr_addr (pc),
		.o_instr_data (instr)
 	);
	
	// 8. instr_decoder
	instr_decoder u8 (
		.i_instr (instr),
		.o_rs1_addr (rs1_addr),
		.o_rs2_addr (rs2_addr),
		.o_rd_addr (rd_addr)
	);
	
	// 9 . pc_reg
	pc_reg u9 (
		.i_clk (i_clk),
		.i_rst (i_rst_n),
		.i_pc_en (pc_en),
		.i_pc_next (pc_next),
		.o_pc (pc)
	);
	// 10. pc_four
	pc_four u10 (
		.i_pc (pc),
		.o_pc_four (pc_four)
	);
	
	// 11. mux2to1
	// pc_mux
	mux2to1_32bit pc_mux (
		.i_sel		(pc_sel),
		.i_data_0	(pc_four),
		.i_data_1	(alu_data),
		.o_data 		(pc_next)
	  );

	// opa_mux
	mux2to1_32bit opa_mux (
		.i_sel		(opa_sel),
		.i_data_0	(rs1_data),
		.i_data_1	(pc),
		.o_data 		(operand_a)
	  );

	// opb_mux
	mux2to1_32bit opb_mux (
		.i_sel		(opb_sel),
		.i_data_0	(imm_data),
		.i_data_1	(rs2_data),
		.o_data 		(operand_b)
	  );
	
	// 12. mux4to1
	mux4to1_32bit wb_mux (
		.i_sel		(wb_sel),
		.i_data_00 	(alu_data),
		.i_data_01 	(ld_data),
		.i_data_10	(imm_data),
		.i_data_11  (pc_four),
		.o_data  	(wb_data)
	);
	
	// 13. pc_debug_reg
	pc_debug_reg u12 (
		.i_clk      (i_clk),
	   .i_rst      (i_rst_n),  
	   .i_pc       (pc),
	   .o_pc_debug (pc_debug)
	);

	// 14. insn_vld_reg 
	insn_vld_reg u13 (
	   .i_clk      (i_clk),
	   .i_rst      (i_rst_n),
	   .i_insn_vld (insn_vld),
	   .o_insn_vld (insn_vld_ledg7)
	);

endmodule: singlecycle