module tb_pc_debug_reg;

    // Khai báo các tín hiệu
    logic i_clk;               // Tín hiệu đồng hồ
    logic i_rst;               // Tín hiệu reset
    logic [31:0] i_pc;         // Địa chỉ chương trình (PC)
    logic [31:0] o_pc_debug;   // Địa chỉ chương trình sau khi debug

    // Khai báo mô-đun uut
    pc_debug_reg uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_pc(i_pc),
        .o_pc_debug(o_pc_debug)
    );

    // Khai báo biến kiểm tra
    bit test_pass = 1;

    // Khai báo task kiểm tra kết quả
    task check_result(input [31:0] expected, input string operation);
        // Hiển thị các giá trị đầu vào và đầu ra
        $display("%s | i_pc: %h, o_pc_debug: %h, Expected: %h", 
                 operation, i_pc, o_pc_debug, expected);
        
        // Kiểm tra kết quả đầu ra
        if (o_pc_debug !== expected) begin
            $display("TEST FAILED: %s | Expected: %h, Got: %h", operation, expected, o_pc_debug);
            test_pass = 0;
        end
    endtask

    // Tạo tín hiệu đồng hồ
    always #5 i_clk = ~i_clk; // Tạo xung clock với chu kỳ 10 đơn vị thời gian

    // Khai báo các giá trị đầu vào cho các test
    initial begin
        // Khởi tạo các tín hiệu
        i_clk = 0;
        i_rst = 0;
        i_pc = 32'h0000_0000;  // Khởi tạo i_pc bằng 0

        // Kiểm tra khi reset bằng 0
        #10; // Chờ một chu kỳ clock
        i_rst = 0;
        i_pc = 32'h1234_5678;  // Địa chỉ chương trình khác
        #10; // Chờ một chu kỳ clock
        check_result(32'b0, "TEST RESET = 0"); // Kiểm tra kết quả khi reset = 0

        // Kiểm tra khi reset = 1
        i_rst = 1;
        #10; // Chờ một chu kỳ clock
        check_result(32'h1234_5678, "TEST RESET = 1"); // Kiểm tra giá trị khi reset = 1

        // Kiểm tra lại khi reset = 0
        i_rst = 0;
        i_pc = 32'hA5A5_A5A5;
        #10; // Chờ một chu kỳ clock
        check_result(32'b0, "TEST RESET = 0 Again");

        // Kết thúc mô phỏng
        if (test_pass) begin
            $display("TEST PASS");
        end else begin
            $display("SOME TESTS FAILED");
        end

        $finish; // Kết thúc mô phỏng
    end

endmodule
