// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 32-bit"
// VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Full Version"
// CREATED		"Sun Jan 19 15:34:09 2020"

module ram_conversion(
	clk,
	rst_n,
	wavelet_end,
	ram_data_input,
	wrreq,
	bit_out,
	cx_out,
	ram_read_address
);


input wire	clk;
input wire	rst_n;
input wire	wavelet_end;
input wire	[15:0] ram_data_input;
output wire	wrreq;
output wire	bit_out;
output wire	[3:0] cx_out;
output wire	[11:0] ram_read_address;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[15:0] SYNTHESIZED_WIRE_2;
wire	[15:0] SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	[15:0] SYNTHESIZED_WIRE_5;
wire	[15:0] SYNTHESIZED_WIRE_6;
wire	[15:0] SYNTHESIZED_WIRE_7;
wire	[15:0] SYNTHESIZED_WIRE_8;
wire	[15:0] SYNTHESIZED_WIRE_9;
wire	[15:0] SYNTHESIZED_WIRE_10;
wire	[2:0] SYNTHESIZED_WIRE_11;





ram_reader	b2v_inst(
	.clk(clk),
	.rst_n(rst_n),
	.bitplane_code_ready(SYNTHESIZED_WIRE_0),
	.wavelet_end(wavelet_end),
	.ram_data_input(ram_data_input),
	.bitplane_input_valid(SYNTHESIZED_WIRE_1),
	.bitplane_data0(SYNTHESIZED_WIRE_2),
	.bitplane_data1(SYNTHESIZED_WIRE_3),
	.bitplane_data2(SYNTHESIZED_WIRE_4),
	.bitplane_data3(SYNTHESIZED_WIRE_5),
	.bitplane_data4(SYNTHESIZED_WIRE_6),
	.bitplane_data5(SYNTHESIZED_WIRE_7),
	.bitplane_data6(SYNTHESIZED_WIRE_8),
	.bitplane_data7(SYNTHESIZED_WIRE_9),
	.bitplane_data8(SYNTHESIZED_WIRE_10),
	.ram_read_address(ram_read_address),
	.subband(SYNTHESIZED_WIRE_11));


bit_plane_coder	b2v_inst1(
	.clk(clk),
	.rst_n(rst_n),
	.input_valid(SYNTHESIZED_WIRE_1),
	.data0(SYNTHESIZED_WIRE_2),
	.data1(SYNTHESIZED_WIRE_3),
	.data2(SYNTHESIZED_WIRE_4),
	.data3(SYNTHESIZED_WIRE_5),
	.data4(SYNTHESIZED_WIRE_6),
	.data5(SYNTHESIZED_WIRE_7),
	.data6(SYNTHESIZED_WIRE_8),
	.data7(SYNTHESIZED_WIRE_9),
	.data8(SYNTHESIZED_WIRE_10),
	.subband(SYNTHESIZED_WIRE_11),
	.wrreq(wrreq),
	.bit_out(bit_out),
	.code_ready(SYNTHESIZED_WIRE_0),
	.cx_out(cx_out));


endmodule
