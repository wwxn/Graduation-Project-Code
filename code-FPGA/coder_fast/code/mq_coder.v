module mq_coder
(
	input clk,
	input rst_n,
	input [3:0] cx,
	input bit,
	input input_valid,
	output update_flag,
	output reg [7:0] byte_out,
	output reg output_valid
);

parameter IDLE=2'b00;
parameter UPDATE=2'b01;
parameter RENORME1=2'b11;
parameter RENORME2=2'b10;




reg [1:0] step;
reg [1:0] step_next;
assign update_flag=(step_next==UPDATE||step_next==IDLE)?1'b1:1'b0;
reg [5:0] index_table [0:8];
reg  mps_table [0:8];

wire mps=mps_table[cx];
wire [5:0] index=index_table[cx];
reg [15:0]A;
reg [27:0]C;
reg [7:0] B;
reg [4:0] CT;

wire tables_inst1_rst_n=rst_n;
wire [5:0] tables_inst1_index=index;
wire [15:0] tables_inst1_qe_out;
wire [5:0] tables_inst1_nmps_out;
wire [5:0] tables_inst1_nlps_out;
wire tables_inst1_switch_out;



wire [3:0] find_highest_bit_inst1_times;


wire [15:0] A_temp=A-tables_inst1_qe_out;

wire [3:0] times=find_highest_bit_inst1_times;
wire [4:0] times1=CT;




						
wire [15:0] A_updated=((bit!=mps&&A_temp>=tables_inst1_qe_out)||(bit==mps&&A_temp<tables_inst1_qe_out))?tables_inst1_qe_out:A_temp;
wire [27:0] C_updated=((bit==mps&&A_temp>=tables_inst1_qe_out)||(bit!=mps&&A_temp<tables_inst1_qe_out))?C+tables_inst1_qe_out:C;

wire [27:0] c_temp0=(times>=times1)?(C_updated<<times1):C_updated;
wire [27:0] c_temp=c_temp0&28'h7ffffff;
wire [4:0] CTtemp=((times>=times1)&&((B==8'hff)||(c_temp0>=28'h8000000&&B==8'hfe)))?(5'd7-(times-times1)):
						(times>=times1)?(5'd8-(times-times1)):5'd0;
wire [15:0] find_highest_bit_inst1_data_in=A_updated;

always @(posedge clk or negedge rst_n)
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
		UPDATE:;
	endcase
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		A<=16'h8000;
		C<=28'd0;
		B<=8'd0;
		CT<=5'd12;
		index_table[0]<=6'd0;
		index_table[1]<=6'd0;
		index_table[2]<=6'd0;
		index_table[3]<=6'd0;
		index_table[4]<=6'd0;
		index_table[5]<=6'd0;
		index_table[6]<=6'd0;
		index_table[7]<=6'd0;
		index_table[8]<=6'd0;
		mps_table[0]<=1'b0;
		mps_table[1]<=1'b0;
		mps_table[2]<=1'b0;
		mps_table[3]<=1'b0;
		mps_table[4]<=1'b0;
		mps_table[5]<=1'b0;
		mps_table[6]<=1'b0;
		mps_table[7]<=1'b0;
		mps_table[8]<=1'b0;
	end
	else
		case(step_next)
			UPDATE:begin
				output_valid<=1'b0;
				mps_table[cx]<=((bit!=mps)&&(tables_inst1_switch_out==1'b1))?(~mps_table[cx]):mps_table[cx];
				index_table[cx]<=(bit!=mps)?tables_inst1_nlps_out:
									  (A_temp<16'h8000)?tables_inst1_nmps_out:index_table[cx];
				A<=(A_updated<16'h8000)?A_updated<<times:A_updated;
				byte_out<=(A_updated<16'h8000)?(((times>=times1)&&(B==8'hff||c_temp0<28'h8000000))?B:
							 (times>=times1)?B+1'b1:byte_out):byte_out;
				output_valid <= (A_updated<16'h8000)?((times>=times1)?1'b1:1'b0):1'b0;
				C<=(A_updated<16'h8000)?((times<times1)?(C_updated<<times):
					((CTtemp[4]==1'b0)&&(B==8'hff))?((c_temp0 & 28'hfffff) << (times - times1)):
					((CTtemp[4]==1'b0)&&(c_temp0>=28'h8000000)&&(B==8'hfe))?((c_temp & 28'hfffff) << (times - times1)):
					(CTtemp[4]==1'b0)?((c_temp0 & 28'h7ffff) << (times - times1)):
					((CTtemp[4]==1'b1)&&(B==8'hff))?((c_temp0 & 28'hfffff) << 7):
					((CTtemp[4]==1'b1)&&(c_temp0>=28'h8000000)&&(B==8'hfe))?((c_temp & 28'hfffff) << 7):
					(CTtemp[4]==1'b1)?((c_temp0 & 28'h7ffff) << 8):C_updated):C_updated;
				CT<=(A_updated<16'h8000)?((times<times1)?CT-times:
					 (CTtemp[4]==1'b0)?CTtemp:
					 ((CTtemp[4]==1'b1)&&((B==8'hff)||(c_temp0>=28'h8000000&&B==8'hfe)))?4'd7:
					 (CTtemp[4]==1'b1)?4'd8:CT):CT;
				B<=(A_updated<16'h8000)?(((times>=times1)&&(B==8'hff))?(c_temp0>>20)&8'hff:
					((times>=times1)&&(c_temp0>=28'h8000000)&&(B==8'hfe))?(c_temp>>20)&8'hff:
					(times>=times1)?(c_temp0>>19)&8'hff:B):B;
			end
		endcase

		
find_highest_bit find_highest_bit_inst1
(
	.data_in(find_highest_bit_inst1_data_in),
	.times(find_highest_bit_inst1_times)
);
		
tables tables_inst1
(
	.rst_n(tables_inst1_rst_n),
	.index(tables_inst1_index),
	.qe_out(tables_inst1_qe_out),
	.nmps_out(tables_inst1_nmps_out),
	.nlps_out(tables_inst1_nlps_out),
	.switch_out(tables_inst1_switch_out)
);


endmodule 