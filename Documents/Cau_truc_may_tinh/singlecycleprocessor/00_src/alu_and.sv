module alu_and (
   input logic  [31:0] i_and_a,  // Toan hang A
   input logic  [31:0] i_and_b,  // Toan hang B
   output logic [31:0] o_and_result  // Ket qua AND
);

    // Khai bao bien de luu tru ket qua AND cho tung bit
    logic [31:0] and_temp;

    // Su dung logic gates de thuc hien phep AND
    assign and_temp[0]  = i_and_a[0]  & i_and_b[0];
    assign and_temp[1]  = i_and_a[1]  & i_and_b[1];
    assign and_temp[2]  = i_and_a[2]  & i_and_b[2];
    assign and_temp[3]  = i_and_a[3]  & i_and_b[3];
    assign and_temp[4]  = i_and_a[4]  & i_and_b[4];
    assign and_temp[5]  = i_and_a[5]  & i_and_b[5];
    assign and_temp[6]  = i_and_a[6]  & i_and_b[6];
    assign and_temp[7]  = i_and_a[7]  & i_and_b[7];
    assign and_temp[8]  = i_and_a[8]  & i_and_b[8];
    assign and_temp[9]  = i_and_a[9]  & i_and_b[9];
    assign and_temp[10] = i_and_a[10] & i_and_b[10];
    assign and_temp[11] = i_and_a[11] & i_and_b[11];
    assign and_temp[12] = i_and_a[12] & i_and_b[12];
    assign and_temp[13] = i_and_a[13] & i_and_b[13];
    assign and_temp[14] = i_and_a[14] & i_and_b[14];
    assign and_temp[15] = i_and_a[15] & i_and_b[15];
    assign and_temp[16] = i_and_a[16] & i_and_b[16];
    assign and_temp[17] = i_and_a[17] & i_and_b[17];
    assign and_temp[18] = i_and_a[18] & i_and_b[18];
    assign and_temp[19] = i_and_a[19] & i_and_b[19];
    assign and_temp[20] = i_and_a[20] & i_and_b[20];
    assign and_temp[21] = i_and_a[21] & i_and_b[21];
    assign and_temp[22] = i_and_a[22] & i_and_b[22];
    assign and_temp[23] = i_and_a[23] & i_and_b[23];
    assign and_temp[24] = i_and_a[24] & i_and_b[24];
    assign and_temp[25] = i_and_a[25] & i_and_b[25];
    assign and_temp[26] = i_and_a[26] & i_and_b[26];
    assign and_temp[27] = i_and_a[27] & i_and_b[27];
    assign and_temp[28] = i_and_a[28] & i_and_b[28];
    assign and_temp[29] = i_and_a[29] & i_and_b[29];
    assign and_temp[30] = i_and_a[30] & i_and_b[30];
    assign and_temp[31] = i_and_a[31] & i_and_b[31];

    // Kết quả AND là kết quả sau khi thực hiện phép AND cho mỗi bit
    assign o_and_result = and_temp;

endmodule: alu_and
