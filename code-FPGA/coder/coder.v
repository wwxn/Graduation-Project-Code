module coder
(
	input clk,
	input rst_n,
	input bit_input,
	input input_valid,
	output reg bit_output,
	output reg output_valid,
	output code_ready
);

parameter context=4'd0;

reg LPS;
reg [10:0] R;
reg [10:0] L;
reg [10:0] RLPS;
reg [10:0] bits_outstanding;
reg first_bit;
reg [8:0] address;
reg [6:0] step;
reg [6:0] step_next;
reg rom_clk;
reg [5:0] state;

wire [7:0] rom_out;
wire [10:0] RMPS=R-RLPS;
wire MPS=~LPS;
wire [1:0] R_quantization=(R>>6)&2'b11;
assign code_ready=(step==7'd0)?1'd1:1'd0;

rom rom_inst1
(
	.clock(rom_clk),
	.address(address),
	.q(rom_out)
);

always@(posedge clk or negedge rst_n)
	if(!rst_n) 
		step<=7'd0;
	else
		step<=step_next;

always@*
	case(step)
		7'd0:
		if(input_valid==1'b1)
			step_next<=7'd1;
		else
			step_next<=7'd0;
		7'd1:step_next<=7'd2;
		7'd2:
		if(bit_input==MPS)
			step_next<=7'd3;
		else
			step_next<=7'd5;
		7'd3:step_next<=7'd4;
		7'd4:
		if(R<11'd256)
			step_next<=7'd7;
		else
			step_next<=7'd0;
		7'd5:
		if(state==6'd0)
			step_next<=7'd6;
		else
			step_next<=7'd3;
		7'd6:step_next<=7'd3;
		7'd7:
		if(L<11'd256)
			step_next<=7'd8;
		else
			step_next<=7'd9;
		7'd8:
		if(first_bit==1'b0)
			step_next<=7'd10;
		else
			step_next<=7'd11;
		7'd9:
		if(L<11'h200)
			step_next<=7'd13;
		else
			step_next<=7'd14;
		7'd10:
		if(bits_outstanding>0)
			step_next<=7'd12;
		else
			step_next<=7'd13;
		7'd11:
		if(bits_outstanding>0)
			step_next<=7'd12;
		else
			step_next<=7'd13;
		7'd12:
		if(bits_outstanding>0)
			step_next<=7'd12;
		else
			step_next<=7'd13;
		7'd13:
		if(R<11'h100)
			step_next<=7'd7;
		else
			step_next<=7'd0;
		7'd14:
		if(first_bit==1'b0)
			step_next<=7'd15;
		else
			step_next<=7'd16;
		7'd15:
		if(bits_outstanding>0)
			step_next<=7'd17;
		else
			step_next<=7'd13;
		7'd16:
		if(bits_outstanding>0)
			step_next<=7'd17;
		else
			step_next<=7'd13;
		7'd17:
		if(bits_outstanding>0)
			step_next<=7'd17;
		else
			step_next<=7'd13;
	endcase


always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		LPS<=(context<=4'd4)?1'b1:1'b0;
		R<=11'd510;
		L<=11'd0;
		bits_outstanding<=11'd0;
		first_bit<=1'b1;
		rom_clk<=1'b0;
		output_valid<=1'b0;
		case(context)
			4'd0:state<=6'd32;
			4'd1:state<=6'd17;
			4'd2:state<=6'd10;
			4'd3:state<=6'd5;
			4'd4:state<=6'd2;
			4'd5:state<=6'd1;
			4'd6:state<=6'd5;
			4'd7:state<=6'd11;
			4'd8:state<=6'd19;
		endcase
	end
	else
		case (step_next)
		7'd1:begin
			rom_clk<=1'b1;
			address<=(state<<2)+R_quantization;
		end
		7'd2:begin
			RLPS=rom_out;
			R=R-RLPS;
			rom_clk<=1'b0;
		end
		7'd3:begin
			rom_clk<=1'b1;
			address<=(bit_input==MPS)?(9'd320+state):(9'd256+state);
		end
		7'd4:begin
			state=rom_out;
			rom_clk<=1'b0;
		end
		7'd5:begin
			L<=L+R;
			R<=RLPS;
		end
		7'd6:LPS=~LPS;
		7'd7:;
		7'd8:;
		7'd9:
		if(L<11'h200)begin
			L<=L-11'h100;
			bits_outstanding<=bits_outstanding+1'b1;
		end
		7'd10:begin
			output_valid<=1'b1;
			bit_output<=1'b0;
		end
		7'd11:first_bit<=1'd0;
		7'd12:begin
			output_valid<=1'b1;
			bit_output<=1'b1;
			bits_outstanding<=bits_outstanding-1'b1;
		end
		7'd13:begin
			output_valid<=1'b0;
			R<=R<<1;
			L<=L<<1;
		end
		7'd14:L<=L-11'h200;
		7'd15:begin
			output_valid<=1'b1;
			bit_output<=1'b1;
		end
		7'd16:first_bit<=1'd0;
		7'd17:begin
			output_valid<=1'b1;
			bit_output<=1'b0;
			bits_outstanding<=bits_outstanding-1'b1;
		end
		7'd13:begin
			output_valid<=1'b0;
			R<=R<<1;
			L<=L<<1;
		end
		endcase
end

endmodule 