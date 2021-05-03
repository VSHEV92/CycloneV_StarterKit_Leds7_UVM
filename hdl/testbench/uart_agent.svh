`ifndef UART_AGENT_H
`define UART_AGENT_H

`include "uart_sequence_item.svh"
`include "uart_driver.svh"
`include "uart_monitor.svh"

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_agent extends uvm_agent;

    `uvm_component_utils(uart_agent)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    uart_driver uart_driver_inst;
    uart_monitor uart_monitor_inst;
    uvm_sequencer #(uart_sequence_item) uart_sequecer_inst;

endclass

function uart_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void uart_agent::build_phase(uvm_phase phase);
    uart_sequecer_inst = uvm_sequencer #(uart_sequence_item)::type_id::create("uart_sequecer_inst", this);
    uart_driver_inst = uart_driver::type_id::create("uart_driver_inst", this);
    uart_monitor_inst = uart_monitor::type_id::create("uart_monitor_inst", this);
endfunction

function void uart_agent::connect_phase(uvm_phase phase);
    uart_driver_inst.seq_item_port.connect(uart_sequecer_inst.seq_item_export);
endfunction

`endif