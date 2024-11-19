module decoder1to2_lsu (
    input  logic [15:0] i_lsu_addr,  // dia chi bo nho 16-bit
    input  logic [31:0] i_data,   // du lieu dau vao 32-bit
    output logic [31:0] o_wr_op_data,  // du lieu dau ra cho dia chi 0x7000 - 0x703F
    output logic [31:0] o_wr_data        // du lieu dau ra cho dia chi 0x2000 - 0x3FFF
);

    // Khoi lenh giai ma dia chi
    always_comb begin
	     o_wr_op_data = 32'b0;
        o_wr_data = 32'b0;
		  
        // Giai ma dia chi
        if (i_lsu_addr[15:13] == 3'b001) begin
            o_wr_data = i_data; // dia chi thuoc khoang 0x02000 - 0x3FFF
        end else if (i_lsu_addr[15:6] == 10'b0111_0000_00) begin
            o_wr_op_data = i_data;      // dia chi thuoc khoang 0x7000 - 0x703F
        end
    end
endmodule: decoder1to2_lsu
