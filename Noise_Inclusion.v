module Noise_Inclusion(
    input  [7:0] in_data,
    input  [4:0] in_noise,
    output [7:0] out_data
    );
    
    reg  [6:0] noise;
    wire [2:0] bit_error;
    
    always @(*) begin
    case (in_noise[2:0])
    3'd1: noise = {in_noise[3], 6'b000001}; // 1bit or 2bit error
    3'd2: noise = {in_noise[3], 6'b000010};
    3'd3: noise = {in_noise[3], 6'b000100};
    3'd4: noise = {in_noise[3], 6'b001000};
    3'd5: noise = {in_noise[3], 6'b010000};
    3'd6: noise = {in_noise[3], 6'b100000};
    3'd7: noise = {6'b100000, in_noise[3]};
    default : noise = {in_noise[3], 6'b000000};  // no error or 1bit error
    endcase
    end

    assign bit_error = in_noise[2:0];
    assign out_data = in_data ^ {in_noise[4], noise};
    
endmodule
