module insn_vld_reg_tb;
  // Khai báo tín hiệu
  reg i_clk;
  reg i_rst;
  reg i_insn_vld;
  wire o_insn_vld;

  // Khai báo module insn_vld_reg
  insn_vld_reg uut (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_insn_vld(i_insn_vld),
    .o_insn_vld(o_insn_vld)
  );

  // Tạo xung clock
  always #5 i_clk = ~i_clk; // Tạo xung clock với chu kỳ 10 đơn vị thời gian

  // Khối khởi tạo cho các kiểm thử
  initial begin
    // Khởi tạo các tín hiệu
    i_clk = 0;
    i_rst = 0;
    i_insn_vld = 0;
    #10; // Chờ một khoảng thời gian để ổn định

    // Kiểm tra trường hợp Reset
    i_rst = 0;
    i_insn_vld = 1;
    #10;
    $display("i_clk = %b, i_rst = %b, i_insn_vld = %b, o_insn_vld = %b", i_clk, i_rst, i_insn_vld, o_insn_vld);
    if (o_insn_vld !== 1'b0)
      $display("TEST FAILED");
    else
      $display("TEST PASSED");

    // Kiểm tra khi Reset được bật và i_insn_vld = 1
    i_rst = 1;
    i_insn_vld = 1;
    #10;
    $display("i_clk = %b, i_rst = %b, i_insn_vld = %b, o_insn_vld = %b", i_clk, i_rst, i_insn_vld, o_insn_vld);
    if (o_insn_vld !== 1'b1)
      $display("TEST FAILED");
    else
      $display("TEST PASSED");

    // Kiểm tra khi Reset được bật và i_insn_vld = 0
    i_insn_vld = 0;
    #10;
    $display("i_clk = %b, i_rst = %b, i_insn_vld = %b, o_insn_vld = %b", i_clk, i_rst, i_insn_vld, o_insn_vld);
    if (o_insn_vld !== 1'b0)
      $display("TEST FAILED");
    else
      $display("TEST PASSED");

    $finish; // Kết thúc mô phỏng
  end

endmodule
