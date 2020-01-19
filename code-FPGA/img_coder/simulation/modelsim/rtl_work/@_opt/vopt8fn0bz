library verilog;
use verilog.vl_types.all;
entity mq_coder is
    generic(
        IDLE            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        UPDATE          : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        RENORME1        : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        RENORME2        : vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        cx              : in     vl_logic_vector(3 downto 0);
        bit             : in     vl_logic;
        input_valid     : in     vl_logic;
        update_flag     : out    vl_logic;
        byte_out        : out    vl_logic_vector(7 downto 0);
        output_valid    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of UPDATE : constant is 1;
    attribute mti_svvh_generic_type of RENORME1 : constant is 1;
    attribute mti_svvh_generic_type of RENORME2 : constant is 1;
end mq_coder;
