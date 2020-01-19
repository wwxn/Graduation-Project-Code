module lifted_wavelet_decomposition
(
	input clk,
	input rst_n,
	input data_valid,
	input[15:0] data_in,
	input[7:0] line_address,
	output [15:0] odd_address,
	output [15:0] even_address,
	output reg [15:0] data_out_odd,
	output reg [15:0] data_out_even,
	output data_loading,
	output output_valid,
	output update_flag
);


reg[5:0] save_wait_counter;
reg[10:0] data_counter;
reg[6:0] step;
reg[6:0] step_next;
reg[63:0] data_reg;
reg[1:0] wait_counter;
reg[7:0] odd_offset;
reg[7:0] even_offset;
reg[7:0] cal_counter;
reg[15:0] first_input;

assign update_flag=((step==8'd0&&step_next==8'd1)||(step_next==8'd2)||step_next==8'd3)?1'b1:1'b0;
wire[15:0] data3=data_reg[15:0];
wire[15:0] data2=data_reg[31:16];
wire[15:0] data1=data_reg[47:32];
wire[15:0] data0=data_reg[63:48];
wire[15:0] data_sum1=(cal_counter==8'd31)?data1+first_input:data1+data3;
wire[15:0] data_sum2=(cal_counter==8'd0)?data2+data1+2:data0+data2+2;


assign data_loading=(step_next==7'd1||step_next==7'd4)?1'b1:1'b0;
assign output_valid=(step==7'd3)?1'b1:1'b0;
assign odd_address=(line_address<<6)+odd_offset;
assign even_address=(line_address<<6)+even_offset;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=7'd0;
	else
		step<=step_next;
		
always@*
	if(data_valid)
		case(step)
			7'd0:
			if(wait_counter==2'd0)
				step_next<=7'd1;
			else
				step_next<=7'd0;
			7'd1:
			if(data_counter<2'd3)
				step_next<=7'd1;
			else
				step_next<=7'd2;
			7'd2:step_next<=7'd3;
			7'd3:step_next<=7'd4;
			7'd4:
			if(data_counter<2'd2)
				step_next<=7'd4;
			else
				step_next<=7'd5;
			7'd5:
			if(save_wait_counter<6'd30)
				step_next<=7'd5;
			else
				step_next<=7'd2;
		endcase
	else
		step_next<=7'd0;
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		data_counter<=11'd0;
//		data_out_odd<=16'd0;
//		data_out_even<=16'd0;
		data_reg<=64'd0;
		wait_counter<=2'd0;
		even_offset<=8'd0;
		odd_offset<=8'd32;
		save_wait_counter<=6'd0;
		cal_counter<=8'd0;
	end
	else
		case(step_next)
			7'd0:begin
				wait_counter<=wait_counter+1'b1;
			end
			7'd1:begin
				wait_counter<=1'b0;
				data_reg<=(data_reg<<16)|data_in;
				data_counter<=data_counter+1'b1;
			end
			7'd2:begin
				save_wait_counter<=6'd0;
				data_counter<=11'd0;
				odd_offset<=odd_offset+1'b1;
				if(cal_counter==8'd0)
					first_input<=data1;
				data_reg[31:16]=((data_sum1&16'h8000)==16'h8000)?data2-((data_sum1>>1)|16'h8000):data2-(data_sum1>>1);
				data_out_odd=data_reg[31:16];
			end
			7'd3:begin
				cal_counter<=cal_counter+1'b1;
				even_offset<=even_offset+1'b1;
				data_reg[47:32]=((data_sum2&16'h8000)==16'h8000)?data1+((data_sum2>>2)|16'hc000):data1+(data_sum2>>2);
				data_out_even=data_reg[47:32];
			end
			7'd4:begin
				data_reg<=(data_reg<<16)|data_in;
				data_counter<=data_counter+1'b1;
			end
			7'd5:
				save_wait_counter<=save_wait_counter+1'b1;
		endcase

endmodule 