/* source sequencer for router 1x3 */

class src_seqencer extends uvm_sequencer #(src_xtn);

	`uvm_component_utils(src_seqencer)
	
	extern function new(string name = "src_seqencer",uvm_component parent);
endclass

function src_seqencer::new(string name="src_seqencer",uvm_component parent);
	super.new(name,parent);
endfunction