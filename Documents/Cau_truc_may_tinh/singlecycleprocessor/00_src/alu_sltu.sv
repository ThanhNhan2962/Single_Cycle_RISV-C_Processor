module alu_sltu (
    input  logic [31:0] i_sltu_a,  // Toan hang A (rs1)
    input  logic [31:0] i_sltu_b,  // Toan hang B (rs2)
    output logic [31:0] o_sltu_result // Ket qua (1 neu A < B, 0 neu A >= B)
);
    logic [31:0] b_com;     // Bien chua gia tri B sau khi dao bit (bu 1)
    logic [31:0] o_diff;    // Bien luu ket qua phep tru (A - B)

    // Dao bit cua B (bu 1)
    assign b_com = ~i_sltu_b;

    // Su dung full_adder_32bit de thuc hien phep tru: A - B
    full_adder_32bit fa2 (
        .a(i_sltu_a), 
        .b(b_com), 
        .ci(1'b1), 
        .s(o_diff), 
        .co(co)
    );
	 
    // Xac dinh ket qua so sanh
    // Khi A < B, `o_sltu_result` = 1 (32 bit) ; khi A >= B, `o_sltu_result` = 0
    assign o_sltu_result = {31'b0, o_diff[31]}; // Tao ket qua 32 bit tu bit dau

endmodule: alu_sltu
