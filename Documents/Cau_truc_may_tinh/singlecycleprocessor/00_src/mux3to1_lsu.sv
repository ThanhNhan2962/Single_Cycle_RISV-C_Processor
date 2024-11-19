module mux3to1_lsu (
    input  logic [15:0] i_lsu_addr,      // dia chi bo nho 16-bit
    input  logic [31:0] i_rd_ip_data,    // du lieu tu dia chi 0x7800 - 0x781F
    input  logic [31:0] i_rd_op_data,    // du lieu tu dia chi 0x7000 - 0x703F
    input  logic [31:0] i_rd_data,         // du lieu tu dia chi 0x2000 - 0x3FFF
    output logic [31:0] o_data        // du lieu duoc chon dua tren dia chi
);

    // Khoi lenh chon du lieu dua tren dia chi
    always_comb begin
        // Mac dinh dau ra bang 0
        o_data = 32'b0;

        // Chon du lieu dua tren dia chi
        if ((i_lsu_addr[15:13] == 3'b001)) begin // dia chi thuoc khoang 0x2000 - 0x3FFF
            o_data = i_rd_data;   
        end else if (i_lsu_addr[15:6] == 10'b0111_0000_00) begin // dia chi thuoc khoang 0x7000 - 0x703F
            o_data = i_rd_op_data;
        end else if (i_lsu_addr[15:5] == 11'b0111_1000_000) begin // dia chi thuoc khoang 0x7800 - 0x781F
            o_data = i_rd_ip_data;        
        end
    end
endmodule: mux3to1_lsu
