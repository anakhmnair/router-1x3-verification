/*router testbench environment*/

class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)
	
	//MEMBERS
	src_agt_top sagt_top[];
	dst_agt_top dagt_top[];
	router_virtual_sequencer v_sequencer;
	router_scoreboard sb;
    router_env_config m_cfg;
	// METHODS

	extern function new(string name = "router_tb", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass
	
function router_tb::new(string name = "router_tb", uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------  build phase method  -------------------//

function void router_tb::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    if(m_cfg.has_sagent) begin
		sagt_top = new[1];
		foreach(sagt_top[i])begin
            uvm_config_db #(src_agent_config)::set(this,"*",  "src_agent_config", m_cfg.m_src_agent_cfg[i]);
	        sagt_top[i]=src_agt_top::type_id::create($sformatf("sagt_top[%0d]",i) ,this);
			sagt_top[i].agnth = new[m_cfg.m_src_agent_cfg[i].no_of_src];
        end 
    end
    if(m_cfg.has_dagent) begin
        dagt_top = new[1];
        foreach(dagt_top[i]) begin
			uvm_config_db #(dst_agent_config)::set(this,"*",  "dst_agent_config", m_cfg.m_dst_agent_cfg[i]);
			dagt_top[i]=dst_agt_top::type_id::create($sformatf("dagt_top[%0d]",i) ,this);
			dagt_top[i].agnth = new[m_cfg.m_dst_agent_cfg[i].no_of_dst];
        end
    end

    super.build_phase(phase);
    if(m_cfg.has_virtual_sequencer)
	    v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
    if(m_cfg.has_scoreboard) begin
        sb = router_scoreboard::type_id::create("sb",this);
		sb.fifo_src = new("fifo_src", this);
		sb.fifo_dst= new[m_cfg.m_dst_agent_cfg[0].no_of_dst];

		foreach(sb.fifo_dst[i])
			sb.fifo_dst[i] = new($sformatf("fifo_dst[%0d]",i),this);
	end
endfunction

//-----------------  connect phase method  -------------------//

function void router_tb::connect_phase(uvm_phase phase);
    if(m_cfg.has_virtual_sequencer) begin
        if(m_cfg.has_sagent) begin
			foreach(sagt_top[0].agnth[i]) begin
				
				v_sequencer.src_seqrh[i] = sagt_top[0].agnth[i].seqrh;
			end
		end
        if(m_cfg.has_dagent) begin
			foreach(dagt_top[0].agnth[i]) begin
				
				v_sequencer.dst_seqrh[i] = dagt_top[0].agnth[i].seqrh ;
			end
		end
		
	fork begin
   		if(m_cfg.has_scoreboard) begin
			foreach(sagt_top[0].agnth[i]) begin
				
				sagt_top[0].agnth[i].monh.monitor_port.connect(sb.fifo_src.analysis_export);
			end
		end
		begin
			foreach(dagt_top[0].agnth[i]) begin
				foreach(sb.fifo_dst[j])
				dagt_top[0].agnth[i].monh.monitor_port.connect(sb.fifo_dst[j].analysis_export);
			end
		end
		end
	join
	end
endfunction

