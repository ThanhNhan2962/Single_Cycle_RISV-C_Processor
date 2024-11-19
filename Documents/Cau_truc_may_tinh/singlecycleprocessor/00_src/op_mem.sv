module op_mem (
   input  logic        i_clk,          // tín hiệu đồng hồ
   input  logic        i_rst,          // tín hiệu reset
   input  logic        i_lsu_wren,     // tín hiệu ghi vào bộ nhớ
   input  logic [15:0] i_op_addr,      // địa chỉ bộ nhớ
   input  logic [31:0] i_op_data,      // dữ liệu đầu vào
   output logic [31:0] o_op_data,      // dữ liệu đầu ra
   output logic [31:0] o_io_ledr,      // dữ liệu cho LED đỏ
   output logic [31:0] o_io_ledg,      // dữ liệu cho LED xanh
   output logic [6:0]  o_io_hex0,
   output logic [6:0]  o_io_hex1,
   output logic [6:0]  o_io_hex2,
   output logic [6:0]  o_io_hex3,
   output logic [6:0]  o_io_hex4,
   output logic [6:0]  o_io_hex5,
   output logic [6:0]  o_io_hex6,
   output logic [6:0]  o_io_hex7,
   output logic [31:0] o_io_lcd        // dữ liệu cho LCD
);

   // Bộ nhớ để lưu trữ dữ liệu cho các thiết bị
   logic [3:0][7:0] memory[0:4];  // Bộ nhớ 2 chiều [5][32-bit]
   
   // Đọc/ghi dữ liệu vào bộ nhớ
   always_ff @(posedge i_clk) begin
      if (!i_rst) begin
         // Reset toàn bộ bộ nhớ
         for (int i = 0; i < 5; i++) begin
            memory[i] <= 32'b0;
         end
      end 
      else if (i_lsu_wren) begin
         // Ghi dữ liệu dựa trên địa chỉ
         case (i_op_addr)
            16'h7000: begin
               memory[0][0] <= i_op_data[7:0];
               memory[0][1] <= i_op_data[15:8];
               memory[0][2] <= i_op_data[23:16];
               memory[0][3] <= i_op_data[31:24];
            end
            16'h7010: begin
               memory[1][0] <= i_op_data[7:0];
               memory[1][1] <= i_op_data[15:8];
               memory[1][2] <= i_op_data[23:16];
               memory[1][3] <= i_op_data[31:24];
            end
            16'h7020: begin
               memory[2][0] <= i_op_data[7:0];
               memory[2][1] <= i_op_data[15:8];
               memory[2][2] <= i_op_data[23:16];
               memory[2][3] <= i_op_data[31:24];
            end
            16'h7024: begin
               memory[3][0] <= i_op_data[7:0];
               memory[3][1] <= i_op_data[15:8];
               memory[3][2] <= i_op_data[23:16];
               memory[3][3] <= i_op_data[31:24];
            end
            16'h7030: begin
               memory[4][0] <= i_op_data[7:0];
               memory[4][1] <= i_op_data[15:8];
               memory[4][2] <= i_op_data[23:16];
               memory[4][3] <= i_op_data[31:24];
            end
         endcase
      end
   end

   // Đọc dữ liệu ra dựa trên địa chỉ
   always_comb begin
      // Mặc định đầu ra là 0
      o_op_data = 32'b0;
      o_io_ledr = 32'b0;
      o_io_ledg = 32'b0;
      o_io_hex0 = 7'b0;
      o_io_hex1 = 7'b0;
      o_io_hex2 = 7'b0;
      o_io_hex3 = 7'b0;
      o_io_hex4 = 7'b0;
      o_io_hex5 = 7'b0;
      o_io_hex6 = 7'b0;
      o_io_hex7 = 7'b0;
      o_io_lcd = 32'b0;

      case (i_op_addr)
         16'h7000: begin
            o_op_data = {memory[0][3], memory[0][2], memory[0][1], memory[0][0]};
            o_io_ledr = o_op_data;
         end
         16'h7010: begin
            o_op_data = {memory[1][3], memory[1][2], memory[1][1], memory[1][0]};
            o_io_ledg = o_op_data;
         end
         16'h7020: begin
            o_op_data = {memory[2][3], memory[2][2], memory[2][1], memory[2][0]};
            o_io_hex0 = memory[2][0][6:0];
            o_io_hex1 = memory[2][1][6:0];
            o_io_hex2 = memory[2][2][6:0];
            o_io_hex3 = memory[2][3][6:0];
         end
         16'h7024: begin
            o_op_data = {memory[3][3], memory[3][2], memory[3][1], memory[3][0]};
            o_io_hex4 = memory[3][0][6:0];
            o_io_hex5 = memory[3][1][6:0];
            o_io_hex6 = memory[3][2][6:0];
            o_io_hex7 = memory[3][3][6:0];
         end
         16'h7030: begin
            o_op_data = {memory[4][3], memory[4][2], memory[4][1], memory[4][0]};
            o_io_lcd = o_op_data;
         end
			default: begin
				o_op_data = 32'b0;
			end
      endcase
   end

endmodule: op_mem
