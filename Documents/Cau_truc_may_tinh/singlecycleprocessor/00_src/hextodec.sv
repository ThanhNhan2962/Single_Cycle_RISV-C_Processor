module hex_to_dec (
    input      [31:0] i_hex_value,       // đầu vào 32-bit số hex
    output reg [6:0]  o_hex0,            // led 7 đoạn cho số hàng đơn vị
    output reg [6:0]  o_hex1,            // led 7 đoạn cho số hàng chục
    output reg [6:0]  o_hex2,            // led 7 đoạn cho số hàng trăm
    output reg [6:0]  o_hex3,            // led 7 đoạn cho số hàng nghìn
    output reg [6:0]  o_hex4,            // led 7 đoạn cho số hàng chục nghìn
    output reg [6:0]  o_hex5,            // led 7 đoạn cho số hàng trăm nghìn
    output reg [6:0]  o_hex6,            // led 7 đoạn cho số hàng triệu
    output reg [6:0]  o_hex7             // led 7 đoạn cho số hàng chục triệu
);

    // Mã hóa số thập phân từ 0-9 cho led 7 đoạn
    function [6:0] seg7_decode;
        input [3:0] digit;
        case (digit)
            4'd0: seg7_decode = 7'b1000000; // hiển thị 0
            4'd1: seg7_decode = 7'b1111001; // hiển thị 1
            4'd2: seg7_decode = 7'b0100100; // hiển thị 2
            4'd3: seg7_decode = 7'b0110000; // hiển thị 3
            4'd4: seg7_decode = 7'b0011001; // hiển thị 4
            4'd5: seg7_decode = 7'b0010010; // hiển thị 5
            4'd6: seg7_decode = 7'b0000010; // hiển thị 6
            4'd7: seg7_decode = 7'b1111000; // hiển thị 7
            4'd8: seg7_decode = 7'b0000000; // hiển thị 8
            4'd9: seg7_decode = 7'b0010000; // hiển thị 9
            default: seg7_decode = 7'b1111111; // tắt hiển thị
        endcase
    endfunction

    // Chuyển đổi từ số hex thành số dec và hiển thị trên 8 led 7 đoạn
    integer i;
    reg [3:0] digits[7:0];
    reg [31:0] temp;

    always @(*) begin
        // Khởi tạo các chữ số thập phân
        temp = i_hex_value;
        for (i = 0; i < 8; i = i + 1) begin
            digits[i] = temp % 10;
            temp = temp / 10;
        end

        // Hiển thị các chữ số lên 8 led 7 đoạn
        o_hex0 = seg7_decode(digits[0]);
        o_hex1 = seg7_decode(digits[1]);
        o_hex2 = seg7_decode(digits[2]);
        o_hex3 = seg7_decode(digits[3]);
        o_hex4 = seg7_decode(digits[4]);
        o_hex5 = seg7_decode(digits[5]);
        o_hex6 = seg7_decode(digits[6]);
        o_hex7 = seg7_decode(digits[7]);
    end
endmodule
