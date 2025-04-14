module router_top(clk,rstn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,
						data_in,vld_out_0,vld_out_1,vld_out_2,
						error, busy,data_out_0,data_out_1,data_out_2);

input clk,rstn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
input [7:0] data_in;
output vld_out_0,vld_out_1,vld_out_2,error, busy;
output [7:0] data_out_0,data_out_1,data_out_2;

wire [2:0] write_enb;
wire [7:0] din;

router_fsm fsm(clk,rstn,pkt_valid,low_pkt_valid,
						 parity_done,fifo_full,data_in[1:0],
						 soft_reset_0,soft_reset_1,soft_reset_2,
						 empty_0,empty_1,empty_2,
						 busy, detect_add, ld_state, laf_state,
						 full_state, write_enb_reg, rst_int_reg, lfd_state);


router_synchroniser synchroniser(clk, rstn, detect_add,
						 write_enb_reg,
						 read_enb_0,read_enb_1,read_enb_2,
						 empty_0,empty_1,empty_2,
						 full_0,full_1,full_2, data_in[1:0],
						 fifo_full, soft_reset_0,soft_reset_1,soft_reset_2,
						 write_enb,vld_out_0,vld_out_1,vld_out_2);


router_reg register(clk,rstn,pkt_valid,fifo_full,
						 rst_int_reg,detect_add,ld_state,
						 laf_state,full_state,lfd_state,
						 data_in, parity_done,low_pkt_valid,
						 error,din);


router_fifo fifo_0(clk,rstn,soft_reset_0,lfd_state,
						 write_enb[0], read_enb_0, din,
						 empty_0,full_0, data_out_0);


router_fifo fifo_1(clk,rstn,soft_reset_1,lfd_state,
						 write_enb[1], read_enb_1, din,
						 empty_1,full_1, data_out_1);


router_fifo fifo_2(clk,rstn,soft_reset_2,lfd_state,
						 write_enb[2], read_enb_2, din,
						 empty_2,full_2, data_out_2);

endmodule