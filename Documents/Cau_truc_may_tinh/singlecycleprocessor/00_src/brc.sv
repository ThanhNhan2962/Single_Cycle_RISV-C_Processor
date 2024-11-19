module brc (
	input  logic 		  i_br_un,
	input  logic [31:0] i_rs1_data,
	input  logic [31:0] i_rs2_data,
	output logic		  o_br_less,	
	output logic		  o_br_equal
);
	
	// Khoi tao cac wire ket noi cac module
	logic signed_br_less;
	logic unsigned_br_less;
	logic signed_br_equal;
	logic unsigned_br_equal;
	
	// Module chon dau cho tin hieu o_br_less 
	mux2to1_1bit mux_br_less (
		.i_data1 (unsigned_br_less),
		.i_data0 (signed_br_less),
		.i_sel   (i_br_un),
		.o_data  (o_br_less)
	);
	
	// Module chon dau cho tin hieu o_br_equal
	mux2to1_1bit mux_br_equal (
		.i_data1 (unsigned_br_equal),
		.i_data0	(signed_br_equal),
		.i_sel   (i_br_un),
		.o_data  (o_br_equal)
	);
	
	// Module so sanh 2 so khong dau
	signed_32bit_comparator sign_compare(
		.i_rs1_data			 (i_rs1_data),
		.i_rs2_data 		 (i_rs2_data),
		.o_signed_br_less  (signed_br_less),
		.o_signed_br_equal (signed_br_equal)
	);
	
	// Module so sanh 2 so co dau
	unsigned_32bit_comparator unsign_compare (
		.i_rs1_data 		   (i_rs1_data),
		.i_rs2_data			   (i_rs2_data),
		.o_unsigned_br_less  (unsigned_br_less),
		.o_unsigned_br_equal (unsigned_br_equal)
	);
	
endmodule: brc

module signed_32bit_comparator (
    input  logic [31:0] i_rs1_data,        // Toan hang A
    input  logic [31:0] i_rs2_data,        // Toan hang B
    output logic o_signed_br_less,         // Ket qua A < B
    output logic o_signed_br_equal         // Ket qua A == B
);
    logic [31:0] b_com;        // Bien chua gia tri b duoc dao bit
    logic [31:0] o_diff;       // Bien luu ket qua phep tru (A - B)
    logic o_co;                // Bien carry out
    logic a_sign, b_sign, diff_sign; // Cac bien kiem tra dau

    // Dao bit cua B (bu 1)
    assign b_com = ~i_rs2_data;

    // Su dung full_adder_32bit de thuc hien phep tru: A - B
    full_adder_32bit fa3 (
        .a(i_rs1_data), 
        .b(b_com), 
        .ci(1'b1), 
        .s(o_diff), 
        .co(o_co)
    );

    // Lay bit dau cua A, B va ket qua hieu
    assign a_sign = i_rs1_data[31];
    assign b_sign = i_rs2_data[31];
    assign diff_sign = o_diff[31];

    // Xac dinh ket qua so sanh
    always_comb begin
        // Kiem tra neu A va B khac dau
        if (a_sign != b_sign) begin
            // Neu A am va B duong, thi A < B
            o_signed_br_less = a_sign;
        end else begin
            // Neu cung dau, kiem tra bit dau cua hieu
            o_signed_br_less = diff_sign;
        end

        // Kiem tra neu hieu bang 0 de xac dinh A == B
        o_signed_br_equal = (o_diff == 32'b0);
    end
endmodule: signed_32bit_comparator

module unsigned_32bit_comparator (
    input  logic [31:0] i_rs1_data,        // Toan hang A
    input  logic [31:0] i_rs2_data,        // Toan hang B
    output logic o_unsigned_br_less,       // Ket qua A < B
    output logic o_unsigned_br_equal       // Ket qua A == B
);
    logic [31:0] b_com;        // Bien chua gia tri b duoc dao bit
    logic [31:0] o_diff;       // Bien luu ket qua phep tru (A - B)
    logic o_co;                // Bien carry out
    logic diff_sign;           // Bien kiem tra dau cua ket qua tru

    // Dao bit cua B (bu 1)
    assign b_com = ~i_rs2_data;

    // Su dung full_adder_32bit de thuc hien phep tru: A - B
    full_adder_32bit fa4 (
        .a(i_rs1_data), 
        .b(b_com), 
        .ci(1'b1), 
        .s(o_diff), 
        .co(o_co)
    );

    // Lay bit dau cua ket qua hieu
    assign diff_sign = o_diff[31];

    // Xac dinh ket qua so sanh
    always_comb begin
        // Kiem tra neu hieu bang 0 de xac dinh A == B
        o_unsigned_br_equal = (o_diff == 32'b0);

        // Neu hieu am (diff_sign = 1), thi A < B, nguoc lai A >= B
        o_unsigned_br_less = diff_sign;
    end
endmodule: unsigned_32bit_comparator

module mux2to1_1bit (
	input logic i_data1,
	input logic i_data0,
	input logic i_sel,
	output logic o_data
);

	assign o_data = (i_sel) ? i_data1 : i_data0;
	
endmodule: mux2to1_1bit