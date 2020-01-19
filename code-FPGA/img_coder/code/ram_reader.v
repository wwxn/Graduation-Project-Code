module ram_reader
(
	input clk,
	input rst_n,
	input bitplane_code_ready,
	input wavelet_end,
	input [15:0] ram_data_input,
	output reg [11:0] ram_read_address,
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
localparam WAIT=4'b0011;
localparam LL=3'd0;
localparam HL1=3'd1;
localparam HL2=3'd2;
localparam LH1=3'd3;
localparam LH2=3'd4;
localparam HH1=3'd5;
localparam HH2=3'd6;

reg [143:0] data_reg;

reg [3:0] step;
reg [3:0] step_next;
reg [3:0] cycle_counter;
reg [11:0] start_address;
//reg [5:0] start_line;
//reg [5:0] start_row;
//wire [11:0] start_address=(start_line<<6)+start_row;
wire [5:0] center_line_address=(start_address>>6)+1'b1;
wire [5:0] center_row_address=(start_address&6'd63)+1'b1;

wire [15:0] data_buff0=data_reg[15:0];
wire [15:0] data_buff1=data_reg[31:16];
wire [15:0] data_buff2=data_reg[47:32];
wire [15:0] data_buff3=data_reg[63:48];
wire [15:0] data_buff4=data_reg[79:64];
wire [15:0] data_buff5=data_reg[95:80];
wire [15:0] data_buff6=data_reg[111:96];
wire [15:0] data_buff7=data_reg[127:112];
wire [15:0] data_buff8=data_reg[143:128];

assign bitplane_data0=data_buff8;
assign bitplane_data1=data_buff5;
assign bitplane_data2=data_buff2;
assign bitplane_data3=data_buff7;
assign bitplane_data4=data_buff4;
assign bitplane_data5=data_buff1;
assign bitplane_data6=data_buff6;
assign bitplane_data7=data_buff3;
assign bitplane_data8=data_buff0;

assign bitplane_input_valid=(cycle_counter==4'd5)?1'b1:1'b0;
assign subband=(center_line_address>6'd31)?((center_row_address>6'd31)?HH2:LH2):
					((center_row_address>6'd31)?(HL2)
					:((center_line_address>6'd15)?((center_row_address>6'd15)?HH1:LH1)
					:((center_row_address>6'd15)?(HL1):(LL))));

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
		LOAD:
			if(cycle_counter>4'd5)
				step_next<=WAIT;
			else
				step_next<=LOAD;
		WAIT:
			if(bitplane_code_ready)
				step_next<=LOAD;
			else
				step_next<=WAIT;
	endcase
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		cycle_counter<=4'd0;
		ram_read_address<=12'd4032;
		start_address<=12'd4032;
		data_reg<=144'd0;
	end
	else
		case(step_next)
			LOAD:
			begin
				cycle_counter<=cycle_counter+1'b1;
				ram_read_address<=(cycle_counter==4'd0)?start_address+12'd64:
										(cycle_counter==4'd1)?start_address+12'd128:
										(cycle_counter==4'd5)?start_address+1'b1:ram_read_address;
				start_address<=(cycle_counter==4'd5)?start_address+1'b1:start_address;
				data_reg<=(cycle_counter==4'd2||cycle_counter==4'd3||cycle_counter==4'd4)?(data_reg<<16)+ram_data_input:data_reg;
			end
			WAIT:cycle_counter<=4'd0;
			
		endcase

endmodule 








