/* router environment configuration */

class router_env_config extends uvm_object;

	`uvm_object_utils(router_env_config)

	// Data Members
	// Whether env analysis components are used:
	bit has_functional_coverage = 0;
	bit has_sagent_functional_coverage = 0;
	bit has_scoreboard = 1;
	// Whether the various agents are used:
	bit has_sagent = 1;
	bit has_dagent = 1;
	// Whether the virtual sequencer is used:
	bit has_virtual_sequencer = 1;

	src_agent_config m_src_agent_cfg[];
	dst_agent_config m_dst_agent_cfg[];

	// PROJECT :  Declare variable no_of_duts as int which can be set to the required dut value
	//int no_of_dut = 1;
	//int no_of_src = 1;
	//int no_of_dst = 3;

	// Methods
	extern function new(string name = "router_env_config");

endclass

function router_env_config::new(string name = "router_env_config");
	super.new(name);
endfunction


