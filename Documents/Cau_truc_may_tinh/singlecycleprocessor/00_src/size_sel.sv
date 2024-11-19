module size_sel (
    input  logic [31:0] i_data,      // du lieu doc tu bo nho
    input  logic [3:0]  i_mask,      // loai tai du lieu (0001: byte, 0011: half, 1111: word)
    input  logic        i_unsigned,  // chon loai khong dau (1: unsigned, 0: signed)
    output logic [31:0] o_data       // du lieu dau ra da duoc dieu chinh
);
    always_comb begin
        case (i_mask)
            4'b0001: begin // Load Byte (LB, LBU)
                // Neu tai du lieu khong dau, zero-extend; neu co dau, sign-extend
                o_data = (i_unsigned) ? {24'b0, i_data[7:0]} : {{24{i_data[7]}}, i_data[7:0]};
            end
            4'b0011: begin // Load Halfword (LH, LHU)
                // Neu tai du lieu khong dau, zero-extend; neu co dau, sign-extend
                o_data = (i_unsigned) ? {16'b0, i_data[15:0]} : {{16{i_data[15]}}, i_data[15:0]};
            end
            4'b1111: begin // Load Word (LW)
                // Tra ve du lieu 32-bit goc
                o_data = i_data;
            end
            default: begin
                // Neu mask khong hop le, tra ve 0
                o_data = 32'b0;
            end
        endcase
    end
endmodule: size_sel
