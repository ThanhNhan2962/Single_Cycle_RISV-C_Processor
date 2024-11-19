module mux4to1_32bit (
  input  logic [1:0]  i_sel,      // Chọn tín hiệu (2 bit)
  input  logic [31:0] i_data_00,  // Dữ liệu đầu vào 00
  input  logic [31:0] i_data_01,  // Dữ liệu đầu vào 01
  input  logic [31:0] i_data_10,  // Dữ liệu đầu vào 10
  input  logic [31:0] i_data_11,  // Dữ liệu đầu vào 11
  output logic [31:0] o_data      // Dữ liệu đầu ra
);

  // Chọn đầu vào dựa trên giá trị của `i_sel`
  always_comb begin
    case (i_sel)
      2'b00: o_data = i_data_00;
      2'b01: o_data = i_data_01;
      2'b10: o_data = i_data_10;
      2'b11: o_data = i_data_11;
    endcase
  end

endmodule: mux4to1_32bit
