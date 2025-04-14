/* destination agent for router 1x3 */

class dst_agent extends uvm_agent;

	`uvm_component_utils(dst_agent)
	
	//MEMBER
	dst_agent_config m_cfg;
	dst_monitor monh;
	dst_seqencer seqrh;
	dst_driver drvh;
	
	//METHODS
extern function new(string name = "dst_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function dst_agent::new(string name = "dst_agent", 
                               uvm_component parent = null);
    super.new(name, parent);
endfunction

function void dst_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(dst_agent_config)::get(this,"",get_name(),m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")  
	//$display("the agent name path %s",get_full_name());
	//$display("the agent name is %s",get_name());
	//$display("----------%p----------",m_cfg);
	monh=dst_monitor::type_id::create("monh",this);	
if(m_cfg.is_active==UVM_ACTIVE) begin
	drvh=dst_driver::type_id::create("drvh",this);
	seqrh=dst_seqencer::type_id::create("seqrh",this);
	end
	monh.m_cfg = m_cfg;
	drvh.m_cfg = m_cfg;
endfunction

function void dst_agent::connect_phase(uvm_phase phase);
	
	if(m_cfg.is_active==UVM_ACTIVE)
	begin
	drvh.seq_item_port.connect(seqrh.seq_item_export);
	end
endfunction