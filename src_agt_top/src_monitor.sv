/* source monitor for router 1x3 */

class src_monitor extends uvm_monitor;

	`uvm_component_utils(src_monitor)
	
	virtual router_if.SMON_MP vif;
	
	src_agent_config m_cfg;
	
	uvm_analysis_port #(src_xtn) monitor_port;
	
	//METHODS
	
	extern function new(string name = "src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass

function src_monitor::new(string name = "src_monitor", uvm_component parent);
	super.new(name,parent);
 	monitor_port = new("monitor_port", this);
endfunction

function void src_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction

function void src_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
endfunction

task src_monitor::run_phase(uvm_phase phase);
    forever
       collect_data();     
endtask

task src_monitor::collect_data();

    src_xtn xtn;
	xtn= src_xtn::type_id::create("xtn");
	@(vif.smon_cb);
	wait(vif.smon_cb.pkt_valid == 1 && vif.smon_cb.busy == 0)
	xtn.header = vif.smon_cb.data_in;
	xtn.payload = new[xtn.header[7:2]];
	// payload size
	@(vif.smon_cb);
//$display("header [7:2] == %0h",xtn.header[7:0]);
	
	foreach(xtn.payload[i]) begin
		wait(vif.smon_cb.busy == 0)
		///wait(vif.smon_cb.busy == 0)
			//@(vif.smon_cb);
		xtn.payload[i] = vif.smon_cb.data_in;
		//$display("header [7:2] == %0h",xtn.payload[i]);
		@(vif.smon_cb);
		//end
	end
	while(vif.smon_cb.busy)
		@(vif.smon_cb);
	wait(vif.smon_cb.pkt_valid == 0)
	xtn.parity = vif.smon_cb.data_in;
	@(vif.smon_cb);
	//$display("header [7:2] == %0h",xtn.parity);
	@(vif.smon_cb);
	xtn.error = vif.smon_cb.error;
	
    `uvm_info("SOURCE_MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW) 
	//xtn.print();
	//foreach(xtn.payload[i])
	
	
  	monitor_port.write(xtn);
  	m_cfg.mon_rcvd_xtn_cnt++;
endtask

function void src_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ROUTER src Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction