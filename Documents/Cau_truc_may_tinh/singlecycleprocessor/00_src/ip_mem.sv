module ip_mem (
   input  logic        i_clk,        // tín hiệu đồng hồ
   input  logic        i_rst,        // tín hiệu reset
   input  logic [31:0] i_io_sw,      // dữ liệu từ switch
   input  logic [31:0] i_io_btn,     // dữ liệu từ button
   input  logic [15:0] i_ip_addr,    // địa chỉ bộ nhớ
   output logic [31:0] o_ip_data     // dữ liệu đầu ra
);

   // bộ nhớ 8-bit cho địa chỉ từ 0x7800 đến 0x781F
   logic [3:0][7:0] memory [0:1]; // 8 ô nhớ, mỗi ô 4 byte
   logic [31:0] switch;
   logic [31:0] button;
   logic [15:0] ip_addr;
   logic [31:0] switch_prev;
   logic [31:0] button_prev;

   // Reset bộ nhớ khi có tín hiệu reset
   always_ff @(posedge i_clk) begin
      if (!i_rst) begin
         // reset toàn bộ bộ nhớ
         for (int i = 0; i < 2; i = i + 1) begin
            memory[i] <= 32'b0;
         end
         switch_prev <= 32'b0;
         button_prev <= 32'b0;
      end else begin
         // ghi dữ liệu vào vùng switch (0x7800)
         if (i_ip_addr == 16'h7800 && i_io_sw !== switch_prev) begin
            memory[0][0] <= i_io_sw[7:0];
            memory[0][1] <= i_io_sw[15:8];
            memory[0][2] <= i_io_sw[23:16];
            memory[0][3] <= i_io_sw[31:24];
            switch_prev <= i_io_sw;
         end
         
         // ghi dữ liệu vào vùng button (0x7810)
         if (i_ip_addr == 16'h7810 && i_io_btn !== button_prev) begin
            memory[1][0] <= i_io_btn[7:0];
            memory[1][1] <= i_io_btn[15:8];
            memory[1][2] <= i_io_btn[23:16];
            memory[1][3] <= i_io_btn[31:24];
            button_prev <= i_io_btn;
         end
      end
   end

   // đọc dữ liệu từ vùng switch và button
   always_comb begin
      if (i_ip_addr == 16'h7800) begin
         o_ip_data = {memory[0][3], memory[0][2], memory[0][1], memory[0][0]};
      end else if (i_ip_addr == 16'h7810) begin
         o_ip_data = {memory[1][3], memory[1][2], memory[1][1], memory[1][0]};
      end else begin
         o_ip_data = 32'b0;
      end
   end

endmodule: ip_mem
