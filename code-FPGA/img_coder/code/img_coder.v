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
// CREATED		"Sun Jan 19 15:38:28 2020"

module img_coder(
	clk,
	rst_n,
	data_in_even,
	data_in_odd,
	output_valid,
	byte_out
);


input wire	clk;
input wire	rst_n;
input wire	[15:0] data_in_even;
input wire	[15:0] data_in_odd;
output wire	output_valid;
output wire	[7:0] byte_out;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[3:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	[11:0] SYNTHESIZED_WIRE_5;





code_queue	b2v_code_queue_inst1(
	.clk(clk),
	.rst_n(rst_n),
	.wrreq(SYNTHESIZED_WIRE_0),
	.d_input(SYNTHESIZED_WIRE_1),
	.cx_input(SYNTHESIZED_WIRE_2),
	.output_valid(output_valid),
	.byte_out(byte_out));


ram_conversion	b2v_inst(
	.clk(clk),
	.rst_n(rst_n),
	.wavelet_end(SYNTHESIZED_WIRE_3),
	.ram_data_input(SYNTHESIZED_WIRE_4),
	.wrreq(SYNTHESIZED_WIRE_0),
	.bit_out(SYNTHESIZED_WIRE_1),
	.cx_out(SYNTHESIZED_WIRE_2),
	.ram_read_address(SYNTHESIZED_WIRE_5));


wavelet_transform	b2v_wavlet_transform_inst1(
	.clk(clk),
	.rst_n(rst_n),
	.address_a_input(SYNTHESIZED_WIRE_5),
	
	.data_in_even(data_in_even),
	.data_in_odd(data_in_odd),
	.end_flag(SYNTHESIZED_WIRE_3),
	.ram_out_a(SYNTHESIZED_WIRE_4)
	);


endmodule
