module bit_plane_coder
(
	input clk,
	input rst_n,
	input [2:0] subband,
	input [15:0] data0,
	input [15:0] data1,
	input [15:0] data2,
	input [15:0] data3,
	input [15:0] data4,
	input [15:0] data5,
	input [15:0] data6,
	input [15:0] data7,
	input [15:0] data8,
	input input_valid,
	output wrreq,
	output bit_out,
	output [3:0] cx_out,
	output code_ready
);

localparam LL=3'd0;
localparam HL1=3'd1;
localparam HL2=3'd2;
localparam LH1=3'd3;
localparam LH2=3'd4;
localparam HH1=3'd5;
localparam HH2=3'd6;

localparam IDLE=4'b0000;
localparam UPDATE=4'b0001;

reg [3:0] step;
reg [3:0] step_next;

reg [4:0] bit_number;

wire [3:0] bit_number_least=(subband==LL||subband==HL1||subband==LH1)?3'd3:
									 (subband==HH1)?3'd4:3'd5;

wire [7:0] weighted_sum=(subband==LL)?data0[bit_number]*8+data1[bit_number]*14+data2[bit_number]*9+data3[bit_number]*15+data5[bit_number]*15+data6[bit_number]*10+data7[bit_number]*14+data8[bit_number]*8:
								(subband==HL1)?data0[bit_number]*9+data1[bit_number]*19+data2[bit_number]*10+data3[bit_number]*4+data5[bit_number]*5+data6[bit_number]*11+data7[bit_number]*19+data8[bit_number]*9:
								(subband==HL2)?data0[bit_number]*5+data1[bit_number]*31+data2[bit_number]*6+data3[bit_number]*1+data5[bit_number]*1+data6[bit_number]*6+data7[bit_number]*31+data8[bit_number]*6:
								(subband==LH1)?data0[bit_number]*9+data1[bit_number]*6+data2[bit_number]*10+data3[bit_number]*18+data5[bit_number]*18+data6[bit_number]*10+data7[bit_number]*5+data8[bit_number]*10:
								(subband==LH2)?data0[bit_number]*6+data1[bit_number]*2+data2[bit_number]*7+data3[bit_number]*29+data5[bit_number]*29+data6[bit_number]*7+data7[bit_number]*1+data8[bit_number]*6:
						      (subband==HH1)?data0[bit_number]*11+data1[bit_number]*10+data2[bit_number]*12+data3[bit_number]*9+data5[bit_number]*9+data6[bit_number]*12+data7[bit_number]*10+data8[bit_number]*11:
								(subband==HH2)?data0[bit_number]*10+data1[bit_number]*9+data2[bit_number]*9+data3[bit_number]*11+data5[bit_number]*9+data6[bit_number]*10+data7[bit_number]*9+data8[bit_number]*10:8'd0;

assign cx_out=(weighted_sum<=8'd4)?4'd0:
			 (weighted_sum<=8'd14)?4'd1:
			 (weighted_sum<=8'd25)?4'd2:
			 (weighted_sum<=8'd35)?4'd3:
			 (weighted_sum<=8'd44)?4'd4:
			 (weighted_sum<=8'd54)?4'd5:
			 (weighted_sum<=8'd65)?4'd6:
			 (weighted_sum<=8'd82)?4'd7:4'd8;

assign wrreq=(step_next==UPDATE)?1'b1:1'b0;

assign bit_out=data4[bit_number];
assign code_ready=(step_next==IDLE)?1'b1:1'b0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=IDLE;
	else
		step<=step_next;

		
always@*
	case(step)
		IDLE:
			if(input_valid)
				step_next<=UPDATE;
			else
				step_next<=IDLE;
		UPDATE:
			if(bit_number<bit_number_least)
				step_next<=IDLE;
			else
				step_next<=UPDATE;
	endcase

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		bit_number<=4'd8;
	end
	else
		case(step_next)
		IDLE:
			bit_number<=4'd8;
		UPDATE:
			bit_number<=bit_number-1'b1;
		endcase
		







endmodule 
