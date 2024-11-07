module instr_mem (
	input logic i_clk,         // tin hieu dong bo
   input logic [31:0] i_pc,   // dia chi bo nho chuong trinh
   output logic [31:0] o_instr // du lieu bo nho chuong trinh
);

   reg [3:0][7:0] instr_data [2**(11)-1:0]; 

   // Nap du lieu tu file "mem.txt" vao mang instr_data
	initial $readmemh("C:/altera/13.0sp1/milestone2/02_test/dump/mem.txt", instr_data);

   // Doc lenh tu bo nho theo dia chi PC
   always_ff @(posedge i_clk) begin
		o_instr <= instr_data[i_pc[12:2]][3:0]; // Lay du lieu tu bo nho dua tren dia chi PC
   end
endmodule : instr_mem
