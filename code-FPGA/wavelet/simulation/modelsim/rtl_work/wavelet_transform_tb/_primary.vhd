library verilog;
use verilog.vl_types.all;
entity wavelet_transform_tb is
    generic(
        PIC_SIZE        : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PIC_SIZE : constant is 1;
end wavelet_transform_tb;
