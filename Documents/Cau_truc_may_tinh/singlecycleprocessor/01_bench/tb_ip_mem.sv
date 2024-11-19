`timescale 1ns/1ps

module tb_ip_mem;

   // T?o các tín hi?u ?? k?t n?i v?i module ip_mem
   logic        tb_clk;
   logic        tb_rst;
   logic [31:0] tb_io_sw;
   logic [31:0] tb_io_btn;
   logic [15:0] tb_ip_addr;
   logic [31:0] tb_ip_data;

   // Kh?i t?o module ip_mem
   ip_mem dut (
      .i_clk(tb_clk),
      .i_rst(tb_rst),
      .i_io_sw(tb_io_sw),
      .i_io_btn(tb_io_btn),
      .i_ip_addr(tb_ip_addr),
      .o_ip_data(tb_ip_data)
   );

   // T?o tín hi?u ??ng h? v?i chu k? 10ns (t?n s? 100MHz)
   always #5 tb_clk = ~tb_clk;

   // Kh?i t?o các tín hi?u và ki?m tra
   initial begin
      // Kh?i t?o tín hi?u ban ??u
      tb_clk = 0;
      tb_rst = 0;
      tb_io_sw = 32'h00000000;
      tb_io_btn = 32'h00000000;
      tb_ip_addr = 16'h0000;

      // Reset h? th?ng
      #10;
      tb_rst = 1;
      #10;
      tb_rst = 0;
      #10;
      tb_rst = 1;

      // Ghi d? li?u vào switch và ki?m tra ??c l?i t? ??a ch? 0x7800
      tb_io_sw = 32'hDEADBEEF;
      tb_ip_addr = 16'h7800;
      #20;
      if (tb_ip_data == 32'hDEADBEEF) 
         $display("Switch Data Load Test: PASS");
      else 
         $display("Switch Data Load Test: FAIL (Expected: DEADBEEF, Got: %h)", tb_ip_data);

      // Ghi d? li?u vào button và ki?m tra ??c l?i t? ??a ch? 0x7810
      tb_io_btn = 32'h12345678;
      tb_ip_addr = 16'h7810;
      #20;
      if (tb_ip_data == 32'h12345678) 
         $display("Button Data Load Test: PASS");
      else 
         $display("Button Data Load Test: FAIL (Expected: 12345678, Got: %h)", tb_ip_data);

      // Ki?m tra ??a ch? không h?p l?
      tb_ip_addr = 16'h7FFF;
      #20;
      if (tb_ip_data == 32'h00000000)
         $display("Invalid Address Test: PASS");
      else
         $display("Invalid Address Test: FAIL (Expected: 00000000, Got: %h)", tb_ip_data);

      // D?ng mô ph?ng
      #20;
      $stop;
   end
endmodule
