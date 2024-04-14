`define    ERROR    1
`define    NO_ERROR 0
`timescale 1ns / 1ps

module tb_Hamming_74();

integer success_no = 0, error_no = 0, test_no = 0, i = 0;

reg  [3:0] in_secded;
reg  [4:0] in_noise;
wire [6:0] out_7seg;
wire [3:0] out_secded;
wire       out_1bit_error;
wire       out_2bit_error;
wire       out_parity_error;


Hamming_Secded_Top Hamm1 (
.in_secded        (in_secded        ),
.in_noise         (in_noise         ),
.out_7seg         (out_7seg         ),
.out_secded       (out_secded       ),
.out_1bit_error   (out_1bit_error   ),
.out_2bit_error   (out_2bit_error   ),
.out_parity_error (out_parity_error )
);
 
initial begin
    $display($time, "BEGIN TEST");
    $display($time, "\n TEST 1: NO bit errors");
    for (i=0; i<16; i=i+1) begin
        in_secded = i[3:0]; 
        in_noise = 0;
        #1; 
        compare_data(in_secded, out_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);
    end
    
    #10
    $display($time, "\n TEST 2: 1 bit error");
    for (i=0; i<16; i=i+1) begin
        in_secded = i[3:0];
        in_noise = (i == 16) ? 5'b10000 : $urandom_range(7,1);
        #1;
        if (i<16)
            compare_data(in_secded, out_secded, `ERROR, `NO_ERROR, `NO_ERROR);
            else
            compare_data(in_secded, out_secded, `NO_ERROR, `NO_ERROR, `ERROR);
    end        
       
     #10;
     $display($time, "\n TEST 3: 2 bit error");
     for (i=0; i<16; i=i+1) begin
       in_secded = i[3:0];
       in_noise = (1<<3) | $urandom_range(7,1);
       #1
       compare_data(in_secded, out_secded, `NO_ERROR, `ERROR, `NO_ERROR);
     end
    
    #10;
    $display($time, "\n TEST 4: Parity diff and 2 bit error -> 3 bit error");
    in_secded = 4'd8;
    in_noise = (1<<4) | (1<<3) | $urandom_range(7,1);
    #1;
    in_secded = 0;
    in_noise = 0;
    
    #10;
    $display($time, "\n TEST 5: No bit errors");
    in_secded = 4'b1010; in_noise = 0;
    #1;
    compare_data(in_secded, out_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);
    
    #10;
    $display($time, " TEST STOP \n\t\t RESULTS success_no = %0d, error_no = %0d, test_no = %0d", success_no, error_no, test_no);
    $stop;
end

task compare_data(
input [3:0] in_secded,
input [3:0] out_secded,
input       exp_1bit_error,
input       exp_2bit_error,
input       exp_parity_error );
begin: cmp_data

reg [6:0] exp_hamming74;

if (!exp_2bit_error) begin
        if ({in_secded, exp_1bit_error, exp_parity_error} === { out_secded, out_1bit_error, out_parity_error}) begin
            $display($time, " SUCCESS \t in_secded = %b, out_secded = %b, 1bit_error = %b, parity_error = %b | SECDED_IN = %b | SECDED_OUT = %b",
                             in_secded, out_secded, exp_1bit_error, exp_parity_error, in_secded, out_secded);
                             success_no = success_no +1;
            end else begin
              
				$display($time, " ERROR \t in_secded = %b, out_secded = %b, 1bit_error = %b, parity_error = %b  | SECDED_IN = %b | SECDED_OUT = %b", 
								  in_secded, out_secded, exp_1bit_error, exp_parity_error, in_secded, out_secded);
				error_no = error_no + 1;
			end
		    end else begin
			if (exp_2bit_error === out_2bit_error) begin
				$display($time, " SUCCESS \t in_secded = %b, out_secded = %b, 2bit_error = %b | SECDED_IN = %b | SECDED_OUT = %b", 
								  in_secded, out_secded, exp_2bit_error, in_secded, out_secded);
				success_no = success_no + 1;
			end else begin
				$display($time, " ERROR \t in_secded = %b, out_secded = %b, 2bit_error = %b | SECDED_IN = %b | SECDED_OUT = %b", 
								  in_secded, out_secded, exp_2bit_error, in_secded, out_secded);
				error_no = error_no + 1;
			end
		end
		test_no = test_no + 1;	
	end	: cmp_data		
	endtask          
endmodule
