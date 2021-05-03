`ifndef LED7_MONITOR_H
`define LED7_MONITOR_H

`include "uart_sequence_item.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class led7_monitor extends uvm_monitor;

    `uvm_component_utils(led7_monitor)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    virtual Leds_intf leds;
    uvm_analysis_port #(uart_sequence_item) led7_analysis_port;
    uart_sequence_item uart_seq_item_inst;
    
endclass

function led7_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void led7_monitor::build_phase(uvm_phase phase);
     if (!uvm_config_db #(virtual Leds_intf)::get(this, "", "leds", leds)) 
        `uvm_fatal("BFM", "Failed to get bfm");
    led7_analysis_port = new("led7_analysis_port", this);
endfunction

task led7_monitor::run_phase(uvm_phase phase);
    int led_numb;
    logic [3:0] bin_data;
    
    forever begin
        uart_seq_item_inst = uart_sequence_item::type_id::create("uart_seq_item_inst");
        
        @(posedge leds.led_data_valid[0], posedge leds.led_data_valid[1], posedge leds.led_data_valid[2], posedge leds.led_data_valid[3]);
        for (int i = 0; i < 4; i++)
    		if (leds.led_data_valid[i])
    			led_numb = i;

  	    unique case (led_numb)
	    	0: uart_seq_item_inst.leds7 = Leds_7_pkg::LED0;
	    	1: uart_seq_item_inst.leds7 = Leds_7_pkg::LED1;
	    	2: uart_seq_item_inst.leds7 = Leds_7_pkg::LED2;
	    	3: uart_seq_item_inst.leds7 = Leds_7_pkg::LED3;
    	endcase
        
    	#0;
    	bin_data = Leds_7_pkg::led7_to_bin(~leds.leds_data[led_numb]);
        uart_seq_item_inst.value = bin_data;

        led7_analysis_port.write(uart_seq_item_inst);  
    end
endtask

`endif