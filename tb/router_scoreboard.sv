/* Scoreboard for router 1x3 */

class router_scoreboard extends uvm_scoreboard;
	
	uvm_tlm_analysis_fifo #(src_xtn) fifo_src;
    uvm_tlm_analysis_fifo #(dst_xtn) fifo_dst[];


	int  src_xtns_in, dst_xtns_in , xtns_compared ,xtns_dropped;	

	 `uvm_component_utils(router_scoreboard)

	// MEMBER FOR REFERENCE MODEL
	
	
		src_xtn src_data;
		dst_xtn dst_data;

		src_xtn src_cov_data;
		dst_xtn dst_cov_data;
		
		router_env_config m_cfg;
		
		int header_data_count = 0;
		int payload_data_count = 0;
		int parity_data_count = 0;
		int verified_data_count = 0;

bit [1:0] addr;

covergroup router_fcov1;
option.per_instance=1;
       //ADDRESS
     
		SRC_ADD 	: coverpoint src_cov_data.header[1:0] {
													   bins zero	= {2'b00};
													   bins one 	= {2'b01};
													   bins two 	= {2'b10}; 
													  }
    	     	     

        SIZE 	: coverpoint src_cov_data.header[7:2] {
													   bins Small	= {[1:20]};
													   bins Med		= {[21:40]};
													   bins Large 	= {[41:63]};
													  }
    

        GOOD_pkt : coverpoint src_cov_data.error	  {
													   bins good_pkt= {0};
													   bins bad_pkt	= {1};
													  }
    
    
 
		WRITE_FC : cross SIZE,SRC_ADD;
          
endgroup  


/*covergroup router_fcov2;
option.per_instance=1;

        RD_ADD : coverpoint  {}
       

        DATA : coverpoint  {}
    

        RD : coverpoint  {}
        

        READ_FC : cross RD,RD_ADD,DATA;
        
endgroup */



	// METHODS

	extern function new(string name,uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void compare_data(src_xtn src, dst_xtn dst);
	extern function void report_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

function router_scoreboard::new(string name,uvm_component parent);
	super.new(name,parent);
	
	router_fcov1 = new;
	//router_fcov2 = new;  
endfunction

//-----------------  build() phase  -------------------//

function void router_scoreboard::build_phase(uvm_phase phase);

if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
	`uvm_fatal("router_scoreboard","router_env_config not set")
/*fifo_src = new("fifo_src", this);
fifo_dst= new[m_cfg.m_dst_agent_cfg[0].no_of_dst];

foreach(fifo_dst[i])
	fifo_dst[i] = new($sformatf("fifo_dst[%0d]",i),this);*/
	
endfunction

//-----------------  run() phase  -------------------//

task router_scoreboard::run_phase(uvm_phase phase);
if(!uvm_config_db #(bit [1:0])::get(this,"","bit[1:0]",addr))
	`uvm_fatal("router_scoreboard","addr not set")

    fork
		 begin
            fifo_src.get(src_data);
             `uvm_info("SOURCE SB","source data" , UVM_LOW)
			 src_xtns_in++;
              src_data.print;
			  src_cov_data = src_data;
			router_fcov1.sample();
		end
// In fork join
// get and print the read data using the tlm fifo

         begin
            fifo_dst[addr].get(dst_data);
            `uvm_info("dst SB", "dst data" , UVM_LOW)
			dst_xtns_in++;
            dst_data.print;
			dst_cov_data = dst_data;
			//router_fcov2.sample();
		end
		
    join

// Call the method compare_data
	$display("call compare data");
	compare_data(src_data, dst_data);
endtask


function void router_scoreboard::compare_data(src_xtn src, dst_xtn dst);
    if(src.header == dst.header) begin
		$display("----- header matched -----");
		header_data_count++;
	end
	else
		$display("----- header not matched -----");
	
	if (src.payload == dst.payload) begin
		$display("----- payload matched -----");
		payload_data_count++;
	end
	else
		$display("----- payload not matched -----");
	if (src.parity == dst.parity) begin
		$display("----- parity matched -----");
		parity_data_count++;
	end
	else
		$display("----- parity not matched -----");
	if (header_data_count == parity_data_count && parity_data_count == payload_data_count)
		verified_data_count++;
endfunction


    function void router_scoreboard::report_phase(uvm_phase phase);
   // Displays the final report of test using scoreboard stistics
   `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard \n Number of destination Transactions from dst_agt_top : %0d \n Number of source Transactions from src_agt_top : %0d \n Number Header compared : %0d \n Number payload compared : %0d \n Number Parity compared : %0d \n\n",dst_xtns_in, src_xtns_in, header_data_count, payload_data_count, parity_data_count), UVM_LOW)
 endfunction 







      

   
