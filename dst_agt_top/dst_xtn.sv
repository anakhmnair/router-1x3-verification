/* destination transaction properties for router 1x3 */

class dst_xtn extends uvm_sequence_item;
	`uvm_object_utils(dst_xtn)
	
	// DATA MEMBERS
	bit [7:0] header;
	bit [7:0] payload[];
	bit [7:0] parity;
	bit vld_out, read_enb;
	rand bit  [5:0] delay;
	// CONSTRAINTS
	//constraint a {payload.size == header[7:2];}
	// METHODS
	extern function new(string name = "dst_xtn");
	extern function void do_print(uvm_printer printer);
endclass : dst_xtn

function dst_xtn::new(string name = "dst_xtn");
	super.new(name);
endfunction

function void dst_xtn::do_print(uvm_printer printer);
	    //              srting name   					bitstream value   size    radix for printing
    printer.print_field( "header", 						this.header, 	    8,		UVM_HEX		);
		foreach(payload[i])
    printer.print_field( $sformatf("payload [%0d]",i), 	this.payload[i],	8,		UVM_HEX		);
    printer.print_field( "parity", 						this.parity,     	8,		UVM_HEX		);
	printer.print_field( "vld_out", 					this.vld_out,    	1,		UVM_HEX		);
	printer.print_field( "read_enb", 					this.read_enb,   	1,		UVM_HEX		);
   
endfunction
