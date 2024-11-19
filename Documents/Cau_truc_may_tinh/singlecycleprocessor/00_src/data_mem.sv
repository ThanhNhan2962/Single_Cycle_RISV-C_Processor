module data_mem (
   input  logic        i_clk,          // tín hiệu đồng hồ
   input  logic        i_rst,          // tín hiệu reset
   input  logic        i_lsu_wren,     // tín hiệu ghi vào bộ nhớ
   input  logic [15:0] i_data_addr,     // địa chỉ bộ nhớ (16-bit, 0x2000 đến 0x3FFF)
   input  logic [31:0] i_data,         // dữ liệu đầu vào
   output logic [31:0] o_data          // dữ liệu đầu ra
);

   // Bộ nhớ 8-bit với địa chỉ từ 0x2000 đến 0x3FFF (2048 từ)
   logic [3:0][7:0] memory [0:2**11-1];
	logic [15:0] data_addr;
	
	assign data_addr = i_data_addr;
	
   // Ghi dữ liệu vào bộ nhớ
   always_ff @(posedge i_clk) begin
      if (!i_rst) begin
         // Reset toàn bộ bộ nhớ và đầu ra
         for (int i = 0; i < 2048; i++) begin
            memory[i] <= 32'b0;
         end
      end 
      // Ghi dữ liệu vào bộ nhớ nếu địa chỉ hợp lệ và tín hiệu ghi được bật
      else if (data_addr[15:13] == 3'b001 && i_lsu_wren) begin
         // Chia 32-bit dữ liệu thành 4 phần 8-bit
         memory[i_data_addr[11:2]][0] <= i_data[7:0];
         memory[i_data_addr[11:2]][1] <= i_data[15:8];
         memory[i_data_addr[11:2]][2] <= i_data[23:16];
         memory[i_data_addr[11:2]][3] <= i_data[31:24];
      end
   end

   // Đọc dữ liệu từ bộ nhớ tự động dựa trên địa chỉ
   always_comb begin
      if (data_addr[15:13] == 3'b001) begin
         o_data = {memory[i_data_addr[11:2]][3],
                   memory[i_data_addr[11:2]][2],
                   memory[i_data_addr[11:2]][1],
                   memory[i_data_addr[11:2]][0]};
      end else begin
         o_data = 32'b0; // Địa chỉ ngoài phạm vi sẽ trả về 0
      end
   end
	
endmodule: data_mem
