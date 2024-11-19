module tb_pc_four;

    // Khai báo các tín hiệu
    logic [31:0] i_pc;            // Đầu vào PC
    logic [31:0] o_pc_four;       // Đầu ra PC + 4
    
pc_four uut (
        .i_pc(i_pc),
        .o_pc_four(o_pc_four)
    );

    // Khai báo biến kiểm tra
    bit test_pass = 1;

    // Task để so sánh kết quả và cập nhật trạng thái test_pass
    task check_result(input [31:0] expected, input string operation);
        // Hiển thị giá trị đầu vào và kết quả
        $display("%s | i_pc: %h, o_pc_four: %h, Expected: %h", operation, i_pc, o_pc_four, expected);
        if (o_pc_four !== expected) begin
            $display("TEST FAILED: %s | Expected: %h, Got: %h", operation, expected, o_pc_four);
            test_pass = 0;
        end
    endtask

    // Khai báo các giá trị đầu vào cho các test
    initial begin
        // Test 1: Kiểm tra với giá trị i_pc là số dương
        i_pc = 32'h00000010; // 16 trong hệ thập phân
        #10;
        check_result(32'h00000014, "Test 1");

        // Test 2: Kiểm tra với giá trị i_pc là số âm
        i_pc = 32'hFFFFFFF0; // -16 trong hệ thập phân
        #10;
        check_result(32'hFFFFFFF4, "Test 2");

        // Test 3: Kiểm tra khi i_pc có giá trị 0
        i_pc = 32'h00000000;
        #10;
        check_result(32'h00000004, "Test 3");

        // Test 4: Kiểm tra với giá trị lớn cho i_pc
        i_pc = 32'h7FFFFFFF; 
        #10;
        check_result(32'h80000003, "Test4");

        // Test 5: Kiểm tra với giá trị i_pc là 0xFFFFFFFF
        i_pc = 32'hFFFFFFFF; // 4,294,967,295 trong hệ thập phân
        #10;
        check_result(32'h00000003, "Test 5");

        // Kiểm tra kết quả cuối cùng
        if (test_pass) begin
            $display("TEST PASS");
        end else begin
            $display("SOME TESTS FAILED");
        end

        // Kết thúc mô phỏng
        $finish;
    end

endmodule
