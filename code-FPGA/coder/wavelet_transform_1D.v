module wavelet_transform_1D
(
	input clk,
	input rst_n,
	input [15:0] data_input,
	input  step_input,
	output data_in_ready,
	output [11:0] ram_address_in,
	output reg [15:0] ram_data_in,
	output ram_wren,
	output end_flag,
	output update_flag
);


reg[7:0] step;
reg[7:0] step_next;
reg [11:0] fill_counter;
reg [4:0] save_counter;

wire [15:0] line0;
wire [15:0] line1;
wire [15:0] line2;
wire [15:0] line3;
wire [15:0] line4;
wire [15:0] line5;
wire [15:0] line6;
wire [15:0] line7;
wire [15:0] line8;
wire [15:0] line9;
wire [15:0] line10;
wire [15:0] line11;
wire [15:0] line12;
wire [15:0] line13;
wire [15:0] line14;
wire [15:0] line15;

wire [15:0] data_out_odd0;
wire [15:0] data_out_even0;
wire [15:0] data_out_odd1;
wire [15:0] data_out_even1;
wire [15:0] data_out_odd2;
wire [15:0] data_out_even2;
wire [15:0] data_out_odd3;
wire [15:0] data_out_even3;
wire [15:0] data_out_odd4;
wire [15:0] data_out_even4;
wire [15:0] data_out_odd5;
wire [15:0] data_out_even5;
wire [15:0] data_out_odd6;
wire [15:0] data_out_even6;
wire [15:0] data_out_odd7;
wire [15:0] data_out_even7;
wire [15:0] data_out_odd8;
wire [15:0] data_out_even8;
wire [15:0] data_out_odd9;
wire [15:0] data_out_even9;
wire [15:0] data_out_odd10;
wire [15:0] data_out_even10;
wire [15:0] data_out_odd11;
wire [15:0] data_out_even11;
wire [15:0] data_out_odd12;
wire [15:0] data_out_even12;
wire [15:0] data_out_odd13;
wire [15:0] data_out_even13;
wire [15:0] data_out_odd14;
wire [15:0] data_out_even14;
wire [15:0] data_out_odd15;
wire [15:0] data_out_even15;

wire [15:0] odd_address0;
wire [15:0] even_address0;
wire [15:0] odd_address1;
wire [15:0] even_address1;
wire [15:0] odd_address2;
wire [15:0] even_address2;
wire [15:0] odd_address3;
wire [15:0] even_address3;
wire [15:0] odd_address4;
wire [15:0] even_address4;
wire [15:0] odd_address5;
wire [15:0] even_address5;
wire [15:0] odd_address6;
wire [15:0] even_address6;
wire [15:0] odd_address7;
wire [15:0] even_address7;
wire [15:0] odd_address8;
wire [15:0] even_address8;
wire [15:0] odd_address9;
wire [15:0] even_address9;
wire [15:0] odd_address10;
wire [15:0] even_address10;
wire [15:0] odd_address11;
wire [15:0] even_address11;
wire [15:0] odd_address12;
wire [15:0] even_address12;
wire [15:0] odd_address13;
wire [15:0] even_address13;
wire [15:0] odd_address14;
wire [15:0] even_address14;
wire [15:0] odd_address15;
wire [15:0] even_address15;

reg [7:0] line_address0;
reg [7:0] line_address1;
reg [7:0] line_address2;
reg [7:0] line_address3;
reg [7:0] line_address4;
reg [7:0] line_address5;
reg [7:0] line_address6;
reg [7:0] line_address7;
reg [7:0] line_address8;
reg [7:0] line_address9;
reg [7:0] line_address10;
reg [7:0] line_address11;
reg [7:0] line_address12;
reg [7:0] line_address13;
reg [7:0] line_address14;
reg [7:0] line_address15;

reg [15:0] ram_address_in_reg;
assign ram_address_in=ram_address_in_reg[11:0];

