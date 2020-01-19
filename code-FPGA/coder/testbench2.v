`timescale 1ns/1ns


module testbench2();


reg clk;
reg rst_n;
reg [15:0] data_input_row0[24:0];
reg [15:0] data_input_row1[24:0];
reg [15:0] data_input_row2[24:0];
wire [2:0] coding_mode=3'd0;
reg[5:0] address=6'd0;
wire cal_flag=(address>=6'd2)?1'b1:1'b0;
wire [15:0] sum;
wire ram_update_flag;


initial begin
	$readmemb("test_row0.hex",data_input_row0);
	$readmemb("test_row1.hex",data_input_row1);
	$readmemb("test_row2.hex",data_input_row2);
//	test_address<=12'd1055;
	rst_n<=1'b1;
	#1 rst_n<=1'b0;
	#1 rst_n<=1'b1;
	clk<=1'b0;
//	#5 address<=16'd0;
end

always #5 clk<=~clk;


always@(posedge clk)
	if(ram_update_flag)
		address<=address+1'b1;


context_encoder context_encoder_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.data_input_row0(data_input_row0[address]),
	.data_input_row1(data_input_row1[address]),
	.data_input_row2(data_input_row2[address]),
	.cal_flag(cal_flag),
	.ram_update_flag(ram_update_flag)
);

endmodule 