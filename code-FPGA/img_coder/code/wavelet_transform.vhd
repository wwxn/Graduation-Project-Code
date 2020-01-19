-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Full Version"
-- CREATED		"Thu Jan 16 20:06:25 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY wavelet_transform IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		rst_n :  IN  STD_LOGIC;
		data_in_even :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_in_odd :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END wavelet_transform;

ARCHITECTURE bdf_type OF wavelet_transform IS 

COMPONENT controller
	PORT(clk : IN STD_LOGIC;
		 rst_n : IN STD_LOGIC;
		 wavelet_stop_flag : IN STD_LOGIC;
		 data_in_even : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_in_odd : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ram_inst1_data_in_even : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ram_inst1_data_in_odd : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ram_inst2_data_in_even : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ram_inst2_data_in_odd : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wavlet_even_address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 wavlet_odd_address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 wavelet_rst : OUT STD_LOGIC;
		 wavlet_wrreq : OUT STD_LOGIC;
		 ram1_wren : OUT STD_LOGIC;
		 ram1_rden : OUT STD_LOGIC;
		 ram2_wren : OUT STD_LOGIC;
		 ram2_rden : OUT STD_LOGIC;
		 ram_address_a : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 ram_address_b : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 wavelet_data_even_input : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wavelet_data_odd_input : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wavelet_lineaddress : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT wavelet_queue
	PORT(clk : IN STD_LOGIC;
		 rst_n : IN STD_LOGIC;
		 wrreq : IN STD_LOGIC;
		 data_in_even : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_in_odd : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 line_address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 output_valid : OUT STD_LOGIC;
		 stop_flag : OUT STD_LOGIC;
		 data_out_even : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_out_odd : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 even_address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 odd_address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram
	PORT(aclr : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 rden_a : IN STD_LOGIC;
		 rden_b : IN STD_LOGIC;
		 wren_a : IN STD_LOGIC;
		 wren_b : IN STD_LOGIC;
		 address_a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 address_b : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 data_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q_a : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q_b : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 
SYNTHESIZED_WIRE_31 <= '1';



b2v_inst : controller
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 wavelet_stop_flag => SYNTHESIZED_WIRE_0,
		 data_in_even => data_in_even,
		 data_in_odd => data_in_odd,
		 ram_inst1_data_in_even => SYNTHESIZED_WIRE_1,
		 ram_inst1_data_in_odd => SYNTHESIZED_WIRE_2,
		 ram_inst2_data_in_even => SYNTHESIZED_WIRE_3,
		 ram_inst2_data_in_odd => SYNTHESIZED_WIRE_4,
		 wavlet_even_address => SYNTHESIZED_WIRE_5,
		 wavlet_odd_address => SYNTHESIZED_WIRE_6,
		 wavelet_rst => SYNTHESIZED_WIRE_7,
		 wavlet_wrreq => SYNTHESIZED_WIRE_8,
		 ram1_wren => SYNTHESIZED_WIRE_37,
		 ram1_rden => SYNTHESIZED_WIRE_36,
		 ram2_wren => SYNTHESIZED_WIRE_33,
		 ram2_rden => SYNTHESIZED_WIRE_32,
		 ram_address_a => SYNTHESIZED_WIRE_34,
		 ram_address_b => SYNTHESIZED_WIRE_35,
		 wavelet_data_even_input => SYNTHESIZED_WIRE_9,
		 wavelet_data_odd_input => SYNTHESIZED_WIRE_10,
		 wavelet_lineaddress => SYNTHESIZED_WIRE_11);


b2v_inst1 : wavelet_queue
PORT MAP(clk => clk,
		 rst_n => SYNTHESIZED_WIRE_7,
		 wrreq => SYNTHESIZED_WIRE_8,
		 data_in_even => SYNTHESIZED_WIRE_9,
		 data_in_odd => SYNTHESIZED_WIRE_10,
		 line_address => SYNTHESIZED_WIRE_11,
		 stop_flag => SYNTHESIZED_WIRE_0,
		 data_out_even => SYNTHESIZED_WIRE_29,
		 data_out_odd => SYNTHESIZED_WIRE_28,
		 even_address => SYNTHESIZED_WIRE_5,
		 odd_address => SYNTHESIZED_WIRE_6);


b2v_inst3 : ram
PORT MAP(aclr => SYNTHESIZED_WIRE_30,
		 clock => clk,
		 enable => SYNTHESIZED_WIRE_31,
		 rden_a => SYNTHESIZED_WIRE_32,
		 rden_b => SYNTHESIZED_WIRE_32,
		 wren_a => SYNTHESIZED_WIRE_33,
		 wren_b => SYNTHESIZED_WIRE_33,
		 address_a => SYNTHESIZED_WIRE_34,
		 address_b => SYNTHESIZED_WIRE_35,
		 q_a => SYNTHESIZED_WIRE_4,
		 q_b => SYNTHESIZED_WIRE_3);


SYNTHESIZED_WIRE_30 <= NOT(rst_n);




b2v_ram_inst1 : ram
PORT MAP(aclr => SYNTHESIZED_WIRE_30,
		 clock => clk,
		 enable => SYNTHESIZED_WIRE_31,
		 rden_a => SYNTHESIZED_WIRE_36,
		 rden_b => SYNTHESIZED_WIRE_36,
		 wren_a => SYNTHESIZED_WIRE_37,
		 wren_b => SYNTHESIZED_WIRE_37,
		 address_a => SYNTHESIZED_WIRE_34,
		 address_b => SYNTHESIZED_WIRE_35,
		 data_a => SYNTHESIZED_WIRE_28,
		 data_b => SYNTHESIZED_WIRE_29,
		 q_a => SYNTHESIZED_WIRE_2,
		 q_b => SYNTHESIZED_WIRE_1);


END bdf_type;