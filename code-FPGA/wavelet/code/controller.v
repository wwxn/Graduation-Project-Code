module controller
(
	input clk,
	input rst_n,
	input [15:0] data_in_odd,
	input [15:0] data_in_even,
	input [15:0] ram_inst1_data_in_odd,
	input [15:0] ram_inst1_data_in_even,
	input [15:0] ram_inst2_data_in_odd,
	input [15:0] ram_inst2_data_in_even,
	input [11:0] wavlet_odd_address,
	input [11:0] wavlet_even_address,
	input wavelet_stop_flag,
	input [11:0] address_a_input,
	input [11:0] address_b_input,
	output wavelet_rst,
	output [15:0] wavelet_data_odd_input,
	output [15:0] wavelet_data_even_input,
	output wavlet_wrreq,
	output [7:0]wavelet_lineaddress,
	output ram1_wren,
	output ram1_rden,
	output ram2_wren,
	output ram2_rden,
	output [11:0] ram1_address_a,
	output [11:0] ram1_address_b,
	output [11:0] ram2_address_a,
	output [11:0] ram2_address_b,
	output wavelet_mode,
	output end_flag
);



localparam IDLE=8'd0;
localparam WAVELET1=8'd1; 
localparam RESTART1=8'd2;
localparam WAVELET2=8'd3;
localparam BUFFER1=8'd4;
localparam RESTART2=8'd5;
localparam WAVELET3=8'd6;
localparam BUFFER2=8'd7;
localparam RESTART3=8'd8;
localparam WAVELET4=8'd9;
localparam BUFFER3=8'd10;
localparam END=8'd11;

reg [8:0] step;
reg [8:0] step_next;
reg [2:0] reset_counter;
reg [2:0] buffer_counter;
reg [5:0] line_address;
reg [5:0] row_address;
reg [4:0] line_address2;
reg [4:0] row_address2;
reg[5:0] data_in_counter;

//assign address_even=(step==WAVELET2||step_next==BUFFER1)?row_address*64+line_address;
//assign address_odd=(step==WAVELET2||step_next==BUFFER1)?(row_address+1'b1)*64+line_address
wire wavelet_reset_flag=(step==RESTART1||step_next==BUFFER1||step==RESTART2||step_next==BUFFER2||step==RESTART3||step_next==BUFFER3||step==END)?1'b0:1'b1;
assign wavelet_rst=wavelet_reset_flag&rst_n;
assign wavelet_data_odd_input=(step_next==WAVELET1)?data_in_odd:
										(step_next==WAVELET2||step_next==WAVELET4)?ram_inst1_data_in_odd:
										(step_next==WAVELET3)?ram_inst2_data_in_odd:16'd0;
assign wavelet_data_even_input=(step_next==WAVELET1)?data_in_even:
										 (step_next==WAVELET2||step_next==WAVELET4)?ram_inst1_data_in_even:
										 (step_next==WAVELET3)?ram_inst2_data_in_even:16'd0;
