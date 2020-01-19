library verilog;
use verilog.vl_types.all;
entity fifo is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        data            : in     vl_logic_vector(0 downto 0);
        rdreq           : in     vl_logic;
        wrreq           : in     vl_logic;
        almost_full     : out    vl_logic;
        empty           : out    vl_logic;
        q               : out    vl_logic_vector(0 downto 0)
    );
end fifo;
