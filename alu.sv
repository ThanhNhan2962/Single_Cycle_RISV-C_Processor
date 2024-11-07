module alu (
	input  logic [3:0] i_alu_op,        // Ngo vao chon che do hoat dong cho alu
	input  logic [31:0] i_operand_a,    // Ngo vao data tu opa_mux
	input  logic [31:0] i_operand_b,    // Ngo vao data tu opb_mux
   output logic [31:0] o_alu_data      // Ngo ra du lieu cua ALU
);

	// Dinh nghia cac gia tri cho i_alu_op bang typedef enum
	typedef enum logic [3:0] {
		ADD      = 4'b0000,	// Phep cong
		SUB      = 4'b1000,  // Phep tru
		SLL      = 4'b0001,  // Dich trai logic
		SLT      = 4'b0010,  // So sanh nho hon
		SLTU     = 4'b0011,  // So sanh nho hon khong dau
		XOR      = 4'b0100,  // Phep XOR
		SRL      = 4'b0101,  // Dich phai logic
		SRA      = 4'b1101,  // Dich phai so hoc
		OR       = 4'b0110,  // Phep OR
		AND      = 4'b0111,  // Phep AND
		LUI      = 4'b1111   // Lay phan dia chi cao
	} alu_op_e;
	
	// Tao wire ket noi cac module phu
   logic ci;
   logic [31:0] add_sub_result;
   logic [31:0] sll_result;
   logic [31:0] slt_result;
   logic [31:0] sltu_result;
   logic [31:0] xor_result;
   logic [31:0] srl_result;
   logic [31:0] sra_result;
   logic [31:0] or_result;
   logic [31:0] and_result;

   assign ci = i_alu_op[3];

	// Module add sub
   alu_add_sub u_add_sub (.i_add_sub_a(i_operand_a), .i_add_sub_b(i_operand_b), .i_carry_in(ci), .o_add_sub_result(add_sub_result));
    
   // Module sll
   alu_sll u_sll (.i_sll_data(i_operand_a), .i_sll_shift(i_operand_b), .o_sll_result(sll_result));
    
   // Module slt
   alu_slt u_slt (.i_slt_a(i_operand_a), .i_slt_b(i_operand_b), .o_slt_result(slt_result));
   
   // Module sltu
   alu_sltu u_sltu (.i_sltu_a(i_operand_a), .i_sltu_b(i_operand_b), .o_sltu_result(sltu_result));

   // Module xor
   alu_xor u_xor (.i_xor_a(i_operand_a), .i_xor_b(i_operand_b), .o_xor_result(xor_result));

   // Module srl
   alu_srl u_srl (.i_srl_data(i_operand_a), .i_srl_shift(i_operand_b), .o_srl_result(srl_result));
    
   // Module sra
   alu_sra u_sra (.i_sra_data(i_operand_a), .i_sra_shift(i_operand_b), .o_sra_result(sra_result));
    
   // Module or
   alu_or u_or (.i_or_a(i_operand_a), .i_or_b(i_operand_b), .o_or_result(or_result));
    
   // Module and
   alu_and u_and (.i_and_a(i_operand_a), .i_and_b(i_operand_b), .o_and_result(and_result));
    
   // Lua chon che do hoat dong cho ALU dua vao i_alu_op
	always_comb begin
		case (i_alu_op)
			ADD    : o_alu_data = add_sub_result;	// Phep cong
			SUB    : o_alu_data = add_sub_result;	// Phep tru
			SLL    : o_alu_data = sll_result;		// Dich trai logic
			SLT    : o_alu_data = slt_result;		// So sanh nho hon
			SLTU   : o_alu_data = sltu_result;  	// So sanh nho hon khong dau
			XOR    : o_alu_data = xor_result;   	// Phep XOR
			SRL    : o_alu_data = srl_result;  		// Dich phai logic
			SRA    : o_alu_data = sra_result;		// Dich phai so hoc
			OR     : o_alu_data = or_result;			// Phep OR
			AND    : o_alu_data = and_result;		// Phep AND
			LUI    : o_alu_data = i_operand_b;		// Lay phan dia chi cao (LUI)
			default: o_alu_data = 32'b0;				// Gia tri mac dinh khi khong co che do nao phu hop
		endcase
	end
endmodule: alu

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
	full_adder_32bit fa0 (.a(i_add_sub_a), .b(temp), .ci(i_carry_in), .s(o_add_sub_result), .co(o_carry_out));

endmodule: alu_add_sub

// Mo-dun full-adder 1 bit
module full_adder_1bit (
	input  logic a,   // Toan hang 1
   input  logic b,   // Toan hang 2
   input  logic ci,  // Carry in
   output logic s,   // Tong
   output logic co   // Carry out
);
   always_comb begin
       s = a ^ b ^ ci;                // Tong
       co = (a & b) | (ci & (a ^ b)); // Tinh toan carry out
   end
