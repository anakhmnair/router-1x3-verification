/* this is the agent configuration for destination */

class dst_agent_config extends uvm_object;
	
	`uvm_object_utils(dst_agent_config)
	
	virtual router_if vif;
	// MEMBERS
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
	static int mon_rcvd_xtn_cnt = 0;
	
	static int drv_data_sent_cnt = 0;
	
	static int no_of_dst = 3;
	
	//METHODS

	extern function new(string name = "dst_agent_config");
endclass

function dst_agent_config::new(string name = "dst_agent_config");
	super.new(name);
endfunction