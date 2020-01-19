library verilog;
use verilog.vl_types.all;
entity img_coder is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_in_even    : in     vl_logic_vector(15 downto 0);
        data_in_odd     : in     vl_logic_vector(15 downto 0);
        output_valid    : out    vl_logic;
        byte_out        : out    vl_logic_vector(7 downto 0)
    );
end img_coder;
