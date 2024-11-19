module alu_or (
    input  logic [31:0] i_or_a,  // Toan hang A
    input  logic [31:0] i_or_b,  // Toan hang B
    output logic [31:0] o_or_result  // Ket qua OR
);

    // Khai bao bien de luu tru ket qua OR cho tung bit
    logic [31:0] or_temp;

    // Su dung logic gates de thuc hien phep OR
    assign or_temp[0]  = i_or_a[0]  | i_or_b[0];
    assign or_temp[1]  = i_or_a[1]  | i_or_b[1];
    assign or_temp[2]  = i_or_a[2]  | i_or_b[2];
    assign or_temp[3]  = i_or_a[3]  | i_or_b[3];
    assign or_temp[4]  = i_or_a[4]  | i_or_b[4];
    assign or_temp[5]  = i_or_a[5]  | i_or_b[5];
    assign or_temp[6]  = i_or_a[6]  | i_or_b[6];
    assign or_temp[7]  = i_or_a[7]  | i_or_b[7];
    assign or_temp[8]  = i_or_a[8]  | i_or_b[8];
    assign or_temp[9]  = i_or_a[9]  | i_or_b[9];
    assign or_temp[10] = i_or_a[10] | i_or_b[10];
    assign or_temp[11] = i_or_a[11] | i_or_b[11];
    assign or_temp[12] = i_or_a[12] | i_or_b[12];
    assign or_temp[13] = i_or_a[13] | i_or_b[13];
    assign or_temp[14] = i_or_a[14] | i_or_b[14];
    assign or_temp[15] = i_or_a[15] | i_or_b[15];
    assign or_temp[16] = i_or_a[16] | i_or_b[16];
    assign or_temp[17] = i_or_a[17] | i_or_b[17];
    assign or_temp[18] = i_or_a[18] | i_or_b[18];
    assign or_temp[19] = i_or_a[19] | i_or_b[19];
    assign or_temp[20] = i_or_a[20] | i_or_b[20];
    assign or_temp[21] = i_or_a[21] | i_or_b[21];
    assign or_temp[22] = i_or_a[22] | i_or_b[22];
    assign or_temp[23] = i_or_a[23] | i_or_b[23];
    assign or_temp[24] = i_or_a[24] | i_or_b[24];
    assign or_temp[25] = i_or_a[25] | i_or_b[25];
    assign or_temp[26] = i_or_a[26] | i_or_b[26];
    assign or_temp[27] = i_or_a[27] | i_or_b[27];
    assign or_temp[28] = i_or_a[28] | i_or_b[28];
    assign or_temp[29] = i_or_a[29] | i_or_b[29];
    assign or_temp[30] = i_or_a[30] | i_or_b[30];
    assign or_temp[31] = i_or_a[31] | i_or_b[31];

    // Kết quả OR là kết quả sau khi thực hiện phép OR cho mỗi bit
    assign o_or_result = or_temp;

endmodule: alu_or
