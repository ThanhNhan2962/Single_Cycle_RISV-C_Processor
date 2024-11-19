module tb_alu;
  // Khai báo các biến cho testbench
  logic [3:0] i_alu_op;
  logic [31:0] i_operand_a;
  logic [31:0] i_operand_b;
  logic [31:0] o_alu_data;

  alu uut (
    .i_alu_op(i_alu_op),
    .i_operand_a(i_operand_a),
    .i_operand_b(i_operand_b),
    .o_alu_data(o_alu_data)
  );

  // Biến kiểm tra thành công
  bit test_pass = 1;

  // Task để so sánh kết quả và cập nhật trạng thái test_pass
  task check_result(input [31:0] expected, input string operation);
    if (o_alu_data !== expected) begin
      $display("TEST FAILED: %s | Expected: %h, Got: %h", operation, expected, o_alu_data);
      test_pass = 0;
    end
    else begin
      $display("TEST PASSED: %s | Expected: %h, Got: %h", operation, expected, o_alu_data);
    end
  endtask

  initial begin
    // Test phép toán ADD
    i_alu_op = 4'b0000;  // ADD
    i_operand_a = 32'h00000010;
    i_operand_b = 32'h00000020;
    $display("Test ADD: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;  
    check_result(32'h00000030, "ADD");

    // Test phép toán SUB
    i_alu_op = 4'b1000;  // SUB
    i_operand_a = 32'h00000030;
    i_operand_b = 32'h00000010;
    $display("Test SUB: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h00000020, "SUB");

    // Test phép toán SLL
    i_alu_op = 4'b0001;  // SLL
    i_operand_a = 32'h00000001;
    i_operand_b = 32'h00000002;  // Lấy 5 bit thấp từ i_operand_b
    $display("Test SLL: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h00000004, "SLL");

    // Test phép toán SLT
    i_alu_op = 4'b0010;  // SLT
    i_operand_a = 32'h00000001;
    i_operand_b = 32'h00000002;
    $display("Test SLT: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h00000001, "SLT");

    // Test phép toán SLTU
    i_alu_op = 4'b0011;  // SLTU
    i_operand_a = 32'hFFFFFFFF;
    i_operand_b = 32'h00000001;
    $display("Test SLTU: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h00000000, "SLTU");

    // Test phép toán XOR
    i_alu_op = 4'b0100;  // XOR
    i_operand_a = 32'h0000000F;
    i_operand_b = 32'h000000F0;
    $display("Test XOR: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h000000FF, "XOR");

    // Test phép toán SRL
    i_alu_op = 4'b0101;  // SRL
    i_operand_a = 32'h00000010;
    i_operand_b = 32'h00000002;  // Lấy 5 bit thấp từ i_operand_b
    $display("Test SRL: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h00000004, "SRL");

    // Test phép toán SRA
    i_alu_op = 4'b1101;  // SRA
    i_operand_a = 32'h80000000;
    i_operand_b = 32'h00000002;  // Lấy 5 bit thấp từ i_operand_b
    $display("Test SRA: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'hE0000000, "SRA");

    // Test phép toán OR
    i_alu_op = 4'b0110;  // OR
    i_operand_a = 32'h0000000F;
    i_operand_b = 32'h000000F0;
    $display("Test OR: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h000000FF, "OR");

    // Test phép toán AND
    i_alu_op = 4'b0111;  // AND
    i_operand_a = 32'h000000FF;
    i_operand_b = 32'h000000F0;
    $display("Test AND: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h000000F0, "AND");

    // Test phép toán LUI
    i_alu_op = 4'b1111;  // LUI
    i_operand_a = 32'h00000000;  // Không ảnh hưởng tới kết quả
    i_operand_b = 32'h12345678;
    $display("Test LUI: i_operand_a = %h, i_operand_b = %h, i_alu_op = %b", i_operand_a, i_operand_b, i_alu_op);
    #10;
    check_result(32'h12345678, "LUI");

    // Kiểm tra kết quả cuối cùng
    if (test_pass) begin
      $display("TEST PASS");
    end else begin
      $display("SOME TESTS FAILED");
    end

    $finish;
  end
endmodule
