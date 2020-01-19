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
// CREATED		"Fri Jan 17 14:53:22 2020"

module wavelet_queue(
	clk,
	rst_n,
	wrreq,
	wavelet_mode,
	data_in_even,
	data_in_odd,
	line_address,
	output_valid,
	stop_flag,
	data_out_even,
	data_out_odd,
	even_address,
	odd_address
);


input wire	clk;
input wire	rst_n;
input wire	wrreq;
input wire	wavelet_mode;
input wire	[15:0] data_in_even;
input wire	[15:0] data_in_odd;
input wire	[7:0] line_address;
output wire	output_valid;
output wire	stop_flag;
output wire	[15:0] data_out_even;
output wire	[15:0] data_out_odd;
output wire	[11:0] even_address;
output wire	[11:0] odd_address;

wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_4;
wire	[15:0] SYNTHESIZED_WIRE_5;
wire	[15:0] SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
reg	DFF_inst3;

assign	SYNTHESIZED_WIRE_7 = 1;
assign	SYNTHESIZED_WIRE_9 = 1;




fifo	b2v_fifo_even(
	.aclr(SYNTHESIZED_WIRE_10),
	.clock(clk),
	.rdreq(SYNTHESIZED_WIRE_11),
	.wrreq(wrreq),
	.data(data_in_even),
	.empty(SYNTHESIZED_WIRE_8),
	
	.q(SYNTHESIZED_WIRE_5));


fifo	b2v_fifo_odd(
	.aclr(SYNTHESIZED_WIRE_10),
	.clock(clk),
	.rdreq(SYNTHESIZED_WIRE_11),
	.wrreq(wrreq),
	.data(data_in_odd),
	
	
	.q(SYNTHESIZED_WIRE_6));


wavelet_fast	b2v_inst(
	.clk(clk),
	.rst_n(rst_n),
	.data_valid(SYNTHESIZED_WIRE_4),
	.wavelet_mode(wavelet_mode),
	.data_in_even(SYNTHESIZED_WIRE_5),
	.data_in_odd(SYNTHESIZED_WIRE_6),
	.line_address(line_address),
	.data_loading(SYNTHESIZED_WIRE_11),
	.output_valid(output_valid),
	.stop_flag(stop_flag),
	.data_out_even(data_out_even),
	.data_out_odd(data_out_odd),
	.even_address(even_address),
	.odd_address(odd_address));
	defparam	b2v_inst.CAL = 2'b11;
	defparam	b2v_inst.CAL0 = 2'b10;
	defparam	b2v_inst.IDLE = 2'b00;
	defparam	b2v_inst.LOAD = 2'b01;
	defparam	b2v_inst.RESET = 3'b110;
	defparam	b2v_inst.STOP = 3'b100;

assign	SYNTHESIZED_WIRE_10 =  ~rst_n;


always@(posedge clk or negedge SYNTHESIZED_WIRE_7 or negedge SYNTHESIZED_WIRE_9)
begin
if (!SYNTHESIZED_WIRE_7)
	begin
	DFF_inst3 <= 0;
	end
else
if (!SYNTHESIZED_WIRE_9)
	begin
	DFF_inst3 <= 1;
	end
else
	begin
	DFF_inst3 <= SYNTHESIZED_WIRE_8;
	end
end

assign	SYNTHESIZED_WIRE_4 =  ~DFF_inst3;




endmodule
