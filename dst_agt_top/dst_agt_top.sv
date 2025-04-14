/* agent top for destination of router 1x3 */

class dst_agt_top extends uvm_env;

	`uvm_component_utils(dst_agt_top)
	
	//MEMBERS
	//dst_agent_config m_cfg;
	dst_agent agnth[];
	router_env_config m_cfg;
	
	//METHOD
	extern function new(string name = "dst_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);
endclass
  
function dst_agt_top::new(string name = "dst_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

function void dst_agt_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("DST_AGT_TOP","dst_agent_config not set()")
	agnth = new[m_cfg.m_dst_agent_cfg[0].no_of_dst];
	foreach(agnth[i])begin
	agnth[i]=dst_agent::type_id::create($sformatf("agnth[%0d]",i),this);
	uvm_config_db #(dst_agent_config)::set(this,"*",$sformatf("agnth[%0d]*",i),m_cfg.m_dst_agent_cfg[i]);//,"dst_agent_config",m_cfg.m_dst_agent_cfg[i]);
	//$display("agnth[%0d]*",i);
	//$display("----------%p----------",m_cfg.m_dst_agent_cfg[i]);
	end
endfunction

//task dst_agt_top::run_phase(uvm_phase phase);
//	uvm_top.print_topology;
//endtask