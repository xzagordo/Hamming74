module Decoder_7seg
#(parameter Common_Anode_Cathode = 0)(
    input [3:0] in,
    output out_a,
    output out_b,
    output out_c,
    output out_d,
    output out_e,
    output out_f,
    output out_g
    );
    
    reg a,b,c,d,e,f,g;
    
    always @(*) begin
        case (in)
        4'd0    : {a,b,c,d,e,f,g} = 7'b1111110;
        4'd1    : {a,b,c,d,e,f,g} = 7'b0110000;
        4'd2    : {a,b,c,d,e,f,g} = 7'b1101101;
        4'd3    : {a,b,c,d,e,f,g} = 7'b1111001;
        4'd4    : {a,b,c,d,e,f,g} = 7'b0110011;
        4'd5    : {a,b,c,d,e,f,g} = 7'b1011011;
        4'd6    : {a,b,c,d,e,f,g} = 7'b1011111;
        4'd7    : {a,b,c,d,e,f,g} = 7'b1110000;
        4'd8    : {a,b,c,d,e,f,g} = 7'b1111111;
        4'd9    : {a,b,c,d,e,f,g} = 7'b1111011;
        4'd10   : {a,b,c,d,e,f,g} = 7'b1110111;
        4'd11   : {a,b,c,d,e,f,g} = 7'b0011111;
        4'd12   : {a,b,c,d,e,f,g} = 7'b1001110;
        4'd13   : {a,b,c,d,e,f,g} = 7'b0111101;
        4'd14   : {a,b,c,d,e,f,g} = 7'b1001111;
        4'd15   : {a,b,c,d,e,f,g} = 7'b1000111;
        default : {a,b,c,d,e,f,g} = 7'b1111110;
        endcase
     end 
     
     assign {out_a, out_b, out_c, out_d, out_e, out_f, out_g} = Common_Anode_Cathode ? {a,b,c,d,e,f,g} : ~{a,b,c,d,e,f,g};
endmodule
