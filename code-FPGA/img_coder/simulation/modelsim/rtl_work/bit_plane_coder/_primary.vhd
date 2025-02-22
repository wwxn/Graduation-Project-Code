library verilog;
use verilog.vl_types.all;
entity bit_plane_coder is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        subband         : in     vl_logic_vector(2 downto 0);
        data0           : in     vl_logic_vector(15 downto 0);
        data1           : in     vl_logic_vector(15 downto 0);
        data2           : in     vl_logic_vector(15 downto 0);
        data3           : in     vl_logic_vector(15 downto 0);
        data4           : in     vl_logic_vector(15 downto 0);
        data5           : in     vl_logic_vector(15 downto 0);
        data6           : in     vl_logic_vector(15 downto 0);
        data7           : in     vl_logic_vector(15 downto 0);
        data8           : in     vl_logic_vector(15 downto 0);
        input_valid     : in     vl_logic;
        wrreq           : out    vl_logic;
        bit_out         : out    vl_logic;
        cx_out          : out    vl_logic_vector(3 downto 0);
        code_ready      : out    vl_logic
    );
end bit_plane_coder;
