/* destination monitor for router 1x3 */

class dst_monitor extends uvm_monitor;

	`uvm_component_utils(dst_monitor)
	
	virtual router_if.DMON_MP vif;
	
	int i = 0;
	
	dst_agent_config m_cfg;
	
	uvm_analysis_port #(dst_xtn) monitor_port;
	//METHODS
	extern function new(string name = "dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass 

function dst_monitor::new (string name = "dst_monitor", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);

endfunction

function void dst_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
	//if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
	//	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void dst_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
	//
	//$display("----------%p----------",m_cfg);
endfunction

task dst_monitor::run_phase(uvm_phase phase);
    forever
		collect_data();     
endtask

task dst_monitor::collect_data();

    dst_xtn data_sent;
    data_sent= dst_xtn::type_id::create("data_sent");
	
	wait(vif.dmon_cb.read_enb && vif.dmon_cb.vld_out)

	data_sent.header = vif.dmon_cb.data_out;
	data_sent.payload = new[data_sent.header[7:2]];
	
	@(vif.dmon_cb);
	foreach(data_sent.payload[i]) begin
		data_sent.payload[i] = vif.dmon_cb.data_out;
		@(vif.dmon_cb);
	end
	data_sent.parity = vif.dmon_cb.data_out;
	if(data_sent.header != 0) begin
		`uvm_info("DST_MONITOR",$sformatf("printing from monitor \n %s", data_sent.sprint()),UVM_LOW) 
		monitor_port.write(data_sent);
	end
	m_cfg.mon_rcvd_xtn_cnt++;
   
endtask

function void dst_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ROUTER DST Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction