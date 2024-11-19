module tb_lsu;

   // Khai báo các tín hi?u ??u vào và ??u ra
   logic        i_clk;
   logic        i_rst;
   logic        i_lsu_un;
   logic [31:0] i_lsu_addr;
   logic [3:0]  i_mask;
   logic        i_lsu_wren;
   logic        i_lsu_rden;
   logic [31:0] i_st_data;
   logic [31:0] o_ld_data;

   logic [31:0] i_io_sw;
   logic [31:0] i_io_btn;

   logic [31:0] o_io_ledr;
   logic [31:0] o_io_ledg;
   logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3;
   logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
   logic [31:0] o_io_lcd;

   // Kh?i t?o module `lsu`
   lsu uut (
      .i_clk(i_clk),
      .i_rst(i_rst),
      .i_lsu_un(i_lsu_un),
      .i_lsu_addr(i_lsu_addr),
      .i_mask(i_mask),
      .i_lsu_wren(i_lsu_wren),
      .i_lsu_rden(i_lsu_rden),
      .i_st_data(i_st_data),
      .o_ld_data(o_ld_data),
      .i_io_sw(i_io_sw),
      .i_io_btn(i_io_btn),
      .o_io_ledr(o_io_ledr),
      .o_io_ledg(o_io_ledg),
      .o_io_hex0(o_io_hex0),
      .o_io_hex1(o_io_hex1),
      .o_io_hex2(o_io_hex2),
      .o_io_hex3(o_io_hex3),
      .o_io_hex4(o_io_hex4),
      .o_io_hex5(o_io_hex5),
      .o_io_hex6(o_io_hex6),
      .o_io_hex7(o_io_hex7),
      .o_io_lcd(o_io_lcd)
   );

   // T?o tín hi?u ??ng h? (clock)
   always #5 i_clk = ~i_clk;

   // Reset h? th?ng
   task reset_system();
      begin
         i_rst = 0;
         i_lsu_un = 0;
         i_lsu_wren = 0;
         i_lsu_rden = 0;
         i_lsu_addr = 32'h0000;
         i_st_data = 32'h00000000;
         i_mask = 4'b1111;
         #20;
         i_rst = 1;
         #10;
      end
   endtask

   // Ghi d? li?u vào b? nh?
   task write_data(input [31:0] addr, input [31:0] data);
      begin
         @(negedge i_clk);
         i_lsu_wren = 1;
         i_lsu_addr = addr;
         i_st_data = data;
         @(negedge i_clk);
         i_lsu_wren = 0;
      end
   endtask

   // ??c d? li?u t? b? nh?
   task read_data(input [31:0] addr);
      begin
         @(negedge i_clk);
         i_lsu_rden = 1;
         i_lsu_addr = addr;
         @(negedge i_clk);
         i_lsu_rden = 0;
      end
   endtask

   initial begin
      i_clk = 0;

      // Reset h? th?ng
      reset_system();

      // --- Testcase 1-2: Ki?m tra ip_mem (sw, btn) ---
      $display("=== Testcase 1: Ki?m tra ip_mem (sw) ===");
      i_io_sw = 32'hA5A5A5A5;
      read_data(32'h7800);
      #5;
      if (o_ld_data == 32'hA5A5A5A5)
         $display("PASS");
      else
         $display("FAILED");

      $display("=== Testcase 2: Ki?m tra ip_mem (btn) ===");
      i_io_btn = 32'h5A5A5A5A;
      read_data(32'h7810);
      #5;
      if (o_ld_data == 32'h5A5A5A5A)
         $display("PASS");
      else
         $display("FAILED");

      // --- Testcase 3-7: Ki?m tra op_mem (ledr, ledg, hex, lcd) ---
      $display("=== Testcase 3: Ki?m tra op_mem (ledr) ===");
      write_data(32'h7000, 32'hFFFFFFFF);
      if (o_io_ledr == 32'hFFFFFFFF)
         $display("PASS");
      else
         $display("FAILED");

      $display("=== Testcase 4: Ki?m tra op_mem (ledg) ===");
      write_data(32'h7010, 32'h0F0F0F0F);
      if (o_io_ledg == 32'h0F0F0F0F)
         $display("PASS");
      else
         $display("FAILED");

      $display("=== Testcase 5: Ki?m tra op_mem (hex3...0) ===");
      write_data(32'h7020, 32'h4F5B063F);
      #5;
      $display("Hex0: %h, Hex1: %h, Hex2: %h, Hex3: %h", o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3);

      $display("=== Testcase 6: Ki?m tra op_mem (hex7...4) ===");
      write_data(32'h7024, 32'h077D6D66);
      #5;
      $display("Hex4: %h, Hex5: %h, Hex6: %h, Hex7: %h", o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7);

      $display("=== Testcase 7: Ki?m tra op_mem (lcd) ===");
      write_data(32'h7030, 32'hDEADBEEF);
      if (o_io_lcd == 32'hDEADBEEF)
         $display("PASS");
      else
         $display("FAILED");

      // --- Testcase 8-10: Ki?m tra data_mem ---
      $display("=== Testcase 8: Ki?m tra data_mem (0x2000) ===");
      write_data(32'h2000, 32'hA1A1A1A1);
      read_data(32'h2000);
      if (o_ld_data == 32'hA1A1A1A1)
         $display("PASS");
      else
         $display("FAILED");

      $display("=== Testcase 9: Ki?m tra data_mem (0x2004) ===");
      write_data(32'h2004, 32'hB2B2B2B2);
      read_data(32'h2004);
      if (o_ld_data == 32'hB2B2B2B2)
         $display("PASS");
      else
         $display("FAILED");

      $display("=== Testcase 10: Ki?m tra data_mem (0x2008) ===");
      write_data(32'h2008, 32'hC3C3C3C3);
      read_data(32'h2008);
      if (o_ld_data == 32'hC3C3C3C3)
         $display("PASS");
      else
         $display("FAILED");

      $stop;
   end

endmodule

