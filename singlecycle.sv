module singlecycle (
	input	 logic		  i_clk,
	input  logic        i_rst_n,
	input  logic [31:0] i_io_sw,
	input  logic [31:0] i_io_btn,
	output logic [31:0] o_pc_debug,
	output logic        o_insn_vld,
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

	logic [31:0] alu_data;
	logic [31:0] pc_four;
	logic        pc_sel;	
	logic [31:0] pc_next;
	logic			 pc_wren;
	logic [31:0] pc;
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
	logic [1:0]  wb_sel;	
	logic [31:0] ld_data;
	logic        insn_vld;
  
	assign rs1_addr = instr[19:15];
	assign rs2_addr = instr[24:20];
	assign rd_addr = instr[11:7];
  
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
		.i_clk      (i_clk),
		.i_rst      (i_rst_n),
		.i_lsu_wren (mem_wren),
		.i_st_data  (rs2_data),
		.i_io_sw    (i_io_sw),
		.i_io_btn   (i_io_btn),
		.o_ld_data  (ld_data),
		.o_io_ledg  (o_io_ledg),
		.o_io_ledr  (o_io_ledr),
		.o_io_lcd   (o_io_lcd),
		.o_io_hex0  (o_io_hex0),
		.o_io_hex1  (o_io_hex1),
		.o_io_hex2  (o_io_hex2),
		.o_io_hex3  (o_io_hex3),
		.o_io_hex4  (o_io_hex4),
		.o_io_hex5  (o_io_hex5),
		.o_io_hex6  (o_io_hex6),
		.o_io_hex7  (o_io_hex7)
	);

	// 5. ctrlu
	ctrlu u5 (
		.i_instr    (instr),
		.i_br_less  (br_less),
		.i_br_equal	(br_equal),
		.o_pc_sel	(pc_sel),
		.o_rd_wren 	(rd_wren),
		.o_insn_vld (insn_vld),
		.o_br_un		(br_un),
		.o_alu_op 	(alu_op),
		.o_mem_wren (mem_wren),
		.o_opa_sel 	(opa_sel),
		.o_opb_sel	(opb_sel),
		.o_wb_sel 	(wb_sel),
		.o_pc_wren 	(pc_wren)
	);
	
	// 6. imm_gen
	imm_gen u6 (
		.i_instr		(instr),
		.o_imm_data (imm_data)
	);

	// 7. instr_mem
	instr_mem u7 (
		.i_clk	(i_clk),
		.i_pc    (pc),
		.o_instr (instr)
	);
	
	// 8. pc_reg
	pc_reg u8 (
		.i_clk 	  (i_clk),
		.i_rst     (i_rst_n),
		.i_pc_wren (pc_wren),
		.i_pc_next (pc_next),
		.o_pc      (pc)
	);

	// 9. pc_four
	pc_four u9 (
		.i_pc      (pc),
		.o_pc_four (pc_four)
	);
	
	// 10. mux2to1
	// pc_mux
	mux2to1 pc_mux (
		.i_sel		(pc_sel),
		.i_data_0	(pc_four),
		.i_data_1	(alu_data),
		.o_data 		(pc_next)
	  );

	// opa_mux
	mux2to1 opa_mux (
		.i_sel		(opa_sel),
		.i_data_0	(rs1_data),
		.i_data_1	(pc),
		.o_data 		(operand_a)
	  );

	// opb_mux
	mux2to1 opb_mux (
		.i_sel		(opb_sel),
		.i_data_0	(imm_data),
		.i_data_1	(rs2_data),
		.o_data 		(operand_b)
	  );
	
	// 11. mux3to1
	mux3to1 wb_mux (
		.i_sel		(wb_sel),
		.i_data_01 	(ld_data),
		.i_data_10	(alu_data),
		.i_data_11  (pc_four),
		.o_data  	(wb_data)
	);
	
	// 12. pc_debug_reg
	pc_debug_reg u12 (
		.i_clk      (i_clk),
	   .i_rst      (i_rst_n),  
	   .i_pc       (pc),
	   .o_pc_debug (o_pc_debug)
	);

	// 13. insn_vld_reg 
	insn_vld_reg u13 (
	   .i_clk      (i_clk),
	   .i_rst      (i_rst_n),
	   .i_insn_vld (insn_vld),
	   .o_insn_vld (o_insn_vld)
	);

endmodule: singlecycle
