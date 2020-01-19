`timescale 1ns/1ns

module bit_plane_coder_tb();

localparam LL=3'd0;
localparam HL1=3'd1;
localparam HL2=3'd2;
localparam LH1=3'd3;
localparam LH2=3'd4;
localparam HH1=3'd5;
localparam HH2=3'd6;

reg clk;
reg rst_n;
reg [2:0] subband;
wire [15:0] data0=16'd50;
wire [15:0] data1=16'd211;
wire [15:0] data2=16'd150;
wire [15:0] data3=16'd54;
wire [15:0] data4=16'd241;
wire [15:0] data5=16'd156;
wire [15:0] data6=16'd52;
wire [15:0] data7=16'd242;
wire [15:0] data8=16'd117;
reg input_valid;
wire bit_out;
wire [3:0] cx_out;
wire wrreq;
wire code_ready;


initial	begin
	input_valid<=1'b0;
	clk<=1'b0;
	rst_n<=1'b0;
	#2 rst_n<=1'b1;
	subband<=LL;
	#13 input_valid<=1'b1;
	#10 input_valid<=1'b0;
	#100 subband<=HL2;
	input_valid<=1'b1;
	#10 input_valid<=1'b0;
end

always #5 clk=~clk;



bit_plane_coder bit_plane_coder_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.subband(subband),
	.data0(data0),
	.data1(data1),
	.data2(data2),
	.data3(data3),
	.data4(data4),
	.data5(data5),
	.data6(data6),
	.data7(data7),
	.data8(data8),
	.input_valid(input_valid),
	.bit_out(bit_out),
	.cx_out(cx_out),
	.wrreq(wrreq),
	.code_ready(code_ready)
);

endmodule 