module tb_op_mem;

  // Declare signals
  logic        clk;
  logic        rst;
  logic        lsu_wren;
  logic [15:0] op_addr;
  logic [31:0] op_data;
  logic [31:0] o_op_data;
  logic [31:0] o_io_ledr;
  logic [31:0] o_io_ledg;
  logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3;
  logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
  logic [31:0] o_io_lcd;

  // Instantiate the module under test
  op_mem uut (
    .i_clk(clk),
    .i_rst(rst),
    .i_lsu_wren(lsu_wren),
    .i_op_addr(op_addr),
    .i_op_data(op_data),
    .o_op_data(o_op_data),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_io_lcd(o_io_lcd)
  );

  // Clock generation (10ns period)
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    $display("Starting testbench...");

    // Initialize signals
    clk = 0;
    rst = 0;
    lsu_wren = 0;
    op_addr = 16'b0;
    op_data = 32'b0;

    // Apply reset
    #10 rst = 1;

    // Test 1: Store and load to/from LED red (o_io_ledr)
    op_addr = 16'h7000;
    op_data = 32'h12345678; // Data to store
    lsu_wren = 1; // Write enable
    #10;
    lsu_wren = 0; // Disable write
    #10;

    // Verify that the value is correctly loaded into LED red
    if (o_io_ledr == 32'h12345678) begin
      $display("Test LED Red: PASS - Value = %h", o_io_ledr);
    end else begin
      $display("Test LED Red: FAIL - Value = %h", o_io_ledr);
    end

    // Test 2: Store and load to/from LED green (o_io_ledg)
    op_addr = 16'h7010;
    op_data = 32'hA1B2C3D4; // Data to store
    lsu_wren = 1; // Write enable
    #10;
    lsu_wren = 0; // Disable write
    #10;

    // Verify that the value is correctly loaded into LED green
    if (o_io_ledg == 32'hA1B2C3D4) begin
      $display("Test LED Green: PASS - Value = %h", o_io_ledg);
    end else begin
      $display("Test LED Green: FAIL - Value = %h", o_io_ledg);
    end

    // Test 3: Store and load to/from HEX0-3 (o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3)
    op_addr = 16'h7020;
    op_data = 32'h4F5B063F; // Data to store
    lsu_wren = 1; // Write enable
    #10;
    lsu_wren = 0; // Disable write
    #10;

    // Verify that the value is correctly loaded into HEX0-3
    if ({o_io_hex3, o_io_hex2, o_io_hex1, o_io_hex0} == 32'h4F5B063F) begin
      $display("Test HEX0-3: PASS - Values = %h %h %h %h", o_io_hex3, o_io_hex2, o_io_hex1, o_io_hex0);
    end else begin
      $display("Test HEX0-3: FAIL - Values = %h %h %h %h", o_io_hex3, o_io_hex2, o_io_hex1, o_io_hex0);
    end

    // Test 4: Store and load to/from HEX4-7 (o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7)
    op_addr = 16'h7024;
    op_data = 32'h077D6D66; // Data to store
    lsu_wren = 1; // Write enable
    #10;
    lsu_wren = 0; // Disable write
    #10;

    // Verify that the value is correctly loaded into HEX4-7
    if ({o_io_hex7, o_io_hex6, o_io_hex5, o_io_hex4} == 32'h077D6D66) begin
      $display("Test HEX4-7: PASS - Values = %h %h %h %h", o_io_hex7, o_io_hex6, o_io_hex5, o_io_hex4);
    end else begin
      $display("Test HEX4-7: FAIL - Values = %h %h %h %h", o_io_hex7, o_io_hex6, o_io_hex5, o_io_hex4);
    end

    // Test 5: Store and load to/from LCD (o_io_lcd)
    op_addr = 16'h7030;
    op_data = 32'h1A2B3C4D; // Data to store
    lsu_wren = 1; // Write enable
    #10;
    lsu_wren = 0; // Disable write
    #10;

    // Verify that the value is correctly loaded into LCD
    if (o_io_lcd == 32'h1A2B3C4D) begin
      $display("Test LCD: PASS - Value = %h", o_io_lcd);
    end else begin
      $display("Test LCD: FAIL - Value = %h", o_io_lcd);
    end

    $display("All tests completed!");
    $stop;
  end

endmodule