endmodule: full_adder_1bit

// Mo-dun full-adder 8 bit (ghep tu 8 full-adder 1 bit)
module full_adder_8bit (
   input  logic [7:0] a,  // Toan hang A
   input  logic [7:0] b,  // Toan hang B
   input  logic ci,       // Carry vao
   output logic [7:0] s,  // Tong 8 bit
   output logic co        // Carry ra
);
   logic [6:0] carry; // Bien trung gian carry giua cac bit

   // Ket noi cac full-adder 1 bit cho 8 bit du lieu
   full_adder_1bit fa0 (.a(a[0]), .b(b[0]), .ci(ci),       .s(s[0]), .co(carry[0]));
   full_adder_1bit fa1 (.a(a[1]), .b(b[1]), .ci(carry[0]), .s(s[1]), .co(carry[1]));
   full_adder_1bit fa2 (.a(a[2]), .b(b[2]), .ci(carry[1]), .s(s[2]), .co(carry[2]));
   full_adder_1bit fa3 (.a(a[3]), .b(b[3]), .ci(carry[2]), .s(s[3]), .co(carry[3]));
   full_adder_1bit fa4 (.a(a[4]), .b(b[4]), .ci(carry[3]), .s(s[4]), .co(carry[4]));
   full_adder_1bit fa5 (.a(a[5]), .b(b[5]), .ci(carry[4]), .s(s[5]), .co(carry[5]));
   full_adder_1bit fa6 (.a(a[6]), .b(b[6]), .ci(carry[5]), .s(s[6]), .co(carry[6]));
   full_adder_1bit fa7 (.a(a[7]), .b(b[7]), .ci(carry[6]), .s(s[7]), .co(co));
endmodule: full_adder_8bit

// Mo-dun full-adder 32 bit (ghep tu 4 bo full-adder 8 bit)
module full_adder_32bit (
    input  logic [31:0] a,      // Toan hang A
    input  logic [31:0] b,      // Toan hang B
    input  logic ci,            // Carry vao
    output logic [31:0] s,      // Tong 32 bit
    output logic co             // Carry ra
);
    logic [2:0] carry;          // Bien trung gian carry giua cac khoi 8 bit

   // Ket noi cac full-adder 8 bit
	// Bo cong 32 bit chia thanh 4 khoi 8 bit
   full_adder_8bit fa0 (.a(a[7:0]),   .b(b[7:0]),   .ci(ci), .s(s[7:0]),   .co(carry[0]));
   full_adder_8bit fa1 (.a(a[15:8]),  .b(b[15:8]),  .ci(carry[0]),   .s(s[15:8]),  .co(carry[1]));
   full_adder_8bit fa2 (.a(a[23:16]), .b(b[23:16]), .ci(carry[1]),   .s(s[23:16]), .co(carry[2]));
   full_adder_8bit fa3 (.a(a[31:24]), .b(b[31:24]), .ci(carry[2]),   .s(s[31:24]), .co(co));
endmodule: full_adder_32bit

