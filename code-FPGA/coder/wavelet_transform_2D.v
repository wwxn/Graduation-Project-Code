module wavelet_transform_2D
(
	input clk,
	input rst_n,
	input [15:0] data_input,
	input [15:0]ram_inst2_qout,
	output end_flag,
	output data_in_ready,
	output [11:0]ram_inst2_address,
	output [15:0] ram_inst2_data_in,
	output ram_inst2_wren
);

reg [7:0] step;
reg [7:0] step_next;

wire update_flag;
assign end_flag=(step==8'd8)?1'b1:1'b0;
wire step_flag=(step==8'd3||step==8'd5||step==8'd7)?1'b1:1'b0;
wire ram_wren;
wire [11:0] ram_address_in;
wire wavelet1D_endflag;
wire [15:0] wavlet_1D_input;
wire wavelet1D_reset_flag;
wire [15:0] ram_inst1_data_in;
wire [11:0] ram_inst1_address;
wire wavelet_1D_data_in_ready;
wire data_in_ready_flag=(step==8'd1)?1'b1:1'b0;
wire wavelet1D_reset=rst_n&wavelet1D_reset_flag;
wire [15:0] ram_data_in;
wire [15:0] ram_inst1_qout;


reg [11:0] ram_inst1_read_address;
reg [11:0] ram_inst2_read_address;
assign data_in_ready=data_in_ready_flag&wavelet_1D_data_in_ready;
assign wavelet1D_reset_flag=(step==8'd1||step==8'd3||step==8'd5||step==8'd7)?1'b1:1'b0;

assign ram_inst1_address=(step==8'd1||step==8'd5)?ram_address_in:ram_inst1_read_address;
assign ram_inst1_data_in=(step==8'd1||step==8'd5)?ram_data_in:16'd0;
assign ram_inst1_wren=(step==8'd1||step==8'd5)?ram_wren:1'b0;

assign ram_inst2_address=(step==8'd3||step==8'd7)?((ram_address_in&6'd63)<<6)+(ram_address_in>>6):(step==8'd5)?ram_inst2_read_address:12'd0;
assign ram_inst2_data_in=(step==8'd3||step==8'd7)?ram_data_in:16'd0;
assign ram_inst2_wren=(step==8'd3||step==8'd7)?ram_wren:1'b0;


reg [1:0] reset_counter;
assign wavlet_1D_input=(step==8'd1)?data_input:(step==8'd3||step==8'd7)?ram_inst1_qout:(step==8'd5)?ram_inst2_qout:16'd0;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=8'd0;
	else
		step<=step_next;
		
always@*
	case(step)
	8'd0:step_next<=8'd1;
	8'd1:
		if(wavelet1D_endflag)
			step_next<=8'd2;
		else
			step_next<=8'd1;
	8'd2:
		if(reset_counter>=2'd3)
			step_next<=8'd3;
		else
			step_next<=8'd2;
	8'd3:
		if(wavelet1D_endflag)
			step_next<=8'd4;
		else
			step_next<=8'd3;
	8'd4:
		if(reset_counter>=2'd3)
			step_next<=8'd5;
		else
			step_next<=8'd4;
	8'd5:
		if(wavelet1D_endflag)
			step_next<=8'd6;
		else
			step_next<=8'd5;
	8'd6:
		if(reset_counter>=2'd3)
			step_next<=8'd7;
		else
			step_next<=8'd6;
	8'd7:
		if(wavelet1D_endflag)
			step_next<=8'd8;
		else
			step_next<=8'd7;
	endcase
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		ram_inst1_read_address<=12'd0;
		reset_counter<=2'd0;
		ram_inst2_read_address<=12'd0;
	end
	else
		case(step_next)
		8'd2:reset_counter<=reset_counter+1'b1;
		8'd3:begin
			reset_counter<=2'd0;
			if(ram_wren)
				if(update_flag&&step_flag)
					if(ram_inst1_read_address+64>=13'd4096)
						ram_inst1_read_address<=ram_inst1_read_address+12'd65;
					else
						ram_inst1_read_address<=ram_inst1_read_address+12'd64;
				else
					ram_inst1_read_address<=ram_inst1_read_address;
			else
				if(ram_inst1_read_address+64>=13'd4096)
					ram_inst1_read_address<=ram_inst1_read_address+12'd65;
				else
					ram_inst1_read_address<=ram_inst1_read_address+12'd64;
			end
		8'd4:begin
			reset_counter<=reset_counter+1'b1;
			ram_inst1_read_address<=12'd0;
			end
		8'd5:begin
			reset_counter<=2'd0;
			if(ram_wren)
				if(update_flag&&step_flag)
					ram_inst2_read_address<=ram_inst2_read_address+12'd1;
				else
					ram_inst1_read_address<=ram_inst1_read_address;
			else
				ram_inst2_read_address<=ram_inst2_read_address+12'd1;
			end
		8'd6:begin
			reset_counter<=reset_counter+1'b1;
			ram_inst2_read_address<=12'd0;
		end
		8'd7:begin
			reset_counter<=2'd0;
			if(ram_wren)
				if(update_flag&&step_flag)
					if(ram_inst1_read_address+64>=13'd4096)
						ram_inst1_read_address<=ram_inst1_read_address+12'd65;
					else
						ram_inst1_read_address<=ram_inst1_read_address+12'd64;
				else
					ram_inst1_read_address<=ram_inst1_read_address;
			else 
				if(ram_inst1_read_address+64>=13'd4096)
					ram_inst1_read_address<=ram_inst1_read_address+12'd65;
				else
					ram_inst1_read_address<=ram_inst1_read_address+12'd64;
			end
		endcase
		
		
	
	
wavelet_transform_1D wavelet_transform_1D_inst
(
	.clk(clk),
	.rst_n(wavelet1D_reset),
	.data_input(wavlet_1D_input),
	.data_in_ready(wavelet_1D_data_in_ready),
	.ram_address_in(ram_address_in),
	.ram_data_in(ram_data_in),
	.ram_wren(ram_wren),
	.end_flag(wavelet1D_endflag),
	.step_input(step_flag),
	.update_flag(update_flag)
);


ram ram_inst1
(
	.address(ram_inst1_address),
	.clock(clk),
	.data(ram_inst1_data_in),
	.wren(ram_inst1_wren),
	.q(ram_inst1_qout)
);



endmodule 