library verilog;
use verilog.vl_types.all;
entity lifted_wavelet_decomposition is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_valid      : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        line_address    : in     vl_logic_vector(7 downto 0);
        odd_address     : out    vl_logic_vector(15 downto 0);
        even_address    : out    vl_logic_vector(15 downto 0);
        data_out_odd    : out    vl_logic_vector(15 downto 0);
        data_out_even   : out    vl_logic_vector(15 downto 0);
        data_loading    : out    vl_logic;
        output_valid    : out    vl_logic;
        update_flag     : out    vl_logic
    );
end lifted_wavelet_decomposition;
