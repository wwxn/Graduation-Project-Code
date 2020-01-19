`timescale 1ns/1ns
module wavelet_transform_tb();

reg	clk;
reg	rst_n;
parameter PIC_SIZE=16'd4096;
reg [7:0] pic_memory [PIC_SIZE-1:0];
wire [15:0] address;
wire [7:0] shiftin_odd=pic_memory[address+1];
wire [7:0] shiftin_even=pic_memory[address];

reg [5:0] line_address;
reg [5:0] row_address;

assign address=line_address*64+row_address;
reg[5:0] data_in_counter;

initial begin
	
	$readmemb("pic.hex",pic_memory);
	
	rst_n<=1'b0;
	clk<=1'b1;
	#2 rst_n<=1'b1;
	line_address<=6'd0;
	row_address<=-6'd2;
	data_in_counter<=6'd0;
end

always #5 clk<=~clk;

always@(posedge clk)
	if(data_in_counter>=6'd33)begin
		data_in_counter<=6'd0;
		row_address<=-6'd2;
		line_address<=line_address+1'b1;
	end
	else begin
		data_in_counter<=data_in_counter+1'b1;
		row_address<=row_address+2'd2;
	end


wavelet_transform wavelet_transform_1
(
	.clk(clk),
	.rst_n(rst_n),
	.data_in_even(16'd0+shiftin_even),
	.data_in_odd(16'd0+shiftin_odd)
);

endmodule 