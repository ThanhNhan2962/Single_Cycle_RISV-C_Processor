module tb_ctrlu;

    // Định nghĩa tín hiệu đầu vào và đầu ra 
    logic [31:0] i_instr;
    logic i_br_less, i_br_equal;
    logic o_pc_sel, o_pc_wren, o_rd_wren, o_insn_vld;
    logic o_br_un, o_opa_sel, o_opb_sel;
    logic [3:0] o_alu_op;
    logic o_mem_wren;
    logic [3:0] o_mask;
    logic o_mem_un;
    logic [1:0] o_wb_sel;

   
    ctrlu uut (
        .i_instr(i_instr),
        .i_br_less(i_br_less),
        .i_br_equal(i_br_equal),
        .o_pc_sel(o_pc_sel),
        .o_pc_wren(o_pc_wren),
        .o_rd_wren(o_rd_wren),
        .o_insn_vld(o_insn_vld),
        .o_br_un(o_br_un),
        .o_opa_sel(o_opa_sel),
        .o_opb_sel(o_opb_sel),
        .o_alu_op(o_alu_op),
        .o_mem_wren(o_mem_wren),
        .o_mask(o_mask),
        .o_mem_un(o_mem_un),
        .o_wb_sel(o_wb_sel)
    );

    // In ra kết quả
    initial begin
        
        $monitor("At time %t, i_instr = %h, o_pc_sel = %b, o_pc_wren = %b, o_rd_wren = %b, o_insn_vld = %b, o_br_un = %b, o_opa_sel = %b, o_opb_sel = %b, o_alu_op = %b, o_mem_wren = %b, o_mask = %h, o_mem_un = %b, o_wb_sel = %b",
                 $time, i_instr, o_pc_sel, o_pc_wren, o_rd_wren, o_insn_vld, o_br_un, o_opa_sel, o_opb_sel, o_alu_op, o_mem_wren,  o_mask, o_mem_un, o_wb_sel);
    end

    // Khởi tạo tín hiệu đầu vào và kiểm tra các trường hợp
    initial begin
        // Trường hợp 1: Lệnh lw x5, 0(x6)
        $display("1:  lw x5, 0(x6)");
        i_instr = 32'h00032283; // lw x5, 0(x6)
        #10;  // Chờ 10 time units

        // Trường hợp 2: Lệnh addi x5, x6, 10
        $display("2:  addi x5, x6, 10");
        i_instr = 32'h00A30293; // addi x5, x6, 10
        #10;

        // Trường hợp 3: Lệnh sw x5, 4(x6)
        $display("3:  sw x5, 4(x6)");
        i_instr = 32'h00532223; // sw x5, 4(x6)
        #10;

        // Trường hợp 4: Lệnh add x5, x6, x7
        $display("4:  add x5, x6, x7");
        i_instr = 32'h007302B3; // add x5, x6, x7
        #10;

        // Trường hợp 5: Lệnh beq x5, x6, 4
        $display("5:  beq x5, x6, 4");
        i_instr = 32'h00628263; // beq x5, x6, 4
        #10;

        // Trường hợp 6: Lệnh lui x5, 65536
        $display("6:  lui x5, 65536");
        i_instr = 32'h100002B7; // lui x5, 65536
        #10;

        // Trường hợp 7: Lệnh jal x1, 100
        $display("7:  jal x1, 100");
        i_instr = 32'h064000EF; // jal x1, 100
        #10;

        // Trường hợp 8: Lệnh slli x5, x6, 2
        $display("8:  slli x5, x6, 2");
        i_instr = 32'h00231293; // slli x5, x6, 2
        #10;

        // Trường hợp 9: Lệnh xor x5, x6, x7
        $display("9:  xor x5, x6, x7");
        i_instr = 32'h007342B3; // xor x5, x6, x7
        #10;

        // Kết thúc mô phỏng
        $finish;
    end

endmodule
