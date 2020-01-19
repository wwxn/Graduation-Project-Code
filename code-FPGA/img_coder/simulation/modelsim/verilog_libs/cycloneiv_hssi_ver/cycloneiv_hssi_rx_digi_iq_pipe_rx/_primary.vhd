library verilog;
use verilog.vl_types.all;
entity cycloneiv_hssi_rx_digi_iq_pipe_rx is
    port(
        clk_2_b_raw     : in     vl_logic;
        rd_enable_in_centrl: in     vl_logic;
        rd_enable_in_pipe_quad_down: in     vl_logic;
        rd_enable_in_pipe_quad_up: in     vl_logic;
        rd_enable_out_pipe: out    vl_logic;
        reset_pc_ptrs_in_centrl: in     vl_logic;
        reset_pc_ptrs_in_pipe_quad_down: in     vl_logic;
        reset_pc_ptrs_in_pipe_quad_up: in     vl_logic;
        reset_pc_ptrs_out_pipe: out    vl_logic;
        rfreerun_rx     : in     vl_logic;
        rmaster_rx      : in     vl_logic;
        rmaster_up_rx   : in     vl_logic;
        rpipeline_bypass_rx: in     vl_logic;
        rx_div2_sync_in_centrl: in     vl_logic;
        rx_div2_sync_in_pipe_quad_down: in     vl_logic;
        rx_div2_sync_in_pipe_quad_up: in     vl_logic;
        rx_div2_sync_out_pipe: out    vl_logic;
        rx_rd_clk_raw   : in     vl_logic;
        rx_we_in_centrl : in     vl_logic;
        rx_we_in_pipe_quad_down: in     vl_logic;
        rx_we_in_pipe_quad_up: in     vl_logic;
        rx_we_out_pipe  : out    vl_logic;
        rx_wr_clk_raw   : in     vl_logic;
        rxrst           : in     vl_logic;
        soft_reset_rclk1: in     vl_logic;
        soft_reset_wclk1: in     vl_logic;
        speed_change_in_centrl: in     vl_logic;
        speed_change_in_pipe_quad_down: in     vl_logic;
        speed_change_in_pipe_quad_up: in     vl_logic;
        speed_change_out_pipe: out    vl_logic;
        wr_enable_in_centrl: in     vl_logic;
        wr_enable_in_pipe_quad_down: in     vl_logic;
        wr_enable_in_pipe_quad_up: in     vl_logic;
        wr_enable_out_pipe: out    vl_logic
    );
end cycloneiv_hssi_rx_digi_iq_pipe_rx;
