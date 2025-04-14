/* destination sequencer for router 1x3 */

class dst_seqencer extends uvm_sequencer #(dst_xtn);

	`uvm_component_utils(dst_seqencer)
	
	extern function new(string name = "dst_seqencer",uvm_component parent);
endclass

function dst_seqencer::new(string name="dst_seqencer",uvm_component parent);
	super.new(name,parent);
endfunction