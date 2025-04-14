/*test for router 1x3*/

	class router_base_test extends uvm_test;

	`uvm_component_utils(router_base_test)

    	 router_tb router_envh;
         router_env_config m_tb_cfg;

		src_agent_config m_src_cfg[];
		dst_agent_config m_dst_cfg[];

bit [1:0] addr;

         int no_of_src = 1;
		 int no_of_dst = 3;
         int has_dagent = 1;
         int has_sagent = 1;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "router_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_router();
	extern task run_phase(uvm_phase phase);
        endclass
//-----------------  constructor new method  -------------------//
   	function router_base_test::new(string name = "router_base_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
//----------------- function config_router()  -------------------//

	function void router_base_test::config_router();
 	   if (has_sagent) begin
            m_src_cfg = new[no_of_src];
			foreach(m_src_cfg[i]) begin
                m_src_cfg[i]=src_agent_config::type_id::create($sformatf("m_src_cfg[%0d]", i));

				if(!uvm_config_db #(virtual router_if)::get(this,"", "vif",m_src_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
                $display("----------%p----------",m_src_cfg[i]);
				m_src_cfg[i].is_active = UVM_ACTIVE;

                m_tb_cfg.m_src_agent_cfg[i] = m_src_cfg[i];
                
            end
        end

        if (has_dagent) begin

            m_dst_cfg = new[no_of_dst];
			foreach(m_dst_cfg[i]) begin

                m_dst_cfg[i] = dst_agent_config::type_id::create($sformatf("m_dst_cfg[%0d]",i),this);

				if(!uvm_config_db #(virtual router_if)::get(this,"", $sformatf("vif_%0d",i),m_dst_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
                
				m_dst_cfg[i].is_active = UVM_ACTIVE;


                m_tb_cfg.m_dst_agent_cfg[i] = m_dst_cfg[i];
                
            end
        end

                m_tb_cfg.m_src_agent_cfg[0].no_of_src = no_of_src;
				m_tb_cfg.m_dst_agent_cfg[0].no_of_dst = no_of_dst;
                m_tb_cfg.has_dagent = has_dagent;
                m_tb_cfg.has_sagent = has_sagent;
endfunction : config_router


//-----------------  build() phase method  -------------------//

function void router_base_test::build_phase(uvm_phase phase);

	
	m_tb_cfg=router_env_config::type_id::create("m_tb_cfg");

        if(has_sagent) begin

            m_tb_cfg.m_src_agent_cfg = new[no_of_src];
			//m_src_cfg = new[no_of_src];
		end
		
        if(has_dagent) begin
			m_tb_cfg.m_dst_agent_cfg = new[no_of_dst];
			//m_dst_cfg = new[no_of_dst];
		end
		$display("-----BEFORE CONFIG ROUTER-----");
		
        config_router(); 
		$display("-----AFTER CONFIG ROUTER-----");
	 	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_tb_cfg);
		$display("-----AFTER ENV SET-----");
		$display("%0t",$time);
		

		router_envh=router_tb::type_id::create("router_envh", this);
		super.build_phase(phase);
		
endfunction

task router_base_test::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask   
	


/***** TESTS TO BE FURTHER EXTENDED *****/

/****** ROUTER SMALL NORMAL TEST ******/

	class router_small_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_small_test)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_small_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_small_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_small_test::new(string name = "router_small_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_small_test::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_small_test::run_phase(uvm_phase phase);
		//uvm_config_db #(dst_agent_config)::dump();
 //raise objection
         phase.raise_objection(this);
	addr = 2'b00;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          //router_seqh=router_small_spkt::type_id::create("router_seqh");
		  router_seqh=router_small_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
		//foreach(router_envh.sagt_top[i])begin
			//foreach(router_envh.sagt_top[i].agnth[j])
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask   

/****** ROUTER MEDIUM NORMAL TEST ******/

class router_med_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_med_test)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_med_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_med_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_med_test::new(string name = "router_med_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_med_test::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_med_test::run_phase(uvm_phase phase);
		//uvm_config_db #(dst_agent_config)::dump();
 //raise objection
 
         phase.raise_objection(this);
	addr = 2'b01;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_med_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
		
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask 
	
	/****** ROUTER LARGE NORMAL TEST ******/
	
class router_large_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_large_test)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_large_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_large_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_large_test::new(string name = "router_large_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_large_test::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_large_test::run_phase(uvm_phase phase);
		//uvm_config_db #(dst_agent_config)::dump();
 //raise objection
 
         phase.raise_objection(this);
	addr = 2'b10;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_large_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
	
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask 
	
	
	
	/****** ROUTER SMALL SOFT RST TEST ******/
	
	
	
class router_ssmall_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_ssmall_test)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_ssmall_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_ssmall_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_ssmall_test::new(string name = "router_ssmall_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_ssmall_test::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_ssmall_test::run_phase(uvm_phase phase);
		
 //raise objection
         phase.raise_objection(this);
	addr = 2'b01;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_ssmall_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
		
				router_seqh.start(router_envh.v_sequencer);
		
		
 //drop objection
         phase.drop_objection(this);
	endtask   

/****** ROUTER MEDIUM SFTRST TEST ******/

class router_smed_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_smed_test)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_smed_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_smed_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_smed_test::new(string name = "router_smed_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_smed_test::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_smed_test::run_phase(uvm_phase phase);
		
 //raise objection
 
         phase.raise_objection(this);
	addr = 2'b10;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_smed_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
		
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask 
	
	/****** ROUTER LARGE SFTRST TEST ******/
	
class router_slarge_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_slarge_test)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_slarge_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_slarge_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_slarge_test::new(string name = "router_slarge_test" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_slarge_test::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_slarge_test::run_phase(uvm_phase phase);
		
 //raise objection
 
         phase.raise_objection(this);
	addr = 2'b00;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_slarge_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
	
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask 











/*REGRESSION TESTING FOR ROUTER ADDR*/


/****** ROUTER SMALL NORMAL TEST ******/

	class router_small_test1 extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_small_test1)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_small_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_small_test1" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_small_test1::new(string name = "router_small_test1" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_small_test1::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_small_test1::run_phase(uvm_phase phase);
		//uvm_config_db #(dst_agent_config)::dump();
 //raise objection
         phase.raise_objection(this);
	addr = 2'b10;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          //router_seqh=router_small_spkt::type_id::create("router_seqh");
		  router_seqh=router_small_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
		//foreach(router_envh.sagt_top[i])begin
			//foreach(router_envh.sagt_top[i].agnth[j])
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask   

/****** ROUTER MEDIUM NORMAL TEST ******/

class router_med_test1 extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_med_test1)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_med_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_med_test1" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_med_test1::new(string name = "router_med_test1" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_med_test1::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_med_test1::run_phase(uvm_phase phase);
		//uvm_config_db #(dst_agent_config)::dump();
 //raise objection
 
         phase.raise_objection(this);
	addr = 2'b00;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_med_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
		
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask 
	
	/****** ROUTER LARGE NORMAL TEST ******/
	
class router_large_test1 extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(router_large_test1)
	

   // Declare the handle for  ram_single_vseq virtual sequence
        
		//router_small_spkt router_seqh;
		router_large_vseq router_seqh;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "router_large_test1" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
   	function router_large_test1::new(string name = "router_large_test1" , uvm_component parent);
		super.new(name,parent);
	endfunction


//-----------------  build() phase method  -------------------//
            
	function void router_large_test1::build_phase(uvm_phase phase);

            super.build_phase(phase);
			
	endfunction


//-----------------  run() phase method  -------------------//
      	task router_large_test1::run_phase(uvm_phase phase);
		//uvm_config_db #(dst_agent_config)::dump();
 //raise objection
 
         phase.raise_objection(this);
	addr = 2'b01;//{$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
 //create instance for sequence
          
		  router_seqh=router_large_vseq::type_id::create("router_seqh");
 //start the sequence wrt virtual sequencer
	
				router_seqh.start(router_envh.v_sequencer);
		//end
		
 //drop objection
         phase.drop_objection(this);
	endtask 
