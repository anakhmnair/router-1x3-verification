/* source driver for router 1x3 */

class src_driver extends uvm_driver #(src_xtn);

	`uvm_component_utils(src_driver)
	
	virtual router_if.SDRV_MP vif;
	
	src_agent_config m_cfg;
	
	//METHODS
	extern function new(string name ="src_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_router(src_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

function src_driver::new(string name ="src_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void src_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",m_cfg))
		`uvm_fatal("Source DRIVER","config not set() have you configured it?")
endfunction

function void src_driver::connect_phase(uvm_phase phase);

    vif = m_cfg.vif;
endfunction

task src_driver::run_phase(uvm_phase phase);
	@(vif.sdrv_cb);
	vif.sdrv_cb.resetn <= 0;
	@(vif.sdrv_cb);
	vif.sdrv_cb.resetn <= 1;
   	forever begin
		seq_item_port.get_next_item(req);
		send_to_router(req);
		seq_item_port.item_done();
	end
endtask

task src_driver::send_to_router(src_xtn xtn);

	
	//@(vif.sdrv_cb);
	wait(vif.sdrv_cb.busy == 0)
	@(vif.sdrv_cb);
	vif.sdrv_cb.pkt_valid <= 1;	
	vif.sdrv_cb.data_in <= xtn.header;
	//wait(vif.sdrv_cb.busy == 0)
	@(vif.sdrv_cb);
		foreach (xtn.payload[i]) begin
			while(vif.sdrv_cb.busy)
				@(vif.sdrv_cb);
			vif.sdrv_cb.data_in <= xtn.payload[i];
			@(vif.sdrv_cb);
		end
	while(vif.sdrv_cb.busy)
		@(vif.sdrv_cb);
	vif.sdrv_cb.pkt_valid <= 0;
	vif.sdrv_cb.data_in <= xtn.parity;
	@(vif.sdrv_cb);
	@(vif.sdrv_cb);
	xtn.error = vif.sdrv_cb.error; 	
	@(vif.sdrv_cb);
		`uvm_info("SRC_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)
	m_cfg.drv_data_sent_cnt++;
endtask

function void src_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ROUTER source driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
  endfunction 