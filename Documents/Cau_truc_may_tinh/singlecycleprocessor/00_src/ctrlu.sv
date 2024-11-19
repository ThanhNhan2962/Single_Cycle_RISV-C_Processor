module ctrlu(
	input  logic [31:0] i_instr,
   input  logic		  i_br_less,
   input  logic 		  i_br_equal,
	output logic 		  o_pc_sel,
	output logic 		  o_pc_en,
   output logic 		  o_rd_wren,
	output logic 		  o_insn_vld,
	output logic 		  o_br_un,
   output logic 		  o_opa_sel,
   output logic 		  o_opb_sel,	
   output logic [3:0]  o_alu_op,
   output logic 		  o_mem_wren,
	output logic [3:0]  o_mask,
	output logic 		  o_mem_un,
	output logic [1:0]  o_wb_sel
);

	logic [6:0] opcode;
	logic [2:0] funct3;
	logic [6:0] funct7;
	logic pc_sel;
	logic pc_en;
	logic rd_wren;
	logic insn_vld;
	logic br_un;
	logic opa_sel;
	logic opb_sel;
	logic [3:0] alu_op;
	logic mem_wren;
	logic [3:0] mask;
	logic mem_un;
	logic [1:0] wb_sel;

	assign opcode = i_instr[6:0];
	assign funct3 = i_instr[14:12];
	assign funct7 = i_instr[31:25];
	assign o_pc_sel = pc_sel;
	assign o_pc_en = pc_en;
	assign o_rd_wren = rd_wren;
	assign o_insn_vld = insn_vld;
	assign o_br_un = br_un;
	assign o_opa_sel = opa_sel;
	assign o_opb_sel = opb_sel;
	assign o_alu_op = alu_op;
	assign o_mem_wren = mem_wren;
	assign o_mask = mask;
	assign o_mem_un = mem_un;
	assign o_wb_sel = wb_sel;
	
	// Dinh nghia cac gia tri cho i_alu_op bang typedef enum
	typedef enum logic [3:0] {
		ADD  = 4'b0000,	// Phep cong
		SUB  = 4'b1000,  // Phep tru
		SLL  = 4'b0001,  // Dich trai logic
		SLT  = 4'b0010,  // So sanh nho hon
		SLTU = 4'b0011,  // So sanh nho hon khong dau
		XOR  = 4'b0100,  // Phep XOR
		SRL  = 4'b0101,  // Dich phai logic
		SRA  = 4'b1101,  // Dich phai so hoc
		OR   = 4'b0110,  // Phep OR
		AND  = 4'b0111,  // Phep AND
		LUI  = 4'b1111   // Lay phan dia chi cao
	} alu_op_e;
   
	// Dieu khien cac module dua vao tin hieu opcode
	always_comb begin
		pc_sel   = 1'b0;
		pc_en    = 1'b0;
		rd_wren  = 1'b0;
		insn_vld = 1'b0;
		br_un    = 1'b0;
		opa_sel  = 1'b0;
		opb_sel  = 1'b0;
		alu_op   = ADD;
		mem_wren = 1'b0;
		mask     = 4'b0000;
		mem_un    = 1'b0;
		wb_sel   = 2'b00;
		
		// Kiem tra opcode de xac dinh loai lenh
      case (opcode)
			// I_type (load): opcode = 3
			7'b0000011: begin
				pc_sel   = 1'b0;  // Chon PC+4
				rd_wren  = 1'b1;  // Cho phep ghi vao thanh ghi dich
				br_un    = 1'b0;  // Khong dung cho lenh load
				opa_sel  = 1'b0;  // Chon rs1
				opb_sel  = 1'b1;  // Chon imm
				alu_op   = ADD;   // ALU thuc hien phep cong
				mem_wren = 1'b0;  // Khong ghi vao bo nho			
				wb_sel   = 2'b01; // Chon ld_data vao thanh ghi dich
				
				// Kiem tra gia tri funct3
				case (funct3)
					// Lenh lb
					3'b000: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b0001;
						mem_un   = 1'b0;
					end
					
					// Lenh lh
					3'b001: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b0011;
						mem_un   = 1'b0;
					end
					
					// Lenh lw
					3'b010: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b1111;
						mem_un   = 1'b0;
					end
					
					// Lenh lbu
					3'b100: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b0001;
						mem_un   = 1'b1;
					end
					
					//Lenh lhu
					3'b101: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b0011;
						mem_un   = 1'b1;
					end
					
					// Lenh khong hop le
					default: begin
						pc_en    = 1'b0;
						insn_vld = 1'b0; // Danh dau lenh khong hop le
					end
				endcase
			end

			// I_type (logic immediate): opcode = 19
			7'b0010011: begin
				pc_sel   = 1'b0;   // Chon PC + 4
				rd_wren  = 1'b1;   // Cho phep ghi vao thanh ghi dich
				br_un    = 1'b0;   // Khong can dung br_un
				opa_sel  = 1'b0;   // Chon rs1
				opb_sel  = 1'b1;   // Chon imm
				mem_wren = 1'b0;   // Khong ghi vao bo nho
				mask     = 4'b0000; // Khong can dung mask
				mem_un   = 1'b0;   // Khong can dung mem_un
				wb_sel   = 2'b00;  // Chon alu_data
				case (funct3)
					// Lenh addi
					3'b000: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						alu_op   = ADD;
					end
					  
					// Lenh slli
					3'b001: begin
						// Kiem tra funct7 hop le
						case (funct7)
							// Lenh hop le
							7'b0000000: begin
								pc_en    = 1'b1;
								insn_vld = 1'b1;
								alu_op   = SLL; 
							end
							
							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0; 
							end
						endcase
					end
					  
					// Lenh slti
					3'b010: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						alu_op   = SLT; 
					end
					  
					// Lenh sltiu
					3'b011: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						alu_op   = SLTU;
					end
					  
					// Lenh xori
					3'b100: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						alu_op   = XOR; 
					end
					  
					// Lenh srli, srai
					3'b101: begin
						// Kiem tra funct7 hop le
						case (funct7)
							// Lenh srli
							7'b0000000: begin 
								pc_en    = 1'b1;
								insn_vld = 1'b1;
								alu_op   = SRL;
							end
								 
							// Lenh srai
							7'b0100000: begin
								pc_en    = 1'b1;
								insn_vld = 1'b1;
								alu_op   = SRA;  

							end
								 
							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0; 
							end
						endcase
					end
					  
					// Lenh ori
					3'b110: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						alu_op   = OR;
					end
					  
					// Lenh andi
					3'b111: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						alu_op   = AND;
					end
				endcase
			end
						
			// U_type (add upper immediate to PC): opcode = 23
			// Lenh auipc
			7'b0010111: begin
				pc_sel   = 1'b0;   // Chon PC + 4
				pc_en    = 1'b1;
				rd_wren  = 1'b1;   // Cho phep ghi vao thanh ghi dich
				insn_vld = 1'b1;	// Lenh hop le
				br_un    = 1'b0;	// Khong can dung br_un
				opa_sel  = 1'b1;	// Chon PC
				opb_sel  = 1'b1;	// Chon imm
				alu_op   = ADD;		// Alu thuc hien phep cong
				mem_wren = 1'b0;	// Khong ghi vao bo nho
				mask     = 4'b0000; // Khong can dung mask
				mem_un   = 1'b0;   // Khong can dung mem_un
				wb_sel   = 2'b00;	// Chon alu_data vao thanh ghi dich
			end
			
			//S_type (store): opcode = 35
			7'b0100011: begin
				pc_sel   = 1'b0;  // Chon PC+4
				pc_en    = 1'b1;
				rd_wren  = 1'b0;  // Khong cho phep ghi vao thanh ghi dich
				br_un    = 1'b0;  // Khong dung cho lenh load
				opa_sel  = 1'b0;  // Chon rs1
				opb_sel  = 1'b1;  // Chon imm
				alu_op   = ADD;   // ALU thuc hien phep cong
				mem_wren = 1'b1;  // Ghi vao bo nho
				mem_un   = 1'b0;  // Khong can mem_un
				wb_sel   = 2'b00; // Khong can wb_data
				
				// Kiem tra gia tri funct3
				case (funct3)
					// Lenh sb
					3'b000: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b0001;
					end
					
					// Lenh sh
					3'b001: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b0011;
					end
					
					// Lenh sw
					3'b010: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						mask     = 4'b1111;
					end
					
					// Lenh khong hop le
					default: begin
						pc_en    = 1'b0;
						insn_vld = 1'b0; // Danh dau lenh khong hop le
					end
				endcase
			end
			
			//R_type (logic register): opcode = 51
			7'b0110011: begin
				pc_sel   = 1'b0;   // Chon PC + 4
				pc_en    = 1'b1;
				rd_wren  = 1'b1;   // Cho phep ghi vao thanh ghi dich
				br_un    = 1'b0;   // Khong can dung br_un
				opa_sel  = 1'b0;   // Chon rs1
				opb_sel  = 1'b0;   // Chon rs2
				mem_wren = 1'b0;   // Khong ghi vao bo nho
				mask     = 4'b0000; // Khong can dung mask
				mem_un   = 1'b0;   // Khong can dung mem_un
				wb_sel   = 2'b00;  // Chon alu_data
				case (funct3)
					//Lenh add, sub
					3'b000: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh add
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op   = ADD;
								insn_vld = 1;
							end
							
							// Lenh sub
							7'b0100000: begin 
								pc_en    = 1'b1;
								alu_op   = SUB;
								insn_vld = 1;
							end
							
							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0;
							end
						endcase
					end
					
					// Lenh sll
					3'b001: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op = SLL;
								insn_vld = 1'b1;
							end

							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0;
							end
						endcase
					end
					
					// Lenh slt
					3'b010: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op = SLT;
								insn_vld = 1'b1;
							end

							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0; 
							end
						endcase
					end
					
					// Lenh sltu
					3'b011: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op   = SLTU;
								insn_vld = 1'b1;
							end

							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0;
							end
						endcase
					end
					
					// Lenh xor
					3'b100: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin 
								pc_en    = 1'b1;
								alu_op   = XOR;
								insn_vld = 1'b1;
							end

							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0;  
							end
						endcase
					end
					
					// Lenh srl, sra
					3'b101: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh srl
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op   = SRL;
								insn_vld = 1'b1;
							end
							
							// Lenh srai
							7'b0100000: begin
								pc_en    = 1'b1;
								alu_op   = SRA;
								insn_vld = 1'b1;
							end
							
							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0; 
							end
						endcase
					end
					
					// Lenh or
					3'b110: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op   = OR;
								insn_vld = 1'b1;
							end

							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0;
							end
						endcase;
					end
					
					// Lenh and
					3'b111: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin
								pc_en    = 1'b1;
								alu_op   = AND;
								insn_vld = 1'b1;
							end

							// Lenh khong hop le
							default: begin
								pc_en    = 1'b0;
								insn_vld = 1'b0;
							end
						endcase;
					end
				endcase
			end
			
			// U_type (load upper immediate): opcode = 55
			7'b0110111: begin
				pc_sel   = 1'b0;   // Chon PC + 4
				pc_en    = 1'b1;
				rd_wren  = 1'b1;   // Cho phep ghi vao thanh ghi dich
				insn_vld = 1'b1;	// Lenh hop le
				br_un    = 1'b0;	// Khong can dung br_un
				opa_sel  = 1'b0;	// Khong chon rs1
				opb_sel  = 1'b0;	// Khong chon rs2
				alu_op   = ADD;		// Alu thuc hien phep lui
				mem_wren = 1'b0;	// Khong ghi vao bo nho
				mask     = 4'b0000; // Khong can dung mask
				mem_un   = 1'b0;   // Khong can dung mem_un
				wb_sel   = 2'b10;	// Chon imm vao thanh ghi dich
			end

			//B_type (branch): opcode = 99
			7'b1100011: begin
				rd_wren  = 1'b0;	// Khong cho ghi vao thanh ghi dich
				opa_sel  = 1'b1;	// Chon PC
				opb_sel  = 1'b1;	// Chon imm
				alu_op = ADD;
				mem_wren = 1'b0;	// Khong ghi vao bo nho
				mask     = 4'b0000; // Khong can dung mask
				mem_un   = 1'b0;   // Khong can dung mem_un
				wb_sel	  = 2'b00;	// Khong can wb_data
				case (funct3)
					// Lenh beq
					3'b000: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						br_un 	= 1'b0;
						if (i_br_equal) begin
							pc_sel   = 1'b1;
						end else begin
							pc_sel   = 1'b0;
						end
					end
					
					// Lenh bne
					3'b001: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						br_un 	= 1'b0;
						if (i_br_equal) begin
							pc_sel   = 1'b0;
						end else begin
							pc_sel   = 1'b1;
						end
					end
						
					// Lenh blt
					3'b010: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						br_un 	= 1'b0;
						if (i_br_less) begin
							pc_sel   = 1'b1;
						end else begin
							pc_sel   = 1'b0;
						end
					end
						
					// Lenh bge
					3'b011: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						br_un 	= 1'b0;
						if (i_br_less) begin
							pc_sel   = 1'b0;
						end else begin
							pc_sel   = 1'b1;
						end
					end
					
					// Lenh bltu
					3'b100 : begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						br_un 	= 1'b1;
						if (i_br_less) begin
							pc_sel   = 1'b1;
						end else begin
							pc_sel   = 1'b0;
						end
					end
						
					// Lenh bgeu
					3'b101: begin
						pc_en    = 1'b1;
						insn_vld = 1'b1;
						br_un 	= 1'b1;
						if (i_br_less) begin
							pc_sel   = 1'b0;
						end else begin
							pc_sel   = 1'b1;
						end
					end
						
					// Lenh khong hop le
					default: begin
						pc_en    = 1'b0;
						insn_vld = 1'b0;
					end
				endcase
			end
			
			// I_type (JALR - jump and link register): opcode = 103
			// Lenh jalr
			7'b1100111: begin
				case (funct3)
					// Lenh jalr
					3'b000: begin
						pc_sel   = 1'b1;   // Chon alu_data
						pc_en    = 1'b1;
						rd_wren  = 1'b1;   // Cho phep ghi vao thanh ghi dich
						insn_vld = 1'b1;	// Lenh hop le
						br_un    = 1'b0;	// Khong can dung br_un
						opa_sel  = 1'b0;	// Chon rs1
						opb_sel  = 1'b1;	// Chon imm
						alu_op   = ADD;		// Alu thuc hien phep cong
						mem_wren = 1'b0;	// Khong ghi vao bo nho
						mask     = 4'b0000; // Khong can dung mask
						mem_un   = 1'b0;   // Khong can dung mem_un
						wb_sel   = 2'b11;	// Chon PC + 4 vao thanh ghi dich
					end
					
					// Lenh khong hop le
					default: begin
						pc_en    = 1'b0;
						insn_vld = 1'b0;	// Lenh khong hop le
					end
				endcase
			end

			// J_type (JAL - jump and link): opcode = 111
			// Lenh jal
			7'b1101111: begin
				pc_sel   = 1'b1;   // Chon alu_data
				pc_en    = 1'b1;
				rd_wren  = 1'b1;   // Cho phep ghi vao thanh ghi dich
				insn_vld = 1'b1;	// Lenh hop le
				br_un    = 1'b0;	// Khong can dung br_un
				opa_sel  = 1'b1;	// Chon PC
				opb_sel  = 1'b1;	// Chon imm
				alu_op   = ADD;		// Alu thuc hien phep cong
				mem_wren = 1'b0;	// Khong ghi vao bo nho
				mask     = 4'b0000; // Khong can dung mask
				mem_un   = 1'b0;   // Khong can dung mem_un
				wb_sel   = 2'b11;	// Chon PC + 4 vao thanh ghi dich
			end
			
			// Lenh khong hop le
			default: begin
				pc_en    = 1'b0;
				insn_vld = 1'b0;
			end
		endcase
	end
endmodule: ctrlu
