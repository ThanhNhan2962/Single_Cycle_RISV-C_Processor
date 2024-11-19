module instr_fetch(
  input  logic        i_clk     ,
  input  logic        i_rst   ,
  input  logic        i_pc_sel  ,
  input  logic        i_pc_en   ,
  input  logic [31:0] i_alu_data,
  output logic [31:0] o_pc      ,
  output logic [31:0] o_instr
);

  logic [31:0] pc;
  logic [12:0] instr_addr;
  logic [31:0] instr_data;

  pc_gen pcgen(
    .i_clk     (i_clk),
    .i_rst     (i_rst),
    .i_pc_sel  (i_pc_sel),
    .i_pc_en   (i_pc_en),
    .i_alu_data(i_alu_data),
    .o_pc      (pc)
  );

  instr_mem instrmem(
    .i_instr_addr (instr_addr),
    .o_instr_data (instr_data)
  );

  assign instr_addr  = pc[12:0];
  assign o_pc   = pc;
  assign o_instr = (~i_rst) ? instr_data : 32'h0;

endmodule : instr_fetch

