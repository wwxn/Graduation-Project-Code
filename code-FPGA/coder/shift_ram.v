// megafunction wizard: %Shift register (RAM-based)%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTSHIFT_TAPS 

// ============================================================
// File Name: shift_ram.v
// Megafunction Name(s):
// 			ALTSHIFT_TAPS
//
// Simulation Library Files(s):
// 			
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.1.0 Build 162 10/23/2013 SJ Full Version
// ************************************************************


//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module shift_ram (
	aclr,
	clken,
	clock,
	shiftin,
	shiftout,
	taps0x,
	taps10x,
	taps11x,
	taps12x,
	taps13x,
	taps14x,
	taps15x,
	taps1x,
	taps2x,
	taps3x,
	taps4x,
	taps5x,
	taps6x,
	taps7x,
	taps8x,
	taps9x);

	input	  aclr;
	input	  clken;
	input	  clock;
	input	[15:0]  shiftin;
	output	[15:0]  shiftout;
	output	[15:0]  taps0x;
	output	[15:0]  taps10x;
	output	[15:0]  taps11x;
	output	[15:0]  taps12x;
	output	[15:0]  taps13x;
	output	[15:0]  taps14x;
	output	[15:0]  taps15x;
	output	[15:0]  taps1x;
	output	[15:0]  taps2x;
	output	[15:0]  taps3x;
	output	[15:0]  taps4x;
	output	[15:0]  taps5x;
	output	[15:0]  taps6x;
	output	[15:0]  taps7x;
	output	[15:0]  taps8x;
	output	[15:0]  taps9x;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  aclr;
	tri1	  clken;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [255:0] sub_wire0;
	wire [15:0] sub_wire9;
	wire [95:80] sub_wire31 = sub_wire0[95:80];
	wire [239:224] sub_wire30 = sub_wire0[239:224];
	wire [239:224] sub_wire29 = sub_wire30[239:224];
	wire [79:64] sub_wire28 = sub_wire0[79:64];
	wire [79:64] sub_wire27 = sub_wire28[79:64];
	wire [223:208] sub_wire26 = sub_wire0[223:208];
	wire [223:208] sub_wire25 = sub_wire26[223:208];
	wire [127:112] sub_wire24 = sub_wire0[127:112];
	wire [127:112] sub_wire23 = sub_wire24[127:112];
	wire [63:48] sub_wire22 = sub_wire0[63:48];
	wire [63:48] sub_wire21 = sub_wire22[63:48];
	wire [207:192] sub_wire20 = sub_wire0[207:192];
	wire [207:192] sub_wire19 = sub_wire20[207:192];
	wire [111:96] sub_wire18 = sub_wire0[111:96];
	wire [111:96] sub_wire17 = sub_wire18[111:96];
	wire [47:32] sub_wire16 = sub_wire0[47:32];
	wire [47:32] sub_wire15 = sub_wire16[47:32];
	wire [255:240] sub_wire14 = sub_wire0[255:240];
	wire [255:240] sub_wire13 = sub_wire14[255:240];
	wire [191:176] sub_wire12 = sub_wire0[191:176];
	wire [191:176] sub_wire11 = sub_wire12[191:176];
	wire [159:144] sub_wire10 = sub_wire0[159:144];
	wire [159:144] sub_wire8 = sub_wire10[159:144];
	wire [31:16] sub_wire7 = sub_wire0[31:16];
	wire [31:16] sub_wire6 = sub_wire7[31:16];
	wire [175:160] sub_wire5 = sub_wire0[175:160];
	wire [175:160] sub_wire4 = sub_wire5[175:160];
	wire [143:128] sub_wire3 = sub_wire0[143:128];
	wire [143:128] sub_wire2 = sub_wire3[143:128];
	wire [15:0] sub_wire1 = sub_wire0[15:0];
	wire [15:0] taps0x = sub_wire1[15:0];
	wire [15:0] taps8x = sub_wire2[143:128];
	wire [15:0] taps10x = sub_wire4[175:160];
	wire [15:0] taps1x = sub_wire6[31:16];
	wire [15:0] taps9x = sub_wire8[159:144];
	wire [15:0] shiftout = sub_wire9[15:0];
	wire [15:0] taps11x = sub_wire11[191:176];
	wire [15:0] taps15x = sub_wire13[255:240];
	wire [15:0] taps2x = sub_wire15[47:32];
	wire [15:0] taps6x = sub_wire17[111:96];
	wire [15:0] taps12x = sub_wire19[207:192];
	wire [15:0] taps3x = sub_wire21[63:48];
	wire [15:0] taps7x = sub_wire23[127:112];
	wire [15:0] taps13x = sub_wire25[223:208];
	wire [15:0] taps4x = sub_wire27[79:64];
	wire [15:0] taps14x = sub_wire29[239:224];
	wire [15:0] taps5x = sub_wire31[95:80];

	altshift_taps	ALTSHIFT_TAPS_component (
				.aclr (aclr),
				.clock (clock),
				.clken (clken),
				.shiftin (shiftin),
				.taps (sub_wire0),
				.shiftout (sub_wire9));
	defparam
		ALTSHIFT_TAPS_component.intended_device_family = "Cyclone IV E",
		ALTSHIFT_TAPS_component.lpm_hint = "RAM_BLOCK_TYPE=M9K",
		ALTSHIFT_TAPS_component.lpm_type = "altshift_taps",
		ALTSHIFT_TAPS_component.number_of_taps = 16,
		ALTSHIFT_TAPS_component.tap_distance = 64,
		ALTSHIFT_TAPS_component.width = 16;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ACLR NUMERIC "1"
