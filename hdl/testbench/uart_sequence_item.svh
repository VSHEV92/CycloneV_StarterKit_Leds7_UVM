`ifndef UART_SEQUENCE_ITEM_H
`define UART_SEQUENCE_ITEM_H

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_sequence_item extends uvm_sequence_item;
    
    `uvm_object_utils(uart_sequence_item)

    extern function new(string name = "uart_sequence_item");
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string();
	extern function bit [7:0] get_led7_id();
	extern function void set_led7_id(bit [7:0]);

	int unsigned max_delay = 100; 
	rand Leds_7_pkg::leds7_t leds7;
	rand bit [3:0] value;
	rand int unsigned delay;
	rand int unsigned delay_id;

	constraint max_delay_const {delay < max_delay; delay > 2;}
	constraint max_delay_id_const {delay_id < max_delay; delay_id > 2;}
	constraint max_value_const {value < 10;}

	covergroup transaction_cg();
	   	leds7: coverpoint leds7;
	   	value: coverpoint value {
	   		ignore_bins value_10_to_15 = {[10:15]};
	   	}
	   	all: cross leds7, value; 
	endgroup : transaction_cg

endclass

function uart_sequence_item::new(string name = "uart_sequence_item");
    super.new(name);
endfunction

function bit uart_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    uart_sequence_item RHS;
    bit same;

    same = super.do_compare(rhs, comparer);
    $cast(RHS, rhs);

    same = leds7 == RHS.leds7 && value == RHS.value && same;
    return same;    
endfunction

function string uart_sequence_item::convert2string();
    string s;
    s = $sformatf("LED = %s; value = %3d", leds7.name(), value);
    return s;
endfunction

function bit [7:0] uart_sequence_item::get_led7_id();
	bit [7:0] id;
	unique case(leds7)
		Leds_7_pkg::LED0: id = 8'hF0;
		Leds_7_pkg::LED1: id = 8'hF1;
		Leds_7_pkg::LED2: id = 8'hF2;
		Leds_7_pkg::LED3: id = 8'hF3;
	endcase
	return id;
endfunction

function void uart_sequence_item::set_led7_id(bit [7:0] data);
	unique case(data)
		8'hF0: leds7 = Leds_7_pkg::LED0;
		8'hF1: leds7 = Leds_7_pkg::LED1;
		8'hF2: leds7 = Leds_7_pkg::LED2;
		8'hF3: leds7 = Leds_7_pkg::LED3;
	endcase
endfunction

`endif