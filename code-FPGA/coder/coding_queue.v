module coding_queue
(
	input clk,
	input rst_n,
	input bit_input,
	input wrreq,
	output bit_output,
	output fifo_full,
	output[11:0] space_used,
	output fifo_empty
);
//localparams
parameter context=4'd0;

//signals for fifo inst1
wire fifo_inst1_aclr=~rst_n;
wire fifo_inst1_clock=clk;
wire fifo_inst1_data=bit_input;

wire fifo_inst1_wrreq=wrreq;

wire fifo_inst1_full;
wire fifo_inst1_q;
wire[11:0] fifo_inst1_usedw;

//signals for conder inst1
wire coder_inst1_bit_input=fifo_inst1_q;
wire coder_inst1_input_valid=~fifo_empty;
wire coder_inst1_bit_output;
wire coder_inst1_output_valid;
wire coder_inst1_code_ready;

wire fifo_inst1_rdreq=coder_inst1_code_ready;

//output wires
assign bit_output=coder_inst1_bit_output;
assign fifo_full=fifo_inst1_full;
assign space_used=fifo_inst1_usedw;

fifo fifo_inst1
(
	.aclr(fifo_inst1_aclr),
	.clock(fifo_inst1_clock),
	.data(fifo_inst1_data),
	.rdreq(fifo_inst1_rdreq),
	.wrreq(fifo_inst1_wrreq),
	.empty(fifo_empty),
	.almost_full(fifo_inst1_full),
	.q(fifo_inst1_q)
);


coder
#(
	.context(context)
)
coder_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.bit_input(coder_inst1_bit_input),
	.input_valid(coder_inst1_input_valid),
	.bit_output(coder_inst1_bit_output),
	.output_valid(coder_inst1_output_valid),
	.code_ready(coder_inst1_code_ready)
);
endmodule 