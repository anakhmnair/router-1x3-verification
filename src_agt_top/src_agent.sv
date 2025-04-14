/* source agent for router 1x3 */

class src_agent extends uvm_agent;
	
	`uvm_component_utils(src_agent)
	
	//MEMBERS
	src_agent_config m_cfg;
	src_monitor monh;
	src_seqencer seqrh;
	src_driver drvh;
	
	//METHODS
	extern function new(string name = "src_agent", uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

function src_agent::new(string name = "src_agent", 
                               uvm_component parent = null);
    super.new(name, parent);
endfunction

function void src_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
    monh=src_monitor::type_id::create("monh",this);	
	if(m_cfg.is_active==UVM_ACTIVE)
		begin
		drvh=src_driver::type_id::create("drvh",this);
		seqrh=src_seqencer::type_id::create("seqrh",this);
		end
endfunction

function void src_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active==UVM_ACTIVE)
	begin
	drvh.seq_item_port.connect(seqrh.seq_item_export);
	end
endfunction