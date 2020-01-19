library verilog;
use verilog.vl_types.all;
entity img_coding is
    generic(
        LL_BASE_ADDRESS : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        HL_BASE_ADDRESS : vl_logic_vector(0 to 11) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        LH_BASE_ADDRESS : vl_logic_vector(0 to 11) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        IDLE            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        WAVLET          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        FILL            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        ENCODE          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        SYNC2           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        SYNC3           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1);
        ENCODEFILL      : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_input      : in     vl_logic_vector(15 downto 0);
        data_in_ready   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LL_BASE_ADDRESS : constant is 1;
    attribute mti_svvh_generic_type of HL_BASE_ADDRESS : constant is 1;
    attribute mti_svvh_generic_type of LH_BASE_ADDRESS : constant is 1;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of WAVLET : constant is 1;
    attribute mti_svvh_generic_type of FILL : constant is 1;
    attribute mti_svvh_generic_type of ENCODE : constant is 1;
    attribute mti_svvh_generic_type of SYNC2 : constant is 1;
    attribute mti_svvh_generic_type of SYNC3 : constant is 1;
    attribute mti_svvh_generic_type of ENCODEFILL : constant is 1;
end img_coding;