// Retrieval info: PRIVATE: CLKEN NUMERIC "1"
// Retrieval info: PRIVATE: GROUP_TAPS NUMERIC "1"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: NUMBER_OF_TAPS NUMERIC "16"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: TAP_DISTANCE NUMERIC "64"
// Retrieval info: PRIVATE: WIDTH NUMERIC "16"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: CONSTANT: LPM_HINT STRING "RAM_BLOCK_TYPE=M9K"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altshift_taps"
// Retrieval info: CONSTANT: NUMBER_OF_TAPS NUMERIC "16"
// Retrieval info: CONSTANT: TAP_DISTANCE NUMERIC "64"
// Retrieval info: CONSTANT: WIDTH NUMERIC "16"
// Retrieval info: USED_PORT: aclr 0 0 0 0 INPUT VCC "aclr"
// Retrieval info: USED_PORT: clken 0 0 0 0 INPUT VCC "clken"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: shiftin 0 0 16 0 INPUT NODEFVAL "shiftin[15..0]"
// Retrieval info: USED_PORT: shiftout 0 0 16 0 OUTPUT NODEFVAL "shiftout[15..0]"
// Retrieval info: USED_PORT: taps0x 0 0 16 0 OUTPUT NODEFVAL "taps0x[15..0]"
// Retrieval info: USED_PORT: taps10x 0 0 16 0 OUTPUT NODEFVAL "taps10x[15..0]"
// Retrieval info: USED_PORT: taps11x 0 0 16 0 OUTPUT NODEFVAL "taps11x[15..0]"
// Retrieval info: USED_PORT: taps12x 0 0 16 0 OUTPUT NODEFVAL "taps12x[15..0]"
// Retrieval info: USED_PORT: taps13x 0 0 16 0 OUTPUT NODEFVAL "taps13x[15..0]"
// Retrieval info: USED_PORT: taps14x 0 0 16 0 OUTPUT NODEFVAL "taps14x[15..0]"
// Retrieval info: USED_PORT: taps15x 0 0 16 0 OUTPUT NODEFVAL "taps15x[15..0]"
// Retrieval info: USED_PORT: taps1x 0 0 16 0 OUTPUT NODEFVAL "taps1x[15..0]"
// Retrieval info: USED_PORT: taps2x 0 0 16 0 OUTPUT NODEFVAL "taps2x[15..0]"
// Retrieval info: USED_PORT: taps3x 0 0 16 0 OUTPUT NODEFVAL "taps3x[15..0]"
// Retrieval info: USED_PORT: taps4x 0 0 16 0 OUTPUT NODEFVAL "taps4x[15..0]"
// Retrieval info: USED_PORT: taps5x 0 0 16 0 OUTPUT NODEFVAL "taps5x[15..0]"
// Retrieval info: USED_PORT: taps6x 0 0 16 0 OUTPUT NODEFVAL "taps6x[15..0]"
// Retrieval info: USED_PORT: taps7x 0 0 16 0 OUTPUT NODEFVAL "taps7x[15..0]"
// Retrieval info: USED_PORT: taps8x 0 0 16 0 OUTPUT NODEFVAL "taps8x[15..0]"
// Retrieval info: USED_PORT: taps9x 0 0 16 0 OUTPUT NODEFVAL "taps9x[15..0]"
// Retrieval info: CONNECT: @aclr 0 0 0 0 aclr 0 0 0 0
// Retrieval info: CONNECT: @clken 0 0 0 0 clken 0 0 0 0
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @shiftin 0 0 16 0 shiftin 0 0 16 0
// Retrieval info: CONNECT: shiftout 0 0 16 0 @shiftout 0 0 16 0
// Retrieval info: CONNECT: taps0x 0 0 16 0 @taps 0 0 16 0
// Retrieval info: CONNECT: taps10x 0 0 16 0 @taps 0 0 16 160
// Retrieval info: CONNECT: taps11x 0 0 16 0 @taps 0 0 16 176
// Retrieval info: CONNECT: taps12x 0 0 16 0 @taps 0 0 16 192
// Retrieval info: CONNECT: taps13x 0 0 16 0 @taps 0 0 16 208
// Retrieval info: CONNECT: taps14x 0 0 16 0 @taps 0 0 16 224
// Retrieval info: CONNECT: taps15x 0 0 16 0 @taps 0 0 16 240
// Retrieval info: CONNECT: taps1x 0 0 16 0 @taps 0 0 16 16
// Retrieval info: CONNECT: taps2x 0 0 16 0 @taps 0 0 16 32
// Retrieval info: CONNECT: taps3x 0 0 16 0 @taps 0 0 16 48
// Retrieval info: CONNECT: taps4x 0 0 16 0 @taps 0 0 16 64
// Retrieval info: CONNECT: taps5x 0 0 16 0 @taps 0 0 16 80
// Retrieval info: CONNECT: taps6x 0 0 16 0 @taps 0 0 16 96
// Retrieval info: CONNECT: taps7x 0 0 16 0 @taps 0 0 16 112
// Retrieval info: CONNECT: taps8x 0 0 16 0 @taps 0 0 16 128
// Retrieval info: CONNECT: taps9x 0 0 16 0 @taps 0 0 16 144
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_ram.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_ram.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_ram.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_ram.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_ram_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL shift_ram_bb.v TRUE
