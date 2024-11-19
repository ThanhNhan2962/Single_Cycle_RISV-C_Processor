module alu_xor (
    input logic [31:0] i_xor_a,  // Toan hang A
    input logic [31:0] i_xor_b,  // Toan hang B
    output logic [31:0] o_xor_result  // Ket qua XOR
);

    // Khai bao bien de luu tru bit XOR cho tung cap bit
    logic [31:0] xor_temp; 

    // Su dung logic gates de thuc hien phep XOR
    assign xor_temp[0]  = (i_xor_a[0]  & ~i_xor_b[0])  | (~i_xor_a[0]  & i_xor_b[0]);
    assign xor_temp[1]  = (i_xor_a[1]  & ~i_xor_b[1])  | (~i_xor_a[1]  & i_xor_b[1]);
    assign xor_temp[2]  = (i_xor_a[2]  & ~i_xor_b[2])  | (~i_xor_a[2]  & i_xor_b[2]);
    assign xor_temp[3]  = (i_xor_a[3]  & ~i_xor_b[3])  | (~i_xor_a[3]  & i_xor_b[3]);
    assign xor_temp[4]  = (i_xor_a[4]  & ~i_xor_b[4])  | (~i_xor_a[4]  & i_xor_b[4]);
    assign xor_temp[5]  = (i_xor_a[5]  & ~i_xor_b[5])  | (~i_xor_a[5]  & i_xor_b[5]);
    assign xor_temp[6]  = (i_xor_a[6]  & ~i_xor_b[6])  | (~i_xor_a[6]  & i_xor_b[6]);
    assign xor_temp[7]  = (i_xor_a[7]  & ~i_xor_b[7])  | (~i_xor_a[7]  & i_xor_b[7]);
    assign xor_temp[8]  = (i_xor_a[8]  & ~i_xor_b[8])  | (~i_xor_a[8]  & i_xor_b[8]);
    assign xor_temp[9]  = (i_xor_a[9]  & ~i_xor_b[9])  | (~i_xor_a[9]  & i_xor_b[9]);
    assign xor_temp[10] = (i_xor_a[10] & ~i_xor_b[10]) | (~i_xor_a[10] & i_xor_b[10]);
    assign xor_temp[11] = (i_xor_a[11] & ~i_xor_b[11]) | (~i_xor_a[11] & i_xor_b[11]);
    assign xor_temp[12] = (i_xor_a[12] & ~i_xor_b[12]) | (~i_xor_a[12] & i_xor_b[12]);
    assign xor_temp[13] = (i_xor_a[13] & ~i_xor_b[13]) | (~i_xor_a[13] & i_xor_b[13]);
    assign xor_temp[14] = (i_xor_a[14] & ~i_xor_b[14]) | (~i_xor_a[14] & i_xor_b[14]);
    assign xor_temp[15] = (i_xor_a[15] & ~i_xor_b[15]) | (~i_xor_a[15] & i_xor_b[15]);
    assign xor_temp[16] = (i_xor_a[16] & ~i_xor_b[16]) | (~i_xor_a[16] & i_xor_b[16]);
    assign xor_temp[17] = (i_xor_a[17] & ~i_xor_b[17]) | (~i_xor_a[17] & i_xor_b[17]);
    assign xor_temp[18] = (i_xor_a[18] & ~i_xor_b[18]) | (~i_xor_a[18] & i_xor_b[18]);
    assign xor_temp[19] = (i_xor_a[19] & ~i_xor_b[19]) | (~i_xor_a[19] & i_xor_b[19]);
    assign xor_temp[20] = (i_xor_a[20] & ~i_xor_b[20]) | (~i_xor_a[20] & i_xor_b[20]);
    assign xor_temp[21] = (i_xor_a[21] & ~i_xor_b[21]) | (~i_xor_a[21] & i_xor_b[21]);
    assign xor_temp[22] = (i_xor_a[22] & ~i_xor_b[22]) | (~i_xor_a[22] & i_xor_b[22]);
    assign xor_temp[23] = (i_xor_a[23] & ~i_xor_b[23]) | (~i_xor_a[23] & i_xor_b[23]);
    assign xor_temp[24] = (i_xor_a[24] & ~i_xor_b[24]) | (~i_xor_a[24] & i_xor_b[24]);
    assign xor_temp[25] = (i_xor_a[25] & ~i_xor_b[25]) | (~i_xor_a[25] & i_xor_b[25]);
    assign xor_temp[26] = (i_xor_a[26] & ~i_xor_b[26]) | (~i_xor_a[26] & i_xor_b[26]);
    assign xor_temp[27] = (i_xor_a[27] & ~i_xor_b[27]) | (~i_xor_a[27] & i_xor_b[27]);
    assign xor_temp[28] = (i_xor_a[28] & ~i_xor_b[28]) | (~i_xor_a[28] & i_xor_b[28]);
    assign xor_temp[29] = (i_xor_a[29] & ~i_xor_b[29]) | (~i_xor_a[29] & i_xor_b[29]);
    assign xor_temp[30] = (i_xor_a[30] & ~i_xor_b[30]) | (~i_xor_a[30] & i_xor_b[30]);
    assign xor_temp[31] = (i_xor_a[31] & ~i_xor_b[31]) | (~i_xor_a[31] & i_xor_b[31]);

    // Kết quả XOR là kết quả sau khi thực hiện toán tử XOR cho mỗi bit
    assign o_xor_result = xor_temp;

endmodule: alu_xor
