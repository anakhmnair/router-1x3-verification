/*top module for router 1x3*/

module top();

    import router_test_pkg::*;

	import uvm_pkg::*;

	bit clock = 1'b0;  
	
	always
		#10 clock=!clock;     

    router_if in(clock);
	router_if in0(clock);
	router_if in1(clock);
	router_if in2(clock);


    router_top  DUV(.clk(clock), .rstn(in.resetn), .read_enb_0(in0.read_enb), 
					.read_enb_1(in1.read_enb), .read_enb_2(in2.read_enb),
					.pkt_valid(in.pkt_valid), .data_in(in.data_in),
					.vld_out_0(in0.vld_out), .vld_out_1(in1.vld_out),
					.vld_out_2(in2.vld_out),.error(in.error), .busy(in.busy),
					.data_out_0(in0.data_out), .data_out_1(in1.data_out),
					.data_out_2(in2.data_out));

       	initial 
		begin

			uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);
			run_test();
		end   


default clocking def_clk
	@(posedge clock);
endclocking

property Stable_data;
	in.busy |=> $stable(in.data_in);
endproperty  
   
property busy_check;
	$rose(in.pkt_valid) |=> in.busy;  
endproperty

property read_enb0;
	in0.vld_out |=> ##[0:29] in0.read_enb;
endproperty

property read_enb1;
	in1.vld_out |=> ##[0:29] in1.read_enb;
endproperty

property read_enb2;
	in2.vld_out |=> ##[0:29] in2.read_enb;
endproperty

property vld_sig;
	$rose(in.pkt_valid) |-> ##3(in0.vld_out | in1.vld_out | in2.vld_out);
endproperty

property read_enb0_low;
	$fell(in0.vld_out) |-> ##2 $fell(in0.read_enb);
endproperty

property read_enb1_low;
	$fell(in1.vld_out) |-> ##2 $fell(in1.read_enb);
endproperty

property read_enb2_low;
	$fell(in2.vld_out) |-> ##2 $fell(in2.read_enb);
endproperty

C1: assert property(Stable_data)
	$display("Assertion is successfull for stable data");
	else
	$display("assertion failed for Stable data");

C2: assert property(busy_check)
	$display("Assertion is successfull for busy check");
	else
	$display("assertion failed for busy check");
	
C3: assert property(read_enb0)
	$display("Assertion is successfull for read enb 0");
	else
	$display("assertion failed for read enb 0");

C4: assert property(read_enb1)
	$display("Assertion is successfull for read enb 1");
	else
	$display("assertion failed for read enb 1");

C5: assert property(read_enb2)
	$display("Assertion is successfull for read enb 2");
	else
	$display("assertion failed for read enb 2");
	
C6: assert property(read_enb0_low)
	$display("Assertion is successfull for read enb 0 low");
	else
	$display("assertion failed for read enb 0 low");
	
C7: assert property(read_enb1_low)
	$display("Assertion is successfull for read enb 1 low");
	else
	$display("assertion failed for read enb 1 low");
	
C8: assert property(read_enb2_low)
	$display("Assertion is successfull for read enb 2 low");
	else
	$display("assertion failed for read enb 2 low");
	
C9: assert property(vld_sig)
	$display("Assertion is successfull for vld_sig");
	else
	$display("assertion failed for vld_sig");



endmodule