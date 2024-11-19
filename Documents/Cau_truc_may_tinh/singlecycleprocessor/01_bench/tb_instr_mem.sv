module tb_instr_mem;
  reg i_clk;                   
  reg [31:0] i_pc;             
  wire [31:0] o_instr;           
  instr_mem uut (
    .i_clk(i_clk),
    .i_pc(i_pc),
    .o_instr(o_instr)
  );

  initial begin
    i_clk = 0;
    forever #5 i_clk = ~i_clk;
  end

  // Test cases
  initial begin
    $display("Starting Test Bench");

    // Test Case 1: PC = 0x00000000
    i_pc = 32'h00000000;
    #10; // Wait for one clock cycle
    $display("PC: %h, Instruction: %h", i_pc, o_instr);
    if (o_instr == 32'h00000093) $display("Test Case 1 Passed");
    else $display("Test Case 1 Failed: Expected 00000093, Got %h", o_instr);

    // Test Case 2: PC = 0x00000004
    i_pc = 32'h00000004;
    #10;
    $display("PC: %h, Instruction: %h", i_pc, o_instr);
    if (o_instr == 32'h40000113) $display("Test Case 2 Passed");
    else $display("Test Case 2 Failed: Expected 40000113, Got %h", o_instr);

    // Test Case 3: PC = 0x00000008
    i_pc = 32'h00000008;
    #10;
    $display("PC: %h, Instruction: %h", i_pc, o_instr);
    if (o_instr == 32'h00211033) $display("Test Case 3 Passed");
    else $display("Test Case 3 Failed: Expected 00211033, Got %h", o_instr);

    // Test Case 4: PC = 0x00000010
    i_pc = 32'h00000010;
    #10;
    $display("PC: %h, Instruction: %h", i_pc, o_instr);
    if (o_instr == 32'h02010213) $display("Test Case 4 Passed");
    else $display("Test Case 4 Failed: Expected 02010213 , Got %h", o_instr);

    // Test Case 5: PC = 0x00000014
    i_pc = 32'h00000014;
    #10;
    $display("PC: %h, Instruction: %h", i_pc, o_instr);
    if (o_instr == 32'h03010293) $display("Test Case 5 Passed");
    else $display("Test Case 5 Failed: Expected 03010293, Got %h", o_instr);

    // Test Case 6: PC = 0x00000020
    i_pc = 32'h00000020;
    #10;
    $display("PC: %h, Instruction: %h", i_pc, o_instr);
    if (o_instr == 32'h0083a023) $display("Test Case 6 Passed");
    else $display("Test Case 6 Failed: Expected 0083a023, Got %h", o_instr);

    $display("Test Bench Completed");
    $finish;
  end
endmodule
