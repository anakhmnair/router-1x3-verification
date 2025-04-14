/****** sv file for router_test_pkg.sv*/

package router_test_pkg;


//import uvm_pkg.sv
	import uvm_pkg::*;
//include uvm_macros.sv
	`include "uvm_macros.svh"
`include "src_xtn.sv"
`include "dst_xtn.sv"
`include "src_agent_config.sv"
`include "dst_agent_config.sv"
`include "router_env_config.sv"



`include "src_driver.sv"
`include "src_monitor.sv"
`include "src_seqencer.sv"
`include "src_agent.sv"
`include "src_agt_top.sv"
`include "src_seqs.sv"



`include "dst_monitor.sv"
`include "dst_seqencer.sv"
`include "dst_seqs.sv"
`include "dst_driver.sv"
`include "dst_agent.sv"
`include "dst_agt_top.sv"


`include "router_virtual_sequencer.sv"
`include "router_virtual_seqs.sv"
`include "router_scoreboard.sv"

`include "router_tb.sv"


`include "router_test.sv"
endpackage
