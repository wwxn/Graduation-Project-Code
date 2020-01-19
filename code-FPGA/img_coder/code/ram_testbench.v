`timescale 1ps/1ps
module ram_testbench();

wire	  aclr=1'b0;
reg	[11:0]  address_a;
reg	[11:0]  address_b;
reg	  clock;
reg	[15:0]  data_a;
reg	[15:0]  data_b;
reg	  enable;
wire	  rden_a=1'b1;
wire	  rden_b=1'b1;
wire	  wren_a=1'b0;
wire	  wren_b=1'b0;
wire	[15:0]  q_a;
wire	[15:0]  q_b;


initial begin
	address_a<=12'd0;
	address_b<=12'd2048;
	clock<=1'b0;
	enable<=1'b1;
end

always#5 clock=~clock;

always@(posedge clock)begin
	address_a<=address_a+1'b1;
	address_b<=address_b+1'b1;
end


ram ram_inst1(
	aclr,
	address_a,
	address_b,
	clock,
	data_a,
	data_b,
	enable,
	rden_a,
	rden_b,
	wren_a,
	wren_b,
	q_a,
	q_b);

endmodule 