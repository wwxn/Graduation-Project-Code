library verilog;
use verilog.vl_types.all;
entity coding_queue is
    generic(
        context         : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        bit_input       : in     vl_logic;
        wrreq           : in     vl_logic;
        bit_output      : out    vl_logic;
        fifo_full       : out    vl_logic;
        space_used      : out    vl_logic_vector(11 downto 0);
        fifo_empty      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of context : constant is 1;
end coding_queue;
