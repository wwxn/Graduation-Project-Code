library verilog;
use verilog.vl_types.all;
entity coder is
    generic(
        context         : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        bit_input       : in     vl_logic;
        input_valid     : in     vl_logic;
        bit_output      : out    vl_logic;
        output_valid    : out    vl_logic;
        code_ready      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of context : constant is 1;
end coder;
