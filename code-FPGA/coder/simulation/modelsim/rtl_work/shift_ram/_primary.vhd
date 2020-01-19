library verilog;
use verilog.vl_types.all;
entity shift_ram is
    port(
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        clock           : in     vl_logic;
        shiftin         : in     vl_logic_vector(15 downto 0);
        shiftout        : out    vl_logic_vector(15 downto 0);
        taps0x          : out    vl_logic_vector(15 downto 0);
        taps10x         : out    vl_logic_vector(15 downto 0);
        taps11x         : out    vl_logic_vector(15 downto 0);
        taps12x         : out    vl_logic_vector(15 downto 0);
        taps13x         : out    vl_logic_vector(15 downto 0);
        taps14x         : out    vl_logic_vector(15 downto 0);
        taps15x         : out    vl_logic_vector(15 downto 0);
        taps1x          : out    vl_logic_vector(15 downto 0);
        taps2x          : out    vl_logic_vector(15 downto 0);
        taps3x          : out    vl_logic_vector(15 downto 0);
        taps4x          : out    vl_logic_vector(15 downto 0);
        taps5x          : out    vl_logic_vector(15 downto 0);
        taps6x          : out    vl_logic_vector(15 downto 0);
        taps7x          : out    vl_logic_vector(15 downto 0);
        taps8x          : out    vl_logic_vector(15 downto 0);
        taps9x          : out    vl_logic_vector(15 downto 0)
    );
end shift_ram;
