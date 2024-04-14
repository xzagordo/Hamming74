module Hamming_74Enc(
    input  [3:0] in_data,
    output [6:0] out_hamming_code,
    output       out_parity
    );
    
    reg p1, p2, p4;
    
    always @(*) begin
    p1 <= in_data[0] ^ in_data[1] ^ in_data[3];
    p2 <= in_data[0] ^ in_data[2] ^ in_data[3];
    p4 <= in_data[1] ^ in_data[2] ^ in_data[3];
    end
    
    assign out_hamming_code = {in_data[3:1], p4, in_data[0], p2, p1};
    assign out_parity = ^ out_hamming_code;
    
endmodule
