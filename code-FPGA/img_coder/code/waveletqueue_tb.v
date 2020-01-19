`timescale 1ns/1ns
module waveletqueue_tb();



reg [15:0] bit_input[0:15];
reg [3:0] address;
reg clk;
reg rst_n;
reg	wrreq;
 wire	[15:0] data_in_even=bit_input[(address)];
 wire	[15:0] data_in_odd=bit_input[(address)+1];
 wire	[7:0] line_address=8'd1;
 wire	output_valid;
 wire	[15:0] data_out_even;
 wire	[15:0] data_out_odd;
 wire	[11:0] even_address;
 wire	[11:0] odd_address;

reg[4:0] counter;

initial begin
	
	counter<=5'd0;
	bit_input[0]<=16'd0;
	bit_input[1]<=16'd225;
	bit_input[2]<=16'd74;
	bit_input[3]<=16'd150;
	bit_input[4]<=16'd204;
	bit_input[5]<=16'd142;
	bit_input[6]<=16'd240;
	bit_input[7]<=16'd242;
	bit_input[8]<=16'd225;
	bit_input[9]<=16'd82;
	bit_input[10]<=16'd289;
	bit_input[11]<=16'd62;
	bit_input[12]<=16'd127;
	bit_input[13]<=16'd126;
	bit_input[14]<=16'd226;
	bit_input[15]<=16'd27;
	rst_n<=1'b0;
	clk<=1'b1;
	#10 rst_n<=1'b1;
	address<=-4'd2;
	wrreq<=1'b1;
end


always#5 clk=~clk;

always@(posedge clk)
	if(!rst_n)
		address<=-4'd2;
	else if(counter>=4'd10)
		wrreq<=1'b0;
	else begin
		counter<=counter+1'b1;
		address<=address+2'd2;
	end


wavelet_queue  wavelet_queue_1
(
	clk,
	rst_n,
	wrreq,
	data_in_even,
	data_in_odd,
	line_address,
	output_valid,
	data_out_even,
	data_out_odd,
	even_address,
	odd_address
);

endmodule 