/*virtual sequence for router 1x3*/

class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(router_vbase_seq)
	src_seqencer src_seqrh[];
	dst_seqencer dst_seqrh[];
	
    router_virtual_sequencer vsqrh;

	router_small_spkt small_sxtns;
	router_med_spkt med_sxtns;
	router_large_spkt large_sxtns;
	
	router_dnorm_pkt norm_dxtns;
	router_dsoft_pkt soft_dxtns;

	router_env_config m_cfg;
	
	bit [1:0] addr;


	// METHODS
 	extern function new(string name = "router_vbase_seq");
	extern task body();
endclass
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_vbase_seq::new(string name ="router_vbase_seq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//


task router_vbase_seq::body();

	if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

	src_seqrh = new[m_cfg.m_src_agent_cfg[0].no_of_src];
	dst_seqrh = new[m_cfg.m_dst_agent_cfg[0].no_of_dst];

  assert($cast(vsqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end

	foreach(src_seqrh[i]) begin
		src_seqrh[i] = vsqrh.src_seqrh[i];
	end
	foreach(dst_seqrh[i]) begin
		dst_seqrh[i] = vsqrh.dst_seqrh[i];
	end
endtask: body

	/******ROUTER SMALL NORMAL SEQUENCE******
	*****************************************/

class router_small_vseq extends router_vbase_seq ;

     // Define Constructor new() function
	`uvm_object_utils(router_small_vseq)


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_small_vseq");
	extern task body();
	endclass : router_small_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_small_vseq::new(string name ="router_small_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

task router_small_vseq::body();
    super.body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("virtual seqs","addr not set()")
        
		
		fork begin
            if(m_cfg.has_sagent) begin
			small_sxtns = router_small_spkt::type_id::create("small_sxtns");
            foreach(src_seqrh[i])
				small_sxtns.start(src_seqrh[i]);
			end
		end
		begin
			norm_dxtns = router_dnorm_pkt::type_id::create("norm_dxtns");
            if(m_cfg.has_dagent) begin
                //foreach(dst_seqrh[i])
				if(addr == 2'b00)
				norm_dxtns.start(dst_seqrh[0]);
				if(addr == 2'b01)
				norm_dxtns.start(dst_seqrh[1]);
				if(addr == 2'b10)
				norm_dxtns.start(dst_seqrh[2]);
            end 
		end
		join
endtask


	/******ROUTER MEDIUM NORMAL SEQUENCE******
	*****************************************/


class router_med_vseq extends router_vbase_seq ;

     // Define Constructor new() function
	`uvm_object_utils(router_med_vseq)


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_med_vseq");
	extern task body();
	endclass : router_med_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_med_vseq::new(string name ="router_med_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

task router_med_vseq::body();
    super.body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("virtual seqs","addr not set()")
        
		
		fork begin
            if(m_cfg.has_sagent) begin
			med_sxtns = router_med_spkt::type_id::create("small_sxtns");
            foreach(src_seqrh[i])
				med_sxtns.start(src_seqrh[i]);
			end
		end
		begin
			norm_dxtns = router_dnorm_pkt::type_id::create("norm_dxtns");
            if(m_cfg.has_dagent) begin
                //foreach(dst_seqrh[i])
				if(addr == 2'b00)
				norm_dxtns.start(dst_seqrh[0]);
				if(addr == 2'b01)
				norm_dxtns.start(dst_seqrh[1]);
				if(addr == 2'b10)
				norm_dxtns.start(dst_seqrh[2]);
            end 
		end
		join
endtask


	/******ROUTER LARGE NORMAL SEQUENCE******
	*****************************************/


class router_large_vseq extends router_vbase_seq ;

     // Define Constructor new() function
	`uvm_object_utils(router_large_vseq)


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_large_vseq");
	extern task body();
	endclass : router_large_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_large_vseq::new(string name ="router_large_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

task router_large_vseq::body();
    super.body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("virtual seqs","addr not set()")
        
		
		fork begin
            if(m_cfg.has_sagent) begin
			large_sxtns = router_large_spkt::type_id::create("small_sxtns");
            foreach(src_seqrh[i])
				large_sxtns.start(src_seqrh[i]);
			end
		end
		begin
			norm_dxtns = router_dnorm_pkt::type_id::create("norm_dxtns");
            if(m_cfg.has_dagent) begin
                //foreach(dst_seqrh[i])
				if(addr == 2'b00)
				norm_dxtns.start(dst_seqrh[0]);
				if(addr == 2'b01)
				norm_dxtns.start(dst_seqrh[1]);
				if(addr == 2'b10)
				norm_dxtns.start(dst_seqrh[2]);
            end 
		end
		join
endtask


	/******ROUTER SMALL SFTRST SEQUENCE******
	*****************************************/

class router_ssmall_vseq extends router_vbase_seq ;

     // Define Constructor new() function
	`uvm_object_utils(router_ssmall_vseq)


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_ssmall_vseq");
	extern task body();
	endclass : router_ssmall_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_ssmall_vseq::new(string name ="router_ssmall_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

task router_ssmall_vseq::body();
    super.body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("virtual seqs","addr not set()")
        
		
		fork begin
            if(m_cfg.has_sagent) begin
			small_sxtns = router_small_spkt::type_id::create("small_sxtns");
            foreach(src_seqrh[i])
				small_sxtns.start(src_seqrh[i]);
			end
		end
		begin
			soft_dxtns =  router_dsoft_pkt::type_id::create("soft_dxtns");
            if(m_cfg.has_dagent) begin
                //foreach(dst_seqrh[i])
				if(addr == 2'b00)
				soft_dxtns.start(dst_seqrh[0]);
				if(addr == 2'b01)
				soft_dxtns.start(dst_seqrh[1]);
				if(addr == 2'b10)
				soft_dxtns.start(dst_seqrh[2]);
            end 
		end
		join
endtask


	/******ROUTER MEDIUM SFTRST SEQUENCE******
	*****************************************/


class router_smed_vseq extends router_vbase_seq ;

     // Define Constructor new() function
	`uvm_object_utils(router_smed_vseq)


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_smed_vseq");
	extern task body();
	endclass : router_smed_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_smed_vseq::new(string name ="router_smed_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

task router_smed_vseq::body();
    super.body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("virtual seqs","addr not set()")
        
		
		fork begin
            if(m_cfg.has_sagent) begin
			med_sxtns = router_med_spkt::type_id::create("small_sxtns");
            foreach(src_seqrh[i])
				med_sxtns.start(src_seqrh[i]);
			end
		end
		begin
			soft_dxtns =  router_dsoft_pkt::type_id::create("soft_dxtns");
            if(m_cfg.has_dagent) begin
                //foreach(dst_seqrh[i])
				if(addr == 2'b00)
				soft_dxtns.start(dst_seqrh[0]);
				if(addr == 2'b01)
				soft_dxtns.start(dst_seqrh[1]);
				if(addr == 2'b10)
				soft_dxtns.start(dst_seqrh[2]);
            end 
		end
		join
endtask


	/******ROUTER LARGE SFTRST SEQUENCE******
	*****************************************/


class router_slarge_vseq extends router_vbase_seq ;

     // Define Constructor new() function
	`uvm_object_utils(router_slarge_vseq)


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_slarge_vseq");
	extern task body();
	endclass : router_slarge_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function router_slarge_vseq::new(string name ="router_slarge_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

task router_slarge_vseq::body();
    super.body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("virtual seqs","addr not set()")
        
		
		fork begin
            if(m_cfg.has_sagent) begin
			large_sxtns = router_large_spkt::type_id::create("small_sxtns");
            foreach(src_seqrh[i])
				large_sxtns.start(src_seqrh[i]);
			end
		end
		begin
			soft_dxtns =  router_dsoft_pkt::type_id::create("soft_dxtns");
            if(m_cfg.has_dagent) begin
                //foreach(dst_seqrh[i])
				if(addr == 2'b00)
				soft_dxtns.start(dst_seqrh[0]);
				if(addr == 2'b01)
				soft_dxtns.start(dst_seqrh[1]);
				if(addr == 2'b10)
				soft_dxtns.start(dst_seqrh[2]);
            end 
		end
		join
endtask