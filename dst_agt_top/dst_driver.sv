/* destination driver for router 1x3 */

class dst_driver extends uvm_driver #(dst_xtn);

	`uvm_component_utils(dst_driver)
	
	virtual router_if.DDRV_MP vif;
	
	int i = 0;
	
	dst_agent_config m_cfg;
	
	//METHODS
	extern function new(string name ="dst_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_router(dst_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

function dst_driver::new (string name ="dst_driver", uvm_component parent);
   	super.new(name, parent);
endfunction

function void dst_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
	//if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
	//	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction

function void dst_driver::connect_phase(uvm_phase phase);
   vif = m_cfg.vif;
   //$display("dest driver");
   //$display("----------%p----------",m_cfg);
endfunction

task dst_driver::run_phase(uvm_phase phase);
   	forever begin
		req = dst_xtn::type_id::create("req");
		seq_item_port.get_next_item(req);
		send_to_router(req);
		seq_item_port.item_done();
	end
endtask

task dst_driver::send_to_router (dst_xtn xtn);
	//$display("send to router");
	wait(vif.ddrv_cb.vld_out)
	
	`uvm_info("DST_DRIVER",$sformatf("printing from driver ===== %0d", vif.ddrv_cb.vld_out),UVM_LOW) 
	repeat(req.delay)
		@(vif.ddrv_cb);
		
	xtn.read_enb <= 1;
	vif.ddrv_cb.read_enb <= 1;
	
	wait(!vif.ddrv_cb.vld_out)
		@(vif.ddrv_cb);
	
	xtn.read_enb <= 0;
	vif.ddrv_cb.read_enb <= 0;
	@(vif.ddrv_cb);
	
    `uvm_info("DST_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
		
   	m_cfg.drv_data_sent_cnt++;

endtask

function void dst_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: ROUTER dst driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endfunction 
