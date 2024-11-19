module tb_mux2to1;
  // Khai báo tín hiệu
  reg i_sel;
  reg [31:0] i_data_0;
  reg [31:0] i_data_1;
  wire [31:0] o_data;

  // Kết nối module mux2to1
  mux2to1 uut (
    .i_sel(i_sel),
    .i_data_0(i_data_0),
    .i_data_1(i_data_1),
    .o_data(o_data)
  );

  // Khởi tạo test cases
  initial begin

    // Test Case 1: i_sel = 0, i_data_0 = 32'h00000001, i_data_1 = 32'hFFFFFFFF
    i_sel = 0;
    i_data_0 = 32'h00000001;
    i_data_1 = 32'hFFFFFFFF;
    #10; // Chờ một khoảng thời gian
    $display("i_sel: %b, i_data_0: %h, i_data_1: %h, o_data: %h", i_sel, i_data_0, i_data_1, o_data);
    if (o_data == i_data_0) $display("Test Case 1 Passed");
    else $display("Test Case 1 Failed: Expected %h, Got %h", i_data_0, o_data);

    // Test Case 2: i_sel = 1, i_data_0 = 32'h00000001, i_data_1 = 32'hFFFFFFFF
    i_sel = 1;
    #10; // Chờ một khoảng thời gian
    $display("i_sel: %b, i_data_0: %h, i_data_1: %h, o_data: %h", i_sel, i_data_0, i_data_1, o_data);
    if (o_data == i_data_1) $display("Test Case 2 Passed");
    else $display("Test Case 2 Failed: Expected %h, Got %h", i_data_1, o_data);

    // Test Case 3: i_sel = 0, i_data_0 = 32'h12345678, i_data_1 = 32'h87654321
    i_sel = 0;
    i_data_0 = 32'h12345678;
    i_data_1 = 32'h87654321;
    #10; // Chờ một khoảng thời gian
    $display("i_sel: %b, i_data_0: %h, i_data_1: %h, o_data: %h", i_sel, i_data_0, i_data_1, o_data);
    if (o_data == i_data_0) $display("Test Case 3 Passed");
    else $display("Test Case 3 Failed: Expected %h, Got %h", i_data_0, o_data);

    // Test Case 4: i_sel = 1, i_data_0 = 32'h12345678, i_data_1 = 32'h87654321
    i_sel = 1;
    #10; // Chờ một khoảng thời gian
    $display("i_sel: %b, i_data_0: %h, i_data_1: %h, o_data: %h", i_sel, i_data_0, i_data_1, o_data);
    if (o_data == i_data_1) $display("Test Case 4 Passed");
    else $display("Test Case 4 Failed: Expected %h, Got %h", i_data_1, o_data);
    $finish;
  end
endmodule
