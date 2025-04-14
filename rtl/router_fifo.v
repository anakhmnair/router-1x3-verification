module router_fifo(clk,rstn,soft_rst,lfd_state, wrt_en, rd_en,
						 din,empty,full,dout);

input clk,rstn,soft_rst,lfd_state, wrt_en, rd_en;
input [7:0] din;
output empty,full;
output reg [7:0] dout;

parameter bus = 9,
addr = 16;

reg [4:0] wrt_ptr = 5'b0 , rd_ptr = 5'b0;
reg [6:0] fifo_counter;
reg lfd_state_s;
integer i;

reg [bus-1 : 0] fifo [addr-1 : 0];

always@(posedge clk)	//read and write pointer logic
	begin
		if(!rstn)
			begin
				rd_ptr <= 5'b0;
				wrt_ptr <= 5'b0;
			end
		else if(soft_rst)
			begin
			 rd_ptr <= 5'b0;
			 wrt_ptr <= 5'b0;
			 end
		else
			begin
				if(rd_en && !empty)
					rd_ptr <= rd_ptr+1'b1;
				else
					rd_ptr <= rd_ptr;
				if(wrt_en && !full)
					wrt_ptr <= wrt_ptr+1'b1;
				else
					wrt_ptr <= wrt_ptr;
			end
	end

always @ (posedge clk)	//lfd state logic to delay lfd state
	begin
		if(!rstn)
			lfd_state_s <= 1'b0;
		else
			lfd_state_s <= lfd_state;
	end

always @ (posedge clk)	// writing operation
	begin

		if(!rstn)
			for(i=0;i<addr;i=i+1)
				fifo[i] <= 8'b0;
		else if(soft_rst)
			for(i=0;i<addr;i=i+1)
				fifo[i] <= 8'b0;
		else if(wrt_en && !full)
			begin
				fifo [wrt_ptr[3:0]] <= {lfd_state_s , din};
			end
	end

always @ (posedge clk)	// reading operation
	begin
		if(!rstn)
			dout <= 8'b0;
		else if(soft_rst)
			dout <= 8'bz;
		else if(rd_en && !empty)
			dout <= fifo [rd_ptr [3:0]][7:0];
		else if(rd_en && (fifo_counter == 7'b0)) begin
			@(posedge clk)
				if(fifo_counter == 7'b0)
					dout <= 8'bz;
				else
					dout <= dout;
			end
		else
			dout <= dout;
	end
	
always @ (negedge clk)	// counter operation
	begin
		if((!rstn) || (soft_rst))
			fifo_counter <= 7'b0;
		else if(rd_en && !empty)
		begin
		if (fifo [rd_ptr[3:0]][8] == 1'b1)
			fifo_counter <= fifo [0][7:2] + 1'b1;
		else if (fifo_counter != 7'b0)
			fifo_counter <= fifo_counter - 1'b1;
		else
			fifo_counter <= fifo_counter;
		end
		else
			fifo_counter <= fifo_counter;
	end

assign full = (wrt_ptr[4] != rd_ptr[4])&&(wrt_ptr[3:0] == rd_ptr[3:0])?1'b1:1'b0;
assign empty = (wrt_ptr == rd_ptr)?1'b1:1'b0;
endmodule	