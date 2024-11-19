module alu_add_sub (
	input logic [31:0] i_add_sub_a,			// Toan hang A
   input logic [31:0] i_add_sub_b,        // Toan hang B
   input logic i_carry_in,        			// Carry in (0 cho cong, 1 cho tru)
   output logic [31:0] o_add_sub_result,  // Ket qua
   output logic o_carry_out       			// Carry out
);

   logic [31:0] temp;             			// Bien trung gian cho phep toan B
	
   // Chon dau vao temp dua tren i_carry_in, neu i_carry_in = 1, lay ~i_add_sub_b (tru), nguoc lai lay i_add_sub_b
   assign temp = i_carry_in ? ~i_add_sub_b : i_add_sub_b;
	
	//Su dung bo full_adder_32bit de tinh tong/hieu
	full_adder_32bit fa0 (
		.a  (i_add_sub_a),
		.b	 (temp),
		.ci (i_carry_in),
		.s	 (o_add_sub_result),
		.co (o_carry_out)
	);

endmodule: alu_add_sub