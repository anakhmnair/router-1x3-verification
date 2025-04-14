/* source sequence for router 1x3 */

class router_sbase_seq extends uvm_sequence #(src_xtn);  
	
	`uvm_object_utils(router_sbase_seq)  
	
	// METHODS
    extern function new(string name ="router_sbase_seq");
endclass

function router_sbase_seq::new(string name ="router_sbase_seq");
	super.new(name);
endfunction




class router_small_spkt extends router_sbase_seq;
	
	`uvm_object_utils(router_small_spkt)
	
	bit[1:0] addr;
	
	//METHODS
	extern function new(string name ="router_small_spkt");
	extern task body();
	
endclass

function router_small_spkt::new(string name ="router_small_spkt");
	super.new(name);
endfunction

task router_small_spkt::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal("src_seqs","addr not set() have you configured it?")

	req=src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[1:20]} && header[1:0] == addr;});
	finish_item(req); 	
		
endtask



class router_med_spkt extends router_sbase_seq;
	
	`uvm_object_utils(router_med_spkt)
	
	bit[1:0] addr;
	
	//METHODS
	extern function new(string name ="router_med_spkt");
	extern task body();
	
endclass

function router_med_spkt::new(string name ="router_med_spkt");
	super.new(name);
endfunction

task router_med_spkt::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal("Source Transaction","address not set() have you configured it?")
		req=src_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[21:40]} && header[1:0] == addr;});
		finish_item(req); 	
		
endtask

class router_large_spkt extends router_sbase_seq;
	
	`uvm_object_utils(router_large_spkt)
	
	bit[1:0] addr;
	
	//METHODS
	extern function new(string name ="router_large_spkt");
	extern task body();
	
endclass

function router_large_spkt::new(string name ="router_large_spkt");
	super.new(name);
endfunction

task router_large_spkt::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal("Source Transaction","address not set() have you configured it?")
		req=src_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[41:63]} && header[1:0] == addr;});
		finish_item(req); 	
		
endtask