library verilog;
use verilog.vl_types.all;
entity context_encoder is
    generic(
        SUBBAND         : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        LL              : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        HL              : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        LH              : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        IDLE            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        INITIAL         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        READ0           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        CALCULATE       : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        DISTRIBUTION    : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        READ1           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1);
        WAITEMPTY       : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        data_input_row0 : in     vl_logic_vector(15 downto 0);
        data_input_row1 : in     vl_logic_vector(15 downto 0);
        data_input_row2 : in     vl_logic_vector(15 downto 0);
        cal_flag        : in     vl_logic;
        ram_update_flag : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SUBBAND : constant is 1;
    attribute mti_svvh_generic_type of LL : constant is 1;
    attribute mti_svvh_generic_type of HL : constant is 1;
    attribute mti_svvh_generic_type of LH : constant is 1;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of INITIAL : constant is 1;
    attribute mti_svvh_generic_type of READ0 : constant is 1;
    attribute mti_svvh_generic_type of CALCULATE : constant is 1;
    attribute mti_svvh_generic_type of DISTRIBUTION : constant is 1;
    attribute mti_svvh_generic_type of READ1 : constant is 1;
    attribute mti_svvh_generic_type of WAITEMPTY : constant is 1;
end context_encoder;
