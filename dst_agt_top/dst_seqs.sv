/* destination sequence for router 1x3 */

class router_dbase_seq extends uvm_sequence #(dst_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(router_dbase_seq)  
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="router_dbase_seq");
	endclass
	

//-----------------  constructor new method  -------------------//
	function router_dbase_seq::new(string name ="router_dbase_seq");
		super.new(name);
	endfunction
	
	
	
class router_dnorm_pkt extends router_dbase_seq;

	`uvm_object_utils(router_dnorm_pkt)
	
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="router_dnorm_pkt");
		extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_dnorm_pkt::new(string name ="router_dnorm_pkt");
	super.new(name);
endfunction
	
task router_dnorm_pkt::body();
	req = dst_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {delay < 29;});
	finish_item(req); 
endtask



class router_dsoft_pkt extends router_dbase_seq;

	`uvm_object_utils(router_dsoft_pkt)
	
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="router_dsoft_pkt");
		extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_dsoft_pkt::new(string name ="router_dsoft_pkt");
	super.new(name);
endfunction
	
task router_dsoft_pkt::body();
	req = dst_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {delay > 30;});
	finish_item(req); 
endtask
	