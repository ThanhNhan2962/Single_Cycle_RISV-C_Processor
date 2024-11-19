module tb_regfile;

    // Khai báo tín hiệu
    logic        i_clk;            // Tín hiệu clock
    logic        i_rst;            // Tín hiệu reset
    logic        i_rd_wren;        // Tín hiệu cho phép ghi
    logic [4:0]  i_rd_addr;        // Địa chỉ ghi rd
    logic [4:0]  i_rs1_addr;       // Địa chỉ đọc rs1
    logic [4:0]  i_rs2_addr;       // Địa chỉ đọc rs2
    logic [31:0] i_rd_data;        // Dữ liệu ghi vào thanh ghi
    logic [31:0] o_rs1_data;       // Dữ liệu đọc từ rs1
    logic [31:0] o_rs2_data;       // Dữ liệu đọc từ rs2

    // Khai báo module DUT (Device Under Test)
    regfile uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_rd_wren(i_rd_wren),
        .i_rd_addr(i_rd_addr),
        .i_rs1_addr(i_rs1_addr),
        .i_rs2_addr(i_rs2_addr),
        .i_rd_data(i_rd_data),
        .o_rs1_data(o_rs1_data),
        .o_rs2_data(o_rs2_data)
    );

    // Khai báo biến kiểm tra
    bit test_pass = 1;

    // Task để kiểm tra kết quả
    task check_result(input [31:0] expected_rs1, input [31:0] expected_rs2, input string operation);
        // Hiển thị các giá trị đầu vào và đầu ra
        $display("%s | i_rd_addr: %h, i_rs1_addr: %h, i_rs2_addr: %h, o_rs1_data: %h, o_rs2_data: %h, Expected RS1: %h, Expected RS2: %h", 
                 operation, i_rd_addr, i_rs1_addr, i_rs2_addr, o_rs1_data, o_rs2_data, expected_rs1, expected_rs2);
        
        if (o_rs1_data !== expected_rs1 || o_rs2_data !== expected_rs2) begin
            $display("TEST FAILED: %s | Expected RS1: %h, Got RS1: %h | Expected RS2: %h, Got RS2: %h", 
                     operation, expected_rs1, o_rs1_data, expected_rs2, o_rs2_data);
            test_pass = 0;
        end
    endtask

    // Khai báo các giá trị đầu vào cho các test
    initial begin
        // Khởi tạo tín hiệu
        i_clk = 0;
        i_rst = 1;
        i_rd_wren = 0;
        i_rd_addr = 5'd0;
        i_rs1_addr = 5'd0;
        i_rs2_addr = 5'd0;
        i_rd_data = 32'd0;

        // Giả lập reset
        #5 i_rst = 0; // Hủy reset sau 5 đơn vị thời gian
        #5 i_rst = 1; // Kích hoạt lại reset

        // Test 1: Kiểm tra đọc dữ liệu mặc định từ các thanh ghi
        i_rs1_addr = 5'd1;
        i_rs2_addr = 5'd2;
        #10;
        check_result(32'd0, 32'd0, "Test 1");

        // Test 2: Ghi giá trị vào thanh ghi 5 và đọc lại
        i_rd_wren = 1;
        i_rd_addr = 5'd5;
        i_rd_data = 32'h12345678;  // Dữ liệu ghi vào thanh ghi
        #10;

        i_rs1_addr = 5'd5;  // Đọc thanh ghi vừa ghi
        i_rs2_addr = 5'd0;
        #10;
        check_result(32'h12345678, 32'd0, "Test 2");

        // Test 3: Ghi giá trị vào thanh ghi 10 và đọc các giá trị khác nhau
        i_rd_wren = 1;
        i_rd_addr = 5'd10;
        i_rd_data = 32'h87654321;  // Dữ liệu ghi vào thanh ghi
        #10;

        i_rs1_addr = 5'd10;  // Đọc thanh ghi 10
        i_rs2_addr = 5'd5;   // Đọc thanh ghi 5
        #10;
        check_result(32'h87654321, 32'h12345678, "Test 3");

        // Test 4: Kiểm tra ghi lại và đọc từ thanh ghi khác
        i_rd_wren = 1;
        i_rd_addr = 5'd15;
        i_rd_data = 32'hAABBCCDD;  // Dữ liệu ghi vào thanh ghi
        #10;

        i_rs1_addr = 5'd15;  // Đọc thanh ghi 15
        i_rs2_addr = 5'd0;   // Đọc thanh ghi 0
        #10;
        check_result(32'hAABBCCDD, 32'd0, "Test 4");

        // Test 5: Kiểm tra không ghi và đọc thanh ghi mặc định
        i_rd_wren = 0;
        i_rd_addr = 5'd20;
        i_rd_data = 32'h0;
        i_rs1_addr = 5'd20;  // Đọc thanh ghi 20
        i_rs2_addr = 5'd0;   // Đọc thanh ghi 0
        #10;
        check_result(32'd0, 32'd0, "Test 5");

        // Kiểm tra kết quả cuối cùng
        if (test_pass) begin
            $display("TEST PASS");
        end else begin
            $display("SOME TESTS FAILED");
        end

        // Kết thúc mô phỏng
        $finish;
    end

    // Tạo xung clock
    always #5 i_clk = ~i_clk;  // Tạo clock 10ns

endmodule
