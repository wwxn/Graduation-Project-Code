module ram_reader
(
	input clk,
	input rst_n,
	input bitplane_code_ready,
	input wavelet_end,
	input [15:0] ram_data_input,
	output [11:0] ram_read_address,
	output [2:0] subband,
	output [15:0] bitplane_data0,
	output [15:0] bitplane_data1,
	output [15:0] bitplane_data2,
	output [15:0] bitplane_data3,
	output [15:0] bitplane_data4,
	output [15:0] bitplane_data5,
	output [15:0] bitplane_data6,
	output [15:0] bitplane_data7,
	output [15:0] bitplane_data8,
	output bitplane_input_valid
);


endmodule 