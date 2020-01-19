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
localparam IDLE=4'b0000;
localparam LOAD=4'b0001;

reg [143:0] data_reg;
reg [11:0] start_address;
reg [3:0] step;
reg [3:0] step_next;
reg [3:0] cycle_counter;
wire [5:0] center_line_address=(start_address>>6)+1'b1;
wire [5:0] center_row_address=(start_address&6'd63)+1'b1;

wire data_buff0=data_reg[15:0];
wire data_buff1=data_reg[31:16];
wire data_buff2=data_reg[47:32];
wire data_buff3=data_reg[63:48];
wire data_buff4=data_reg[79:64];
wire data_buff5=data_reg[95:80];
wire data_buff6=data_reg[111:96];
wire data_buff7=data_reg[127:112];
wire data_buff8=data_reg[143:128];

assign bitplane_data0=data_buff8;
assign bitplane_data1=data_buff5;
assign bitplane_data2=data_buff2;
assign bitplane_data3=data_buff7;
assign bitplane_data4=data_buff4;
assign bitplane_data5=data_buff1;
assign bitplane_data6=data_buff6;
assign bitplane_data7=data_buff3;
assign bitplane_data8=data_buff0;



always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=IDLE;
	else
		step<=step_next;
		
always@*
	case(step)
		IDLE:
			if(wavelet_end)
				step_next<=LOAD;
			else
				step_next<=IDLE;
	endcase
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
	end
	else
		case(step_next)
			LOAD:
			begin
				cycle_counter<=cycle_counter+1'b1;
				start_address<=start_address+1'b1;
				data_reg<=(cycle_counter>=4'd2)?(data_reg<<16)+ram_data_input:data_reg;
				
			end


endmodule 








