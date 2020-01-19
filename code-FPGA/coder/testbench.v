`timescale 1ns/1ns
module testbench();

parameter PIC_SIZE=16'd4096;

reg clk;
reg rst_n;
reg [7:0] pic_memory [PIC_SIZE-1:0];
reg [15:0] address;
reg [11:0] test_address;
wire data_in_ready;
wire [7:0] shiftin=pic_memory[address];

initial begin
	$readmemb("pic.hex",pic_memory);
	test_address<=12'd1055;
	rst_n<=1'b1;
	#1 rst_n<=1'b0;
	#1 rst_n<=1'b1;
	clk<=1'b0;
	#5 address<=16'd0;
end

always #5 clk<=~clk;

always@(posedge clk)
	if (address>=16'd4096)
		address<=16'd0;
	else if(data_in_ready)
		address<=address+1'b1;
	else
		address<=address;


img_coding img_coding_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.data_input(16'd0+shiftin),
	.data_in_ready(data_in_ready)
	
);



endmodule
