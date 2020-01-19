library verilog;
use verilog.vl_types.all;
entity encoder_shift_register is
    port(
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        clock           : in     vl_logic;
        shiftin         : in     vl_logic_vector(15 downto 0);
        shiftout        : out    vl_logic_vector(15 downto 0);
        taps0x          : out    vl_logic_vector(15 downto 0);
        taps1x          : out    vl_logic_vector(15 downto 0);
        taps2x          : out    vl_logic_vector(15 downto 0)
    );
end encoder_shift_register;
