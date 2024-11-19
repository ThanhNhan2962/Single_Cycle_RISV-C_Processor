module mux2to1_32bit (
	input logic        i_sel,
	input logic [31:0] i_data_0,
	input logic [31:0] i_data_1,
	output logic [31:0] o_data
);

	assign o_data = (i_sel) ? i_data_1 : i_data_0;
	
endmodule: mux2to1_32bit