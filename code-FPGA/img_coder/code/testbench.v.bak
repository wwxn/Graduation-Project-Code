`timescale 1ns/1ns
module testbench();

reg clk;
reg rst_n;
reg bit_input[0:15];
wire [3:0] cx_input=4'd4;
wire [7:0] byte_output;
wire update_flag;
reg [3:0] address;
wire output_valid;

initial begin
	address<=4'b0;
	bit_input[0]<=1'b0;
	bit_input[1]<=1'b0;
	bit_input[2]<=1'b1;
	bit_input[3]<=1'b1;
	bit_input[4]<=1'b1;
	bit_input[5]<=1'b1;
	bit_input[6]<=1'b0;
	bit_input[7]<=1'b0;
	bit_input[8]<=1'b0;
	bit_input[9]<=1'b0;
	bit_input[10]<=1'b0;
	bit_input[11]<=1'b0;
	bit_input[12]<=1'b1;
	bit_input[13]<=1'b1;
	bit_input[14]<=1'b1;
	bit_input[15]<=1'b1;
	rst_n<=1'b0;
	clk<=1'b1;
	#10 rst_n<=1'b1;
end

always #2 clk<=~clk;

always@(posedge clk)
	if(!rst_n)
		address<=-4'd1;
	else if(update_flag)
		address<=address+1'b1;
	else
		address<=address;

mq_coder m1
(
	.clk(clk),
	.rst_n(rst_n),
	.bit(bit_input[address]),
	.cx(cx_input),
	.update_flag(update_flag),
	.byte_out(byte_output),
	.output_valid(output_valid)
);

endmodule 