assign wavlet_wrreq=(step_next==WAVELET1||step_next==WAVELET2||step_next==WAVELET3||step_next==WAVELET4)?1'b1:1'b0;
assign ram1_wren=(step_next==WAVELET1||step_next==WAVELET3)?1'b1:1'b0;
assign ram1_rden=(step_next==WAVELET1||step_next==BUFFER1||step_next==WAVELET2||step_next==BUFFER2||step_next==WAVELET3||step_next==BUFFER3||step_next==WAVELET4)?1'b1:1'b0;
assign ram1_address_a=(step_next==WAVELET1||step_next==WAVELET3)?wavlet_odd_address:
                      (step_next==WAVELET2||step_next==BUFFER1)?(row_address+1'b1)*64+line_address:
							 (step_next==WAVELET4||step_next==BUFFER3)?(row_address2+1'b1)*64+line_address2:12'd0;
assign ram1_address_b=(step_next==WAVELET1||step_next==WAVELET3)?wavlet_even_address:
							 (step_next==WAVELET2||step_next==BUFFER1)?row_address*64+line_address:
							 (step_next==WAVELET4||step_next==BUFFER3)?(row_address2)*64+line_address2:12'd0;
assign ram2_wren=(step_next==WAVELET2||step_next==WAVELET4)?1'b1:1'b0;
assign ram2_rden=(step_next==WAVELET2||step_next==BUFFER2||step_next==WAVELET3||step_next==BUFFER3||step_next==WAVELET4||step_next==END)?1'b1:1'b0;
assign ram2_address_a=(step_next==END)?address_a_input:
							 (step_next==WAVELET2||step_next==WAVELET4)?((wavlet_odd_address&6'd63)<<6)+(wavlet_odd_address>>6):
							 (step_next==BUFFER2||step_next==WAVELET3)?(line_address2)*64+row_address2+1'b1:12'd0;
assign ram2_address_b=(step_next==END)?address_b_input:
							 (step_next==WAVELET2||step_next==WAVELET4)?((wavlet_even_address&6'd63)<<6)+(wavlet_even_address>>6):
							 (step_next==BUFFER2||step_next==WAVELET3)?(line_address2)*64+row_address2:12'd0;
assign wavelet_mode=(step_next==WAVELET1||step_next==RESTART1||step_next==BUFFER1||step_next==WAVELET2)?1'b0:1'b1;
assign end_flag=(step_next==END)?1'b1:1'b0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=IDLE;
	else
		step<=step_next;

always@*
	case(step)
	IDLE:step_next<=WAVELET1;
	WAVELET1:
		if(wavelet_stop_flag)
			step_next<=RESTART1;
		else
			step_next<=WAVELET1;
	RESTART1:
		if(reset_counter>=3'd6)
			step_next<=BUFFER1;
		else
			step_next<=RESTART1;
	BUFFER1:
		if(buffer_counter>=3'd2)
			step_next<=WAVELET2;
		else
			step_next<=BUFFER1;
	WAVELET2:
		if(wavelet_stop_flag)
			step_next<=RESTART2;
		else
			step_next<=WAVELET2;
	RESTART2:
		if(reset_counter>=3'd6)
			step_next<=BUFFER2;
		else
			step_next<=RESTART2;
	BUFFER2:
		if(buffer_counter>=3'd2)
			step_next<=WAVELET3;
		else
			step_next<=BUFFER2;
	WAVELET3:
		if(wavelet_stop_flag)
			step_next<=RESTART3;
		else
			step_next<=WAVELET3;
	RESTART3:
		if(reset_counter>=3'd6)
			step_next<=BUFFER3;
		else
			step_next<=RESTART3;
	BUFFER3:
		if(buffer_counter>=3'd2)
			step_next<=WAVELET4;
		else
			step_next<=BUFFER3;
	WAVELET4:
		if(wavelet_stop_flag)
			step_next<=END;
		else
			step_next<=WAVELET4;
	endcase

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		reset_counter<=3'd0;
		buffer_counter<=3'd0;
	end
	else
		case(step_next)
			RESTART1,RESTART2,RESTART3:begin
				reset_counter<=reset_counter+1'b1;
				buffer_counter<=3'd0;
			end
			BUFFER1,BUFFER2,BUFFER3:begin
				buffer_counter<=buffer_counter+1'b1;
				reset_counter<=3'd0;
			end
		endcase

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		data_in_counter<=6'd0;
		row_address<=-6'd2;
		line_address<=6'd0;
		row_address2<=-5'd2;
		line_address2<=5'd0;
	end
	else if(step_next==BUFFER1||step_next==WAVELET2)
		if(data_in_counter>=6'd33)begin
			data_in_counter<=6'd0;
			row_address<=-6'd2;
			line_address<=line_address+1'b1;
		end
		else begin
			data_in_counter<=data_in_counter+1'b1;
			row_address<=row_address+2'd2;
		end
	else if (step_next==RESTART2||step_next==RESTART3)begin
		data_in_counter<=6'd0;
		row_address<=-6'd2;
		line_address<=6'd0;
		row_address2<=-5'd2;
		line_address2<=5'd0;
	end
	else if (step_next==BUFFER2||step_next==WAVELET3||step_next==BUFFER3||step_next==WAVELET4)
		if(data_in_counter>=6'd17)begin
			data_in_counter<=6'd0;
			row_address2<=-5'd2;
			line_address2<=line_address2+1'b1;
		end
		else begin
			data_in_counter<=data_in_counter+1'b1;
			row_address2<=row_address2+2'd2;
		end
endmodule 







