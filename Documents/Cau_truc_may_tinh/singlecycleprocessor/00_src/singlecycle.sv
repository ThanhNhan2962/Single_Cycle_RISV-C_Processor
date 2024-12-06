module singlecycle (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [31:0] i_io_sw,
    input  logic [31:0] i_io_btn,
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
    output logic [31:0] o_io_lcd,
    output logic        o_instr_vld,
    output logic [31:0] o_pc_debug
);

    // Internal signals
    logic [31:0] pc, pc_four, instr;
    logic [31:0] rs1_data, rs2_data, imm_data;
    logic pc_sel, pc_en, opa_sel, opb_sel;
    logic [3:0] alu_op;
    logic mem_wren, mem_un;
    logic [3:0] mem_mask;
    logic [1:0] wb_sel;
    logic [31:0] alu_data, ld_data, wb_data;
	logic [6:0] io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;
	
    // Instruction Fetch (IF) stage
    instr_fetch u_instr_fetch (
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),
        .i_pc_sel    (pc_sel),
        .i_pc_en     (pc_en),
        .i_alu_data  (alu_data),
        .o_pc        (pc),
        .o_pc_four   (pc_four),
        .o_instr     (instr)
    );

    // Instruction Decode (ID) stage
    instr_decoder u_instr_decoder (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .i_instr      (instr),
        .i_wb_data    (wb_data),
        .o_rs1_data   (rs1_data),
        .o_rs2_data   (rs2_data),
        .o_imm_data   (imm_data),
        .o_pc_sel     (pc_sel),
        .o_pc_en      (pc_en),
        .o_instr_vld  (o_instr_vld),
        .o_alu_op     (alu_op),
        .o_mem_wren   (mem_wren),
        .o_mem_mask   (mem_mask),
        .o_mem_un     (mem_un),
        .o_wb_sel     (wb_sel),
        .o_opa_sel    (opa_sel),
        .o_opb_sel    (opb_sel)
    );

    // Instruction Execute (EX) stage
    instr_execute u_instr_execute (
        .i_rs1_data   (rs1_data),
        .i_rs2_data   (rs2_data),
        .i_imm_data   (imm_data),
        .i_pc         (pc),
        .i_opa_sel    (opa_sel),
        .i_opb_sel    (opb_sel),
        .i_alu_op     (alu_op),
        .o_alu_data   (alu_data)
    );

    // Instruction Memory (MEM) stage
    instr_memory u_instr_memory (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .i_mem_un     (mem_un),
        .i_mem_mask   (mem_mask),
        .i_mem_wren   (mem_wren),
        .i_alu_data   (alu_data),
        .i_rs2_data   (rs2_data),
        .o_ld_data    (ld_data),
        .i_io_sw      (i_io_sw),
        .i_io_btn     (i_io_btn),
        .o_io_ledr    (o_io_ledr),
        .o_io_ledg    (o_io_ledg),
        .o_io_hex0    (io_hex0),
        .o_io_hex1    (io_hex1),
        .o_io_hex2    (io_hex2),
        .o_io_hex3    (io_hex3),
        .o_io_hex4    (io_hex4),
        .o_io_hex5    (io_hex5),
        .o_io_hex6    (io_hex6),
        .o_io_hex7    (io_hex7),
        .o_io_lcd     (o_io_lcd)
    );
	 
	hex_to_seven_segment conver7segment (
		.i_io_hex0   	 (io_hex0),
		.i_io_hex1    	 (io_hex1),
      .i_io_hex2    	 (io_hex2),
      .i_io_hex3    	 (io_hex3),
      .i_io_hex4    	 (io_hex4),
      .i_io_hex5    	 (io_hex5),
      .i_io_hex6    	 (io_hex6),
      .i_io_hex7      (io_hex7),
		.o_io_seven_segment0 (o_io_hex0),
      .o_io_seven_segment1 (o_io_hex1),
      .o_io_seven_segment2 (o_io_hex2),
      .o_io_seven_segment3 (o_io_hex3),
      .o_io_seven_segment4 (o_io_hex4),
      .o_io_seven_segment5 (o_io_hex5),
      .o_io_seven_segment6 (o_io_hex6),
      .o_io_seven_segment7 (o_io_hex7),
	);

    // Instruction Writeback (WB) stage
    instr_writeback u_instr_writeback (
        .i_alu_data   (alu_data),
        .i_ld_data    (ld_data),
        .i_imm_data   (imm_data),
        .i_pc_four    (pc_four),
        .i_wb_sel     (wb_sel),
        .o_wb_data    (wb_data)
    );

    // Debug output
    assign o_pc_debug = pc;

endmodule: singlecycle
