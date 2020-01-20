library verilog;
use verilog.vl_types.all;
entity wavelet_queue is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        wrreq           : in     vl_logic;
        wavelet_mode    : in     vl_logic;
        data_in_even    : in     vl_logic_vector(15 downto 0);
        data_in_odd     : in     vl_logic_vector(15 downto 0);
        line_address    : in     vl_logic_vector(7 downto 0);
        output_valid    : out    vl_logic;
        stop_flag       : out    vl_logic;
        data_out_even   : out    vl_logic_vector(15 downto 0);
        data_out_odd    : out    vl_logic_vector(15 downto 0);
        even_address    : out    vl_logic_vector(11 downto 0);
        odd_address     : out    vl_logic_vector(11 downto 0)
    );
end wavelet_queue;