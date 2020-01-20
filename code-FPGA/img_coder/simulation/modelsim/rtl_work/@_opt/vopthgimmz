library verilog;
use verilog.vl_types.all;
entity ram_reader is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        bitplane_code_ready: in     vl_logic;
        wavelet_end     : in     vl_logic;
        ram_data_input  : in     vl_logic_vector(15 downto 0);
        ram_read_address: out    vl_logic_vector(11 downto 0);
        subband         : out    vl_logic_vector(2 downto 0);
        bitplane_data0  : out    vl_logic_vector(15 downto 0);
        bitplane_data1  : out    vl_logic_vector(15 downto 0);
        bitplane_data2  : out    vl_logic_vector(15 downto 0);
        bitplane_data3  : out    vl_logic_vector(15 downto 0);
        bitplane_data4  : out    vl_logic_vector(15 downto 0);
        bitplane_data5  : out    vl_logic_vector(15 downto 0);
        bitplane_data6  : out    vl_logic_vector(15 downto 0);
        bitplane_data7  : out    vl_logic_vector(15 downto 0);
        bitplane_data8  : out    vl_logic_vector(15 downto 0);
        bitplane_input_valid: out    vl_logic
    );
end ram_reader;
