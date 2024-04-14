module Hamming_Secded_Top(
    input  [3:0] in_secded,
    input  [4:0] in_noise,
    output [6:0] out_7seg,
    output [3:0] out_secded,
    output       out_1bit_error,
    output       out_2bit_error,
    output       out_parity_error,
//    output [6:0] out_symptom_display,
    output       anode1_active,
    output       anode2_active,
    output       anode3_active
    );
    
    wire [6:0] enc_hamming_code;
    wire       enc_parity;
    wire [6:0] out_noise_hamming_code;
    wire       out_noise_parity;
    wire [6:0] out_symptom;
    wire [2:0] in_7seg;
    wire       anode_active_1 = 1;
    wire       anode_active_2 = 1;
    wire       anode_active_3 = 1;
    
    assign anode_active_1 = anode1_active;
    assign anode_active_2 = anode2_active;
    assign anode_active_3 = anode3_active;
 //   assign out_symptom_display = out_symptom;
    
    Hamming_74Enc Hamm_Encoder(
    .in_data                 (in_secded),
    .out_hamming_code        (enc_hamming_code),
    .out_parity              (enc_parity)
    );
    
    Hamming_74Dec Hamm_Decoder (
    .in_data            (out_noise_hamming_code),
    .in_parity          (out_noise_parity),
    .out_symptom        (out_symptom),
    .out_data           (out_secded),
    .out_1bit_error     (out_1bit_error),
    .out_2bit_error     (out_2bit_error),
    .parity_error       (out_parity_error)
    );
    
    Noise_Inclusion Noise (
    .in_data        ({enc_parity, enc_hamming_code}),
    .in_noise       (in_noise),
    .out_data       ({out_noise_parity, out_noise_hamming_code})
    );
    
    Priority_Encoder_8to3 PrioEnc (
    .d  ({1'b0, out_symptom}),
    .q  (in_7seg),
    .v  ()                          //unused
    );
    
    Decoder_7seg Segment (
    .in         ({1'b0, in_7seg}),
    .out_a      (out_7seg[0]),
    .out_b      (out_7seg[1]),
    .out_c      (out_7seg[2]),
    .out_d      (out_7seg[3]),
    .out_e      (out_7seg[4]),
    .out_f      (out_7seg[5]),
    .out_g      (out_7seg[6])
    );
    
endmodule
