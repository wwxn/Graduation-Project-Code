library verilog;
use verilog.vl_types.all;
entity ram_conversion is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        wavelet_end     : in     vl_logic;
        ram_data_input  : in     vl_logic_vector(15 downto 0);
        wrreq           : out    vl_logic;
        bit_out         : out    vl_logic;
        cx_out          : out    vl_logic_vector(3 downto 0);
        ram_read_address: out    vl_logic_vector(11 downto 0)
    );
end ram_conversion;
