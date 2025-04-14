/* interface for router 1x3 verification */

interface router_if(input bit clock);
	
	logic resetn, pkt_valid, error, busy;
	bit read_enb, vld_out;
	logic [7:0] data_in, data_out;
	
	clocking sdrv_cb @(posedge clock);
	default input #1 output #1;
		input error;
		input busy;
		output resetn;
		output pkt_valid;
		output data_in;
	endclocking
	
	clocking smon_cb @(posedge clock);
	default input #1 output #0;
		input error;
		input busy;
		input resetn;
		input pkt_valid;
		input data_in;
	endclocking
	
	clocking ddrv_cb @(posedge clock);
	default input #1 output # 0;
		output read_enb;
		input vld_out;
	endclocking
	
	clocking dmon_cb @(posedge clock);
	default input #1 output #1;
		input vld_out;
		input data_out;
		input read_enb;
	endclocking
	
	modport SMON_MP (clocking smon_cb);
	
	modport SDRV_MP (clocking sdrv_cb);
	
	modport DMON_MP (clocking dmon_cb);
	
	modport DDRV_MP (clocking ddrv_cb);
	
endinterface
