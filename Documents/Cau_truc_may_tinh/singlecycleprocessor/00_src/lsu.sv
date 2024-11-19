module lsu (
	input  logic 		  i_clk,
	input  logic 		  i_rst,
	input  logic		  i_lsu_un,
	input  logic [31:0] i_lsu_addr,	
	input  logic [3:0]  i_mask,
	input  logic 		  i_lsu_wren,
	input  logic 		  i_lsu_rden,
	input  logic [31:0] i_st_data,
	output logic [31:0] o_ld_data,
	
	// input peripherals
	input  logic [31:0] i_io_sw,
	input  logic [31:0] i_io_btn,
	
	// output peripherals 
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
  
	//Khai bao cac bien ket noi
	logic [31:0] rd_ip_data;
	logic [31:0] wr_op_data;
	logic [31:0] rd_op_data;
	logic [31:0] wr_data;
	logic [31:0] rd_data;
	logic [31:0] decoder_data;
	logic [31:0] mux_data;
	
	ip_mem u15 (
		.i_clk 		(i_clk),
		.i_rst 		(i_rst),
		.i_ip_addr	(i_lsu_addr[15:0]),
		.i_io_sw 	(i_io_sw),
		.i_io_btn 	(i_io_btn),
		.o_ip_data 	(rd_ip_data)
	);
	
	op_mem u16 (
		.i_clk					(i_clk),
		.i_rst					(i_rst),
		.i_lsu_wren 			(i_lsu_wren),
		.i_op_addr  			(i_lsu_addr[15:0]),
		.i_op_data  			(wr_op_data),
		.o_op_data  			(rd_op_data),
		.o_io_ledr  			(o_io_ledr),
		.o_io_ledg 				(o_io_ledg),
		.o_io_hex0 				(o_io_hex0),
		.o_io_hex1 				(o_io_hex1),
		.o_io_hex2 				(o_io_hex2),
		.o_io_hex3 				(o_io_hex3),
		.o_io_hex4 				(o_io_hex4),
		.o_io_hex5 				(o_io_hex5),
		.o_io_hex6 				(o_io_hex6),
		.o_io_hex7 				(o_io_hex7),
		.o_io_lcd   			(o_io_lcd)
	);

	data_mem u17 (
   .i_clk      (i_clk),
   .i_rst      (i_rst),
   .i_lsu_wren (i_lsu_wren),
   .i_data_addr (i_lsu_addr[15:0]),
   .i_data     (wr_data),
   .o_data     (rd_data)
	);
	
	decoder1to2_lsu u18 (
		.i_lsu_addr   (i_lsu_addr[15:0]),
		.i_data  	  (decoder_data),
		.o_wr_op_data (wr_op_data),
		.o_wr_data 	  (wr_data)
		);
	
	mux3to1_lsu u19 (
		.i_lsu_addr   (i_lsu_addr[15:0]),
		.i_rd_ip_data (rd_ip_data),
		.i_rd_op_data (rd_op_data),
		.i_rd_data	  (rd_data),
		.o_data 		  (mux_data)
	);
	
	size_sel store (
		.i_data 		(i_st_data),
		.i_mask 		(i_mask),
		.i_unsigned (1'b0),
		.o_data 		(decoder_data)
	);
	
	size_sel load (
		.i_data 		(mux_data),
		.i_mask 		(i_mask),
		.i_unsigned (i_lsu_un),
		.o_data 		(o_ld_data)
	);
	
endmodule: lsu