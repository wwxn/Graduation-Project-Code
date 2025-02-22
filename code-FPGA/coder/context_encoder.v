module context_encoder
(
	input clk,
	input rst_n,
	input [15:0] data_input_row0,
	input [15:0] data_input_row1,
	input [15:0] data_input_row2,
	input cal_flag,
	output ram_update_flag
);
//localparams
parameter SUBBAND=2'd3;
parameter LL=2'd3;
parameter HL=2'd1;
parameter LH=2'd2;
parameter IDLE=8'd0;
parameter INITIAL=8'd1;
parameter READ0=8'd2;
parameter CALCULATE=8'd3;
parameter DISTRIBUTION=8'd4;
parameter READ1=8'd5;
parameter WAITEMPTY=8'd6;
//local registers
reg [15:0] data_line0_row0;
reg [15:0] data_line0_row1;
reg [15:0] data_line0_row2;
reg [15:0] data_line1_row0;
reg [15:0] data_line1_row1;
reg [15:0] data_line1_row2;
reg [15:0] data_line2_row0;
reg [15:0] data_line2_row1;
reg [15:0] data_line2_row2;
reg [7:0] sum0;
reg [7:0] sum1;
reg [7:0] sum2;
reg [7:0] sum3;
reg [7:0] sum4;
reg [7:0] sum5;
reg [7:0] sum6;
reg [7:0] sum7;
reg [7:0] sum8;
reg bit_code0;
reg bit_code1;
reg bit_code2;
reg bit_code3;
reg bit_code4;
reg bit_code5;
reg bit_code6;
reg bit_code7;
reg bit_code8;
reg[7:0] step;
reg[7:0] step_next;
reg [3:0] distribution_counter;

