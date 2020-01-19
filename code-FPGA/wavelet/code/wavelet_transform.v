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
// CREATED		"Fri Jan 17 17:07:03 2020"

module wavelet_transform(
	clk,
	rst_n,
	address_a_input,
	address_b_input,
	data_in_even,
	data_in_odd,
	end_flag,
	ram_out_a,
	ram_out_b
);


input wire	clk;
input wire	rst_n;
input wire	[11:0] address_a_input;
input wire	[11:0] address_b_input;
input wire	[15:0] data_in_even;
input wire	[15:0] data_in_odd;
output wire	end_flag;
output wire	[15:0] ram_out_a;
output wire	[15:0] ram_out_b;

wire	SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;
wire	[15:0] SYNTHESIZED_WIRE_2;
wire	[15:0] SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	[11:0] SYNTHESIZED_WIRE_5;
wire	[11:0] SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_33;
wire	SYNTHESIZED_WIRE_34;
wire	SYNTHESIZED_WIRE_35;
wire	SYNTHESIZED_WIRE_36;
wire	[11:0] SYNTHESIZED_WIRE_13;
wire	[11:0] SYNTHESIZED_WIRE_14;
wire	[15:0] SYNTHESIZED_WIRE_37;
wire	[15:0] SYNTHESIZED_WIRE_38;
wire	SYNTHESIZED_WIRE_39;
wire	SYNTHESIZED_WIRE_40;
wire	[11:0] SYNTHESIZED_WIRE_23;
wire	[11:0] SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_29;
wire	[15:0] SYNTHESIZED_WIRE_30;
wire	[15:0] SYNTHESIZED_WIRE_31;
wire	[7:0] SYNTHESIZED_WIRE_32;

assign	ram_out_a = SYNTHESIZED_WIRE_4;
assign	ram_out_b = SYNTHESIZED_WIRE_3;
assign	SYNTHESIZED_WIRE_34 = 1;




controller	b2v_controller_inst1(
	.clk(clk),
	.rst_n(rst_n),
	.wavelet_stop_flag(SYNTHESIZED_WIRE_0),
	.address_a_input(address_a_input),
	.address_b_input(address_b_input),
	.data_in_even(data_in_even),
	.data_in_odd(data_in_odd),
	.ram_inst1_data_in_even(SYNTHESIZED_WIRE_1),
	.ram_inst1_data_in_odd(SYNTHESIZED_WIRE_2),
	.ram_inst2_data_in_even(SYNTHESIZED_WIRE_3),
	.ram_inst2_data_in_odd(SYNTHESIZED_WIRE_4),
	.wavlet_even_address(SYNTHESIZED_WIRE_5),
	.wavlet_odd_address(SYNTHESIZED_WIRE_6),
	.wavelet_rst(SYNTHESIZED_WIRE_27),
	.wavlet_wrreq(SYNTHESIZED_WIRE_28),
	.ram1_wren(SYNTHESIZED_WIRE_36),
	.ram1_rden(SYNTHESIZED_WIRE_35),
	.ram2_wren(SYNTHESIZED_WIRE_40),
	.ram2_rden(SYNTHESIZED_WIRE_39),
	.wavelet_mode(SYNTHESIZED_WIRE_29),
	.end_flag(end_flag),
	.ram1_address_a(SYNTHESIZED_WIRE_13),
	.ram1_address_b(SYNTHESIZED_WIRE_14),
	.ram2_address_a(SYNTHESIZED_WIRE_23),
	.ram2_address_b(SYNTHESIZED_WIRE_24),
	.wavelet_data_even_input(SYNTHESIZED_WIRE_30),
	.wavelet_data_odd_input(SYNTHESIZED_WIRE_31),
	.wavelet_lineaddress(SYNTHESIZED_WIRE_32));

assign	SYNTHESIZED_WIRE_33 =  ~rst_n;



ram	b2v_ram_inst1(
	.aclr(SYNTHESIZED_WIRE_33),
	.clock(clk),
	.enable(SYNTHESIZED_WIRE_34),
	.rden_a(SYNTHESIZED_WIRE_35),
	.rden_b(SYNTHESIZED_WIRE_35),
	.wren_a(SYNTHESIZED_WIRE_36),
	.wren_b(SYNTHESIZED_WIRE_36),
	.address_a(SYNTHESIZED_WIRE_13),
	.address_b(SYNTHESIZED_WIRE_14),
	.data_a(SYNTHESIZED_WIRE_37),
	.data_b(SYNTHESIZED_WIRE_38),
	.q_a(SYNTHESIZED_WIRE_2),
	.q_b(SYNTHESIZED_WIRE_1));


ram	b2v_ram_inst2(
	.aclr(SYNTHESIZED_WIRE_33),
	.clock(clk),
	.enable(SYNTHESIZED_WIRE_34),
	.rden_a(SYNTHESIZED_WIRE_39),
	.rden_b(SYNTHESIZED_WIRE_39),
	.wren_a(SYNTHESIZED_WIRE_40),
	.wren_b(SYNTHESIZED_WIRE_40),
	.address_a(SYNTHESIZED_WIRE_23),
	.address_b(SYNTHESIZED_WIRE_24),
	.data_a(SYNTHESIZED_WIRE_37),
	.data_b(SYNTHESIZED_WIRE_38),
	.q_a(SYNTHESIZED_WIRE_4),
	.q_b(SYNTHESIZED_WIRE_3));


wavelet_queue	b2v_wavelet_queue_inst1(
	.clk(clk),
	.rst_n(SYNTHESIZED_WIRE_27),
	.wrreq(SYNTHESIZED_WIRE_28),
	.wavelet_mode(SYNTHESIZED_WIRE_29),
	.data_in_even(SYNTHESIZED_WIRE_30),
	.data_in_odd(SYNTHESIZED_WIRE_31),
	.line_address(SYNTHESIZED_WIRE_32),
	
	.stop_flag(SYNTHESIZED_WIRE_0),
	.data_out_even(SYNTHESIZED_WIRE_38),
	.data_out_odd(SYNTHESIZED_WIRE_37),
	.even_address(SYNTHESIZED_WIRE_5),
	.odd_address(SYNTHESIZED_WIRE_6));


endmodule
