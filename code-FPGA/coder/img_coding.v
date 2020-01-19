module img_coding
(
	input clk,
	input rst_n,
	input [15:0] data_input,
	output data_in_ready

);


//localparams
parameter LL_BASE_ADDRESS=12'd0;
parameter HL_BASE_ADDRESS=12'd32;
parameter LH_BASE_ADDRESS=12'd2048;
parameter IDLE=8'd0;
parameter WAVLET=8'd1;
parameter FILL=8'd2;
parameter ENCODE=8'd3;
parameter SYNC2=8'd4;
parameter SYNC3=8'd5;
parameter ENCODEFILL=8'd6;
//local registers
reg [11:0] data_offset;
reg [1:0] read_ram_cycle;
reg [7:0] step;
reg [7:0] step_next;
reg [13:0] fill_counter;
reg [2:0] cycle_counter; 
//local wires
wire [2:0] LL_coding_mode=(fill_counter<14'd96)?3'd0:(fill_counter<14'd144)?3'd1:(fill_counter<14'd816)?3'd2:(fill_counter<14'd864)?3'd3:3'd4;
wire [2:0] HL_coding_mode=(fill_counter<14'd97)?3'd0:(fill_counter<14'd145)?3'd1:(fill_counter<14'd817)?3'd2:(fill_counter<14'd865)?3'd3:3'd4;
wire [2:0] LH_coding_mode=(fill_counter<14'd98)?3'd0:(fill_counter<14'd146)?3'd1:(fill_counter<14'd818)?3'd2:(fill_counter<14'd866)?3'd3:3'd4;
wire [11:0] LL_read_address=LL_BASE_ADDRESS+data_offset;
wire [11:0] HL_read_address=HL_BASE_ADDRESS+data_offset;
wire [11:0] LH_read_address=LH_BASE_ADDRESS+data_offset;
wire [11:0] ram_inst2_read_address=(read_ram_cycle==2'd0)?LL_read_address:(read_ram_cycle==2'd1)?HL_read_address:LH_read_address;

//signal for wavlet2d
wire wavlet2D_endflag;
wire [11:0] wavlet2D_ram_inst2_address;

//signal for ram inst2
wire [15:0]ram_inst2_qout;
wire [11:0]ram_inst2_address=(step==FILL||step==ENCODEFILL)?ram_inst2_read_address:wavlet2D_ram_inst2_address;
wire [15:0] ram_inst2_data_in;
wire ram_inst2_wren;

//general signals for shift register
wire	  encoder_shift_register_aclr=1'b0;
wire	  encoder_shift_register_clock=clk;
wire	[15:0]  encoder_shift_register_shiftin=ram_inst2_qout;


//signals for shift register inst1
wire	  encoder_shift_register_inst1_clken=(((step==FILL)&&(read_ram_cycle==2'd0))||(step==ENCODE&&cycle_counter==3'd3)||(fill_counter==14'd95&&cycle_counter==3'd1))?1'b1:1'b0;
wire	[15:0]  encoder_shift_register_inst1_shiftout;
wire	[15:0]  encoder_shift_register_inst1_taps0x;
wire	[15:0]  encoder_shift_register_inst1_taps1x;
wire	[15:0]  encoder_shift_register_inst1_taps2x;

//signals for shift register inst2
wire	  encoder_shift_register_inst2_clken=(((step==FILL)&&(read_ram_cycle==2'd1)&&(fill_counter!=1'b1))||(step==ENCODE&&cycle_counter==3'd4)||(fill_counter==14'd96))?1'b1:1'b0;
wire	[15:0]  encoder_shift_register_inst2_shiftout;
wire	[15:0]  encoder_shift_register_inst2_taps0x;
wire	[15:0]  encoder_shift_register_inst2_taps1x;
wire	[15:0]  encoder_shift_register_inst2_taps2x;

//signals for shift register inst3
wire	  encoder_shift_register_inst3_clken=((step==FILL||step==ENCODEFILL)&&(read_ram_cycle==2'd2))?1'b1:1'b0;
wire	[15:0]  encoder_shift_register_inst3_shiftout;
wire	[15:0]  encoder_shift_register_inst3_taps0x;
wire	[15:0]  encoder_shift_register_inst3_taps1x;
wire	[15:0]  encoder_shift_register_inst3_taps2x;


//signals for context encoder inst3
wire context_encoder_inst3_clk=clk;
wire context_encoder_inst3_rst_n=rst_n;
wire [15:0] context_encoder_inst3_data_input_row0=encoder_shift_register_inst3_taps0x;
wire [15:0] context_encoder_inst3_data_input_row1=encoder_shift_register_inst3_taps1x;
wire [15:0] context_encoder_inst3_data_input_row2=encoder_shift_register_inst3_taps2x;
wire context_encoder_inst3_cal_flag=(step==ENCODE)?1'b1:1'b0;
wire context_encoder_inst3_ram_update_flag;


//signals for context encoder inst2
wire context_encoder_inst2_clk=clk;
wire context_encoder_inst2_rst_n=rst_n;
wire [15:0] context_encoder_inst2_data_input_row0=encoder_shift_register_inst2_taps0x;
wire [15:0] context_encoder_inst2_data_input_row1=encoder_shift_register_inst2_taps1x;
wire [15:0] context_encoder_inst2_data_input_row2=encoder_shift_register_inst2_taps2x;
wire context_encoder_inst2_cal_flag=context_encoder_inst3_cal_flag;
wire context_encoder_inst2_ram_update_flag;

//signals for context encoder inst1
wire context_encoder_inst1_clk=clk;
wire context_encoder_inst1_rst_n=rst_n;
wire [15:0] context_encoder_inst1_data_input_row0=encoder_shift_register_inst1_taps0x;
wire [15:0] context_encoder_inst1_data_input_row1=encoder_shift_register_inst1_taps1x;
wire [15:0] context_encoder_inst1_data_input_row2=encoder_shift_register_inst1_taps2x;
wire context_encoder_inst1_cal_flag=context_encoder_inst3_cal_flag;
wire context_encoder_inst1_ram_update_flag;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cycle_counter<=3'd0;
	else if(step==ENCODE&&step_next==ENCODEFILL)
		cycle_counter<=3'd0;
	else if(step_next==ENCODEFILL||step_next==ENCODE)
		cycle_counter<=cycle_counter+1'b1;
	else
		cycle_counter<=3'd0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=IDLE;
	else
		step<=step_next;

always@*
	case(step)
	IDLE:step_next<=WAVLET;
	WAVLET:
		if(wavlet2D_endflag)
			step_next<=FILL;
		else
			step_next<=WAVLET;
	FILL:
		if(fill_counter>=14'd95)
			step_next<=ENCODE;
		else
			step_next<=FILL;
	ENCODE:
		if(context_encoder_inst3_ram_update_flag)
			step_next<=ENCODEFILL;
		else
			step_next<=ENCODE;
	ENCODEFILL:
		if(read_ram_cycle==2'd2)
			step_next<=ENCODE;
		else
			step_next<=ENCODEFILL;
	endcase
	
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		fill_counter<=14'd0;
		data_offset<=12'd0;
		read_ram_cycle<=2'd0;
	end
	else
		case(step_next)
			FILL:begin
				fill_counter<=fill_counter+1'b1;
				if (read_ram_cycle==2'd2)begin
					read_ram_cycle<=2'd0;
					if((data_offset&4'hf)==4'hf)
							data_offset<=data_offset+8'd49;
						else
							data_offset<=data_offset+1'b1;
				end
				else
					read_ram_cycle<=read_ram_cycle+1'b1;
			end
			ENCODEFILL:begin
				fill_counter<=fill_counter+1'b1;
				if (read_ram_cycle==2'd2)begin
					read_ram_cycle<=2'd0;
					if((data_offset&4'hf)==4'hf)
							data_offset<=data_offset+8'd49;
						else
							data_offset<=data_offset+1'b1;
				end
				else
					read_ram_cycle<=read_ram_cycle+1'b1;
			end
		endcase
context_encoder context_encoder_inst3
(
	.clk(context_encoder_inst3_clk),
	.rst_n(context_encoder_inst3_rst_n),
	.data_input_row0(context_encoder_inst3_data_input_row0),
	.data_input_row1(context_encoder_inst3_data_input_row1),
	.data_input_row2(context_encoder_inst3_data_input_row2),
	.cal_flag(context_encoder_inst3_cal_flag),
	.ram_update_flag(context_encoder_inst3_ram_update_flag)
);

context_encoder context_encoder_inst2
(
	.clk(context_encoder_inst2_clk),
	.rst_n(context_encoder_inst2_rst_n),
	.data_input_row0(context_encoder_inst2_data_input_row0),
	.data_input_row1(context_encoder_inst2_data_input_row1),
	.data_input_row2(context_encoder_inst2_data_input_row2),
	.cal_flag(context_encoder_inst2_cal_flag),
	.ram_update_flag(context_encoder_inst2_ram_update_flag)
);


context_encoder context_encoder_inst1
(
	.clk(context_encoder_inst1_clk),
	.rst_n(context_encoder_inst1_rst_n),
	.data_input_row0(context_encoder_inst1_data_input_row0),
	.data_input_row1(context_encoder_inst1_data_input_row1),
	.data_input_row2(context_encoder_inst1_data_input_row2),
	.cal_flag(context_encoder_inst1_cal_flag),
	.ram_update_flag(context_encoder_inst1_ram_update_flag)
);


encoder_shift_register encoder_shift_register_inst1
(
	.aclr(encoder_shift_register_aclr),
	.clken(encoder_shift_register_inst1_clken),
	.clock(encoder_shift_register_clock),
	.shiftin(encoder_shift_register_shiftin),
	.shiftout(encoder_shift_register_inst1_shiftout),
	.taps0x(encoder_shift_register_inst1_taps0x),
	.taps1x(encoder_shift_register_inst1_taps1x),
	.taps2x(encoder_shift_register_inst1_taps2x)
);

encoder_shift_register encoder_shift_register_inst2
(
	.aclr(encoder_shift_register_aclr),
	.clken(encoder_shift_register_inst2_clken),
	.clock(encoder_shift_register_clock),
	.shiftin(encoder_shift_register_shiftin),
	.shiftout(encoder_shift_register_inst2_shiftout),
	.taps0x(encoder_shift_register_inst2_taps0x),
	.taps1x(encoder_shift_register_inst2_taps1x),
	.taps2x(encoder_shift_register_inst2_taps2x)
);

encoder_shift_register encoder_shift_register_inst3
(
	.aclr(encoder_shift_register_aclr),
	.clken(encoder_shift_register_inst3_clken),
	.clock(encoder_shift_register_clock),
	.shiftin(encoder_shift_register_shiftin),
	.shiftout(encoder_shift_register_inst3_shiftout),
	.taps0x(encoder_shift_register_inst3_taps0x),
	.taps1x(encoder_shift_register_inst3_taps1x),
	.taps2x(encoder_shift_register_inst3_taps2x)
);

wavelet_transform_2D wavelet_transform_2D_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.data_input(data_input),
	.ram_inst2_qout(ram_inst2_qout),
	.end_flag(wavlet2D_endflag),
	.data_in_ready(data_in_ready),
	.ram_inst2_address(wavlet2D_ram_inst2_address),
	.ram_inst2_data_in(ram_inst2_data_in),
	.ram_inst2_wren(ram_inst2_wren)
);


ram ram_inst2
(
	.address(ram_inst2_address),
	.clock(clk),
	.data(ram_inst2_data_in),
	.wren(ram_inst2_wren),
	.q(ram_inst2_qout)
);

endmodule 