wire data_loading;
wire clken=(step==8'd1||step==8'd4)?1'b1:(data_loading==1'b1)?1'b1:1'b0;
wire data_valid=(step==8'd2||step==8'd3)?1'b1:1'b0;
assign ram_wren=(step==8'd2||step==8'd3)?1'b1:1'b0;
assign data_in_ready=clken;
assign end_flag=(step==8'd6)?1'b1:1'b0;
reg [7:0] wavelet_counter;
reg [4:0] wait_wavelet_counter;
reg [2:0] wavelet_time;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		step<=8'd0;
	else
		step<=step_next;

always@*
	case(step)
		8'd0:step_next<=8'd1;
		8'd1:
		if(step_input)
			if(fill_counter>=12'd1024)
				step_next<=8'd2;
			else
				step_next<=8'd1;
		else
			if(fill_counter>=12'd1024)
				step_next<=8'd2;
			else
				step_next<=8'd1;
		8'd2:
			if(wavelet_counter>=8'd66)
				step_next<=8'd3;
			else
				step_next<=8'd2;
		8'd3:
			if(wait_wavelet_counter>=5'd31)
				step_next<=8'd5;
			else
				step_next<=8'd3;
		8'd4:
			if(fill_counter>=12'd957)
				step_next<=8'd2;
			else
				step_next<=8'd4;
		8'd5:
			if(wavelet_time<8'd4)
				step_next<=8'd4;
			else
				step_next<=8'd6;
			
	endcase

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		fill_counter<=12'd0;
		save_counter<=5'd0;
		wavelet_counter<=8'd0;
		wait_wavelet_counter<=5'd0;
		wavelet_time<=3'd0;
		line_address0<=8'd0;
		line_address1<=8'd1;
		line_address2<=8'd2;
		line_address3<=8'd3;
		line_address4<=8'd4;
		line_address5<=8'd5;
		line_address6<=8'd6;
		line_address7<=8'd7;
		line_address8<=8'd8;
		line_address9<=8'd9;
		line_address10<=8'd10;
		line_address11<=8'd11;
		line_address12<=8'd12;
		line_address13<=8'd13;
		line_address14<=8'd14;
		line_address15<=8'd15;
	end
	else
		case(step_next)
			8'd1:begin
				wait_wavelet_counter<=5'd0;
				wavelet_counter<=8'd0;
				fill_counter<=fill_counter+1'b1;
			end
			8'd2:begin
				fill_counter<=12'd0;
				save_counter<=save_counter+1'b1;
				if(data_loading)
					wavelet_counter<=wavelet_counter+1'b1;
			end
			8'd3:begin
				save_counter<=save_counter+1'b1;
				wait_wavelet_counter<=wait_wavelet_counter+1'b1;
			end
			8'd4:begin
				wait_wavelet_counter<=5'd0;
				wavelet_counter<=8'd0;
				fill_counter<=fill_counter+1'b1;
			end
			8'd5:begin
				wavelet_time<=wavelet_time+1'b1;
				line_address0<=line_address0+8'd16;
				line_address1<=line_address1+8'd16;
				line_address2<=line_address2+8'd16;
				line_address3<=line_address3+8'd16;
				line_address4<=line_address4+8'd16;
				line_address5<=line_address5+8'd16;
				line_address6<=line_address6+8'd16;
				line_address7<=line_address7+8'd16;
				line_address8<=line_address8+8'd16;
				line_address9<=line_address9+8'd16;
				line_address10<=line_address10+8'd16;
				line_address11<=line_address11+8'd16;
				line_address12<=line_address12+8'd16;
				line_address13<=line_address13+8'd16;
				line_address14<=line_address14+8'd16;
				line_address15<=line_address15+8'd16;
			end
		endcase	

always@*
	case(save_counter)
	5'd0:begin
		ram_address_in_reg<=odd_address0;
		ram_data_in<=data_out_odd0;
	end
	5'd1:begin
		ram_address_in_reg<=even_address0;
		ram_data_in<=data_out_even0;
	end
	5'd2:begin
		ram_address_in_reg<=odd_address1;
		ram_data_in<=data_out_odd1;
	end
	5'd3:begin
		ram_address_in_reg<=even_address1;
		ram_data_in<=data_out_even1;
	end
	5'd4:begin
		ram_address_in_reg<=odd_address2;
		ram_data_in<=data_out_odd2;
	end
	5'd5:begin
		ram_address_in_reg<=even_address2;
		ram_data_in<=data_out_even2;
	end
	5'd6:begin
		ram_address_in_reg<=odd_address3;
		ram_data_in<=data_out_odd3;
	end
	5'd7:begin
		ram_address_in_reg<=even_address3;
		ram_data_in<=data_out_even3;
	end
	5'd8:begin
		ram_address_in_reg<=odd_address4;
		ram_data_in<=data_out_odd4;
	end
	5'd9:begin
		ram_address_in_reg<=even_address4;
		ram_data_in<=data_out_even4;
	end
	5'd10:begin
		ram_address_in_reg<=odd_address5;
		ram_data_in<=data_out_odd5;
	end
	5'd11:begin
		ram_address_in_reg<=even_address5;
		ram_data_in<=data_out_even5;
	end
	5'd12:begin
		ram_address_in_reg<=odd_address6;
		ram_data_in<=data_out_odd6;
	end
	5'd13:begin
		ram_address_in_reg<=even_address6;
		ram_data_in<=data_out_even6;
	end
	5'd14:begin
		ram_address_in_reg<=odd_address7;
		ram_data_in<=data_out_odd7;
	end
	5'd15:begin
		ram_address_in_reg<=even_address7;
		ram_data_in<=data_out_even7;
	end
	5'd16:begin
		ram_address_in_reg<=odd_address8;
		ram_data_in<=data_out_odd8;
	end
	5'd17:begin
		ram_address_in_reg<=even_address8;
		ram_data_in<=data_out_even8;
	end
	5'd18:begin
		ram_address_in_reg<=odd_address9;
		ram_data_in<=data_out_odd9;
	end
	5'd19:begin
		ram_address_in_reg<=even_address9;
		ram_data_in<=data_out_even9;
	end
	5'd20:begin
		ram_address_in_reg<=odd_address10;
		ram_data_in<=data_out_odd10;
	end
	5'd21:begin
		ram_address_in_reg<=even_address10;
		ram_data_in<=data_out_even10;
	end
	5'd22:begin
		ram_address_in_reg<=odd_address11;
		ram_data_in<=data_out_odd11;
	end
	5'd23:begin
		ram_address_in_reg<=even_address11;
		ram_data_in<=data_out_even11;
	end
	5'd24:begin
		ram_address_in_reg<=odd_address12;
		ram_data_in<=data_out_odd12;
	end
	5'd25:begin
		ram_address_in_reg<=even_address12;
		ram_data_in<=data_out_even12;
	end
	5'd26:begin
		ram_address_in_reg<=odd_address13;
		ram_data_in<=data_out_odd13;
	end
	5'd27:begin
		ram_address_in_reg<=even_address13;
		ram_data_in<=data_out_even13;
	end
	5'd28:begin
		ram_address_in_reg<=odd_address14;
		ram_data_in<=data_out_odd14;
	end
	5'd29:begin
		ram_address_in_reg<=even_address14;
		ram_data_in<=data_out_even14;
	end
	5'd30:begin
		ram_address_in_reg<=odd_address15;
		ram_data_in<=data_out_odd15;
	end
	5'd31:begin
		ram_address_in_reg<=even_address15;
		ram_data_in<=data_out_even15;
	end
	endcase
	
		

		
lifted_wavelet_decomposition lifted_wavelet_decomposition_inst0
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line0),
	.data_out_odd(data_out_odd0),
	.data_out_even(data_out_even0),
	.data_loading(data_loading),
	.output_valid(),
	.line_address(line_address0),
	.odd_address(odd_address0),
	.even_address(even_address0),
	.update_flag(update_flag)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst1
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line1),
	.data_out_odd(data_out_odd1),
	.data_out_even(data_out_even1),
	.data_loading(),
	.output_valid(),
	.line_address(line_address1),
	.odd_address(odd_address1),
	.even_address(even_address1)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst2
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line2),
	.data_out_odd(data_out_odd2),
	.data_out_even(data_out_even2),
	.data_loading(),
	.output_valid(),
	.line_address(line_address2),
	.odd_address(odd_address2),
	.even_address(even_address2)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst3
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line3),
	.data_out_odd(data_out_odd3),
	.data_out_even(data_out_even3),
	.data_loading(),
	.output_valid(),
	.line_address(line_address3),
	.odd_address(odd_address3),
	.even_address(even_address3)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst4
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line4),
	.data_out_odd(data_out_odd4),
	.data_out_even(data_out_even4),
	.data_loading(),
	.output_valid(),
	.line_address(line_address4),
	.odd_address(odd_address4),
	.even_address(even_address4)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst5
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line5),
	.data_out_odd(data_out_odd5),
	.data_out_even(data_out_even5),
	.data_loading(),
	.output_valid(),
	.line_address(line_address5),
	.odd_address(odd_address5),
	.even_address(even_address5)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst6
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line6),
	.data_out_odd(data_out_odd6),
	.data_out_even(data_out_even6),
	.data_loading(),
	.output_valid(),
	.line_address(line_address6),
	.odd_address(odd_address6),
	.even_address(even_address6)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst7
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line7),
	.data_out_odd(data_out_odd7),
	.data_out_even(data_out_even7),
	.data_loading(),
	.output_valid(),
	.line_address(line_address7),
	.odd_address(odd_address7),
	.even_address(even_address7)
);
lifted_wavelet_decomposition lifted_wavelet_decomposition_inst8
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line8),
	.data_out_odd(data_out_odd8),
	.data_out_even(data_out_even8),
	.data_loading(),
	.output_valid(),
	.line_address(line_address8),
	.odd_address(odd_address8),
	.even_address(even_address8)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst9
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line9),
	.data_out_odd(data_out_odd9),
	.data_out_even(data_out_even9),
	.data_loading(),
	.output_valid(),
	.line_address(line_address9),
	.odd_address(odd_address9),
	.even_address(even_address9)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst10
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line10),
	.data_out_odd(data_out_odd10),
	.data_out_even(data_out_even10),
	.data_loading(),
	.output_valid(),
	.line_address(line_address10),
	.odd_address(odd_address10),
	.even_address(even_address10)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst11
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line11),
	.data_out_odd(data_out_odd11),
	.data_out_even(data_out_even11),
	.data_loading(),
	.output_valid(),
	.line_address(line_address11),
	.odd_address(odd_address11),
	.even_address(even_address11)
);
lifted_wavelet_decomposition lifted_wavelet_decomposition_inst12
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line12),
	.data_out_odd(data_out_odd12),
	.data_out_even(data_out_even12),
	.data_loading(),
	.output_valid(),
	.line_address(line_address12),
	.odd_address(odd_address12),
	.even_address(even_address12)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst13
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line13),
	.data_out_odd(data_out_odd13),
	.data_out_even(data_out_even13),
	.data_loading(),
	.output_valid(),
	.line_address(line_address13),
	.odd_address(odd_address13),
	.even_address(even_address13)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst14
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line14),
	.data_out_odd(data_out_odd14),
	.data_out_even(data_out_even14),
	.data_loading(),
	.output_valid(),
	.line_address(line_address14),
	.odd_address(odd_address14),
	.even_address(even_address14)
);

lifted_wavelet_decomposition lifted_wavelet_decomposition_inst15
(
	.clk(clk),
	.rst_n(data_valid),
	.data_valid(data_valid),
	.data_in(line15),
	.data_out_odd(data_out_odd15),
	.data_out_even(data_out_even15),
	.data_loading(),
	.output_valid(),
	.line_address(line_address15),
	.odd_address(odd_address15),
	.even_address(even_address15)
);
	
	
shift_ram shift_ram_inst1
(
	.clock(clk),
	.shiftin(data_input),
	.clken(clken),
	.aclr(~rst_n),
	.shiftout(),
	.taps0x(line15),
	.taps1x(line14),
	.taps2x(line13),
	.taps3x(line12),
	.taps4x(line11),
	.taps5x(line10),
	.taps6x(line9),
	.taps7x(line8),
	.taps8x(line7),
	.taps9x(line6),
	.taps10x(line5),
	.taps11x(line4),
	.taps12x(line3),
	.taps13x(line2),
	.taps14x(line1),
	.taps15x(line0)
);

endmodule 