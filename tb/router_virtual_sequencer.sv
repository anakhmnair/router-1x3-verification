/*virtual sequencer for router 1x3*/

	class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;

	`uvm_component_utils(router_virtual_sequencer)

	src_seqencer src_seqrh[];
	dst_seqencer dst_seqrh[];
	

  	router_env_config m_cfg;


	// METHODS

 	extern function new(string name = "router_virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	endclass

   // Define Constructor new() function
function router_virtual_sequencer::new(string name="router_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

   // function void build_phase(uvm_phase phase)
function void router_virtual_sequencer::build_phase(uvm_phase phase);

	 if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    super.build_phase(phase);

		src_seqrh = new[m_cfg.m_src_agent_cfg[0].no_of_src];
		dst_seqrh = new[m_cfg.m_dst_agent_cfg[0].no_of_dst];
    		
	endfunction
