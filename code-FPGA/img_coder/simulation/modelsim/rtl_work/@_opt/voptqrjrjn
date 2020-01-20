library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_in_odd     : in     vl_logic_vector(15 downto 0);
        data_in_even    : in     vl_logic_vector(15 downto 0);
        ram_inst1_data_in_odd: in     vl_logic_vector(15 downto 0);
        ram_inst1_data_in_even: in     vl_logic_vector(15 downto 0);
        ram_inst2_data_in_odd: in     vl_logic_vector(15 downto 0);
        ram_inst2_data_in_even: in     vl_logic_vector(15 downto 0);
        wavlet_odd_address: in     vl_logic_vector(11 downto 0);
        wavlet_even_address: in     vl_logic_vector(11 downto 0);
        wavelet_stop_flag: in     vl_logic;
        address_a_input : in     vl_logic_vector(11 downto 0);
        address_b_input : in     vl_logic_vector(11 downto 0);
        wavelet_rst     : out    vl_logic;
        wavelet_data_odd_input: out    vl_logic_vector(15 downto 0);
        wavelet_data_even_input: out    vl_logic_vector(15 downto 0);
        wavlet_wrreq    : out    vl_logic;
        wavelet_lineaddress: out    vl_logic_vector(7 downto 0);
        ram1_wren       : out    vl_logic;
        ram1_rden       : out    vl_logic;
        ram2_wren       : out    vl_logic;
        ram2_rden       : out    vl_logic;
        ram1_address_a  : out    vl_logic_vector(11 downto 0);
        ram1_address_b  : out    vl_logic_vector(11 downto 0);
        ram2_address_a  : out    vl_logic_vector(11 downto 0);
        ram2_address_b  : out    vl_logic_vector(11 downto 0);
        wavelet_mode    : out    vl_logic;
        end_flag        : out    vl_logic
    );
end controller;
