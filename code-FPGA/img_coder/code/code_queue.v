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
// CREATED		"Sat Jan 18 12:55:45 2020"

module code_queue(
	clk,
	rst_n,
	wrreq,
	d_input,
	cx_input,
	output_valid,
	byte_out
);


input wire	clk;
input wire	rst_n;
input wire	wrreq;
input wire	d_input;
input wire	[3:0] cx_input;
output wire	output_valid;
output wire	[7:0] byte_out;

wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
reg	DFF_inst;
wire	[0:0] SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	[3:0] SYNTHESIZED_WIRE_9;

assign	SYNTHESIZED_WIRE_4 = 1;
assign	SYNTHESIZED_WIRE_6 = 1;




bit_fifo	b2v_bit_fifo_inst1(
	.aclr(SYNTHESIZED_WIRE_10),
	.clock(clk),
	.rdreq(SYNTHESIZED_WIRE_11),
	.wrreq(wrreq),
	.data(d_input),
	
	
	.q(SYNTHESIZED_WIRE_7));


cx_fifo	b2v_cx_fifo_inst1(
	.aclr(SYNTHESIZED_WIRE_10),
	.clock(clk),
	.rdreq(SYNTHESIZED_WIRE_11),
	.wrreq(wrreq),
	.data(cx_input),
	.empty(SYNTHESIZED_WIRE_5),
	
	.q(SYNTHESIZED_WIRE_9));


always@(posedge clk or negedge SYNTHESIZED_WIRE_4 or negedge SYNTHESIZED_WIRE_6)
begin
if (!SYNTHESIZED_WIRE_4)
	begin
	DFF_inst <= 0;
	end
else
if (!SYNTHESIZED_WIRE_6)
	begin
	DFF_inst <= 1;
	end
else
	begin
	DFF_inst <= SYNTHESIZED_WIRE_5;
	end
end



assign	SYNTHESIZED_WIRE_10 =  ~rst_n;

assign	SYNTHESIZED_WIRE_8 =  ~DFF_inst;


mq_coder	b2v_mqcoder_inst1(
	.clk(clk),
	.rst_n(rst_n),
	.bit(SYNTHESIZED_WIRE_7),
	.input_valid(SYNTHESIZED_WIRE_8),
	.cx(SYNTHESIZED_WIRE_9),
	.update_flag(SYNTHESIZED_WIRE_11),
	.output_valid(output_valid),
	.byte_out(byte_out));
	defparam	b2v_mqcoder_inst1.IDLE = 2'b00;
	defparam	b2v_mqcoder_inst1.RENORME1 = 2'b11;
	defparam	b2v_mqcoder_inst1.RENORME2 = 2'b10;
	defparam	b2v_mqcoder_inst1.UPDATE = 2'b01;


endmodule
