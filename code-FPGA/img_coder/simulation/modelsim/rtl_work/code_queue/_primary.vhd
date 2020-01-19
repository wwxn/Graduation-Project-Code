library verilog;
use verilog.vl_types.all;
entity code_queue is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        wrreq           : in     vl_logic;
        d_input         : in     vl_logic;
        cx_input        : in     vl_logic_vector(3 downto 0);
        output_valid    : out    vl_logic;
        byte_out        : out    vl_logic_vector(7 downto 0)
    );
end code_queue;
