module router_fsm(input clk,rstn,pkt_valid,low_pkt_valid,
						parity_done,fifo_full,input [1:0] data_in,
						input soft_reset_0,soft_reset_1,soft_reset_2,
						fifo_empty_0,fifo_empty_1,fifo_empty_2,
						output busy, detect_add, ld_state,
						laf_state, full_state, write_enb_reg,
						rst_int_reg, lfd_state);

parameter DECODE_ADDRESS = 3'b000,
LOAD_FIRST_DATA = 3'b001,
WAIT_TILL_EMPTY = 3'b010,
LOAD_DATA = 3'b011,
LOAD_PARITY = 3'b100,
FIFO_FULL_STATE = 3'b101,
LOAD_AFTER_FULL = 3'b110,
CHECK_PARITY_ERROR = 3'b111;

reg [2:0] state, nextstate;

always @ (posedge clk)
	begin
		if(!rstn)
			state <= DECODE_ADDRESS;
		else if(soft_reset_0||soft_reset_1||soft_reset_2)
			state <= DECODE_ADDRESS;
		else
			state <= nextstate;
	end

always @ (*)
	begin
		case(state)
			DECODE_ADDRESS : begin
								  if((pkt_valid && (data_in[1:0] == 2'b0)&&fifo_empty_0)||(pkt_valid && (data_in[1:0] == 2'b01)&&fifo_empty_1)||(pkt_valid && (data_in[1:0] == 2'b10)&&fifo_empty_2))
									nextstate = LOAD_FIRST_DATA;
								  else if ((pkt_valid &&(data_in[1:0] == 2'b0)&&(!fifo_empty_0))||(pkt_valid &&(data_in[1:0] == 2'b01)&&(!fifo_empty_1))||(pkt_valid && (data_in[1:0]== 2'b10)&&(!fifo_empty_2)))
								   nextstate = WAIT_TILL_EMPTY;
								  //else
									//nextstate = DECODE_ADDRESS;
							 end  
							 
			LOAD_FIRST_DATA : nextstate = LOAD_DATA;
			
			WAIT_TILL_EMPTY : begin
							  if((fifo_empty_0)||(fifo_empty_1)||(fifo_empty_2))
									 nextstate = LOAD_DATA;
							  if(~(fifo_empty_0)||~(fifo_empty_1)||~(fifo_empty_2))
									 nextstate = WAIT_TILL_EMPTY;
							  end
							  
			LOAD_DATA :  begin
							if(fifo_full)
							 nextstate = FIFO_FULL_STATE;
							if (!fifo_full && !pkt_valid)
							 nextstate = LOAD_PARITY;
							//else
							// nextstate = LOAD_DATA;
						 end
						 
			LOAD_PARITY : nextstate = CHECK_PARITY_ERROR;
			
			FIFO_FULL_STATE : begin
									if(fifo_full == 1'b0)
									 nextstate = FIFO_FULL_STATE;
									if(fifo_full == 1'b0)
									 nextstate = LOAD_AFTER_FULL;
							  end
							  
			LOAD_AFTER_FULL : begin
							  if(!parity_done && low_pkt_valid)
									 nextstate = LOAD_PARITY;
							  if(!parity_done && !low_pkt_valid)
									 nextstate = LOAD_DATA;
							  if(parity_done == 1'b1)
									 nextstate = DECODE_ADDRESS;
							  end
							  
			CHECK_PARITY_ERROR : begin
									if(fifo_full)
										 nextstate = FIFO_FULL_STATE;
									if(!fifo_full)
										 nextstate = DECODE_ADDRESS;
								 end
								 
			default : nextstate = DECODE_ADDRESS;
		endcase
	end

assign detect_add = (state == DECODE_ADDRESS);
assign lfd_state = (state == LOAD_FIRST_DATA);
assign busy = ((state == LOAD_FIRST_DATA) ||(state == LOAD_PARITY)|| (state == FIFO_FULL_STATE)|| (state == LOAD_AFTER_FULL)|| (state == WAIT_TILL_EMPTY)|| (state == CHECK_PARITY_ERROR));
assign ld_state = (state == LOAD_DATA);
assign write_enb_reg = ((state == LOAD_DATA)||(state == LOAD_PARITY)||(state == LOAD_AFTER_FULL));
assign full_state = (state == FIFO_FULL_STATE);
assign laf_state = (state == LOAD_AFTER_FULL);
assign rst_int_reg = (state == CHECK_PARITY_ERROR);
endmodule