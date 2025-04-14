module router_synchroniser(clk, rstn, detect_add,write_enb_reg,
									read_enb_0,read_enb_1,read_enb_2,
									empty_0,empty_1,empty_2,full_0,full_1,full_2,
									data_in,
									fifo_full, soft_reset_0,
									soft_reset_1,soft_reset_2,
									write_enb,
									vld_out_0,vld_out_1,vld_out_2);

input clk, rstn, detect_add,write_enb_reg,
		read_enb_0,read_enb_1,read_enb_2,
		empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0] data_in;
output reg fifo_full, soft_reset_0,
		soft_reset_1,soft_reset_2;
output reg [2:0]  write_enb = 3'b000;
output vld_out_0,vld_out_1,vld_out_2;

reg [1:0] fifo_addr;
reg full_temp;
reg [4:0] count_soft_rst0, count_soft_rst1, count_soft_rst2;

always @ (posedge clk) // rst logic
	begin
		if(!rstn)
			fifo_addr <= 2'b0;
		else if(detect_add)
			fifo_addr <= data_in; // last 2 bit is addr bit
	end

always @ (*)
	begin
		if(write_enb_reg)
			begin
				case(fifo_addr)
					2'b00 : write_enb <= 3'b001;
					2'b01 : write_enb <= 3'b010;
					2'b10 : write_enb <= 3'b100;
					2'b11 : write_enb <= 3'b000;
					default : write_enb <= write_enb;

				endcase
			end
		else 
			write_enb <= 3'b000;
	end

always @ (*)
	begin

				case(fifo_addr)
					2'b00 : begin
								fifo_full <= full_0;
							  end
					2'b01 : begin
								fifo_full <= full_1;
							  end
					2'b10 : begin
								fifo_full <= full_2;
							  end
					default : begin
								fifo_full <= 1'b0;
								 end
				endcase
			
	end



assign vld_out_2 = ~empty_2;
assign vld_out_1 = ~empty_1;
assign vld_out_0 = ~empty_0;

always @ (posedge clk) // soft reset for fifo 0
	begin
		if(!rstn)
			begin
				soft_reset_0 <= 1'b0;
				count_soft_rst0 <= 5'b0;
			end
		else if(!vld_out_0)
			begin
				soft_reset_0 <= 1'b0;
				count_soft_rst0 <= 5'b0;
			end
		else if(read_enb_0)
			begin
				soft_reset_0 <= 1'b0;
				count_soft_rst0 <= 5'b0;
			end
		else if(count_soft_rst0 < 5'd30)
			begin
				soft_reset_0 <= 1'b0;
				count_soft_rst0 <= count_soft_rst0 + 1'b1;
			end
		else 
			begin
				soft_reset_0 <= 1'b1;
				count_soft_rst0 <= 5'b0;
			end
	end

always @ (posedge clk)	// soft reset for fifo 1
	begin
		if(!rstn)
			begin
				soft_reset_1 <= 1'b0;
				count_soft_rst1 <= 5'b0;
			end
		else if(!vld_out_1)
			begin
				soft_reset_1 <= 1'b0;
				count_soft_rst1 <= 5'b0;
			end
		else if(read_enb_1)
			begin
				soft_reset_1 <= 1'b0;
				count_soft_rst1 <= 5'b0;
			end
		else if(count_soft_rst1 < 5'd30)
			begin
				soft_reset_1 <= 1'b0;
				count_soft_rst1 <= count_soft_rst1 + 1'b1;
			end
		else 
			begin
				soft_reset_1 <= 1'b1;
				count_soft_rst1 <= 5'b0;
			end
	end

always @ (posedge clk)	//soft reset for fifo 2
	begin
		if(!rstn)
			begin
				soft_reset_2 <= 1'b0;
				count_soft_rst2<= 5'b0;
			end
		else if(!vld_out_2)
			begin
				soft_reset_2 <= 1'b0;
				count_soft_rst2 <= 5'b0;
			end
		else if(read_enb_2)
			begin
				soft_reset_2 <= 1'b0;
				count_soft_rst2 <= 5'b0;
			end
		else if(count_soft_rst2 < 5'd30)
			begin
				soft_reset_2 <= 1'b0;
				count_soft_rst2 <= count_soft_rst2 + 1'b1;
			end
		else 
			begin
				soft_reset_2 <= 1'b1;
				count_soft_rst2 <= 5'b0;
			end
	end
	
endmodule