`timescale 1ns/1ns
module encoder_testbench();


reg clk;
reg rst_n;
reg bit_input[15:0];
reg wrreq;
reg update_flag;
reg[3:0] address;

initial begin
	update_flag<=1'b0;
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
	clk<=1'b0;
	rst_n<=1'b1;
	
	
	#1 rst_n<=1'b0;
	#1 rst_n<=1'b1;
	#98 update_flag<=1'b1;
	wrreq<=1'b1;
	address<=4'd0;
end

always#5 clk<=~clk;

always@(posedge clk)
	if(update_flag)
		if(address<4'd15)
			address<=address+1'b1;
		else begin
			address<=address;
			wrreq<=1'b0;
		end
	
	
coding_queue coding_queue_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.bit_input(bit_input[address]),
	.wrreq(wrreq)
);



endmodule 

