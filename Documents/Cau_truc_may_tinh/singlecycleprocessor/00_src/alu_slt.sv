module alu_slt (
	input logic  [31:0] i_slt_a,  // Toan hang A
   input logic  [31:0] i_slt_b,  // Toan hang B
   output logic [31:0] o_slt_result     // Ket qua SLT
);
   logic [31:0] b_com;          // Bien chua gia tri b duoc dao bit
   logic [31:0] o_diff;         // Bien luu ket qua phep tru
   logic a_sign, b_sign, diff_sign; // Bien kiem tra dau

   // Dao bit cua b
   assign b_com = ~i_slt_b;

   // Su dung bo full_adder_32bit de tinh hieu
   full_adder_32bit fa1 (.a(i_slt_a), .b(b_com), .ci(1'b1), .s(o_diff), .co(co));

   // Lay bit dau cua A va B
   assign a_sign = i_slt_a[31];
   assign b_sign = i_slt_b[31];
	assign diff_sign = o_diff[31];

   always_comb begin
		// Kiem tra neu A va B khac dau
		if (a_sign != b_sign) begin 
			o_slt_result = {31'b0, a_sign};  // Neu A am va B duong, thi A < B (a_sign = 1)
      end else begin 
      // Neu cung dau, xet dau cua hieu
         o_slt_result = {31'b0, diff_sign}; // Neu hieu am, A < B
      end
   end
endmodule: alu_slt
