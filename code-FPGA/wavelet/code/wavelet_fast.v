module wavelet_fast
(
	input clk,
	input rst_n,
	input data_valid,
	input[15:0] data_in_odd,
	input[15:0] data_in_even,
	input[7:0] line_address,
	input wavelet_mode,
	output [15:0] data_out_odd,
	output [15:0] data_out_even,
	output data_loading,
	output output_valid,
	output [11:0] odd_address,
	output [11:0] even_address,
	output stop_flag
);

reg[2:0]step;
reg[2:0]step_next;
reg[5:0] output_counter;
parameter IDLE=3'b000;
parameter LOAD=3'b001;
parameter CAL=3'b011;
parameter CAL0=3'b010;
parameter RESET=3'b110;
parameter STOP=3'b100;

reg[7:0] odd_offset;
reg[7:0] even_offset;
reg[7:0] input_counter;
reg[64:0]data_reg;

wire[15:0]data0=data_reg[15:0];
wire[15:0]data1=data_reg[31:16];
wire[15:0]data2=data_reg[47:32];
wire[15:0]data3=data_reg[63:48];


wire[15:0] data_sum01=data2+data0;
wire[15:0] data_sum1=data2+data_in_even;
wire[15:0] data_odd_updated=((data_sum1&16'h8000)==16'h8000)?data3-((data_sum1>>1)|16'h8000):data3-(data_sum1>>1);
wire[15:0] data_sum2=data_odd_updated+data1+2;

reg[6:0] line_offset;

assign data_out_even=((data_sum2&16'h8000)==16'h8000)?data2+((data_sum2>>2)|16'hc000):data2+(data_sum2>>2);
assign data_out_odd=data_odd_updated;
assign data_loading=(step_next==CAL0||step_next==RESET)?1'b0:1'b1;
assign odd_address=(line_offset<<6)+odd_offset;
assign even_address=(line_offset<<6)+even_offset;
assign stop_flag=(step_next==STOP)?1'b1:1'b0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=IDLE;
	else
		step<=step_next;
	

always@*
	case(step)
		IDLE:
		if(data_valid)
			step_next<=LOAD;
		else
			step_next<=IDLE;
		LOAD:
			if(input_counter>=3'd4)
				step_next<=CAL0;
			else
				step_next<=LOAD;
		CAL0:step_next<=CAL;
		CAL:
		if(!wavelet_mode)
			if(output_counter>=6'd31)
				step_next<=RESET;
			else
				step_next<=CAL;
		else
			if(output_counter>=6'd15)
				step_next<=RESET;
			else
				step_next<=CAL;
		RESET:
		if(!wavelet_mode)
			if(line_offset>=7'd64)
				step_next<=STOP;
			else
				step_next<=IDLE;
		else
			if(line_offset>=7'd32)
				step_next<=STOP;
			else
				step_next<=IDLE;
	endcase
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		input_counter<=8'd0;
		data_reg<=64'd0;
		even_offset<=8'd0;
		odd_offset<=(!wavelet_mode)?8'd32:8'd16;
		output_counter<=6'd0;
		line_offset<=7'd0;
	end
	else
		case(step_next)
			IDLE:begin
				input_counter<=8'd0;
				data_reg<=64'd0;
				even_offset<=8'd0;
				odd_offset<=(!wavelet_mode)?8'd32:8'd16;
			end
			LOAD:begin
				input_counter<=input_counter+2'd2;
				data_reg<=data_reg+(data_in_even<<(input_counter<<4))+(data_in_odd<<((input_counter+1)<<4));
			end
			CAL0:data_reg[31:16]<=((data_sum01&16'h8000)==16'h8000)?data1-((data_sum01>>1)|16'h8000):data1-(data_sum01>>1);
			CAL:begin
				output_counter<=output_counter+1'b1;
				data_reg[63:48]<=data_odd_updated;
				data_reg[47:32]<=((data_sum2&16'h8000)==16'h8000)?data2+((data_sum2>>2)|16'hc000):data2+(data_sum2>>2);
				even_offset<=even_offset+1'b1;
				odd_offset<=odd_offset+1'b1;
				data_reg<=(data_odd_updated<<16)+(((data_sum2&16'h8000)==16'h8000)?data2+((data_sum2>>2)|16'hc000):data2+(data_sum2>>2))+(data_in_even<<32)+(data_in_odd<<48);
			end
			RESET:begin
				output_counter<=6'd0;
				line_offset<=line_offset+1'b1;
				input_counter<=8'd0;
				data_reg<=64'd0;
				even_offset<=8'd0;
				odd_offset<=(!wavelet_mode)?8'd32:8'd16;
			end
		endcase

endmodule 















