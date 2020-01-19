module lifted_wavelet_decomposition
(
	input clk,
	input rst_n,
	input data_valid,
	input[15:0] data_in_odd,
	input[15:0] data_in_even,
	input[7:0] line_address,
	output [15:0] data_out_odd,
	output [15:0] data_out_even,
	output data_loading,
	output output_valid,
	output [15:0] odd_address,
	output [15:0] even_address
);

parameter IDLE=2'b00;
parameter LOAD=2'b01;
parameter CAL=2'b11;


reg[7:0] odd_offset;
reg[7:0] even_offset;

reg [1:0] step;
reg [1:0] step_next;
reg [16:0] data_odd[0:31];
reg [16:0] data_even[0:31];
reg [7:0] data_counter;

reg [4:0] cal_counter;
wire[4:0]number_left=cal_counter-1'b1;
wire[4:0]number_right=cal_counter+1'b1;

wire[15:0] data_sum1=data_even[cal_counter]+data_even[number_right];
wire[15:0] data_odd_updated=((data_sum1&16'h8000)==16'h8000)?data_odd[cal_counter]-((data_sum1>>1)|16'h8000):data_odd[cal_counter]-(data_sum1>>1);
wire[15:0] data_sum2=data_odd_updated+data_odd[number_left]+2;
wire[5:0] display_address=cal_counter-1'b1;
assign data_out_even=data_even[display_address];
assign data_out_odd=data_odd[display_address];
assign odd_address=(line_address<<6)+odd_offset;
assign even_address=(line_address<<6)+even_offset;


always @(posedge clk or negedge rst_n)
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
			if(data_counter>=6'd32)
				step_next<=CAL;
			else
				step_next<=LOAD;
		
		endcase

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		data_counter<=8'd0;
		cal_counter<=-5'd1;
		even_offset<=-8'd1;
		odd_offset<=8'd31;
	end
	else
		case(step_next)
		LOAD:begin
			data_odd[data_counter]<=data_in_odd;
			data_even[data_counter]<=data_in_even;
			data_counter<=data_counter+1'b1;
		end
		CAL:begin
			data_odd[cal_counter]<=data_odd_updated;
			data_even[cal_counter]<=((data_sum2&16'h8000)==16'h8000)?data_even[cal_counter]+((data_sum2>>2)|16'hc000):data_even[cal_counter]+(data_sum2>>2);
			cal_counter<=cal_counter+1'b1;
			even_offset<=even_offset+1'b1;
			odd_offset<=odd_offset+1'b1;
		end
		endcase
	endmodule
		
		
		
