module Hamming_74Dec(
    input  [6:0] in_data,
    input        in_parity,
    output [6:0] out_symptom,
    output [3:0] out_data,
    output       out_1bit_error,
    output       out_2bit_error,
    output       parity_error
    );
    
    reg p1, p2, p4;
    reg  [6:0] symptom;
    wire [6:0] data_decoded;
    wire       overall_parity;
    
    always @(*) begin
    p1 = in_data[0] ^ in_data[2] ^ in_data[4] ^ in_data[6];
    p2 = in_data[1] ^ in_data[2] ^ in_data[5] ^ in_data[6];
    p4 = in_data[3] ^ in_data[4] ^ in_data[5] ^ in_data[6];
    end
    
    always @(*) begin
    case({p4,p2,p1})
    3'd1: symptom = 7'b0000001;
    3'd2: symptom = 7'b0000010;
    3'd3: symptom = 7'b0000100;
    3'd4: symptom = 7'b0001000;
    3'd5: symptom = 7'b0010000;
    3'd6: symptom = 7'b0100000;
    3'd7: symptom = 7'b1000000;
    default : symptom = 7'b0;
    endcase
    end
    
    assign data_decoded = symptom ^ in_data;
    assign out_symptom = symptom;
    assign overall_parity = ^{in_parity, in_data};
    
    assign out_1bit_error   = ({p4,p2,p1} != 3'b0) & overall_parity;
    assign out_2bit_error   = ({p4,p2,p1} != 3'b0) & ~overall_parity;
    assign parity_error = ({p4,p2,p1} == 3'b0) & overall_parity;
    assign out_data         = {data_decoded[6:4], data_decoded[2]}; 
    
endmodule