module alu_sll (
    input logic [31:0] i_sll_data,   // Dau vao 32 bit
    input logic [4:0] i_sll_shift,   // So bit can dich (tu 0 den 31)
    output logic [31:0] o_sll_result   // Dau ra sau khi dich
);

    logic [31:0] temp_data;

    always_comb begin
        temp_data = i_sll_data;       // Gan gia tri ban dau cho bien trung gian
        // Vong lap dich trai
        for (int i = 0; i < i_sll_shift; i++) begin
            temp_data = {temp_data[30:0], 1'b0};  // Dich trai 1 bit trong moi vong lap
        end
        o_sll_result = temp_data;       // Gan gia tri ket qua cuoi cung vao o_data
    end

endmodule: alu_sll

module alu_slt (
	input logic [31:0] i_slt_a,  // Toan hang A
   input logic [31:0] i_slt_b,  // Toan hang B
   output logic o_slt_result     // Ket qua SLT
);
   logic [31:0] b_com;          // Bien chua gia tri b duoc dao bit
   logic [31:0] o_diff;         // Bien luu ket qua phep tru
   logic o_co;                  // Carry out
   logic a_sign, b_sign, diff_sign; // Bien kiem tra dau

   // Dao bit cua b
   assign b_com = ~i_slt_b;

   // Su dung bo full_adder_32bit de tinh hieu
   full_adder_32bit fa1 (.a(i_slt_a), .b(b_com), .ci(1'b1), .s(o_diff), .co(o_co));

   // Lay bit dau cua A va B
   assign a_sign = i_slt_a[31];
   assign b_sign = i_slt_b[31];    assign diff_sign = o_diff[31];

   always_comb begin
		// Kiem tra neu A va B khac dau
		if (a_sign != b_sign) begin 
			o_slt_result = a_sign;  // Neu A am va B duong, thi A < B (a_sign = 1)
      end else begin 
      // Neu cung dau, xet dau cua hieu
         o_slt_result = diff_sign ? 1'b1 : 1'b0; // Neu hieu am, A < B
      end
   end
endmodule

module alu_sltu (
   input logic [31:0] i_sltu_a,  // Toan hang A
   input logic [31:0] i_sltu_b,  // Toan hang B
   output logic o_sltu_result    // Ket qua SLTU
);

   logic compare;  // Bien so sanh de kiem tra su khac nhau

   always_comb begin
      o_sltu_result = 1'b0; // Khoi tao ket qua mac dinh bang 0
      
      // So sanh tung bit tu MSB den LSB
      for (int i = 31; i >= 0; i--) begin
         compare = i_sltu_a[i] ^ i_sltu_b[i];
         if (compare) begin // Neu cac bit khac nhau (compare = 1)
            // Xac dinh ket qua dua tren bit  B
            o_sltu_result = i_sltu_b[i];
            break; // Thoat khoi vong lap khi da co ket qua
         end
      end
   end
endmodule: alu_sltu

module alu_xor (
    input logic [31:0] i_xor_a,  // Toán hạng A
    input logic [31:0] i_xor_b,  // Toán hạng B
    output logic [31:0] o_xor_result  // Kết quả XOR
);
    // Thực hiện phép XOR bitwise
    always_comb begin
        o_xor_result = 32'b0; // Khởi tạo kết quả
        for (int i = 0; i < 32; i++) begin
            o_xor_result[i] = i_xor_a[i] ^ i_xor_b[i]; // XOR từng bit
        end
    end
endmodule: alu_xor

module alu_srl (
    input logic [31:0] i_srl_data,   // Dau vao 32 bit
    input logic [4:0] i_srl_shift,   // So bit can dich (tu 0 den 31)
    output logic [31:0] o_srl_result   // Dau ra sau khi dich
);
    logic [31:0] temp_data;

    always_comb begin
        temp_data = i_srl_data;       // Gan gia tri ban dau cho bien trung gian
        // Vong lap dich phai
        for (int i = 0; i < i_srl_shift; i++) begin
            temp_data = {1'b0, temp_data[31:1]};  // Dich phai 1 bit trong moi vong lap
        end
        o_srl_result = temp_data;       // Gan gia tri ket qua cuoi cung vao o_srl_data
    end

endmodule: alu_srl

module alu_sra (
   input logic [31:0] i_sra_data,   // Toan hang A
   input logic [4:0] i_sra_shift,   // So bit de dich
   output logic [31:0] o_sra_result // Ket qua
);

   logic [31:0] temp_data; // Bien tam thoi luu ket qua sau moi lan dich
	logic sign_bit;         // Bien luu tru bit dau (MSB)

   // Luu bit dau (MSB cua i_sra_data)
   assign sign_bit = i_sra_data[31]; 

   always_comb begin
		// Gan gia tri ban dau cho bien tam
		temp_data = i_sra_data;
		
      // Thuc hien dich phai tung bit
      for (int i = 0; i < i_sra_shift; i++) begin
			// Dich phai, giu nguyen bit dau
         temp_data = {sign_bit, temp_data[31:1]}; 
      end
		
      // Gan ket qua cho output
      o_sra_result = temp_data;
    end
endmodule: alu_sra

module alu_or (
    input logic [31:0] i_or_a,  // Toán hạng A
    input logic [31:0] i_or_b,  // Toán hạng B
    output logic [31:0] o_or_result  // Kết quả OR
);
    // Thực hiện phép OR bitwise
    always_comb begin
        o_or_result = 32'b0; // Khởi tạo kết quả
        for (int i = 0; i < 32; i++) begin
            o_or_result[i] = i_or_a[i] | i_or_b[i]; // OR từng bit
        end
    end
endmodule: alu_or

module alu_and (
   input logic [31:0] i_and_a,  // Toan hang A
   input logic [31:0] i_and_b,  // Toan hang B
   output logic [31:0] o_and_result  // Ket qua AND
);
	
   // Thuc hien phep AND bitwise
   always_comb begin
		o_and_result = 32'b0; // Khoi tao ket qua ve 0
      for (int i = 0; i < 32; i++) begin
			o_and_result[i] = i_and_a[i] & i_and_b[i]; // AND tung bit
      end
   end
endmodule: alu_and