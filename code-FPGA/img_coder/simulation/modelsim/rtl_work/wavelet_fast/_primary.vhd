library verilog;
use verilog.vl_types.all;
entity wavelet_fast is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        LOAD            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        CAL             : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        CAL0            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        RESET           : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        STOP            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_valid      : in     vl_logic;
        data_in_odd     : in     vl_logic_vector(15 downto 0);
        data_in_even    : in     vl_logic_vector(15 downto 0);
        line_address    : in     vl_logic_vector(7 downto 0);
        wavelet_mode    : in     vl_logic;
        data_out_odd    : out    vl_logic_vector(15 downto 0);
        data_out_even   : out    vl_logic_vector(15 downto 0);
        data_loading    : out    vl_logic;
        output_valid    : out    vl_logic;
        odd_address     : out    vl_logic_vector(11 downto 0);
        even_address    : out    vl_logic_vector(11 downto 0);
        stop_flag       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of LOAD : constant is 1;
    attribute mti_svvh_generic_type of CAL : constant is 1;
    attribute mti_svvh_generic_type of CAL0 : constant is 1;
    attribute mti_svvh_generic_type of RESET : constant is 1;
    attribute mti_svvh_generic_type of STOP : constant is 1;
end wavelet_fast;
