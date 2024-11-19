module tb_brc;
    // Khai báo các tín hiệu đầu vào và đầu ra cho testbench
    logic [31:0] i_rs1_data;
    logic [31:0] i_rs2_data;
    logic        i_br_un;
    logic        o_br_less;
    logic        o_br_equal;
    
    // Tạo instance của module brc
    brc uut (
        .i_rs1_data(i_rs1_data),
        .i_rs2_data(i_rs2_data),
        .i_br_un(i_br_un),
        .o_br_less(o_br_less),
        .o_br_equal(o_br_equal)
    );

    // Hàm để kiểm tra pass hoặc fail
    task check_result(logic expected_less, logic expected_equal);
        if (o_br_less === expected_less && o_br_equal === expected_equal) begin
            $display("Test PASSED: i_rs1_data = %h, i_rs2_data = %h, i_br_un = %b, o_br_less = %b, o_br_equal = %b",
                     i_rs1_data, i_rs2_data, i_br_un, o_br_less, o_br_equal);
        end else begin
            $display("Test FAILED: i_rs1_data = %h, i_rs2_data = %h, i_br_un = %b, o_br_less = %b, o_br_equal = %b (Expected: o_br_less = %b, o_br_equal = %b)",
                     i_rs1_data, i_rs2_data, i_br_un, o_br_less, o_br_equal, expected_less, expected_equal);
        end
    endtask

    // Khối initial để thực hiện các bài kiểm thử
    initial begin
        // Test 1: Kiểm tra so sánh không có dấu (i_br_un = 1)
        i_rs1_data = 32'h00000001; // 1
        i_rs2_data = 32'h00000002; // 2
        i_br_un = 1;
        #10;
        check_result(1, 0); // Kỳ vọng: o_br_less = 1, o_br_equal = 0
        
        // Test 2: Kiểm tra so sánh không có dấu (i_br_un = 1)
        i_rs1_data = 32'h00000003; // 3
        i_rs2_data = 32'h00000003; // 3
        i_br_un = 1;
        #10;
        check_result(0, 1); // Kỳ vọng: o_br_less = 0, o_br_equal = 1
        
        // Test 3: Kiểm tra so sánh có dấu (i_br_un = 0)
        i_rs1_data = 32'hFFFFFFFF; // -1
        i_rs2_data = 32'h00000001; // 1
        i_br_un = 0;
        #10;
        check_result(1, 0); // Kỳ vọng: o_br_less = 1, o_br_equal = 0
        
        // Test 4: Kiểm tra so sánh có dấu (i_br_un = 0)
        i_rs1_data = 32'h80000000; // -2147483648
        i_rs2_data = 32'h7FFFFFFF; // 2147483647
        i_br_un = 0;
        #10;
        check_result(1, 0); // Kỳ vọng: o_br_less = 1, o_br_equal = 0

        // Test 5: Kiểm tra trường hợp bằng nhau
        i_rs1_data = 32'h00000000; // 0
        i_rs2_data = 32'h00000000; // 0
        i_br_un = 0;
        #10;
        check_result(0, 1); // Kỳ vọng: o_br_less = 0, o_br_equal = 1

        // Kết thúc mô phỏng
        $finish;
    end
endmodule
