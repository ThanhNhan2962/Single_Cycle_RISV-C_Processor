module tb_mux3to1;
  logic [1:0] i_sel;
  logic [31:0] i_data_01;
  logic [31:0] i_data_10;
  logic [31:0] i_data_11;
  // Output
  logic [31:0] o_data;

  mux3to1 uut (
    .i_sel(i_sel),
    .i_data_01(i_data_01),
    .i_data_10(i_data_10),
    .i_data_11(i_data_11),
    .o_data(o_data)
  );

  // Testbench logic
  initial begin

    // Test Case 1: i_sel = 2'b01
    i_sel = 2'b01;
    i_data_01 = 32'h00000001;
    i_data_10 = 32'h00000002;
    i_data_11 = 32'h00000003;
    #10; // Wait for some time
    $display("i_sel: %b, o_data: %h", i_sel, o_data);
    if (o_data == i_data_01) $display("Test Case 1 Passed");
    else $display("Test Case 1 Failed: Expected %h, Got %h", i_data_01, o_data);

    // Test Case 2: i_sel = 2'b10
    i_sel = 2'b10;
    #10;
    $display("i_sel: %b, o_data: %h", i_sel, o_data);
    if (o_data == i_data_10) $display("Test Case 2 Passed");
    else $display("Test Case 2 Failed: Expected %h, Got %h", i_data_10, o_data);

    // Test Case 3: i_sel = 2'b11
    i_sel = 2'b11;
    #10;
    $display("i_sel: %b, o_data: %h", i_sel, o_data);
    if (o_data == i_data_11) $display("Test Case 3 Passed");
    else $display("Test Case 3 Failed: Expected %h, Got %h", i_data_11, o_data);

    // Test Case 4: i_sel = 2'b00 (Default case)
    i_sel = 2'b00;
    #10;
    $display("i_sel: %b, o_data: %h", i_sel, o_data);
    if (o_data == 32'b0) $display("Test Case 4 Passed");
    else $display("Test Case 4 Failed: Expected 00000000, Got %h", o_data);

    $finish;
  end
endmodule
