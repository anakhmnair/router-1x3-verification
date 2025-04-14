/* source transaction properties for router 1x3 */

class src_xtn extends uvm_sequence_item;
	`uvm_object_utils(src_xtn)
	
	// DATA MEMBERS
	rand bit [7:0] header;
	rand bit [7:0] payload[];
	bit [7:0] parity;
	bit error;
	bit busy;

	// CONSTRAINTS
	constraint a {header[1:0] != 2'b11;}
	constraint b {payload.size == header [7:2];}
	constraint v {header [7:2] != 0;}
	
	// METHODS
	extern function new(string name = "src_xtn");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);
endclass : src_xtn

function src_xtn::new(string name = "src_xtn");
	super.new(name);
endfunction

function void src_xtn::do_print(uvm_printer printer);
	    //              srting name   						bitstream value    size    radix for printing
    printer.print_field( "header", 							this.header, 	     8,		 UVM_HEX		);
		foreach(payload[i])
    printer.print_field( $sformatf("payload [%0d]",i), 		this.payload[i],	 8,		 UVM_HEX		);
    printer.print_field( "parity", 							this.parity,    	 8,		 UVM_HEX		);
	printer.print_field( "error", 							this.error,    		 1,		 UVM_HEX		);
	printer.print_field( "busy", 							this.busy,    		 1,		 UVM_HEX		);
   
endfunction

function void src_xtn::post_randomize();
	parity = 0 ^ header;
		foreach(payload[i])
			parity = parity ^ payload[i];
	
endfunction