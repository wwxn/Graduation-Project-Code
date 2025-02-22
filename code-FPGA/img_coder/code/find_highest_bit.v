module find_highest_bit
(
	input [15:0] data_in,
	output [3:0] times
);


wire [3:0] pos;
assign times=4'd15-pos;
wire [7:0] sel0;
wire [3:0] sel1;
wire [1:0] sel2;

assign {sel0,pos[3]} = (data_in[15:8] == 0) ? {data_in[7:0],1'b0}:{data_in[15:8],1'b1};
assign {sel1,pos[2]} = (sel0[7:4] == 0) ? {sel0[3:0],1'b0}:{sel0[7:4],1'b1};
assign {sel2,pos[1]} = (sel1[3:2] == 0) ? {sel1[1:0],1'b0} :{sel1[3:2],1'b1};
assign pos[0] = (sel2[1] == 0) ? 1'b0 :1'b1;


endmodule
