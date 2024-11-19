module tb_pc_reg;
    
    // Khai báo các tín hiệu
    logic        i_clk;         // Tín hiệu clock
    logic        i_rst;         // Tín hiệu reset, kích hoạt mức thấp
    logic        i_pc_wren;     // Tín hiệu cho phép ghi
    logic [31:0] i_pc_next;     // Giá trị con trỏ PC kế tiếp
    logic [31:0] o_pc;          // Giá trị con trỏ PC hiện tại

    // Instance của pc_reg
    pc_reg uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_pc_wren(i_pc_wren),
        .i_pc_next(i_pc_next),
        .o_pc(o_pc)
    );

    // Biến kiểm tra
    bit test_pass = 1;

    // Task để kiểm tra kết quả
    task check_result(input [31:0] expected, input string operation);
        $display("%s | i_rst: %b, i_pc_wren: %b, i_pc_next: %h, o_pc: %h, Expected: %h", 
                 operation, i_rst, i_pc_wren, i_pc_next, o_pc, expected);
        if (o_pc !== expected) begin
            $display("TEST FAILED: %s | Expected: %h, Got: %h", operation, expected, o_pc);
            test_pass = 0;
        end
    endtask

    // Tạo xung clock
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // Tạo xung clock 10ns
    end

    // Khai báo các giá trị đầu vào cho các test
    initial begin
        // Test 1: Kiểm tra reset
        i_rst = 0;
        i_pc_wren = 0;
        i_pc_next = 32'h12345678;
        #10; // Đợi một chu kỳ clock
        check_result(32'd0, "Test 1: Reset");

        // Test 2: Cập nhật PC khi ghi cho phép
        i_rst = 1;
        i_pc_wren = 1;
        i_pc_next = 32'hA5A5A5A5;
        #10; // Đợi một chu kỳ clock
        check_result(32'hA5A5A5A5, "Test 2: Ghi PC");

        // Test 3: Giữ giá trị PC khi không ghi
        i_pc_wren = 0;
        i_pc_next = 32'hDEADBEEF;
        #10; // Đợi một chu kỳ clock
        check_result(32'hA5A5A5A5, "Test 3: Không ghi PC");

        // Test 4: Cập nhật PC với giá trị khác
        i_pc_wren = 1;
        i_pc_next = 32'hBEEF1234;
        #10; // Đợi một chu kỳ clock
        check_result(32'hBEEF1234, "Test 4: Ghi PC mới");

        // Test 5: Reset lại trong quá trình hoạt động
        i_rst = 0;
        #10; // Đợi một chu kỳ clock
        check_result(32'd0, "Test 5: Reset trong hoạt động");

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
