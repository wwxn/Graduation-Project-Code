library verilog;
use verilog.vl_types.all;
entity wavelet_transform is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        address_a_input : in     vl_logic_vector(11 downto 0);
        address_b_input : in     vl_logic_vector(11 downto 0);
        data_in_even    : in     vl_logic_vector(15 downto 0);
        data_in_odd     : in     vl_logic_vector(15 downto 0);
        end_flag        : out    vl_logic;
        ram_out_a       : out    vl_logic_vector(15 downto 0);
        ram_out_b       : out    vl_logic_vector(15 downto 0)
    );
end wavelet_transform;
