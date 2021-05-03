`ifndef LED7_TEST_ENV_H
`define LED7_TEST_ENV_H

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uart_agent.svh"
`include "led7_agent.svh"
`include "uart_sequence.svh"
`include "scoreboard.svh"

class Led7_test_env extends uvm_env;

    `uvm_component_utils(Led7_test_env)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
    uart_sequence uart_sequence_inst;
    uart_agent uart_agent_inst;
    led7_agent led7_agent_inst;

    scoreboard scoreboard_inst;

endclass

function Led7_test_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void Led7_test_env::build_phase(uvm_phase phase);
    uart_sequence_inst = uart_sequence::type_id::create("uart_sequence_inst", this);
    uart_agent_inst = uart_agent::type_id::create("uart_agent_inst", this);
    led7_agent_inst = led7_agent::type_id::create("led7_agent_inst", this);

    scoreboard_inst = scoreboard::type_id::create("scoreboard_inst", this); 
endfunction

function void Led7_test_env::connect_phase(uvm_phase phase);
    uart_agent_inst.uart_monitor_inst.uart_analysis_port.connect(scoreboard_inst.analysis_port_uart);
    led7_agent_inst.led7_monitor_inst.led7_analysis_port.connect(scoreboard_inst.analysis_port_led7);
endfunction


`endif