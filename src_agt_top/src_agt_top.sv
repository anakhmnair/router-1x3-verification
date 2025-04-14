/* agent top for source of router 1x3 */

	class src_agt_top extends uvm_env;
	
	`uvm_component_utils(src_agt_top)
	
	//MEMBERS
	router_env_config m_cfg;
	src_agent agnth[];
	
	//METHODS
	extern function new(string name = "src_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);
  endclass
  
function src_agt_top::new(string name = "src_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

function void src_agt_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("SRC_AGT_TOP","router_env_config not set()")

	agnth = new[m_cfg.m_src_agent_cfg[0].no_of_src];
	foreach(agnth[i])begin
	agnth[i]=src_agent::type_id::create($sformatf("agnth[%0d]",i),this);
	uvm_config_db #(src_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"src_agent_config",m_cfg.m_src_agent_cfg[i]);
	end
endfunction

//task src_agt_top::run_phase(uvm_phase phase);
//	uvm_top.print_topology;
//endtask   