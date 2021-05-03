`ifndef LED7_AGENT_H
`define LED7_AGENT_H

`include "led7_monitor.svh"

`include "uvm_macros.svh"
import uvm_pkg::*;

class led7_agent extends uvm_agent;

    `uvm_component_utils(led7_agent)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
   
    led7_monitor led7_monitor_inst;

endclass

function led7_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void led7_agent::build_phase(uvm_phase phase);
    led7_monitor_inst = led7_monitor::type_id::create("led7_monitor_inst", this);
endfunction

`endif