//general signals for coding queue
wire coding_queue_clk=clk;
wire coding_queue_rst_n=rst_n;
wire coding_queue_bit_input=(distribution_counter==4'd0)?bit_code3:
									 (distribution_counter==4'd1)?bit_code4:
									 (distribution_counter==4'd2)?bit_code5:
									 (distribution_counter==4'd3)?bit_code6:
									 (distribution_counter==4'd4)?bit_code7:
									 (distribution_counter==4'd5)?bit_code8:1'b0;
//signals for context0

reg context0_inst1_wrreq;
wire context0_inst1_bit_output;
wire context0_inst1_fifo_full;
wire context0_inst1_fifo_empty;
//signals for context1
wire context1_inst1_bit_input;
reg context1_inst1_wrreq;
wire context1_inst1_bit_output;
wire context1_inst1_fifo_full;
wire context1_inst1_fifo_empty;
//signals for context2
wire context2_inst1_bit_input;
reg context2_inst1_wrreq;
wire context2_inst1_bit_output;
wire context2_inst1_fifo_full;
wire context2_inst1_fifo_empty;
//signals for context3
wire context3_inst1_bit_input;
reg context3_inst1_wrreq;
wire context3_inst1_bit_output;
wire context3_inst1_fifo_full;
wire context3_inst1_fifo_empty;
//signals for context4
wire context4_inst1_bit_input;
reg context4_inst1_wrreq;
wire context4_inst1_bit_output;
wire context4_inst1_fifo_full;
wire context4_inst1_fifo_empty;
//signals for context5
wire context5_inst1_bit_input;
reg context5_inst1_wrreq;
wire context5_inst1_bit_output;
wire context5_inst1_fifo_full;
wire context5_inst1_fifo_empty;
//signals for context6
wire context6_inst1_bit_input;
reg context6_inst1_wrreq;
wire context6_inst1_bit_output;
wire context6_inst1_fifo_full;
wire context6_inst1_fifo_empty;
//signals for context7
wire context7_inst1_bit_input;
reg context7_inst1_wrreq;
wire context7_inst1_bit_output;
wire context7_inst1_fifo_full;
wire context7_inst1_fifo_empty;
//signals for context8
wire context8_inst1_bit_input;
reg context8_inst1_wrreq;
wire context8_inst1_bit_output;
wire context8_inst1_fifo_full;
wire context8_inst1_fifo_empty;

//local wires
wire [7:0] sum_code=(distribution_counter==4'd0)?sum3:
						  (distribution_counter==4'd1)?sum4:
						  (distribution_counter==4'd2)?sum5:
						  (distribution_counter==4'd3)?sum6:
						  (distribution_counter==4'd4)?sum7:
						  (distribution_counter==4'd5)?sum8:1'b0;
assign ram_update_flag=(step_next==CALCULATE)?1'b1:1'b0;
wire full_all=context0_inst1_fifo_full|
				  context1_inst1_fifo_full|
				  context2_inst1_fifo_full|
				  context3_inst1_fifo_full|
				  context4_inst1_fifo_full|
				  context5_inst1_fifo_full|
				  context6_inst1_fifo_full|
				  context7_inst1_fifo_full|
				  context8_inst1_fifo_full;
wire empty_all=context0_inst1_fifo_empty&
					context1_inst1_fifo_empty&
					context2_inst1_fifo_empty&
					context3_inst1_fifo_empty&
					context4_inst1_fifo_empty&
					context5_inst1_fifo_empty&
					context6_inst1_fifo_empty&
					context7_inst1_fifo_empty&
					context8_inst1_fifo_empty;


always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=8'd0;
	else
		step<=step_next;
		
always@*
	case(step)
	IDLE:step_next<=READ0;
//	INITIAL:step_next<=READ;
	READ0:
	if(cal_flag)
		step_next<=CALCULATE;
	else
		step_next<=READ0;
	CALCULATE:step_next<=DISTRIBUTION;
	DISTRIBUTION:
	if(full_all&&distribution_counter==4'd5)
		step_next<=READ1;
	else if(full_all)
		step_next<=WAITEMPTY;
	else if(distribution_counter==4'd5)
		step_next<=READ1;
	else
		step_next<=DISTRIBUTION;
	READ1:step_next<=CALCULATE;
	WAITEMPTY:
	if(empty_all)
		step_next<=DISTRIBUTION;
	else
		step_next<=WAITEMPTY;
	endcase
	
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		data_line0_row0<=16'd0;
		data_line0_row1<=16'd0;
		data_line0_row2<=16'd0;
		data_line1_row0<=16'd0;
		data_line1_row1<=16'd0;
		data_line1_row2<=16'd0;
		data_line2_row0<=16'd0;
		data_line2_row1<=16'd0;
		data_line2_row2<=16'd0;
		distribution_counter<=4'd0;
	end
	else
		case(step_next)
		READ0:begin
			distribution_counter<=4'd0;
			data_line0_row0<=data_line1_row0;
			data_line0_row1<=data_line1_row1;
			data_line0_row2<=data_line1_row2;
			data_line1_row0<=data_line2_row0;
			data_line1_row1<=data_line2_row1;
			data_line1_row2<=data_line2_row2;
			data_line2_row0<=data_input_row0;
			data_line2_row1<=data_input_row1;
			data_line2_row2<=data_input_row2;
		end
		READ1:begin
			distribution_counter<=4'd0;
			data_line0_row0<=data_line1_row0;
			data_line0_row1<=data_line1_row1;
			data_line0_row2<=data_line1_row2;
			data_line1_row0<=data_line2_row0;
			data_line1_row1<=data_line2_row1;
			data_line1_row2<=data_line2_row2;
			data_line2_row0<=data_input_row0;
			data_line2_row1<=data_input_row1;
			data_line2_row2<=data_input_row2;
		end
		CALCULATE:begin
				
				bit_code3<=data_line1_row1[3];
				bit_code4<=data_line1_row1[4];
				bit_code5<=data_line1_row1[5];
				bit_code6<=data_line1_row1[6];
				bit_code7<=data_line1_row1[7];
				bit_code8<=data_line1_row1[8];
				if(SUBBAND==LL)begin
//					sum3<=((data_line0_row0[3]<<3))+
//							((data_line1_row0[3]<<3)+(data_line1_row0[3]<<2)+(data_line1_row0[3]<<1))+
//							((data_line2_row0[3]<<3)+(data_line2_row0[3]))+
//							((data_line0_row1[3]<<3)+(data_line0_row1[3]<<2)+(data_line0_row1[3]<<1)+(data_line0_row1[3]))+
//							((data_line2_row1[3]<<3)+(data_line2_row1[3]<<2)+(data_line2_row1[3]<<1)+(data_line2_row1[3]))+
//							((data_line0_row2[3]<<3)+(data_line0_row2[3]<<1))+
//							((data_line1_row2[3]<<3)+(data_line1_row2[3]<<2)+(data_line1_row2[3]<<1))+
//							((data_line2_row2[3]<<3));
//					sum4<=((data_line0_row0[4]<<3))+
//							((data_line1_row0[4]<<3)+(data_line1_row0[4]<<2)+(data_line1_row0[4]<<1))+
//							((data_line2_row0[4]<<3)+(data_line2_row0[4]))+
//							((data_line0_row1[4]<<3)+(data_line0_row1[4]<<2)+(data_line0_row1[4]<<1)+(data_line0_row1[4]))+
//							((data_line2_row1[4]<<3)+(data_line2_row1[4]<<2)+(data_line2_row1[4]<<1)+(data_line2_row1[4]))+
//							((data_line0_row2[4]<<3)+(data_line0_row2[4]<<1))+
//							((data_line1_row2[4]<<3)+(data_line1_row2[4]<<2)+(data_line1_row2[4]<<1))+
//							((data_line2_row2[4]<<3));
//					sum5<=((data_line0_row0[5]<<3))+
//							((data_line1_row0[5]<<3)+(data_line1_row0[5]<<2)+(data_line1_row0[5]<<1))+
//							((data_line2_row0[5]<<3)+(data_line2_row0[5]))+
//							((data_line0_row1[5]<<3)+(data_line0_row1[5]<<2)+(data_line0_row1[5]<<1)+(data_line0_row1[5]))+
//							((data_line2_row1[5]<<3)+(data_line2_row1[5]<<2)+(data_line2_row1[5]<<1)+(data_line2_row1[5]))+
//							((data_line0_row2[5]<<3)+(data_line0_row2[5]<<1))+
//							((data_line1_row2[5]<<3)+(data_line1_row2[5]<<2)+(data_line1_row2[5]<<1))+
//							((data_line2_row2[5]<<3));
//					sum6<=((data_line0_row0[6]<<3))+
//							((data_line1_row0[6]<<3)+(data_line1_row0[6]<<2)+(data_line1_row0[6]<<1))+
//							((data_line2_row0[6]<<3)+(data_line2_row0[6]))+
//							((data_line0_row1[6]<<3)+(data_line0_row1[6]<<2)+(data_line0_row1[6]<<1)+(data_line0_row1[6]))+
//							((data_line2_row1[6]<<3)+(data_line2_row1[6]<<2)+(data_line2_row1[6]<<1)+(data_line2_row1[6]))+
//							((data_line0_row2[6]<<3)+(data_line0_row2[6]<<1))+
//							((data_line1_row2[6]<<3)+(data_line1_row2[6]<<2)+(data_line1_row2[6]<<1))+
//							((data_line2_row2[3]<<3));
//					sum7<=((data_line0_row0[7]<<3))+
//							((data_line1_row0[7]<<3)+(data_line1_row0[7]<<2)+(data_line1_row0[7]<<1))+
//							((data_line2_row0[7]<<3)+(data_line2_row0[7]))+
//							((data_line0_row1[7]<<3)+(data_line0_row1[7]<<2)+(data_line0_row1[7]<<1)+(data_line0_row1[7]))+
//							((data_line2_row1[7]<<3)+(data_line2_row1[7]<<2)+(data_line2_row1[7]<<1)+(data_line2_row1[7]))+
//							((data_line0_row2[7]<<3)+(data_line0_row2[7]<<1))+
//							((data_line1_row2[7]<<3)+(data_line1_row2[7]<<2)+(data_line1_row2[7]<<1))+
//							((data_line2_row2[7]<<3));
//					sum8<=((data_line0_row0[8]<<3))+
//							((data_line1_row0[8]<<3)+(data_line1_row0[8]<<2)+(data_line1_row0[8]<<1))+
//							((data_line2_row0[8]<<3)+(data_line2_row0[8]))+
//							((data_line0_row1[8]<<3)+(data_line0_row1[8]<<2)+(data_line0_row1[8]<<1)+(data_line0_row1[8]))+
//							((data_line2_row1[8]<<3)+(data_line2_row1[8]<<2)+(data_line2_row1[8]<<1)+(data_line2_row1[8]))+
//							((data_line0_row2[8]<<3)+(data_line0_row2[8]<<1))+
//							((data_line1_row2[8]<<3)+(data_line1_row2[8]<<2)+(data_line1_row2[8]<<1))+
//							((data_line2_row2[8]<<3));
							sum3<=((data_line0_row0[3]*8))+
									((data_line1_row0[3]*14))+
									((data_line2_row0[3]*9))+
									((data_line0_row1[3]*15))+
									((data_line2_row1[3]*15))+
									((data_line0_row2[3]*10))+
									((data_line1_row2[3]*14))+
									((data_line2_row2[3]*8));
							sum4<=((data_line0_row0[4]*8))+
									((data_line1_row0[4]*14))+
									((data_line2_row0[4]*9))+
									((data_line0_row1[4]*15))+
									((data_line2_row1[4]*15))+
									((data_line0_row2[4]*10))+
									((data_line1_row2[4]*14))+
									((data_line2_row2[4]*8));
							sum5<=((data_line0_row0[5]*8))+
									((data_line1_row0[5]*14))+
									((data_line2_row0[5]*9))+
									((data_line0_row1[5]*15))+
									((data_line2_row1[5]*15))+
									((data_line0_row2[5]*10))+
									((data_line1_row2[5]*14))+
									((data_line2_row2[5]*8));
							sum6<=((data_line0_row0[6]*8))+
									((data_line1_row0[6]*14))+
									((data_line2_row0[6]*9))+
									((data_line0_row1[6]*15))+
									((data_line2_row1[6]*15))+
									((data_line0_row2[6]*10))+
									((data_line1_row2[6]*14))+
									((data_line2_row2[6]*8));
							sum7<=((data_line0_row0[7]*8))+
									((data_line1_row0[7]*14))+
									((data_line2_row0[7]*9))+
									((data_line0_row1[7]*15))+
									((data_line2_row1[7]*15))+
									((data_line0_row2[7]*10))+
									((data_line1_row2[7]*14))+
									((data_line2_row2[7]*8));
							sum8<=((data_line0_row0[8]*8))+
									((data_line1_row0[8]*14))+
									((data_line2_row0[8]*9))+
									((data_line0_row1[8]*15))+
									((data_line2_row1[8]*15))+
									((data_line0_row2[8]*10))+
									((data_line1_row2[8]*14))+
									((data_line2_row2[8]*8));
				end
				else if(SUBBAND==HL)begin
					sum3<=((data_line0_row0[3]*9))+
							((data_line1_row0[3]*19))+
							((data_line2_row0[3]*10))+
							((data_line0_row1[3]*4))+
							((data_line2_row1[3]*5))+
							((data_line0_row2[3]*11))+
							((data_line1_row2[3]*19))+
							((data_line2_row2[3]*9));
					sum4<=((data_line0_row0[4]*9))+
							((data_line1_row0[4]*19))+
							((data_line2_row0[4]*10))+
							((data_line0_row1[4]*4))+
							((data_line2_row1[4]*5))+
							((data_line0_row2[4]*11))+
							((data_line1_row2[4]*19))+
							((data_line2_row2[4]*9));
					sum5<=((data_line0_row0[5]*9))+
							((data_line1_row0[5]*19))+
							((data_line2_row0[5]*10))+
							((data_line0_row1[5]*4))+
							((data_line2_row1[5]*5))+
							((data_line0_row2[5]*11))+
							((data_line1_row2[5]*19))+
							((data_line2_row2[5]*9));
					sum6<=((data_line0_row0[6]*9))+
							((data_line1_row0[6]*19))+
							((data_line2_row0[6]*10))+
							((data_line0_row1[6]*4))+
							((data_line2_row1[6]*5))+
							((data_line0_row2[6]*11))+
							((data_line1_row2[6]*19))+
							((data_line2_row2[6]*9));
					sum7<=((data_line0_row0[7]*9))+
							((data_line1_row0[7]*19))+
							((data_line2_row0[7]*10))+
							((data_line0_row1[7]*4))+
							((data_line2_row1[7]*5))+
							((data_line0_row2[7]*11))+
							((data_line1_row2[7]*19))+
							((data_line2_row2[7]*9));
					sum8<=((data_line0_row0[8]*9))+
							((data_line1_row0[8]*19))+
							((data_line2_row0[8]*10))+
							((data_line0_row1[8]*4))+
							((data_line2_row1[8]*5))+
							((data_line0_row2[8]*11))+
							((data_line1_row2[8]*19))+
							((data_line2_row2[8]*9));
				end
				else if(SUBBAND==LH)begin
					sum3<=((data_line0_row0[3]*9))+
							((data_line1_row0[3]*6))+
							((data_line2_row0[3]*10))+
							((data_line0_row1[3]*18))+
							((data_line2_row1[3]*18))+
							((data_line0_row2[3]*10))+
							((data_line1_row2[3]*5))+
							((data_line2_row2[3]*10));
					sum4<=((data_line0_row0[4]*9))+
							((data_line1_row0[4]*6))+
							((data_line2_row0[4]*10))+
							((data_line0_row1[4]*18))+
							((data_line2_row1[4]*18))+
							((data_line0_row2[4]*10))+
							((data_line1_row2[4]*5))+
							((data_line2_row2[4]*10));
					sum5<=((data_line0_row0[5]*9))+
							((data_line1_row0[5]*6))+
							((data_line2_row0[5]*10))+
							((data_line0_row1[5]*18))+
							((data_line2_row1[5]*18))+
							((data_line0_row2[5]*10))+
							((data_line1_row2[5]*5))+
							((data_line2_row2[5]*10));
					sum6<=((data_line0_row0[6]*9))+
							((data_line1_row0[6]*6))+
							((data_line2_row0[6]*10))+
							((data_line0_row1[6]*18))+
							((data_line2_row1[6]*18))+
							((data_line0_row2[6]*10))+
							((data_line1_row2[6]*5))+
							((data_line2_row2[6]*10));
					sum7<=((data_line0_row0[7]*9))+
							((data_line1_row0[7]*6))+
							((data_line2_row0[7]*10))+
							((data_line0_row1[7]*18))+
							((data_line2_row1[7]*18))+
							((data_line0_row2[7]*10))+
							((data_line1_row2[7]*5))+
							((data_line2_row2[7]*10));
					sum8<=((data_line0_row0[8]*9))+
							((data_line1_row0[8]*6))+
							((data_line2_row0[8]*10))+
							((data_line0_row1[8]*18))+
							((data_line2_row1[8]*18))+
							((data_line0_row2[8]*10))+
							((data_line1_row2[8]*5))+
							((data_line2_row2[8]*10));
				end
		end
		DISTRIBUTION:begin
			context0_inst1_wrreq<=1'b0;
			context1_inst1_wrreq<=1'b0;
			context2_inst1_wrreq<=1'b0;
			context3_inst1_wrreq<=1'b0;
			context4_inst1_wrreq<=1'b0;
			context5_inst1_wrreq<=1'b0;
			context6_inst1_wrreq<=1'b0;
			context7_inst1_wrreq<=1'b0;
			context8_inst1_wrreq<=1'b0;
			distribution_counter<=distribution_counter+1'b1;
			if(sum_code<=8'd16&&sum_code>=8'd0)
				context0_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd26)
				context1_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd35)
				context2_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd43)
				context3_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd50)
				context4_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd58)
				context5_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd67)
				context6_inst1_wrreq<=1'b1;
			else if(sum_code<=8'd77)
				context7_inst1_wrreq<=1'b1;
			else
				context8_inst1_wrreq<=1'b1;
		end
		endcase





coding_queue 
#(
	.context(4'd0)
)
context0_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context0_inst1_wrreq),
	.bit_output(context0_inst1_bit_output),
	.fifo_full(context0_inst1_fifo_full),
	.fifo_empty(context0_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd1)
)
context1_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context1_inst1_wrreq),
	.bit_output(context1_inst1_bit_output),
	.fifo_full(context1_inst1_fifo_full),
	.fifo_empty(context1_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd2)
)
context2_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context2_inst1_wrreq),
	.bit_output(context2_inst1_bit_output),
	.fifo_full(context2_inst1_fifo_full),
	.fifo_empty(context2_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd3)
)
context3_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context3_inst1_wrreq),
	.bit_output(context3_inst1_bit_output),
	.fifo_full(context3_inst1_fifo_full),
	.fifo_empty(context3_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd4)
)
context4_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context4_inst1_wrreq),
	.bit_output(context4_inst1_bit_output),
	.fifo_full(context4_inst1_fifo_full),
	.fifo_empty(context4_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd5)
)
context5_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context5_inst1_wrreq),
	.bit_output(context5_inst1_bit_output),
	.fifo_full(context5_inst1_fifo_full),
	.fifo_empty(context5_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd6)
)
context6_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context6_inst1_wrreq),
	.bit_output(context6_inst1_bit_output),
	.fifo_full(context6_inst1_fifo_full),
	.fifo_empty(context6_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd7)
)
context7_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context7_inst1_wrreq),
	.bit_output(context7_inst1_bit_output),
	.fifo_full(context7_inst1_fifo_full),
	.fifo_empty(context7_inst1_fifo_empty)
);

coding_queue 
#(
	.context(4'd8)
)
context8_inst1
(
	.clk(coding_queue_clk),
	.rst_n(coding_queue_rst_n),
	.bit_input(coding_queue_bit_input),
	.wrreq(context8_inst1_wrreq),
	.bit_output(context8_inst1_bit_output),
	.fifo_full(context8_inst1_fifo_full),
	.fifo_empty(context8_inst1_fifo_empty)
);

endmodule 