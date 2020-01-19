library verilog;
use verilog.vl_types.all;
entity wavelet_transform_2D is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_input      : in     vl_logic_vector(15 downto 0);
        ram_inst2_qout  : in     vl_logic_vector(15 downto 0);
        end_flag        : out    vl_logic;
        data_in_ready   : out    vl_logic;
        ram_inst2_address: out    vl_logic_vector(11 downto 0);
        ram_inst2_data_in: out    vl_logic_vector(15 downto 0);
        ram_inst2_wren  : out    vl_logic
    );
end wavelet_transform_2D;
