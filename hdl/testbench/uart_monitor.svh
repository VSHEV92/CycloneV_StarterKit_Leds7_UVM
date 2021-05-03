`ifndef UART_MONITOR_H
`define UART_MONITOR_H

`include "uart_sequence_item.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_monitor extends uvm_monitor;

    `uvm_component_utils(uart_monitor)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    virtual UART_intf uart_rx;
    uvm_analysis_port #(uart_sequence_item) uart_analysis_port;
    uart_sequence_item uart_seq_item_inst;
    
endclass

function uart_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void uart_monitor::build_phase(uvm_phase phase);
     if (!uvm_config_db #(virtual UART_intf)::get(this, "", "uart_rx", uart_rx)) 
        `uvm_fatal("BFM", "Failed to get bfm");
    uart_analysis_port = new("uart_analysis_port", this);
endfunction

task uart_monitor::run_phase(uvm_phase phase);
    bit [7:0] data;
    forever begin
        uart_seq_item_inst = uart_sequence_item::type_id::create("uart_seq_item_inst");
        uart_rx.get_from_uart(data);
        uart_seq_item_inst.set_led7_id(data);
        uart_rx.get_from_uart(data);
        uart_seq_item_inst.value = data;
        uart_analysis_port.write(uart_seq_item_inst);  
    end
endtask

`endif