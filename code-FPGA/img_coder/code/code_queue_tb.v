`timescale 1ns/1ns
module code_queue_tb();


reg	clk;
reg	rst_n;
reg	wrreq;
reg	bit_input[0:15];
reg	[3:0] cx_input[0:15];
wire	output_valid;
wire	[7:0] byte_out;

reg[3:0] address;

initial begin
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
	cx_input[0]<=4'd4;
	cx_input[1]<=4'd4;
	cx_input[2]<=4'd4;
	cx_input[3]<=4'd4;
	cx_input[4]<=4'd4;
	cx_input[5]<=4'd4;
	cx_input[6]<=4'd4;
	cx_input[7]<=4'd4;
	cx_input[8]<=4'd4;
	cx_input[9]<=4'd4;
	cx_input[10]<=4'd4;
	cx_input[11]<=4'd4;
	cx_input[12]<=4'd4;
	cx_input[13]<=4'd4;
	cx_input[14]<=4'd4;
	cx_input[15]<=4'd4;
	rst_n<=1'b0;
	clk<=1'b1;
	#2 rst_n<=1'b1;
	address<=-4'd1;
	wrreq<=1'b1;
end

always #5 clk<=~clk;

always@(posedge clk)
	if(!rst_n)
		address<=-4'd1;
	else
		address<=address+1'b1;


code_queue code_queue_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.wrreq(wrreq),
	.d_input(bit_input[address]),
	.cx_input(cx_input[address]),
	.output_valid(output_valid),
	.byte_out(byte_out)
);

endmodule 