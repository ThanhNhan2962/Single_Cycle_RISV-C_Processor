module tb_data_mem;

   // Tín hi?u ??u vào và ??u ra c?a module `data_mem`
   logic        i_clk;
   logic        i_rst;
   logic        i_lsu_wren;
   logic [15:0] i_data_addr;
   logic [31:0] i_data;
   logic [31:0] o_data;

   // Kh?i t?o module `data_mem`
   data_mem uut (
      .i_clk(i_clk),
      .i_rst(i_rst),
      .i_lsu_wren(i_lsu_wren),
      .i_data_addr(i_data_addr),
      .i_data(i_data),
      .o_data(o_data)
   );

   // T?o tín hi?u ??ng h? (clock)
   always #5 i_clk = ~i_clk; // T?n s? 100MHz (chu k? 10ns)

   // Nhi?m v? ?? reset h? th?ng
   task reset_system();
      begin
         i_rst = 0;
         i_lsu_wren = 0;
         i_data_addr = 16'h0000;
         i_data = 32'h00000000;
         #20;
         i_rst = 1;
         #10;
      end
   endtask

   // Nhi?m v? ?? ghi d? li?u vào b? nh?
   task write_data(input [15:0] addr, input [31:0] data);
      begin
         @(negedge i_clk);
         i_lsu_wren = 1;
         i_data_addr = addr;
         i_data = data;
         @(negedge i_clk);
         i_lsu_wren = 0;
         i_data_addr = 16'h0000;
         i_data = 32'h00000000;
      end
   endtask

   // Nhi?m v? ?? ??c d? li?u t? b? nh?
   task read_data(input [15:0] addr);
      begin
         @(negedge i_clk);
         i_data_addr = addr;
         @(negedge i_clk);
      end
   endtask

   // Kh?i ban ??u ?? mô ph?ng
   initial begin
      // Kh?i t?o tín hi?u
      i_clk = 0;
      i_rst = 0;
      i_lsu_wren = 0;
      i_data_addr = 16'h0000;
      i_data = 32'h00000000;

      // Reset h? th?ng
      reset_system();

      // Ghi d? li?u vào các ??a ch? b? nh? và ??c l?i ?? ki?m tra
      $display("=== B?t ??u ghi d? li?u vào b? nh? ===");
      
      // Ki?m tra ghi và ??c t?i ??a ch? 0x2000
      write_data(16'h2000, 32'hDEADBEEF);
      read_data(16'h2000);
      #5;
      if (o_data == 32'hDEADBEEF) 
         $display("??a ch? 0x2000: Store/Load PASS");
      else 
         $display("??a ch? 0x2000: Store/Load FAILED");

      // Ki?m tra ghi và ??c t?i ??a ch? 0x2004
      write_data(16'h2004, 32'h12345678);
      read_data(16'h2004);
      #5;
      if (o_data == 32'h12345678) 
         $display("??a ch? 0x2004: Store/Load PASS");
      else 
         $display("??a ch? 0x2004: Store/Load FAILED");

      // Ki?m tra ghi và ??c t?i ??a ch? 0x2008
      write_data(16'h2008, 32'hCAFEBABE);
      read_data(16'h2008);
      #5;
      if (o_data == 32'hCAFEBABE) 
         $display("??a ch? 0x2008: Store/Load PASS");
      else 
         $display("??a ch? 0x2008: Store/Load FAILED");

      $display("=== Ki?m tra hoàn t?t ===");
      $stop;
   end

endmodule
